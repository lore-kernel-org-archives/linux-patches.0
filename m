Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211621;
	b=hLF5Z+nMQzvGg0CXtAj+MPrZLtUJfdFHFkeNgy8kghadpkKtMwrAY6P9oGHXJP2gvj+P
	 XNLcaa4JYDv87AfqjOma7MxdkWVrzHJLivo+1M8l0k5S1aAMSFYmJzrg9bddUkhPrzD9D
	 ex6yI6tkGAvNShJ7di+KVCmRm5a0QJqH29h0llhsWJ0Eb1BGkvsQh7Sn0br+YhoLBKJWf
	 pK1+7HuWfQfT7IIdYS1Jp7w9YuHOTDPuyaxGsA/jsSL7R8cdFzDFAeSTnzSnbS9qvV3In
	 7vCromH5Gi/97HqMZpqCXb8BUf+UxYs33988MIhVa4+vh+E51+Hv8eKWa5SwyEAgW9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uRZnNhEcYTaoAopSIFk6kvj0dGSZXtJZU6t2MB52Prc=;
	b=FRKHAqxbQ7/QDMzk9QM0EQa9UdZD47kzGIpfIdMxq5eqFtb88TClCby+ZWkFegndNtNH
	 xjgM91Y9eA3/ziPdhlt0FCXchVSZpVV+jzm3BFM7EMRqYtixITvpRgT1ahBljxMTVZkbM
	 s5rv3CdldPHleKNmECaLe6cWOwIT3mP0OLzoZ3hnr+FIcwavoWNUW6Sz+eWPzLIZ/NQ1G
	 9pN0zBLxPF9l2VzeG9UjRxNer3A64SK7QiN2IHYqo2ZQTxG1S9Xc/BROCln5YyjgsTaml
	 x1SJanXhOvaAYpahMaWCHZxLOP3Tz5hTpKFf8OVzshZM64TFM9LvxbKpV51X1oYSSGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Bpw/xG/8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C32606A31E;
	Wed, 28 Oct 2026 18:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bpw/xG/8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9C71F01825;
	Wed, 28 Oct 2026 18:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211621;
	bh=uRZnNhEcYTaoAopSIFk6kvj0dGSZXtJZU6t2MB52Prc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bpw/xG/8HDOoPt1YuZ4xUAptFoI+XDtQ8p8M70ND1USN+TXXdVgAg625NlUGhRSu1
	 rRnb9uYDCsvo7z66qt1dvYD1HgiqmZFP5iz6sxjR94czR/Vro86WXgaIJZ0/pWPyEc
	 TGlO3NPoF68lfALCRDmsNqeJgRHdJPyQ511m4I+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 442/571] pmdomain: rockchip: propagate subdomain add errors
Date: Wed, 28 Oct 2026 17:59:49 +0100
Message-ID: <20261028170018.512775637@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5e73b74a85f58..8d79b3ee42b84 100644
--- a/drivers/soc/rockchip/pm_domains.c
+++ b/drivers/soc/rockchip/pm_domains.c
@@ -629,7 +629,9 @@ static int rockchip_pm_add_subdomain(struct rockchip_pmu *pmu,
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



