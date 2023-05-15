Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD4CFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A461C433EF;
	Mon, 15 May 2023 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169250;
	bh=WCzTwfT1bT2CnQ/Si6jMLvKGx1tZwSHCkr8xf633Rdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJa0nP2dvJeXMJpQzFUUqEhBvv8dshec+wIyzk9+K9VRxy5tFNXlkSExqxsH+NasC
	 UaS8xcsHuP5zYLwDQp5M4iaum63m+1x03KuGkxUvrvsLA/L0Ib5jwnjHMUDjK/WqND
	 kRsLQlDPlZal+OqZUnsqyaqSwZI5uNPNlxlpUN+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruliang Lin <u202112092@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Daniel Mack <daniel@zonque.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 160/191] ALSA: caiaq: input: Add error handling for unsupported input methods in `snd_usb_caiaq_input_init`
Date: Mon, 15 May 2023 18:26:37 +0200
Message-Id: <20230515161713.232534664@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
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
index e883659ea6e77..19951e1dbbb01 100644
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -817,6 +817,7 @@ int snd_usb_caiaq_input_init(struct snd_usb_caiaqdev *cdev)
 
 	default:
 		/* no input methods supported on this device */
+		ret = -EINVAL;
 		goto exit_free_idev;
 	}
 
-- 
2.39.2



