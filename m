Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BEF280CD4;
	Tue, 27 May 2025 17:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368614; cv=none; b=L48ffWfmgZOi1Sq05l5pBXhroh+8oiiI9N/tsX/sgtfdEXxTRaePwaqIIUR/CUqRwKEyxeo3RxvDPPZFdFZ/KCqdOFAU8bWVD4efB6/YWPU5LkkOkFvK/uNm3TkyLmB3zGDRlZkuIEerzK0u/WjYbYwD/jPB4FjejPljLQ7LZZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368614; c=relaxed/simple;
	bh=KkY+KPQtTO7qxH/AZVinuUXILpLdrd8epC4bCSrzDSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ly1FLvNumGTcXjnH2+w+1TZvUSLbnMv3sIJzCN6xyVMehvb+boEp/bRQjsuADpAgModdh0+to/70bcGHJh5y7R5PCZ5ho5k2dtxZ2/5mE/DN5dYeZ2DdxLT4jx0NrxZWy4Tr5SkC2xDMU5qPX13QQtLKtKSici9sAeX5pkxS0lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n63rgswy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n63rgswy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BB2C4CEE9;
	Tue, 27 May 2025 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368614;
	bh=KkY+KPQtTO7qxH/AZVinuUXILpLdrd8epC4bCSrzDSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n63rgswyWNo66c0ldPSYSQFCD5yg/fhIfYnZSRPrMzd8N6VE8kaq2qjSw+nspLsw4
	 cLUu8yqHlq6gTETHZaZrbZHhdXQRhoI4uEBFKRB8+/L/JtKw186Nad+LrolDe4pdau
	 wJ6J7nZF4N2c5hdwrFY3Mq+eY5J6AafCBtT4TQ3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Suman Ghosh <sumang@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 763/783] octeontx2: hide unused label
Date: Tue, 27 May 2025 18:29:20 +0200
Message-ID: <20250527162544.201104248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit ca57d1c56f4015d83fe7840b41d74783ee900b28 upstream.

A previous patch introduces a build-time warning when CONFIG_DCB
is disabled:

drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c: In function 'otx2_probe':
drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:3217:1: error: label 'err_free_zc_bmap' defined but not used [-Werror=unused-label]
drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c: In function 'otx2vf_probe':
drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c:740:1: error: label 'err_free_zc_bmap' defined but not used [-Werror=unused-label]

Add the same #ifdef check around it.

Fixes: efabce290151 ("octeontx2-pf: AF_XDP zero copy receive support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Suman Ghosh <sumang@marvell.com>
Link: https://patch.msgid.link/20250219162239.1376865-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |    2 ++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -3214,8 +3214,10 @@ static int otx2_probe(struct pci_dev *pd
 
 	return 0;
 
+#ifdef CONFIG_DCB
 err_free_zc_bmap:
 	bitmap_free(pf->af_xdp_zc_qidx);
+#endif
 err_sriov_cleannup:
 	otx2_sriov_vfcfg_cleanup(pf);
 err_pf_sriov_init:
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -740,8 +740,10 @@ static int otx2vf_probe(struct pci_dev *
 
 	return 0;
 
+#ifdef CONFIG_DCB
 err_free_zc_bmap:
 	bitmap_free(vf->af_xdp_zc_qidx);
+#endif
 err_unreg_devlink:
 	otx2_unregister_dl(vf);
 err_shutdown_tc:


