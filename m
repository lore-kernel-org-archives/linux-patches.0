Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA9A2EAB86;
	Tue, 22 Jul 2025 14:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193556; cv=none; b=pxidZO9IhLyZA5IB0QMmVXvPsxlyBj3CS5uIaTzDfxFrm3VZEVHRfO3j3N2vkgR+P9XjqZ2h6yFO74BSNsXvBlTs2wgO8J5GIDeuAm0nKP0hetAfS5BUVgMBBBcHeUFwvR+346+xMwcLZeJrUN1ufcijQOept63q9GVDhJh8dG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193556; c=relaxed/simple;
	bh=3R9vU1mw4a4Si562Ib62OtD15uTap9mlilZmB8DZB10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSFldX6NVMJqPRoCosFuKfIaru29PZjlw3vqWT2RPCeMiNprVLSMAVfMwK9QGHva9wPE18NSG7k2VQkY78Fe8NCi0zO4FEELkgd1Pib1n641wTknhSwtXG98XQciS4UwhZ9r3VH56P8zdFnOQwJ0+7U0NcMG0RHHPTjE0ryT3wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYEKyT2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYEKyT2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D365C4CEF1;
	Tue, 22 Jul 2025 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193556;
	bh=3R9vU1mw4a4Si562Ib62OtD15uTap9mlilZmB8DZB10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYEKyT2YuUwJYeYBGDtvLMiBRL4bU0f6l/XSwRKt+/f2A06HsnH3jnAqcpAbTjLm3
	 mobpoqUthYO3vGOvF61iXkg4z60HmMl64Cg7EBDOgK24M+HU5xPr/Fqx88G7/YN5AK
	 NVld/Ifb+tEfIFacNzBYlj2PtuRdp8HFdP/okiro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.15 128/187] ice: check correct pointer in fwlog debugfs
Date: Tue, 22 Jul 2025 15:44:58 +0200
Message-ID: <20250722134350.513416546@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit bedd0330a19b3a4448e67941732153ce04d3fb9b ]

pf->ice_debugfs_pf_fwlog should be checked for an error here.

Fixes: 96a9a9341cda ("ice: configure FW logging")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_debugfs.c b/drivers/net/ethernet/intel/ice/ice_debugfs.c
index 9fc0fd95a13d8..cb71eca6a85bf 100644
--- a/drivers/net/ethernet/intel/ice/ice_debugfs.c
+++ b/drivers/net/ethernet/intel/ice/ice_debugfs.c
@@ -606,7 +606,7 @@ void ice_debugfs_fwlog_init(struct ice_pf *pf)
 
 	pf->ice_debugfs_pf_fwlog = debugfs_create_dir("fwlog",
 						      pf->ice_debugfs_pf);
-	if (IS_ERR(pf->ice_debugfs_pf))
+	if (IS_ERR(pf->ice_debugfs_pf_fwlog))
 		goto err_create_module_files;
 
 	fw_modules_dir = debugfs_create_dir("modules",
-- 
2.39.5



