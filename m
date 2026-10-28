Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213971;
	b=VaEOHR+2BxiYgZbHtP5I1klIsOk/iCT/gAleF8bN1ECZyFlET89+ZUbzd/m5YphKalt3
	 mVardgJ6r086vc77OOp3E1eaFMnixKr5P2BW1YfdRbTUlRzdB+lOikKWqJubqdt8sHNaX
	 Xus8m9OoLojeM7mv8O2K00pI+3srQmiA6NG+Q26cdd8dnE7/7rZ0Z9yZI4j0RuOgfhjui
	 fKrDNkUoBB5nPsrNrYzCm4rS49NOVrpqDXgnI0YR8UouH0CXVhy81cpKFL46JLMjhPLrr
	 OPVSQEmTDttNYIKeQ7A9uky2Tdrh9ocSjqIPK3CBuuAB4nKo2WyYYWZoJRz0S6oX+GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AaTXfEaiqm7wJKczEdPgdREjD0VzCWZ+/jMb/sk9+lY=;
	b=yCBEjGTdN9TV3+WWa5G++OwkV7K+ql7UMyKEldoniiyhQctudpdz1TatXPOSNoBV+nbz
	 +v6wJsDlFSWs+BqcYEpg41kn43MkEw4KkNamhyGGpxLWX2jVKJr0KJE8+6ysJrbyJJyMH
	 5WXFkRaUDe3yjeLTJGNY1J3bnl1A6iI+Q7Msf+sfP+bX7GPa6tfLQhoOxwcXeLDgG8Eb4
	 ApdSBuNC+wOKLCnyLK0iCHUWLie8NbW+PHkHOULXIWfJiTY4m9z+yqNJ/vcTIgt0z2okA
	 rmAmdRPvPHMwTLRy11fBh3CvoDncVwmIITrozhv0n8EQXvoO8/py2DUI4jxBoYWEgZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yhRUbKdD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB5A606A31A;
	Wed, 28 Oct 2026 18:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yhRUbKdD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692211F01825;
	Wed, 28 Oct 2026 18:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213971;
	bh=AaTXfEaiqm7wJKczEdPgdREjD0VzCWZ+/jMb/sk9+lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yhRUbKdDW3eEwmdrty/OkKIgv0azObfTsxX32JMELadjFssCKrrcFuRAJ7p2kKv3H
	 /9IG3zdGQsYqWEz+/1XDA3UwGBnJ4gR4cwWUpF/ZIbMc0SmFDWJlS8arRsEh7S4OZy
	 o2iSANDN4LpwiMs/ZEQX5iLd3bzVAX27W4/L6kog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0694/1887] pmdomain: imx93-blk-ctrl: correct remove path
Date: Wed, 28 Oct 2026 17:46:30 +0100
Message-ID: <20261028170515.205617729@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit f7c7c5aa556378a2c8da72c1f7f238b6648f95fb ]

The check condition should be 'i < bc->onecell_data.num_domains', not
'bc->onecell_data.num_domains' which will make the look never finish
and cause kernel panic.

Also disable runtime to address
"imx93-blk-ctrl 4ac10000.system-controller: Unbalanced pm_runtime_enable!"

Fixes: e9aa77d413c9 ("soc: imx: add i.MX93 media blk ctrl driver")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Cc: stable@vger.kernel.org
Message-ID: <20241101101252.1448466-1-peng.fan@oss.nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/imx93-blk-ctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/imx/imx93-blk-ctrl.c b/drivers/soc/imx/imx93-blk-ctrl.c
index 2c600329436cf..955e084c9d11b 100644
--- a/drivers/soc/imx/imx93-blk-ctrl.c
+++ b/drivers/soc/imx/imx93-blk-ctrl.c
@@ -298,7 +298,9 @@ static int imx93_blk_ctrl_remove(struct platform_device *pdev)
 
 	of_genpd_del_provider(pdev->dev.of_node);
 
-	for (i = 0; bc->onecell_data.num_domains; i++) {
+	pm_runtime_disable(&pdev->dev);
+
+	for (i = 0; i < bc->onecell_data.num_domains; i++) {
 		struct imx93_blk_ctrl_domain *domain = &bc->domains[i];
 
 		pm_genpd_remove(&domain->genpd);
-- 
2.53.0



