Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EDF14B094;
	Mon, 16 Sep 2024 12:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488630; cv=none; b=CBwXdxYFfbzv7ahcBZJ26HWwMeQq27jdVlnqgUoF4M7tLtEAjKZlc2HfGNMmqllHLFPEp64J4UISKbkoW+0HFdMaEchyWTaiXGzCsIQrU9WSAmqNsi104U8BMwLsR6Dh7K34FG4oAqU5VNl1+Tx2gv4sT6Z/1vkmVeqn4k0/xaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488630; c=relaxed/simple;
	bh=uENX6u9PvkdhiphK/U+R/FoiQ67lyevQZ/uU+pyKOp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/cbkZjHFO4lGIlRg924Arq+0Xa689Bdg6i4zno7tAj9hN3Oy0ROwTudhEsy57L0+4iw4WfZ/63ftuxUFjm5n3sA4gZJT5ignzZO9r2wyom54bJ+kzgOtqAQdvHxwnVdVYGfr29/1V3bTbjNPH5nsbkrERv2m+tIxuQhr+Oq4U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiDXGTmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiDXGTmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A21C4CEC4;
	Mon, 16 Sep 2024 12:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488630;
	bh=uENX6u9PvkdhiphK/U+R/FoiQ67lyevQZ/uU+pyKOp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiDXGTmZ98/xQj2rHzW4IOue73FuYfJRv2vlIE7QiXxFhJ6O793/Z1YHXVQ8YurlA
	 40tIXGrIZCujD10PQxbPcFHd6qMJooW5ZYJPMpqKYRWMLABn6323TbWxCFJDi4WWJS
	 5IjSeBPuyc7EG2wHncSMIae6cEfCZR53QUDig3MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 59/91] net/mlx5: Update the list of the PCI supported devices
Date: Mon, 16 Sep 2024 13:44:35 +0200
Message-ID: <20240916114226.443019890@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 7472d157cb8014103105433bcc0705af2e6f7184 ]

Add the upcoming ConnectX-9 device ID to the table of supported
PCI device IDs.

Fixes: f908a35b2218 ("net/mlx5: Update the list of the PCI supported devices")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 11f11248feb8..96136229b1b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2205,6 +2205,7 @@ static const struct pci_device_id mlx5_core_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x101f) },			/* ConnectX-6 LX */
 	{ PCI_VDEVICE(MELLANOX, 0x1021) },			/* ConnectX-7 */
 	{ PCI_VDEVICE(MELLANOX, 0x1023) },			/* ConnectX-8 */
+	{ PCI_VDEVICE(MELLANOX, 0x1025) },			/* ConnectX-9 */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */
-- 
2.43.0



