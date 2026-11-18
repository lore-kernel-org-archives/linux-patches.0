Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034308;
	b=y5IteTsoR5A+Ww4yfFEyCZnp8HfMu2xe7CkRBs80ul7zlBL8GbFD8dLQoo7LGVIP5gW1
	 +qdqtUWrku6tQH0GbKtmU7IS3SSep7doxx5G3sdCdt0iTlqhNicxe9qa6iPipe1qZOLzD
	 tJ3/ZGPewntIRRw5jPrMkwbCwNfb90PLQKKwP86mUl935XrGG80DBbzLXtvNkJzGEr+IL
	 1jFv5rutvPXeLlEdQ85Jx+lFXP3s3g/f9zhLBMktqtHzSuF2g+zvbw/v77HBZaAt3HZoe
	 3pecT2OrJ7hvVWtXU8xauYHYQ6X4yg/baWfI0lnX/C33PwxLhPrvrLaGOYgIORjjAqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ArXflBhYMM6sPhsAj+nJ6QGX4AKEli2PvJtUsy8WUFc=;
	b=0H28ksfD4Aj3GnvWcs/6dp7E4k6/4+f/lqHuWGVOqeBKykLAM9GAn+UCFaW7IZ8wNUUh
	 Xa49GxQ1bkCtZ/Y1ltQ5ezkwb9MNJtmQA6b2nk8WIx6XuIpR9aTugSbXxmj4lN+PSH06Y
	 KYGgS/yCEE0FqE7uO8WZ44KB/o2f6kk/1DHZszBcxQur7KVK+quVaHgFpprgGagEm5VC+
	 Ey5xvaS8xmNxVCqSVevNSgKfYI7B93w08LVRpiLl2VYHk9ZIzyMpWM/T2q+MG6q1ljim2
	 5am0ca/0LJE+EtYZrFhKl7bshmHeEuFIyncn4uDC/ojLb43+gajC0+zdi4U/E2cR6ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q9vtel3P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4039B606A32A;
	Wed, 18 Nov 2026 20:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q9vtel3P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929061F000C4;
	Wed, 18 Nov 2026 20:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034308;
	bh=ArXflBhYMM6sPhsAj+nJ6QGX4AKEli2PvJtUsy8WUFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9vtel3PrUALaLiABlUDmpt0zetUhMSkxFI0DzJ3Lc+asO0Y+ebjrSf9rmEDVQrqE
	 4ZhGGaC+VddYshTS5x4ETPvM8wHpHzZvSlWca+t9N1t3yMWNdt02VesU8UmnJ4ZvwE
	 XF+7aUwd83SA/Bl7jlZ0hDk81iVPAhx6J/FUcAj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0322/3318] ALSA: hda/realtek: Add quirk for Lenovo IdeaPad Slim 3 15ABR8
Date: Wed, 18 Nov 2026 15:15:44 +0100
Message-ID: <20261118150325.532156213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 27356a33a93b2..4499d4fb1d869 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10628,6 +10628,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
+	SND_PCI_QUIRK(0x17aa, 0x3862, "Lenovo IdeaPad Slim 3 15ABR8", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x3865, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3866, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
-- 
2.53.0



