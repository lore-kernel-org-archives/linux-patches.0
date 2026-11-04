Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830808;
	b=umlPbL2+AxP6tkeLEo+9BNIbOxJk6DvgGFIbK/U7nSQmQ412XAivfDaWX/xOTpfIq5bw
	 BmIY+Kk4VOn2NMEA1lsdw96ESvtWtBhPn/OyCbbhXjnol100PDvLqpytKMQF/gAC0mJ+M
	 Kef1Ret/s5TAqYGGK4OtG2ySZkvZxvaA5XVkdqRMYFji3YKuasofRV8jeFH5qWqKUccWE
	 GPFKGq1FsZdQbC+8IKvkvcxotpiywFyORfl705c7FSBhUlLSfV+yP2H0fOeuCt3hB5RzJ
	 5M9jvdDIhhuxXm2t0oBg2NuMfMnKH9Y6m10a1mNwv+OckWNTvnTs/p8yOt6sSqwPidw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rTTs8EWN791PU/tR/DmtKveGZLEDrq1k+6zpLyDIGG4=;
	b=ElbnAeatXFB2b7h/FMOxORb7ELtCq2jdLuYAjwRHkWTd/cDRH/G3AFPz9lt442DK2Ro4
	 QxWK9fnF5EHA8fy/3urQYad/rme2721VZb0O/YnZ+bwqahjMD7KSGMQeH3Qv+Z5LYlEvI
	 5PE7kErXdZTzP9SE+kvfozo8UM0f1AZUh2fwt1u46ZpjQEqrLuchkmo8EtlLJG+NBQx/k
	 BLvhvcy75QNK4lHEqGb/kt6h7wls84XzPCaL0qTCa8fPs4gavXka4z7Ri4z1aK/Abdmyz
	 zyQUeODXZrKZsvHITb+Yhg04YtbP1EqrwhpFF0yHlBwzCYL3iQk76Eu3hUMAvNPXu1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNLmzo35;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDED3606AC29;
	Wed,  4 Nov 2026 22:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNLmzo35
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BBF1F01579;
	Wed,  4 Nov 2026 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830807;
	bh=rTTs8EWN791PU/tR/DmtKveGZLEDrq1k+6zpLyDIGG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNLmzo35d0jqNNPv90pYnl0mRU3/jd38gyC++KFTfT/tc2AK99n/ml5REHIxBqkVk
	 Z2/NR7mWG6OZNave1+v6Pl4WVGcShETX0J8i6zbRHf83x/QhWMHPSeNiS2iiVQyj9z
	 J9o1CuubaQ2zk8jzyVkBe47REx909GsXORJOoZ/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0331/1005] ALSA: hda/realtek: Limit mic boost on Positivo N15RPE-S
Date: Wed,  4 Nov 2026 16:01:04 -0500
Message-ID: <20261104211053.225589446@linuxfoundation.org>
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

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

[ Upstream commit 253010acfc8ad908446347b30a613032d1517bb5 ]

The internal mic boost on the Positivo N15RPE-S is too high.
Fix this by applying the ALC269_FIXUP_LIMIT_INT_MIC_BOOST fixup to the machine
to limit the gain.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Link: https://patch.msgid.link/20260805154518.19093-1-edson.drosdeck@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index f2b0eb8501a78..5098d3f375316 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7646,6 +7646,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x2782, 0x4900, "MEDION E15443", ALC233_FIXUP_MEDION_MTL_SPK),
+	SND_PCI_QUIRK(0x2782, 0xa128, "Positivo N15RPE-S", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0xa212, "Lunnen Ground 14", ALC269VC_FIXUP_LUNNEN_GROUND_14),
 	SND_PCI_QUIRK(0x7017, 0x2014, "Star Labs StarFighter", ALC233_FIXUP_STARLABS_STARFIGHTER),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
-- 
2.53.0



