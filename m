Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E0AFBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCC5C4339B;
	Mon, 15 May 2023 16:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169645;
	bh=QxKW70SDUOcM4ZzlccBHnO5C9wSOqYL2IMHRXM7Zdjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOUj1URAjsnWdX1e64r5Mw46EO2qIusvGjiWi3bmHsu7RHmZ3l75wpDk2fWEVQdh/
	 +db7S8AItHq/OUPbPfG7M40DXvZ50rWYK5/D/14/6CZYvkI9rhdLSBqHHytYD/Qal2
	 Ck0f9+vBUtKlFSdxemkBKTkhyZohU268EYXbWUAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruliang Lin <u202112092@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Daniel Mack <daniel@zonque.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 085/246] ALSA: caiaq: input: Add error handling for unsupported input methods in `snd_usb_caiaq_input_init`
Date: Mon, 15 May 2023 18:24:57 +0200
Message-Id: <20230515161725.136203717@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ruliang Lin <u202112092@hust.edu.cn>

[ Upstream commit 0d727e1856ef22dd9337199430258cb64cbbc658 ]

Smatch complains that:
snd_usb_caiaq_input_init() warn: missing error code 'ret'

This patch adds a new case to handle the situation where the
device does not support any input methods in the
`snd_usb_caiaq_input_init` function. It returns an `-EINVAL` error code
to indicate that no input methods are supported on the device.

Fixes: 523f1dce3743 ("[ALSA] Add Native Instrument usb audio device support")
Signed-off-by: Ruliang Lin <u202112092@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Acked-by: Daniel Mack <daniel@zonque.org>
Link: https://lore.kernel.org/r/20230504065054.3309-1-u202112092@hust.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/caiaq/input.c b/sound/usb/caiaq/input.c
index 1e2cf2f08eecd..84f26dce7f5d0 100644
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -804,6 +804,7 @@ int snd_usb_caiaq_input_init(struct snd_usb_caiaqdev *cdev)
 
 	default:
 		/* no input methods supported on this device */
+		ret = -EINVAL;
 		goto exit_free_idev;
 	}
 
-- 
2.39.2



