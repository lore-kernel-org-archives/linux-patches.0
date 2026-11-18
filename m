Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055678;
	b=YQac/yjYnI98zg/UfeLYO/KWwl04o4kQPm54KR2+/rJM9L+5ujzfVbUQsL2YLonP5dL5
	 tInhv4ovDpGihjwHPV71tMHfdnupzMv2a60Nrl64UuCsFbWybCh8elLp1+BNZ6/y0JFBE
	 z3aPl71uMj+wUzxSZ3Q7akbEXyXe6CjoqfxZPjitDAAurozNM4Dd+iV6SsWKsiZLqbKYQ
	 mh+BU35vIbXZ+3lRkqiuvL79gnK2KkUxhghjG/unqz2OqgHWJ0mnEudc5PyNCrzRbfB/R
	 qZXO6Ul4Tl5+0VIfpJc/0keCRIUwUL6WCYOndvfEz+HRMZwV+DvY0tTV+fXGDDzUvvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7JxCaywFcMFITrGV4zq2OHJNgiLGWq7fcJ/zvTpTCdk=;
	b=zN8jDnByFeaugVwfdHjvUQE3WaCNEysxQ2ULJ3kPq2bNhrE5zbDFMYyR4s/vkTykWd2d
	 CpAlNmNlCOMBKWy3+wnHpeh58eNpqxrTf0GSuKu5a4pLtoemX+vMxsEV7UgeDAJPWym4t
	 xut3laB4KsLntKjbd9pk3Quj06YG2yXHFodc/ei+Hzfzh1PAVt0R5sShV4T0GfSN3fob/
	 aGBvmELmNSd2+mht5FFKHGRHi3rFKqjbg9yktfBkX9PAma2E7TrTFGcVkCEwEZ/1eFWtg
	 LQTIJh7t/aHjlIEyDzjkfPoGQgc3YxmT/BT+x4f5lNz4bp1huiaUu9tHnKzzKywoPWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/kpFQE8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1EC606A31C;
	Thu, 19 Nov 2026 02:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/kpFQE8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7571F000C4;
	Thu, 19 Nov 2026 02:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055678;
	bh=7JxCaywFcMFITrGV4zq2OHJNgiLGWq7fcJ/zvTpTCdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/kpFQE8dPQRvT9XCUbAOqIdseZrXUeRJC+LGphTFKiT3CZd7boNv1pe5QirBifM4
	 rfsTmTssGIO90mmLLanzgc4/xzG2pugeT/5ws5j6CWusv4PUGhnnu1Yx6Zk2cktktL
	 D116xgiFPAU9x2J+hIT+3lcsNbTRD1efzugq4dFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1716/2214] soc/tegra: flowctrl: Release OF node reference on error
Date: Wed, 18 Nov 2026 15:56:32 +0100
Message-ID: <20261118150120.389612912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 4eaed7ea6ab36e1160d660b05551702c36dfed6c ]

tegra_flowctrl_init() obtains a reference from
of_find_matching_node() and currently releases it only after
of_address_to_resource() succeeds.

Release the reference before checking the resource conversion result so
the error path is balanced as well.

Fixes: 1fd09e5d884a ("soc/tegra: Add initial flowctrl support for Tegra132/210")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/flowctrl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/tegra/flowctrl.c b/drivers/soc/tegra/flowctrl.c
index 5db919d96aba5..727b92e938311 100644
--- a/drivers/soc/tegra/flowctrl.c
+++ b/drivers/soc/tegra/flowctrl.c
@@ -197,11 +197,14 @@ static int __init tegra_flowctrl_init(void)
 
 	np = of_find_matching_node(NULL, tegra_flowctrl_match);
 	if (np) {
-		if (of_address_to_resource(np, 0, &res) < 0) {
+		int err = of_address_to_resource(np, 0, &res);
+
+		of_node_put(np);
+
+		if (err < 0) {
 			pr_err("failed to get flowctrl register\n");
 			return -ENXIO;
 		}
-		of_node_put(np);
 	} else if (IS_ENABLED(CONFIG_ARM)) {
 		/*
 		 * Hardcoded fallback for 32-bit Tegra
-- 
2.53.0



