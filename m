Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213643;
	b=HAqxxHZNUekYPe233Me7mCY8Y+yoI6SiUkt04nhb6RsW7qM4KShj2FAMJA/TTfionIOR
	 +C3zeUhA8sXf+tsqF4zYjVBF9J0M7nSpk4USG56YwBE6HaG/IvR3JOESlDFwoxQX/RBLK
	 ul4GYLSBi0Upzz5cQutm1LPNEisg7ll6AhIkyWaW5DUXJy21NN3pqUYY9QN0gWfTXQm6/
	 msrhfSI6VD0OxjyZ3NEiJKyfSChhUlh6/p3HfoHCbCwtqVY02cZyMoZJuQzegppd/lWAy
	 kyHwUPv40xvv8j8fApYFe9lD3JOaXXgCra5nzxWJQ8kHp0AZDhPvau6cB3JEl3A3uuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zJM40ENaUBgIpgqVxmjqmYvr7JBGY0CQ0JfsY665/rc=;
	b=ORzNUm9jvPDwVymbzuDTeud86lDqM38jsmzRMcLLwmDYwFaC+9efqjB2BNAsVC++p7EM
	 E3vi8KsqSE70TTE3gfYFpNU/HTPDNGvKlUqb40EHezFoa1/5QGYJ/QBoLoIkydUKYBgh3
	 o2S5Oxx/RdYB0KUekd/8v7gnB7IkUdbT0Yg7qWrExlQVTlUxl4oCp5o7rIW+HUikUj9vM
	 xZMABr9riDIyJ4ui8wq97x2tgD0cUbWtuS5H2cTD5GURITYe0IwYp0DIKkm2fGdsJKRcE
	 S1TXvN6m9teQ1D9fqVcRwGUFRgyM73+0h/+kmLQR9tshvnnIad7JySarGOy2TUpcAIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1v5iv0p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21C0606A31E;
	Wed, 28 Oct 2026 18:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1v5iv0p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABBC1F01825;
	Wed, 28 Oct 2026 18:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213642;
	bh=zJM40ENaUBgIpgqVxmjqmYvr7JBGY0CQ0JfsY665/rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1v5iv0pOPGBk/c69hze94/OpJhMzwaSpyXARpIetDXoZIda7lVOZ8rwqAWVN7c6S
	 He7++ThwqSyZTIoSMgNqgAhK77l4Xrm/TDhtkjo+ME9C9A49zUlrGt9hrybJug+I0R
	 4hIQk2ZG3nF9zEVFJGUPdYl9Dz2W9YHAgi3+ZpnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0534/1887] pmdomain: rockchip: propagate subdomain add errors
Date: Wed, 28 Oct 2026 17:43:50 +0100
Message-ID: <20261028170511.495714139@linuxfoundation.org>
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

[ Upstream commit 4c0d69d677cf5b0065ebbb3ceb8ba66fddbec630 ]

rockchip_pm_add_subdomain() ignored the return value of its recursive
call, so a failure deeper in the hierarchy was silently dropped and
probe still succeeded with an incomplete domain tree.

Fixes: 6be05b5ec161 ("soc: rockchip: power-domain: add support for sub-power domains")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
[ sashal: goto err_out instead of return, so the np reference taken by for_each_child_of_node() is dropped ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/pm_domains.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/rockchip/pm_domains.c b/drivers/soc/rockchip/pm_domains.c
index 1146fdf477aa8..2697977cf24c3 100644
--- a/drivers/soc/rockchip/pm_domains.c
+++ b/drivers/soc/rockchip/pm_domains.c
@@ -767,7 +767,9 @@ static int rockchip_pm_add_subdomain(struct rockchip_pmu *pmu,
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



