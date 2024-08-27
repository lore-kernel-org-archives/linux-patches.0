Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E9812E4D;
	Tue, 27 Aug 2024 15:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771392; cv=none; b=Jw3/qBUPTRhiH/NTanGOgaGCRZDd61zpKwYNJwdiQYktcYVMOGt4QKc082/oNlCDW3w9yVS4s4vfCAIKdxunmJTYUCoFOd86t4GVaACGfiZWTEgPqMpsjz4wBAoPrMsoM0Ajz0DsHP+JDlKv8Q24m7/Wm0b9fmGqQRMqcbAPOMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771392; c=relaxed/simple;
	bh=bB0i1jXntNK+P+bXqn8bDjeqYNykg/AKkh5GGpIHpek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BntlfS9lGTjLrl/BTioZI8Fdbj4lD5BUhLyMtGIKqwgXlfR/ZNvnelGH13OTnDiCZZktVgJyG49hQlbgCulF8+HTtWPkspzmR8pVZzMSTlOO+9u+0o255vLqYac+ZspxOS5zFiGnG+/b1PZp74TJS5nwOF426KcVmxlsRvsVcaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyl+//e3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyl+//e3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48F5C4AF52;
	Tue, 27 Aug 2024 15:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771392;
	bh=bB0i1jXntNK+P+bXqn8bDjeqYNykg/AKkh5GGpIHpek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyl+//e3cKHIWUdaLlZJ2Off545dostC18zbNHdsYiyqym/n0xpHEI80lmyPP/9tu
	 6++UgZSOqfNWH+a/ifgINqphhdKO2sM+oXSik0AUtELICw7IXtestKHkhu5bU3doik
	 TFgjWAbO6MdwplcUvJQlGiX1deeP0rB5hb+gU68I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 175/273] ice: use internal pf id instead of function number
Date: Tue, 27 Aug 2024 16:38:19 +0200
Message-ID: <20240827143840.071339850@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 503ab6ee40fc103ea55cc9e50bb879e571d65aac ]

Use always the same pf id in devlink port number. When doing
pass-through the PF to VM bus info func number can be any value.

Fixes: 2ae0aa4758b0 ("ice: Move devlink port to PF/VF struct")
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Suggested-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/devlink/devlink_port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/devlink/devlink_port.c b/drivers/net/ethernet/intel/ice/devlink/devlink_port.c
index 13e6790d3cae7..afcf64dab48a1 100644
--- a/drivers/net/ethernet/intel/ice/devlink/devlink_port.c
+++ b/drivers/net/ethernet/intel/ice/devlink/devlink_port.c
@@ -337,7 +337,7 @@ int ice_devlink_create_pf_port(struct ice_pf *pf)
 		return -EIO;
 
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
-	attrs.phys.port_number = pf->hw.bus.func;
+	attrs.phys.port_number = pf->hw.pf_id;
 
 	/* As FW supports only port split options for whole device,
 	 * set port split options only for first PF.
@@ -399,7 +399,7 @@ int ice_devlink_create_vf_port(struct ice_vf *vf)
 		return -EINVAL;
 
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PCI_VF;
-	attrs.pci_vf.pf = pf->hw.bus.func;
+	attrs.pci_vf.pf = pf->hw.pf_id;
 	attrs.pci_vf.vf = vf->vf_id;
 
 	ice_devlink_set_switch_id(pf, &attrs.switch_id);
-- 
2.43.0



