Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209207;
	b=5XuWFUwS3YNmCU0FWrCoiyMMeWJzMnvwVaVcrDHZorFJ0VSWB/T80XeVbtaF7o8X2K5k
	 sPURElzxhX9VCRGdpTMqqXl6EZiFfJ07yU6aN4qAtejDJ6MDSe4XPTXpK2XJrDUqhEL3W
	 pMc5+0UeoS9O2xlDyYRSwRyIt5BNlA7HCgOoijBQRPfYnbNY68KyVSZyvez2n66bjrpsV
	 LJT7y8UsaAyAaZSdO5og1a+YW+Q6Op1dXCIA0E2PaB+x4nnUJLkbjiPsCXHZm2xHcup6v
	 371eBP6yophPW3P0pe71ykHcURU/dcCiL9N9OkRSRlUBasNeit9RuLIx6cCDmPjQBcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MZ5FmT9GtqG1a152hfkftSScZ7Wid6D/VZD1x8qVtMg=;
	b=F5xaG6WCD6otc3GsPuHDMH7SHXOQ78Lq9naxSDI8Yw9JWls0CyEbs7T5ZyasQyku6xTB
	 Y3fA7YPQisTI8V+NJRBdNIVhow8f/6ud6S8d8icCX/gqNWbVx7mW14ITc7z1UbGaWPCbi
	 NZisvXcwQv87SxM6nwgbWCHIHbL4vUSMSeqNdbmooXzVux0DiMj22V9Ytpm5PB/7K+rzq
	 ft34TD2DaycRd2DtD2OYrlvT3ZBB9nwOALIxFLaYl/xBYQ/3vwRqZpK9bH0hQY3wt7Ubb
	 iWL+a7rQbNcEGeTmDRPLRxYDYfm39eF74rLf+JkyijqlUcCbs2ls+Jl3gk4cleO7Lhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M0FQD7C2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE2D606A31D;
	Wed, 28 Oct 2026 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M0FQD7C2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4C21F01825;
	Wed, 28 Oct 2026 17:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209207;
	bh=MZ5FmT9GtqG1a152hfkftSScZ7Wid6D/VZD1x8qVtMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M0FQD7C2F3EIv5K0d+NdmBqnrKb9mB9SjNcZ8LCgHePCGiCsNoO9NcYMvUOoBUtHI
	 jHf4igwys7+Le6FtFiuzwHwD0WbRe6RRKaJCFlfAEHEnIVodJRnSHZko8dTMYLMBbr
	 1rcSaJ7I0x5qytt4Aqoy8s8LKvy8ojPvzasXxZW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 391/516] pmdomain: rockchip: propagate subdomain add errors
Date: Wed, 28 Oct 2026 17:59:03 +0100
Message-ID: <20261028170012.743255429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 4c0d69d677cf5b0065ebbb3ceb8ba66fddbec630 ]

rockchip_pm_add_subdomain() ignored the return value of its recursive
call, so a failure deeper in the hierarchy was silently dropped and
probe still succeeded with an incomplete domain tree.

Fixes: 6be05b5ec161 ("soc: rockchip: power-domain: add support for sub-power domains")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
[ sashal: Adapted to the Rockchip power-domain driver’s older location in the SoC subsystem. ]
[ sashal: goto err_out instead of return, so the np reference taken by for_each_child_of_node() is dropped ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/pm_domains.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/rockchip/pm_domains.c b/drivers/soc/rockchip/pm_domains.c
index 6ccc85ad91c40..915243ac892b8 100644
--- a/drivers/soc/rockchip/pm_domains.c
+++ b/drivers/soc/rockchip/pm_domains.c
@@ -618,7 +618,9 @@ static int rockchip_pm_add_subdomain(struct rockchip_pmu *pmu,
 				parent_domain->name, child_domain->name);
 		}
 
-		rockchip_pm_add_subdomain(pmu, np);
+		error = rockchip_pm_add_subdomain(pmu, np);
+		if (error)
+			goto err_out;
 	}
 
 	return 0;
-- 
2.53.0



