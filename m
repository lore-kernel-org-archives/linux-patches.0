Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213586;
	b=xYp1Wisf9qjOIzwK9ySMw0/AYXer7fRqgyZsPuW/w8KByLRLb8MYplEasruJtJNxu3VI
	 V5+Ta+2q3fQcfU2WyzdxniGPYCaZpqO6ZdW1kZMBQEyOIcdlUiS93fNx45X+g3vMJ5Nm7
	 fuq3yTNPGUwEKxixILS4wsQFYfealS9k3np+B0i0u9JQ/nXoEIl0JNaW6m0+uxzLnFid0
	 BT5ApG8l+ZuyOGMhcfjcCt0HEcfths+fnqnYP1DHMm+EBu62cDbNRAa/x0JRVSmaF0LhR
	 Dvy0rQa3eVGf6AKcqT84J8L/y9YLpHBw44xvD+h2hlVqVkyqYkqGTz72c6a5wXt2WBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ui+2Wr2zVo5w8AKs2JblBgJDf03FtrjUykBCGC/Y1w=;
	b=5ifNLetKgNgHB2oB922WJ1NSZFTS/HKvqMqw/Yuj/7mFw0fF/s2RBWyBitzdn30n307J
	 w+HM7AHIXJfAx5h+LjlUhlSjNJzpJ6szwhck2aoZCpZNmERlPlYYG3aw83KQZ9nCTfOAj
	 52Ojp5DlL0D1+j5oAv8E0OfJtcs4H24NcHux1IpPirX4y4YdLjsBMp8lXpJbeHeuGs1yP
	 YsgIP2U2CyIBKjFmF3cHR8KFKn3EM3Yn0mwVQX6q/ZcNqmpW/I3HUisFKSfNWFC6LO78w
	 zvz7qowWnPMgQ40jvl4x8Zw7TWhVKsiAkNpmh4dvFsz9EOMFNTwjsfiLYBKvI8POIvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUxPafHU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E09606A31A;
	Wed, 28 Oct 2026 18:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUxPafHU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730081F01825;
	Wed, 28 Oct 2026 18:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213586;
	bh=0ui+2Wr2zVo5w8AKs2JblBgJDf03FtrjUykBCGC/Y1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUxPafHU7fIa9JsUbJBt91U5wXUVAr+Y5id4Ps/e2gzY0tcyM3DoDcVA8pCaiolv8
	 /vynOaps04BL0/jUMHlPZZOjennvNglW0B7Cjb+MKF2GziiFZKwted7/AUv+jjYu4l
	 iX2YZ6adyCxjVaRaqUquUhEsUSG48V5utReHpqic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0531/1887] pmdomain: rockchip: fix clock leak on domain probe failure
Date: Wed, 28 Oct 2026 17:43:47 +0100
Message-ID: <20261028170511.424416612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit d8b3847770661b7109146e6479eeadcdab9cecf0 ]

When of_clk_get() failed in the middle of the loop, the references of
the clocks acquired so far were leaked instead of being released by
the error path.

Fixes: d909072d0521 ("soc: rockchip: power-domain: use clk_bulk APIs")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/pm_domains.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/rockchip/pm_domains.c b/drivers/soc/rockchip/pm_domains.c
index 5ba582ffaa1a2..32ea21cd39133 100644
--- a/drivers/soc/rockchip/pm_domains.c
+++ b/drivers/soc/rockchip/pm_domains.c
@@ -589,7 +589,7 @@ static int rockchip_pm_add_one_domain(struct rockchip_pmu *pmu,
 			dev_err(pmu->dev,
 				"%pOFn: failed to get clk at index %d: %d\n",
 				node, i, error);
-			return error;
+			goto err_put_clocks;
 		}
 	}
 
-- 
2.53.0



