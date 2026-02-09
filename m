Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4563793AC;
	Mon,  9 Feb 2026 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647139; cv=none; b=OXSB2p4fgKBA+JWnS5rBoKiDukh0F7ZmFXbXioHKq0u3XjAIsn9KoHfLRTOMm7flazku3P4Yz16IVzMeL87RLDnyKdemBum9phga6L3WRehGU6KltkXGAWrpEXAc9b0rCFRy5D1z8BqgAzuWEeFAZ2IrFXS2MPBIYNEKJmBKbF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647139; c=relaxed/simple;
	bh=Tz+AZBBrpLsaTFDEdieW1iftE3VGrv5gYoEm3VDEZLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8NpvDH0moHuUN6+EgF10TfIJtVDvffLYT4OjEk1PU25JmJbgfT4bsVw468E6WxDbvIPB5uYZr9hic1vB10oDYqf75cEep8XJ/Z8aN9+dghhg+FQ1dWoWudIl1xGsmigCdhw2GH25qUyKkkRV+DN0T1MHsDcXfHrzwyy/9FaW4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJIWMcXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJIWMcXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6160C116C6;
	Mon,  9 Feb 2026 14:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647139;
	bh=Tz+AZBBrpLsaTFDEdieW1iftE3VGrv5gYoEm3VDEZLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJIWMcXmwdyvZ/RwyRuUtrptcsmK4Z6mNxnEI2fLqidTAb25JonBwgkoROUa5C6VG
	 NbLZ4rH6NYxQOO/mildPjgPvl8mCvFCucFNBVH3T8cKmQmdOwiPTzYIUZzzLPmjCsJ
	 0NKXTRF3hKX+EoA0fKYzpper1EdEt8iOmhquuDCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xu Yang <xu.yang_2@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 011/175] pmdomain: imx8m-blk-ctrl: fix out-of-range access of bc->domains
Date: Mon,  9 Feb 2026 15:21:24 +0100
Message-ID: <20260209142320.883337517@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


