Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FE02566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB62C433EF;
	Tue, 18 Apr 2023 12:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821304;
	bh=LJqsLK/fF+B3r7y04bZh1zbvBgs0fFmmwPmGP+1WkfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9uqQ/NDiiGRe35OvFfym/ika7qGdqlTK8/tPJenfProcwR1z6Ec8qFAH+a96KwFJ
	 tcOn1dqx2uMuRHXdp+JNNv+g6ihO0YpWzZY9oQwYMkyGksuispIVDUdge4uPDX/uMW
	 UzYEpC6Sw6t5B1pSxQJFm+PJmtgZUSMZPYiwr8d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 058/124] ALSA: hda/sigmatel: fix S/PDIF out on Intel D*45* motherboards
Date: Tue, 18 Apr 2023 14:21:17 +0200
Message-Id: <20230418120311.944765622@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

commit f342ac00da1064eb4f94b1f4bcacbdfea955797a upstream.

The BIOS botches this one completely - it says the 2nd S/PDIF output is
used, while in fact it's the 1st one. This is tested on DP45SG, but I'm
assuming it's valid for the other boards in the series as well.

Also add some comments regarding the pins.
FWIW, the codec is apparently still sold by Tempo Semiconductor, Inc.,
where one can download the documentation.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230405201220.2197826-2-oswald.buddenhagen@gmx.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_sigmatel.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1707,6 +1707,7 @@ static const struct snd_pci_quirk stac92
 };
 
 static const struct hda_pintbl ref92hd73xx_pin_configs[] = {
+	// Port A-H
 	{ 0x0a, 0x02214030 },
 	{ 0x0b, 0x02a19040 },
 	{ 0x0c, 0x01a19020 },
@@ -1715,9 +1716,12 @@ static const struct hda_pintbl ref92hd73
 	{ 0x0f, 0x01014010 },
 	{ 0x10, 0x01014020 },
 	{ 0x11, 0x01014030 },
+	// CD in
 	{ 0x12, 0x02319040 },
+	// Digial Mic ins
 	{ 0x13, 0x90a000f0 },
 	{ 0x14, 0x90a000f0 },
+	// Digital outs
 	{ 0x22, 0x01452050 },
 	{ 0x23, 0x01452050 },
 	{}
@@ -1758,6 +1762,7 @@ static const struct hda_pintbl alienware
 };
 
 static const struct hda_pintbl intel_dg45id_pin_configs[] = {
+	// Analog outputs
 	{ 0x0a, 0x02214230 },
 	{ 0x0b, 0x02A19240 },
 	{ 0x0c, 0x01013214 },
@@ -1765,6 +1770,9 @@ static const struct hda_pintbl intel_dg4
 	{ 0x0e, 0x01A19250 },
 	{ 0x0f, 0x01011212 },
 	{ 0x10, 0x01016211 },
+	// Digital output
+	{ 0x22, 0x01451380 },
+	{ 0x23, 0x40f000f0 },
 	{}
 };
 


