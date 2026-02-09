Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F75125B2;
	Mon,  9 Feb 2026 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647723; cv=none; b=k2dbrIVHm/VCT4ohnvvNC9omza3xM32p0VmALEMZaoLrBR78gyM+HAchGlhKjOdSKxh5nHnyUlJMQB0qSzkIMIcVt5A9VB8ffSeRncwknps3Yh+z7GpeDYsvKbi7sF3Ur7P4ZSMMXiHmVHdFIax558eWd9LC40eji6cgy9i1GHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647723; c=relaxed/simple;
	bh=DMVLfy3nDHjOj4MkPAXE+7JTarYbrme8CuDxvjcNHaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9Xawt5MWuYZ11YdQEDOlCFlMdXfK818FQ5qwJrh4IJZVkUkXDFP7QdisNaHV/6OjgBoCUzbP1HsAQG7lXWMwfS8y14iLh6NvaLjMjYt8Q+PvHKeDe873kNmY7OQX8uhqjCvyLubhKscYDbmNt9n8pJ3AnqBQMHeIx6pfXPovQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZhqZdu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZhqZdu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978D4C116C6;
	Mon,  9 Feb 2026 14:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647723;
	bh=DMVLfy3nDHjOj4MkPAXE+7JTarYbrme8CuDxvjcNHaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZhqZdu/L0ow1E6ULcpTFuCb9A2R6Qqq3gP8hfnw4caboT0o6XT3y8VJoGIW9+l1S
	 fT4TkB0naWGpq61we1YQZjyJF3UHpLQaHbwOhM77cCpKsLPXf/a/3TiG629Vr/WwYN
	 vt0gvw5/aeVEppSTmb8lczhQvrVpx9vsFghy0zho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xu Yang <xu.yang_2@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 010/113] pmdomain: imx8m-blk-ctrl: fix out-of-range access of bc->domains
Date: Mon,  9 Feb 2026 15:22:39 +0100
Message-ID: <20260209142310.582949893@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 6bd8b4a92a901fae1a422e6f914801063c345e8d upstream.

Fix out-of-range access of bc->domains in imx8m_blk_ctrl_remove().

Fixes: 2684ac05a8c4 ("soc: imx: add i.MX8M blk-ctrl driver")
Cc: stable@kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx8m-blk-ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/imx/imx8m-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx8m-blk-ctrl.c
@@ -340,7 +340,7 @@ static void imx8m_blk_ctrl_remove(struct
 
 	of_genpd_del_provider(pdev->dev.of_node);
 
-	for (i = 0; bc->onecell_data.num_domains; i++) {
+	for (i = 0; i < bc->onecell_data.num_domains; i++) {
 		struct imx8m_blk_ctrl_domain *domain = &bc->domains[i];
 
 		pm_genpd_remove(&domain->genpd);


