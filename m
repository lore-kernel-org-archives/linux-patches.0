Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E12E29D28A;
	Tue, 26 Aug 2025 13:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214081; cv=none; b=W+9iFE/BZTFLaA0jZPBGuBvYIh9643zD1C/Rc+ChVEspYYKoO+w5KNvnHf0EZQpJY7ib8FpWf3NMocklrlHEIxRz6+9bxyuj33OQ6/3NPlqnEABHaBnN/5QsEPTD6iRDyzp8etRbKCGyya7WoxmqdfcGSyS7RYw15irQqc1Dnec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214081; c=relaxed/simple;
	bh=MF6Ej5g1MI19/I13/6BniRDYkiX+cAydYscevyd1XmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZNDqcO3O6m2It6tWcg4W1dRrp74m23ZGO0TVEyKZWBdR+0B4MwTryp/g4sCd8flzBjAkWhTnat1hZ17NgaKuO7BxRpYBwmk44Z0WOGZKDfa5ok3EsPfvP9YfXb0Q8teACX97gxIxNoqkQKnHxIjZ8CBgZTd6Nn3mbCaIw0RZNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/d/s0wf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/d/s0wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF29EC4CEF1;
	Tue, 26 Aug 2025 13:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214081;
	bh=MF6Ej5g1MI19/I13/6BniRDYkiX+cAydYscevyd1XmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/d/s0wfeuvAnxiiXUVkkHDV1dOhG75OAh4rdZ18hTXP199xwxRorqcMxEZJ7cvQ6
	 y2lCI9Hmw3QySYpvm1V9tm40jtCe5Q6N/G8Uamnm32n5V2BYnzJlZcYwmsLnvDVBWH
	 Mi3IXMTw3l2lY5SM6CGbma+pwzglh8du+t4PDhWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jurgens <danielj@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 582/587] net/mlx5: Base ECVF devlink port attrs from 0
Date: Tue, 26 Aug 2025 13:12:11 +0200
Message-ID: <20250826111007.842225157@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Jurgens <danielj@nvidia.com>

[ Upstream commit bc17455bc843b2f4b206e0bb8139013eb3d3c08b ]

Adjust the vport number by the base ECVF vport number so the port
attributes start at 0. Previously the port attributes would start 1
after the maximum number of host VFs.

Fixes: dc13180824b7 ("net/mlx5: Enable devlink port for embedded cpu VF vports")
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250820133209.389065-2-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index d8e739cbcbce..91319b5acd3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -47,10 +47,12 @@ static void mlx5_esw_offloads_pf_vf_devlink_port_attrs_set(struct mlx5_eswitch *
 		devlink_port_attrs_pci_vf_set(dl_port, controller_num, pfnum,
 					      vport_num - 1, external);
 	}  else if (mlx5_core_is_ec_vf_vport(esw->dev, vport_num)) {
+		u16 base_vport = mlx5_core_ec_vf_vport_base(dev);
+
 		memcpy(dl_port->attrs.switch_id.id, ppid.id, ppid.id_len);
 		dl_port->attrs.switch_id.id_len = ppid.id_len;
 		devlink_port_attrs_pci_vf_set(dl_port, 0, pfnum,
-					      vport_num - 1, false);
+					      vport_num - base_vport, false);
 	}
 }
 
-- 
2.50.1



