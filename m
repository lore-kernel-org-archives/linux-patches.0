Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831025;
	b=w+lvvA/PQ7rDX+md57+ntJgtR4QhP+D3eE0ujYDfqy3Nox3fhJnE0aGlRnc/qnf6Mp8P
	 f3FUGaOnvfu2BsB6rFJqv/TqY9vaQ2UY2q5X/ch9B1q/07MkxBtGsBTDgGdEGOW7TRBaK
	 CDv/vVKrPZtHH8lGrxQPaS3gw8iqPKCZb8gl+Hay+GCTGdxRqdAtSziFN6cWaLjeT+uyy
	 7ZW51VNlN1tQKDRa/s/QjHK0HNBZz/bsMG3Jlk8CDmmcWzuzki5YtGGwJr461xgjaXM2s
	 2LOieMYucMIbTCfzvHrBuRkitESrcFQ2kK4ptuNK5Ilb9Jw5H+mXRyy/yUvh89jeE7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=95encrxcjPYacwd4A3Nnqd3nb4JHTU7CSNxsPIJF/e4=;
	b=AKPe6OM3vqNTqGJ5SezQImS7JPmoWxllZ4Zjehu/tQx256Dj1Ud8w0Bixksh5ayPMo5O
	 WuOd5NB8xDlOJ2gXl0cP6N3FOgsRvWmfegUt6iqgCWZKvQNJjTs5YHxkJto393KjyQ/Tg
	 Yn/0d5eP7AvpVSNP2DwPmBU0RuDRt3i9xdnZNDkTNbNw3P47DDIaWxVN9hsK2tcZvNocY
	 hGxm5r1Iwi7LIO5OX0iB0rXj5QXBPHREzWmZxaUd3+wF1FDFXuxSnI0XzA6CLfOcj+Brc
	 n9s2XjGEkvqVYJkKi7h3RhsZm1Z1p29/tZp5E8uMm+aVsJPLL6o44j+FsCZ47atRRmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRNkP9mC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587CA606A843;
	Wed,  4 Nov 2026 22:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRNkP9mC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBE51F000C1;
	Wed,  4 Nov 2026 22:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831025;
	bh=95encrxcjPYacwd4A3Nnqd3nb4JHTU7CSNxsPIJF/e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRNkP9mCSuOrbjlV5CHEJbeelM6jqoUh+vE7sCFQEP2UGCWJrjaGHGVV67q+DmB8X
	 O/r12BEwCBePJHk8/1bSY/y7dtPGuXGlIGw/1Xuayoq9WMNimVXkmtfsiNMmKWKPFf
	 5qTqhgNkGFWARjD22Ov6aG0Tv2WN0oHaJCUxbYz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0462/1005] ASoC: amd: yc: Add DMI entry for Alienware m18 R1 AMD
Date: Wed,  4 Nov 2026 16:03:15 -0500
Message-ID: <20261104211056.969651642@linuxfoundation.org>
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

[ Upstream commit fd8ed52ecea6b93e23d52cb2758fb4fb4029067f ]

Add DMI entry so the YC machine driver probes on this model and
the internal DMIC works.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221485
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260824130302.553419-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 666ac5b36e7d6..8e203c034851f 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -514,6 +514,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17 R5 AMD"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m18 R1 AMD"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



