Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0E130C37E;
	Wed, 28 Jan 2026 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616110; cv=none; b=EqHJrYjDzHYQ5fY7V82LN1bqQ8SHLKUyOntdPeVdNMzzQ2kEUIP2c0AKYcfhl2sAvHwwlWvOW0Uh8cjRdcIIJGNPg4saU57Dqn3pu+z528NQYN7YFfUCBWHfVlfSbNNZ6S6b9tw54iwcKllpAwl9zAR0smI5ueue4uzs0YXcax4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616110; c=relaxed/simple;
	bh=njMYHPSmA8oQctWqjJaLd5GmBXebTX0wybmrY0c8ygA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfDdv1rSqCG0GeVaXnOdy9luarKb8Nh1hauXQlBI95nEe/bJxQ43jjp/dvoGG4bg2aQ5UaUW8GTGvr48Ha9hIGHX7BItx2GCs7hPVTXBAPxZ8drukUgrDQK5jBH+Nlsl9fzpmQ7/oCrlMIxNVNyfrFKFwg8X0QlzcUVJuakYT1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCwPc+IJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCwPc+IJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5371C4CEF1;
	Wed, 28 Jan 2026 16:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616110;
	bh=njMYHPSmA8oQctWqjJaLd5GmBXebTX0wybmrY0c8ygA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCwPc+IJqZTP/r86wQ459CzMzywGZGMIW9pPMnDh6p5aoqdhdlMzludUcvnRTnzhC
	 fiObNuHEoNiEHVRDYyA2NpEhBxr/HXC1jPCRhMusSnhc3L2ywFngVgqyEl05xoOUNn
	 44LPpwLLhN9zYHSEYXHS2CVSty5cbj0bxH9WD7C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 167/227] ALSA: hda/realtek: Add quirk for Samsung 730QED to fix headphone
Date: Wed, 28 Jan 2026 16:23:32 +0100
Message-ID: <20260128145350.461677001@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit c45385ed624eecc5305ff165e1ac5dfa7548bcd5 upstream.

After applying this quirk for the ALC256 audio codec, the headphone
audio path functions normally; otherwise, headphones produce no sound.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220574
Cc: <stable@vger.kernel.org>
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260122085240.3163975-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6906,6 +6906,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
+	SND_PCI_QUIRK(0x144d, 0xc876, "Samsung 730QED (NP730QED-KA2US)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xca03, "Samsung Galaxy Book2 Pro 360 (NP930QED)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xca06, "Samsung Galaxy Book3 360 (NP730QFG)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc868, "Samsung Galaxy Book2 Pro (NP930XED)", ALC298_FIXUP_SAMSUNG_AMP),


