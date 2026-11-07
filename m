Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062001;
	b=wmk18XNN42S6CoBd21ntXY7aWuFRSUiNVKxRnpAAMrz93cczbG0mxchXDF90kNvSQRxW
	 JDTIkhL3ZeOoRmTrEaOsIhQY2NXNaRQnYTrabixjVD6b5MsGW5dGShsuOjl1tr9Mmjpsu
	 llASFAk18ZdNYmNwEELO69kncHvdBczHaRRpzYmtjI7Im4Wl6H37WHnfhjpOl5+ySmA9u
	 m4MkMCr9+XX4vFQfOFnnRbhJlcGe+HiiXfe3YJH9LkO3z1zVaZ23TpGbeHRCXG6HAeVRv
	 OeaaHf2ag9oLuDtycRmK4wNg6/ZDObiJ52KLxWyOT1CLx9K2uwTPXg5576FEXeRDTew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qLLnynb4Fiumcu2aLSZZDnNeRqR2ZwUYtLbcEoJ+lNo=;
	b=yCv6CAPTZChlmi835TjSrYMTOvK2fbl4DRcQD9gu8RAccU6cOXfpX/+dkbJgQofYSSma
	 wffYcuQS/mnDQIs4EFAnQlOsBt6Yd79ZZAo+FzLJmlchmeAQfc4E2jFIgH0eOUiDxkFoc
	 sTm/fjnYEIx4/ULdFGPkcNcglsfZIX2gM6AvUvXP0o2bd+Cv0btNZrmBbzt0wbPcWZDX6
	 0gFOnFizHeKD5+N4yBvuyq4p4C26Mz6Iu6il2MRK8JNFn/9TkWMPr122yrRGbdt8eUYgD
	 0qUwXvsQc0qO+2n4sxfYxXbBm2w5Ns+WzfuNvHCNVjQ09PkwNQczuMFl4PyB716dYkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0+fI5jO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03322606A335;
	Sat,  7 Nov 2026 14:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0+fI5jO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A496C1F008A3;
	Sat,  7 Nov 2026 14:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062000;
	bh=qLLnynb4Fiumcu2aLSZZDnNeRqR2ZwUYtLbcEoJ+lNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0+fI5jOt5GvrKQzI/NMbnXnLgS2UfHoDa9DG1f45L+DHJxt/IS2aYdBw8PKARgyX
	 cV+8s3gRLZC8EDY8v+RKSQnZmP1JnKQMvOuLBwJTPPctFJDK9RL97Be7TmdfuxUbXh
	 Zb+WUuEpXjZP0P6bBXRcsO2JuiGbB6imhTqbShPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0953/1536] media: microchip-isc: dont sleep in the clk .is_enabled callback
Date: Sat,  7 Nov 2026 08:49:29 -0500
Message-ID: <20261107135024.420571696@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

[ Upstream commit 61490ff518c7b3ea3ff1cd16bbc012e9e4f1ab74 ]

isc_clk_is_enabled() calls pm_runtime_resume_and_get() and
pm_runtime_put_sync(), which can sleep and are not safe here, as
.is_enabled must run in atomic context. clk_disable_unused() calls it so
at boot, and CONFIG_DEBUG_ATOMIC_SLEEP reports a "sleeping function
called from invalid context" BUG.

Use the atomic-safe pm_runtime_get_if_active() and pm_runtime_put()
instead. A suspended ISC has its clocks gated, so report the clock
disabled when the device is not already active.

Fixes: 01192aa1c5c2 ("media: atmel-isc: Enable the clocks during probe")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/microchip/microchip-isc-clk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-clk.c b/drivers/media/platform/microchip/microchip-isc-clk.c
index 24358d804e75d..66dc522a61908 100644
--- a/drivers/media/platform/microchip/microchip-isc-clk.c
+++ b/drivers/media/platform/microchip/microchip-isc-clk.c
@@ -98,15 +98,14 @@ static int isc_clk_is_enabled(struct clk_hw *hw)
 {
 	struct isc_clk *isc_clk = to_isc_clk(hw);
 	u32 status;
-	int ret;
 
-	ret = pm_runtime_resume_and_get(isc_clk->dev);
-	if (ret < 0)
+	/* Runs in atomic context, so must not sleep to resume the ISC. */
+	if (pm_runtime_get_if_active(isc_clk->dev) <= 0)
 		return 0;
 
 	regmap_read(isc_clk->regmap, ISC_CLKSR, &status);
 
-	pm_runtime_put_sync(isc_clk->dev);
+	pm_runtime_put(isc_clk->dev);
 
 	return status & ISC_CLK(isc_clk->id) ? 1 : 0;
 }
-- 
2.53.0



