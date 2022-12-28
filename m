Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50181875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BAEC433EF;
	Wed, 28 Dec 2022 16:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243281;
	bh=KO9p54nhjzygjNgFozlKGwdkzlpcixkmnImu6PElxDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfgB+ugsVF1Dz7ANNSv3xiAZ3ShJWr5ehMLQKb7iW0GrbmYYTI+BwAd+x8NUeZJx7
	 BqmUMTGvu6X0wr2bXhDH/K6YDesRR3aGLXoggqAt/7Y4c6+w35jmxAmdBqWfsL9p8G
	 ENvNJM+SCQi6uB0MpSkowG8iKDhbeSGwvcupeSUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 703/731] ALSA: usb-audio: add the quirk for KT0206 device
Date: Wed, 28 Dec 2022 15:43:30 +0100
Message-Id: <20221228144316.838278796@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: wangdicheng <wangdicheng@kylinos.cn>

commit 696b66ac26ef953aed5783ef26a252ec8f207013 upstream.

Add relevant information to the quirks-table.h file.
The test passes and the sound source file plays normally.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/SG2PR02MB587849631CB96809CF90DBED8A1A9@SG2PR02MB5878.apcprd02.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -76,6 +76,8 @@
 { USB_DEVICE_VENDOR_SPEC(0x041e, 0x3f0a) },
 /* E-Mu 0204 USB */
 { USB_DEVICE_VENDOR_SPEC(0x041e, 0x3f19) },
+/* Ktmicro Usb_audio device */
+{ USB_DEVICE_VENDOR_SPEC(0x31b2, 0x0011) },
 
 /*
  * Creative Technology, Ltd Live! Cam Sync HD [VF0770]


