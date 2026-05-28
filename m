Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313C0335566;
	Thu, 28 May 2026 20:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999044; cv=none; b=P+wBNS2ZlnkRG8YYodnSujTFDOaIdbhQtqb/9Azvi79Ibuaq2/1jMysHHIFWe6bkkZBIb/0ZeBDByRc9UPOGn3T7ZQWJ29E2d3deK5b9B0t20g/FX4PQY+5RtJ2d5s0gxHaCytm9yjlCm2UF6DBIc1rNhs/BEQLZ57h0brcO/a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999044; c=relaxed/simple;
	bh=MlFdA/fs0YrVE7q1/Wv+4KzsRByWZYyKapsr8GAeZi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KLxVSQ/zNX0yn5wJUeNfGqbakf0/+oHdv6rYmV/hm2bSM5Scsxxzn4vzJl809qVHOnUFkkypW99OyGZ6F7WfjcMrlzNXrohYPqVTh9JgH08hLKkwvOqDF2YtrwjRWD683VW+P8IQbO+GFCOTKVMDMxT+KiSHxGpxQteE1TKJcPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXxiIPiM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXxiIPiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E63D1F000E9;
	Thu, 28 May 2026 20:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999043;
	bh=qTCF7karRfEKCkBcL1RBq/ZxlDqNb8TQPWq01KVefkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dXxiIPiMjO2fbh6KRnFexqVPMrRH5ugDVNXKK4AztgJEAOkiqpkZdNSvcoHPzqhu1
	 gI8i5pIJ1+JBvB7NVOP/G44apQRhipz4aAQ6D4NXsuAjntPQyb5CpZ298poPQBSw9l
	 NA7nEFy5Xfnb3Ntz/hkACsVti0TFBUS/Hv5WP6Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver White <oliverjwhite07@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 387/461] platform/surface: aggregator_registry: omit battery & AC nodes on Surface Laptop 7
Date: Thu, 28 May 2026 21:48:36 +0200
Message-ID: <20260528194658.662457203@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver White <oliverjwhite07@gmail.com>

[ Upstream commit 0488073a6c84571dd3cffe581a4a73a5fceb099d ]

Surface Laptop 7 exposes battery and AC status via Qualcomm PMIC GLINK
qcom_battmgr. Registering the standard SSAM battery and AC client
devices on this platform causes duplicate power-supply devices to
appear.

Drop the SSAM battery and AC nodes from the Surface Laptop 7 registry
group so that only the qcom_battmgr power supplies are instantiated.

Fixes: b27622f13172 ("platform/surface: Add OF support")
Signed-off-by: Oliver White <oliverjwhite07@gmail.com>
Link: https://patch.msgid.link/20260409034347.17381-1-oliverjwhite07@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surface_aggregator_registry.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index 0599d5adf02e6..f0881edfb6161 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -295,8 +295,6 @@ static const struct software_node *ssam_node_group_sl6[] = {
 /* Devices for Surface Laptop 7. */
 static const struct software_node *ssam_node_group_sl7[] = {
 	&ssam_node_root,
-	&ssam_node_bat_ac,
-	&ssam_node_bat_main,
 	&ssam_node_tmp_perf_profile_with_fan,
 	&ssam_node_fan_speed,
 	&ssam_node_hid_sam_keyboard,
-- 
2.53.0



