Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591320;
	b=sImH193nddbYVPkn75cjrLFn/F7n0JxmjeH36lRYUqPz/RrWw2otGZokwn4OOlFSdvh0
	 mq0KbKag+4J3tUy8kfuAG1pgYczH7OGQMB8ZulLJMwPhIebgmFScYZT0uamRhLIgivSw3
	 GS0IyXmwk517FhZrV6ctagjoXXToJ8yQmuSEI1VQlA+eaWKHuY/hbmdkJ+x4BQO2HK1oT
	 vTE3AtC14qntFZ5457jVXiUq+tU/GJbC8uUCld2MdA0Gp6QUhSWAunPj0n+YK+c3dVuEx
	 H+A7cotKMg3Eaqq9+oaUGzol6/T9k84fCAX3QH7QRW2v6CnC/f3717tXeBv5zYKl9eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lHpiJzoBIhVKHsC5bsZyKuHTBjxQZzrEjldXx5zwM7U=;
	b=fL8Z55XgvPwHqtkzVYO3RS0sjFebj8Rp5lbXu1Q+fwMpmY/28WVZEmMpGn6WYgVOnlbP
	 qDTLrD6MS3mBP31OVXRTwDoQ803I/RUYvxZvN1BYMDMF4YDLyXAoqgiZzQKTocPjh2OcE
	 wFbC+6ihllaV2vvOfTYM+R53RrVXLVrNxKAZK88j2M60fMK2XkweRbZAzUMEIJBcYk87L
	 3e02WZC0S0RHkiztGgYAvuACg3nO/e6Obe0+eG4Wo+ni/9THzk49yJzUOz8RqZcu9xexA
	 crTLI5pcntdfxJEFxN+aHxAdLvHBn2awL/5b1anbXwvTeUpCytZNiA8WwLxeN1+YqmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1177L6zG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE239606B204;
	Fri, 13 Nov 2026 17:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1177L6zG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5D91F000C5;
	Fri, 13 Nov 2026 17:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591320;
	bh=lHpiJzoBIhVKHsC5bsZyKuHTBjxQZzrEjldXx5zwM7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1177L6zGiTWKgMVz3pUKctY/KzCkLb/SdRPS2SBYawTt7j1ELsR/4+dONQWX9/+iS
	 9bJc0u7BVKcSW/0dxM+ye4aEU5J/TtADEyhcwTfNDXi0DqXLS8OvgHCPhbi1K2Chaj
	 ga5cFYs6RP0XxdWMOZSzGlEgemr1gDecTAiUstcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 434/670] media: microchip-isc: fix SBGGR10 Bayer pattern
Date: Fri, 13 Nov 2026 10:49:58 -0500
Message-ID: <20261113153826.495949841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit bb96c78c5f87072913f8825faebe64bf711a503c ]

SBGGR10 was mapped to ISC_BAY_CFG_RGRG instead of ISC_BAY_CFG_BGBG,
causing red/blue channel swap.

Fixes: 1e8f401474d6 ("media: atmel: atmel-isc: reworked driver and formats")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/microchip/microchip-sama5d2-isc.c | 2 +-
 drivers/media/platform/microchip/microchip-sama7g5-isc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/microchip/microchip-sama5d2-isc.c b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
index 9b74c92ca6eb8..a5d9d37b4c40f 100644
--- a/drivers/media/platform/microchip/microchip-sama5d2-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
@@ -148,7 +148,7 @@ static struct isc_format sama5d2_formats_list[] = {
 		.fourcc		= V4L2_PIX_FMT_SBGGR10,
 		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
 		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
-		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
+		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGBRG10,
diff --git a/drivers/media/platform/microchip/microchip-sama7g5-isc.c b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
index 15ec519f61870..ee4f66526bd60 100644
--- a/drivers/media/platform/microchip/microchip-sama7g5-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
@@ -157,7 +157,7 @@ static struct isc_format sama7g5_formats_list[] = {
 		.fourcc		= V4L2_PIX_FMT_SBGGR10,
 		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
 		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
-		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
+		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGBRG10,
-- 
2.53.0



