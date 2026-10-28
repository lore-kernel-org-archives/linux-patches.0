Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209928;
	b=no8ti1BEFvTx8ayx5MEMAzmYQHDFYsI/U2vK4DHSspm54TtT5bvcPYIcGMIZEd1VEMLV
	 fYuLYPiotZKeU2ZQmhx4RUVYQDemLEVoRGh8KhV4DIG2dIGGTg9wsDIbDd1o6YfEtO3a+
	 oXIHX/kF16XLfPIeXLkh/KBIq9iUVP0bozxT1Ie63ZlcWwdaz3dv/JnUNvjmBTm1t6Bp1
	 vii7gU+7xwU0IddBP9QBxjbJnYlm0u46mXDMyxmzO0Yk9lW7iGRBbSwdfEiriRVfdhQNO
	 lpA8RlslKekUFW/bJGWG9jcJjkt2N5mRPacTCkJCbskvL6Kbqjtnlwbgze4YWg63GHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uH4PWaWEX4ea5lxjF+uVdkUDVYIos58D/uxdm9grVbw=;
	b=G4OIwdSr37JVydNJqwEBOoYkPfMT7uM2fzYk667tFgRoTixXFipMaUr7qVGGuofx33IQ
	 sDCsXYWpLaJraTz3tH84s1BGlnIEi7Og7qeUE7KXWcYL2y7pbmJPr9sUt4F5bJOCOatDm
	 oBnxHc9FzDvcw5jvlyzq8tP8/0Q/mE73MSDnkLkOCYrFLzkbV2/cCoVe8IjAYcb3UsB85
	 BsJPzQdS8M4vgGj4aSWHYDibnRFErglTWCL4pa49Eq8KoMOWqoVgE8ETN6abgP9i1M6Ze
	 rVOW71y+7GttiQzL1/J626oS88P3xaxUBOwV+oX43LaaTozvmt0MOHqk64I/6hqx/Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EK5Yowsf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899E2606A31E;
	Wed, 28 Oct 2026 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EK5Yowsf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987151F01828;
	Wed, 28 Oct 2026 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209928;
	bh=uH4PWaWEX4ea5lxjF+uVdkUDVYIos58D/uxdm9grVbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EK5YowsfrrY3e6bP7pjr4qNUuP312CNoW8Y5qhMSLCqJLf2DPH+8pBgobPbVSCp+z
	 ZDatb1kAshSbaCF603hB98KylqRoWD7/ri2BM6gBi9slnIfp5LokGlX8s4I8lqt1Eb
	 ctWjJnxoeT+9kds5w8IH6J7E8ilPATzddDiTXe6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/168] ASoC: cs42l52: Fix the NG Type Switch bit
Date: Wed, 28 Oct 2026 17:59:13 +0100
Message-ID: <20261028165943.504332240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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
index 4fc8a6ae8d92c..2c7698618970d 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -273,7 +273,7 @@ static const char * const cs42l52_ng_type_text[] = {
 };
 
 static SOC_ENUM_SINGLE_DECL(ng_type_enum,
-			    CS42L52_NOISE_GATE_CTL, 6,
+			    CS42L52_NOISE_GATE_CTL, 7,
 			    cs42l52_ng_type_text);
 
 static const char * const left_swap_text[] = {
-- 
2.53.0



