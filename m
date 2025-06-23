Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F973597E;
	Mon, 23 Jun 2025 22:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716490; cv=none; b=M1kpJRBbZKKiW5LY4w88sk30YbrbxpPpkZorg/9/zWkLSKUH255NMXZ6VDaDkg9Yo34hMbK283jt253dcL/1ldKNFxFSyyMDDwjSAWJfnv18oDiqQmkJi3wsii1GW7PPcyyTZDQc38qS+z3D042GrJt1jddKP61uESSau/WBF1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716490; c=relaxed/simple;
	bh=8nCinSH5IiN5C3DlRmG5qEIvSpcdkXd/EHsHV6zDfKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCn16pprV15kznt2CQCnAtipecuwD2U7kUsTfRVjmyfIvvix0uKvluI0nopKjmrFEJlEF8/NmmFSeYkdVbOqIVPxxmdKr+Sz36xu4BFIxBbiEv6yehdHnuzrYSCM47qpoRL3JE7icp3cDH9FjoaQ+OfFZzEvRa0QpPOp7QauTd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOzl+8lo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOzl+8lo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F2FC4CEEA;
	Mon, 23 Jun 2025 22:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716490;
	bh=8nCinSH5IiN5C3DlRmG5qEIvSpcdkXd/EHsHV6zDfKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOzl+8loUn2Q6m//oGgB8XZOPhmPzqp2Q4Pnc6nrOv+3JUN9dprNB08dhnAANjos9
	 LEuXanDN2D/Q8R8pAx/7cqJEk9vgzTQB3NIX2CUPI1xOsufYIRgDdhHzsCy4C4W0gX
	 UNAmlKXQ3skseMapve4Ugd8OJ+JWxg6L47Q8D31E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 358/411] ALSA: usb-audio: Rename ALSA kcontrol PCM and PCM1 for the KTMicro sound card
Date: Mon, 23 Jun 2025 15:08:22 +0200
Message-ID: <20250623130642.655329258@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangdicheng <wangdicheng@kylinos.cn>

commit 93adf20ff4d6e865e0b974110d3cf2f07c057177 upstream.

PCM1 not in Pulseaudio's control list; standardize control to
"Speaker" and "Headphone".

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250613063636.239683-1-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_maps.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -366,6 +366,13 @@ static const struct usbmix_name_map cors
 	{ 0 }
 };
 
+/* KTMicro USB */
+static struct usbmix_name_map s31b2_0022_map[] = {
+	{ 23, "Speaker Playback" },
+	{ 18, "Headphone Playback" },
+	{ 0 }
+};
+
 /* ASUS ROG Zenith II with Realtek ALC1220-VB */
 static const struct usbmix_name_map asus_zenith_ii_map[] = {
 	{ 19, NULL, 12 }, /* FU, Input Gain Pad - broken response, disabled */
@@ -701,5 +708,10 @@ static const struct usbmix_ctl_map uac3_
 		.id = UAC3_FUNCTION_SUBCLASS_SPEAKERPHONE,
 		.map = uac3_badd_speakerphone_map,
 	},
+	{
+		/* KTMicro USB */
+		.id = USB_ID(0X31b2, 0x0022),
+		.map = s31b2_0022_map,
+	},
 	{ 0 } /* terminator */
 };


