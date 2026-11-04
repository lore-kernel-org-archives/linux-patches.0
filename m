Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831021;
	b=eyCLmmPUm2Y0BEmW1bu2dNRDIChr8vEV7wLwqofQO02GEnHCPOsVEjw3fjuC+DnK/4R4
	 sJEc2G0rpP2LqO3qFihUeb+akOygmjpNw1PPcSQE3wQcrJNlPpcCiM1ZOvyq+d9NEUXJ8
	 Af+2VCMyh8a/yhKjixat4qcXgNzyFXUqL26XytjLeXVZez8BH2HTNZarBaJREup4REOE0
	 7mtlce8GPwZT2s2pGYrbGQ6oRGLoVNuv5TmWPNYaYDSHZkZU8KMTSs2VeOxPddHPHP/F4
	 6KtNE24cpGfCK3+O9Y6HBLdAMAnnud8L+bEhYC74ESa+I9xcKpLRsUIf2/hyHc56Urw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dIGUQW5YEE2C1XhmyDZZGNPWgcrfhJK1nSfwiqEBU2Y=;
	b=1OoD284nFvYPEtDqOM+6dZj6bnL/jB3PYIT82hoUQob7vssoZlHFl2uCi/NFGfIll2V2
	 GQ6cb1ZsZOI25kX7SsdWT2zBiLP0J9Yk/ag9N+/HBfhlJ5aoSdrq7h1kKOmzUNLRsdXuJ
	 qeBEUavW/hoQ/bbSwIjP5kGq1OctfSFzuSJVGwmXip7KxDBaNAqs8iKis0q92sEjeFwAP
	 16cDK29TOAARbgkImoOTR9V5VnRTDrM4mkM+GtRQq6XAjTVv0FAe5ntUMVI7cpIHQpMGJ
	 gG0GrCuvXBcEa8vLusUHUEDRGZo8CRbKM0vAwzcfDCy1H/sSEMUzO3vi0yHTaMoGQrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QsH3LbfV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D9C606A843;
	Wed,  4 Nov 2026 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QsH3LbfV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EBD1F000C1;
	Wed,  4 Nov 2026 22:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831020;
	bh=dIGUQW5YEE2C1XhmyDZZGNPWgcrfhJK1nSfwiqEBU2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsH3LbfVIWoz34h66ZZ+OKmdXApAArGKtAOiiFXrKDd2NR4H81Pd3vcMd36TcrP7r
	 fbdsR/PcHbYAegaJNRISvYQMFRJ6gd/ThXIVm7NkVsc431nVCSFDlagoPPatA6nIJb
	 3CsUWinZs5NTOPC/YvXkVjd9APZyVlmGntYJ01j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0460/1005] ALSA: hda/realtek: Add quirk for Lenovo IdeaPad Slim 3 15ABR8
Date: Wed,  4 Nov 2026 16:03:13 -0500
Message-ID: <20261104211056.918082125@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit be79a45e2ec289eb9fad519e8f5a3d4fc3789dd0 ]

The internal microphone on Lenovo IdeaPad Slim 3 15ABR8 (subsystem
17aa:3862) exhibits severe distortion at default gain levels. The
Capture Volume is fixed at 63 (max) and cannot be lowered without
explicit userspace intervention. The existing fixup
ALC269_FIXUP_LIMIT_INT_MIC_BOOST limits the gain range and resolves
the issue.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221891
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260824123752.525173-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 8196235c31d2b..bc87062f86da7 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7515,6 +7515,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
+	SND_PCI_QUIRK(0x17aa, 0x3862, "Lenovo IdeaPad Slim 3 15ABR8", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x3865, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3866, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
-- 
2.53.0



