Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619343;
	b=CWo8ksZXbQNu7tqvrrAdR1cBQ0PjmIbNPD+q4H5qefGFYq2/N48ifXHbwisKgONruNtX
	 0SJA5eXAJxO+4BKO21O0QrZFj+LUvudfcE8CcR7oiBsNyNu/yTPv1qjccd6TzEZJkWvQ6
	 9OayUGyPqYlk6OCH80e/mVlpF1bMr31heHe/1v3+KVsSp4UYP68KGfQFwu0djks+fQybm
	 uGaHGvOAaIIJfvExJ5pi4hez8v4wOyWPOH1grIfYLvK3aCC9yjHqHvVwPf+bS5yuUPkxB
	 PLk2hJeVWcpU0YKPukUrQYrwSVzYAIz0Nx6ZE2iezCVyxEPH73DSPA3cGz7+4oHIJvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ID9uRbSk3Iw1zdhxTI99G7W42aIef0aTZhhRQwWwGg=;
	b=ItdtMAJlK0FGwNOYa/fPuC7ToK3w69kowbWn6vOeL9d6dkIosifcAGPcNzSm65vS8XHr
	 gUN7cbLsO6vKY1VlWu05jUQoI1updpzdb+kO1VMq55PRBaJ3UCFg2OXpYM/SkX9uqaFsV
	 Ertulc4PaDMYhWnUnZ7vJVwDHy2O72V9ET+L0JhvVMQLDURZ3wbDi6ShLwIfRaPI8wlVW
	 +0Qs0VnBy0uchrKheDmNNHXcZvNQVkb1vvnrtHzgVFandHrcf43Lkvb4n4xR/GRArnA3R
	 k1xWPmcH1qOBYwHVGEN5g2AKF1hOyiV10RTA5DcNlH3WetuVfNpq6Mvr7n51jYIuz9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqHBYG3g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C227606A338;
	Wed, 25 Nov 2026 15:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqHBYG3g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C2C1F000EE;
	Wed, 25 Nov 2026 15:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619342;
	bh=6ID9uRbSk3Iw1zdhxTI99G7W42aIef0aTZhhRQwWwGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqHBYG3gSUC1UbcrEidK0LsjUQA559BlIsnFFCaK/hBkdmgegq1UAFWsfRazJiPJ+
	 +y5xtqDxmIT4TFQtbYinMbWx7zA3aSzKhtM+ePSS4lgcTbLbdMKQvKceGMrFcXUQpn
	 eYEyP1FP9jNGo+ViRxfoY0PHqmerucyYj5VNmKKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.3 0567/1005] Revert "ALSA: hda/cs420x: Add CS4208 fixup for MacBookAir 7,2"
Date: Wed, 25 Nov 2026 15:31:45 +0100
Message-ID: <20261125143835.035994089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d1a1f361e08311f6d9a4aea2da2d1bcb3891f4ef upstream.

This reverts commit 82cfab6a52621febf36752bd5ed5184f82c96e07.

The quirk entry seems matching with other multiple irrelevant models
that lead to a regression on those.

Maybe we should use HDA_CODEC_QUIRK() entry for the corresponding
codec SSID, instead.  But let's revert for addressing the regression
at first.

Fixes: 82cfab6a5262 ("ALSA: hda/cs420x: Add CS4208 fixup for MacBookAir 7,2")
Closes: https://lore.kernel.org/71fb1e29-60e1-4522-a071-c53557cea39b@icloud.com
Closes: https://lore.kernel.org/CABWzDrqrskmtb7MVFgJ54k4WNSqby7Qo3R1XeoVBaJ+djaO1ew@mail.gmail.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20261112124844.694544-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/cirrus/cs420x.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/hda/codecs/cirrus/cs420x.c
+++ b/sound/hda/codecs/cirrus/cs420x.c
@@ -571,7 +571,6 @@ static const struct hda_model_fixup cs42
 
 static const struct hda_quirk cs4208_fixup_tbl[] = {
 	SND_PCI_QUIRK_VENDOR(0x106b, "Apple", CS4208_MAC_AUTO),
-	SND_PCI_QUIRK(0x8086, 0x7270, "MacBookAir 7,2", CS4208_MAC_AUTO),
 	{} /* terminator */
 };
 
@@ -584,7 +583,6 @@ static const struct hda_quirk cs4208_mac
 	SND_PCI_QUIRK(0x106b, 0x7800, "MacPro 6,1", CS4208_MACMINI),
 	SND_PCI_QUIRK(0x106b, 0x7b00, "MacBookPro 12,1", CS4208_MBP11),
 	SND_PCI_QUIRK(0x106b, 0x7f00, "iMac 16,1", CS4208_MBP11),
-	SND_PCI_QUIRK(0x8086, 0x7270, "MacBookAir 7,2", CS4208_MBA6),
 	{} /* terminator */
 };
 


