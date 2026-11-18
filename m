Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043643;
	b=3xGAcq6Q5u8L3vu5qX2xaedriY9XoRiUIquHRMCA4ReaVXf6NqA8b9u4LZjBQyzyMBgX
	 QFEAF7WZxdf88qbwQVrAZfqgtm7Wwu8DELG/gYcC1kQnwCVZ+z+z+BMUxN2y8eWdEsiHf
	 XOuGkXjVKRPBTJNoLzlG2MkqSRMJST4Nbp/fdC9rnXN1zMb4obG/sJGevNmIKd91nSVT2
	 NVX9TwWkZJ6dGJNTRHxwl/VKRPy5VzyznGB6dAJ+n8Im2lgZ+uACWaEMjdccBsDfR6chR
	 k5LieCygV3t0CaI0k5+0ZEjiJFBLGhpG+DD3MSL9uK4AdeWgT7EmmwFBDa+EOPkmlaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mC1ZRPeYhPG9Yq8vrx+fzv0uOGbEWUAdcGVjP2v88sU=;
	b=W++0ANwVx53pEG+yg0QymwIQCWxPORI9Q98eri3sVjg3fF4wy9cvVDzitksLi9EJ2s6i
	 BREqzEvsREy4YC73b0PxvCKWRnAacAfs6oTb7po3qM87L0pQlc0+WQQILMZPA8KzktTDV
	 RHNfSlDYiyWMUz8l+wnr24/sQwrkufZXg+jEgmsPOARgNij/tvN4+ITLMXZ9HqRJytMpH
	 SR8stz0OGGk1u2I7aMbO3vHTScExgfFWtWfXnIyELwehwTBwKYXT0gsHJZvVzzsKekT1a
	 GMY2SiBU+OSmDpINp6j7I7Nf7chkD+wl8vo7KK2DYhgmdbg1Bsrow1IvoH1bIDwcrdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYkb9A2K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5F3606A320;
	Wed, 18 Nov 2026 23:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYkb9A2K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF311F000C4;
	Wed, 18 Nov 2026 23:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043643;
	bh=mC1ZRPeYhPG9Yq8vrx+fzv0uOGbEWUAdcGVjP2v88sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYkb9A2KZIIAyQtgPjTOtbK+oL4UqVH10Wxf4f+bZhhyczN9RfQkTYYh/JmZaTsOU
	 ljjuK5TRY77gGUPYJHr+zxrqvZNvvKl478GIJXE0W8jOFRcFs6zrd/wzdhrkimyScg
	 TC13LebOkknWIFvCJGmILmHaJL5j+9d/mkBeKWPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0276/2857] ASoC: amd: yc: Add DMI entry for Alienware m18 R1 AMD
Date: Wed, 18 Nov 2026 15:21:50 +0100
Message-ID: <20261118150211.363054734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 64c217adfe1f9..1ba845212eae0 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -409,6 +409,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
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



