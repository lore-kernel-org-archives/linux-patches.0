Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE627154C05;
	Tue, 23 Jan 2024 00:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969410; cv=none; b=ue7/Gf11qpb7jkuocLdGLT/lKH2OFfFOF36eHj1flDvN2Xzn/iGBROWq6PGXE5TkrUcMBsrTS8r9z5D0p9EI3Y9EgNPoieeWHStjERC1KEyMrijTRqgE2WKArJGSbMKCCxTHUI8oubMmlz4c+dtEho1thg26tIm2HTSsICgnnRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969410; c=relaxed/simple;
	bh=5sAz/AUaNQP9YwcMsMbEQEZKdtyyGT48e9dbOTnOxbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2LzwxrNC8SUlOVcYc0WAgye0R2OX6RwrO0fkubBxgKYZgN18pTbY2g8jlwR6f5CoRz4Tlre9Wm4LVvPZRjjjs0hsnCC0wQbMrBAsZY/jKUgGK160niHyetQ2SnhPTbf+4UANRquI59hkDLcsegl9cCmlkh5e7C4KWgCFH/XEMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkoLrNI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkoLrNI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FF9C43394;
	Tue, 23 Jan 2024 00:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969410;
	bh=5sAz/AUaNQP9YwcMsMbEQEZKdtyyGT48e9dbOTnOxbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JkoLrNI/WF6nZoWxYoie4eKg/xqOWc3EznszE6XFoghevU7yy8Ffo2y29k6GtLlDB
	 2R0X8dy4dZCr6NtDHkuN//XQ6uNObQFzZFkj8qzU6ZZbLwANOLGsgrBl+L8HFauYAl
	 1d4EhXtFVFAPBihdo+l/iZT7rULdXIgMzo7WSTL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <kunwu.chan@hotmail.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Kunwu Chan <chentao@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.7 228/641] ice: Fix some null pointer dereference issues in ice_ptp.c
Date: Mon, 22 Jan 2024 15:52:12 -0800
Message-ID: <20240122235825.071008020@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 3027e7b15b02d2d37e3f82d6b8404f6d37e3b8cf ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: d938a8cca88a ("ice: Auxbus devices & driver for E822 TS")
Cc: Kunwu Chan <kunwu.chan@hotmail.com>
Suggested-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 71f405f8a6fe..e6b1ce76ca8a 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2692,6 +2692,8 @@ static int ice_ptp_register_auxbus_driver(struct ice_pf *pf)
 	name = devm_kasprintf(dev, GFP_KERNEL, "ptp_aux_dev_%u_%u_clk%u",
 			      pf->pdev->bus->number, PCI_SLOT(pf->pdev->devfn),
 			      ice_get_ptp_src_clock_index(&pf->hw));
+	if (!name)
+		return -ENOMEM;
 
 	aux_driver->name = name;
 	aux_driver->shutdown = ice_ptp_auxbus_shutdown;
@@ -2938,6 +2940,8 @@ static int ice_ptp_create_auxbus_device(struct ice_pf *pf)
 	name = devm_kasprintf(dev, GFP_KERNEL, "ptp_aux_dev_%u_%u_clk%u",
 			      pf->pdev->bus->number, PCI_SLOT(pf->pdev->devfn),
 			      ice_get_ptp_src_clock_index(&pf->hw));
+	if (!name)
+		return -ENOMEM;
 
 	aux_dev->name = name;
 	aux_dev->id = id;
-- 
2.43.0



