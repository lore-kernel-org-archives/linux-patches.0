Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773840;
	b=qgURtSSasXD9vIV4BKi7gdm7z/LwDmI4vGruFc6rgcDDZci0CZ9N7bW9UEmM1SdNkthV
	 ExUHQ/O7dvBsDn/hLXfd3JRTJ17mykLS3ooETXPPm2+JBu9jrcmGCsNCfAm2nhKIilkk7
	 XIESwC0Zw2JTrL/ZErE81C6AIZdq3goY3knPcJBPYWgrsWDM6Y+DJ/v7lNXOjpRWHlh71
	 PyL1XnANAUAln7tPJk22GOu+gaRrecA+d/8VKY+kWzNIx+RpvxZDSJhY5+fD6/F+DjA8T
	 GnGyXrTVKGWYsNY9nU6yu1VAuTURLIwng7bK7Vm59Inj1HSBx5G5NJwJmxBO3ZPDb4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=23MZ6tabc5fDX09NbHB1N/MCXt0j8dILNSXHGbPQCwU=;
	b=1ZigaZ0dfN07SCusSba8krIy7jZvNF/NfuCxCjaa301hrFDJtigOONV5eexHJeu3J9t5
	 iV/uaBzNc2OrH3G8EVMzW8iTXC+C04mgXuqlw5LIx8O2f3xfmTbbMXeFHK1QIfzq+Vdag
	 D9Hl5olfNU9Hfz+Hcs+O6jdvs2Iyna0U2YA/aWpMySXyuGfNiZSxmDqiGjRbXIZ6+U7cu
	 qpfBZpw0RVE26/R7hlmhdbYcV21f5UoFBt+oNhNWmNOiDPhJUvoRkxdxjk0p5VFYEg/ts
	 aNSOvSLQNyf5RKyBFYPuO7m4RoeQbIomp5tMTaL6NJ8EztcjeSAnC2niWjUfEuFWRZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vU7kzo7j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D46F60A380D;
	Fri, 23 Oct 2026 16:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vU7kzo7j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11C71F031E4;
	Fri, 23 Oct 2026 16:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773840;
	bh=23MZ6tabc5fDX09NbHB1N/MCXt0j8dILNSXHGbPQCwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vU7kzo7j744GREWdHwIA/2YKcjeYwYfoTKrOFituCuEZDpq+dHX6G6NBumoTRkSAP
	 R4lxcICmQmCFXwct83cQYdDFp3GjSbsX46dx7IMV4DaAfSoGVishXQKtMiQqck6PQH
	 zBOtkzU1UNJZHPlG1YmC06f6Q30dm9EWSNd5zsLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/193] ASoC: cs42l52: Fix the NG Type Switch bit
Date: Fri, 23 Oct 2026 18:35:10 +0200
Message-ID: <20261023163714.983342262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 8b08b98796d2da103f2432550c14a7c687e72080 ]

The NG Type Switch enum selects between "Apply Specific" and "Apply
All", which is the NGALL bit. The datasheet puts NGALL at bit 7 of the
Noise Gate Control register. The enum uses bit 6, which is NG, the
noise gate enable owned by the NG Enable Switch. cs42l52.h names it
CS42L52_NG_ENABLE_SHIFT. cs42l56 has the same Noise Gate register and
puts its NG All Switch at bit 7.

So changing the noise gate type turns the noise gate on or off, and
NGALL cannot be set.

Use bit 7.

Fixes: dfe0f98b8d2e ("ASoC: Add support for CS42L52 Codec")
Link: https://statics.cirrus.com/pubs/proDatasheet/CS42L52_F2.pdf
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-3-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l52.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index a9ffba62aaf88..4a7cfd52e583e 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -290,7 +290,7 @@ static const char * const cs42l52_ng_type_text[] = {
 };
 
 static SOC_ENUM_SINGLE_DECL(ng_type_enum,
-			    CS42L52_NOISE_GATE_CTL, 6,
+			    CS42L52_NOISE_GATE_CTL, 7,
 			    cs42l52_ng_type_text);
 
 static const char * const left_swap_text[] = {
-- 
2.53.0



