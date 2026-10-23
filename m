Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774422;
	b=mLbTryrEz4uNM3ZYgGB8He0Xxk4N8DAp5wUPQNrj79Eakf7g55Hp0LKdjeDHr4AWnoXQ
	 HOJ22yb0y0OmFLXmHReBvX4O2u9mb78Z0svQEvO6PPnq4rBD+YXdAT71bGuQTAwiITme3
	 6MwZhm3lLjdRpQ5YV1wv/GJCc8VQzoAtn3jvGX1mB5yXxZY32kYAbcBTmn44dtDeMK+Jr
	 wUiwsG64evv7rQbLTBRlVAzJUe2pruoVAL++xqLheMzHiwSAfjpU3KXcfL07udrsZcKch
	 lXkJqQBhPi49EGNSuzOc8qTrVqpy4NoLC4rzY/6akMFQfgTx4uD8FQn790WWTx8eKRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LrKmUIvQIi5nm/vfxM1xIbyrNIKgi7+yq7UESvRG8eA=;
	b=YxIY4iLB5Dq48W4gZ5fbz1ZEE1QCHiA1P4aB4qzIKT1aRa6OhxSME4Ec3Zw103wKNDcZ
	 2abUooqaBrx+DWxjXSMeHLJYKgvPDl4Y/urhC01dLSVBA4UL1/gTJtYPOWEh3C5n8Aha+
	 GW0e82tlecoH6tsepOpdA9SkT5u4PwBS1stq4bisiejlyBE+JnlT3dj9Lcu/gxX6ScFdm
	 Zfxc+gEBDt/8aJ2Edohi637HQ9jGDK1Uvj0aTPXyoeWSY3r/90nZ8NgCe18AJMQoPLOd3
	 7fJtItQvo8x7UvVXypIfha7U51pVVy+rZUoy5Nf/amcOMDiU20aF5mfQWTdlQJBoJ4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KNCbkn6n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5C7606A31A;
	Fri, 23 Oct 2026 16:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KNCbkn6n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70C41F01825;
	Fri, 23 Oct 2026 16:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774422;
	bh=LrKmUIvQIi5nm/vfxM1xIbyrNIKgi7+yq7UESvRG8eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNCbkn6nRDytt6OGxPQ0hD/QoWXhPVFPmbvIZRC3w592aDLb6Q0u+9S4qx6q66Fse
	 ylQDucVwjHHQPql0xwoCm06z7olTNBsKQj65nQr5KsGx8K3JJVNHUCzTnb9n5CE4S2
	 K6jBBpKsfN/ZAHb0u1J3mKkDZs5sRHvA5GV8MLsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 034/242] ASoC: cs42l52: Fix the NG Type Switch bit
Date: Fri, 23 Oct 2026 18:37:56 +0200
Message-ID: <20261023163714.587118425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 9d6bcfbbf0b20..c55ae3532682f 100644
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



