Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFA75FEF7;
	Tue, 13 Feb 2024 17:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845099; cv=none; b=AsSaZTzGMGXgthLb4cs0ZG9bEmXmnT6nJ5yP0o8VZ9Uu/cbchPv2HEGY4wgm2l+Hm1t4l2aCayuOpeQGWpC7NKXqT5mxddaOmv1rdPBAkJvhEaoaoVk0BtIICyG8LTPIz1uY9LfSsqCBjqnC3Z968Kr72MwIvptEi2umTcJLCug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845099; c=relaxed/simple;
	bh=JpCUyHzIrvufjlFFCN3kPe2RK1E4NTF9LIggnyn2MQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGmvpcoHtka+v0mWT2TlVdaY0XPmb+x2cY+E3e84SsK5q7BfVJps3FjKedNBPq39Vj/pGPR9+ysqNoj3eCZOMnt67BXU3lz325xOmXNCK7L2zmzr3UuvMF+qIfAPQIC0jY3s+PqqzrX89Ix07/ZLRCO7OH2NiGtJlRrDN1Yki04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qM2S8gvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qM2S8gvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AE4C433C7;
	Tue, 13 Feb 2024 17:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845099;
	bh=JpCUyHzIrvufjlFFCN3kPe2RK1E4NTF9LIggnyn2MQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qM2S8gvtRX1dgGqXetjbV09GCDOfXRzh00FOzmQCaSH53M7olg2F7w+9hNTKs/t5s
	 C9OFSeeSkxE6hiiD21vZnAYrYKe+LstVQxEDYB99ObIujJvOvA1c+Pbg0kj8jt7g1r
	 SdfcRseS3pU9VCCnuXk3JxsqeBpvnSQNkCor1FmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sikorski <belegdol+github@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 46/64] ALSA: usb-audio: Add a quirk for Yamaha YIT-W12TX transmitter
Date: Tue, 13 Feb 2024 18:21:32 +0100
Message-ID: <20240213171846.189860666@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sikorski <belegdol+github@gmail.com>

commit a969210066054ea109d8b7aff29a9b1c98776841 upstream.

The device fails to initialize otherwise, giving the following error:
[ 3676.671641] usb 2-1.1: 1:1: cannot get freq at ep 0x1

Signed-off-by: Julian Sikorski <belegdol+github@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240123084935.2745-1-belegdol+github@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2029,6 +2029,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x0499, 0x1509, /* Steinberg UR22 */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x0499, 0x3108, /* Yamaha YIT-W12TX */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x04d8, 0xfeea, /* Benchmark DAC1 Pre */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x04e8, 0xa051, /* Samsung USBC Headset (AKG) */


