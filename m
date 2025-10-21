Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26F0350A0D;
	Tue, 21 Oct 2025 20:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077218; cv=none; b=qvIfysibAC4TE4J2FbI2zanZz+LRVeqMlSn749ySXGOSHVppTPZbIAqqh1om3rylqC10S3VrwUMUf2p5vMRKGpw62qFje0AJ7vwF2/nrIAvXStzMneZn5Cvre28VlG7flN/U+UcHUWFU8EKXgxGErKulATqsEmn50TLPJk/ZBR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077218; c=relaxed/simple;
	bh=2qen5h23h4pwmvMga4vw2MjQsv995gDzYNKy9878tcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGom3O2TSEHSwD4Q/Xflm79fBjw9BB4fWHF3dRUJBPe0yvmfZKSAL2LefR2JwFZlJXYA6zShXiX94rQa0S4J8Ep2TM/AnhozyRWrBhK8544LHXgtGlvEsZgY4effoW6GGcFE7WxXCV1XW4S3GCpJn35T6Wes9qoxyuUJ7PIDqeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AcQoW2bR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AcQoW2bR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4099BC4CEF1;
	Tue, 21 Oct 2025 20:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077217;
	bh=2qen5h23h4pwmvMga4vw2MjQsv995gDzYNKy9878tcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AcQoW2bRtD3nbazaY+BuoiVlnXxOc4ky6INXjDBlN2/tIfsd8AmlYZ6o/rsWopi8C
	 kkoUSrumkw0vKMDz0uhctb8jf3Y9oFMb2VFMt2v4AX6HL/O0KFoGH4s6EJpBXjOCi8
	 tkcujbKM3nvxa04QqpaNfsYY7OvqQyM/900MdRPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 035/159] ALSA: hda/intel: Add MSI X870E Tomahawk to denylist
Date: Tue, 21 Oct 2025 21:50:12 +0200
Message-ID: <20251021195044.041584460@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>

commit 30b3211aa24161856134b2c2ea2ab1c6eb534b36 upstream.

This motherboard uses USB audio instead, causing this driver to complain
about "no codecs found!".
Add it to the denylist to silence the warning.

Signed-off-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/controllers/intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -2077,6 +2077,7 @@ static const struct pci_device_id driver
 	{ PCI_DEVICE_SUB(0x1022, 0x1487, 0x1043, 0x874f) }, /* ASUS ROG Zenith II / Strix */
 	{ PCI_DEVICE_SUB(0x1022, 0x1487, 0x1462, 0xcb59) }, /* MSI TRX40 Creator */
 	{ PCI_DEVICE_SUB(0x1022, 0x1487, 0x1462, 0xcb60) }, /* MSI TRX40 */
+	{ PCI_DEVICE_SUB(0x1022, 0x15e3, 0x1462, 0xee59) }, /* MSI X870E Tomahawk WiFi */
 	{}
 };
 


