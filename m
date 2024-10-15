Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129E51C07C4;
	Tue, 15 Oct 2024 12:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996862; cv=none; b=lPN5xRzCiLrpblYTLvv0JjlASpH9p72fPVhLdsofyqwUCs/bbZe91IYrtMN007g1uDjbC6G0s2DxY/2AjB1WY7zK9Zs5k3IEychHrFgvt/a4w3MrOMeXckZ/Tz9ggu/e0vWutcVo7MrOlP3v1b9JLvpvDRV80PX+XSWnXgeZoY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996862; c=relaxed/simple;
	bh=CWGJ4WDdCB2U/rjbsw9YH6jTqIE4Aksp3erFwMeVEZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYCowEdIfGR6GktZdwui+rE2qqVJ6+lw1JlBqNS/gwnuZIwm+0naTlxlrrlbxMpuNMaWGZcwzs4DIJxiXvdc/rie5/uOd9BROMbzrbzoFVHEoDwPdLW58N3Tj7UwWBIIXTb8ZijKI+SSosEJ99bao2y9IMRZj2uKFcFOjEzIN9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wl9gHzFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wl9gHzFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F539C4CEC6;
	Tue, 15 Oct 2024 12:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996861;
	bh=CWGJ4WDdCB2U/rjbsw9YH6jTqIE4Aksp3erFwMeVEZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wl9gHzFyKnTchc/uIdgkA5SviTprjYO2mJscTASrCq0AeRCPTQsv90g12Dc3aJbt6
	 fIXjdh8VvERNTEtxvRwxcJ+CV89L8IR46QbbdcY+pLh9rUk5eGFNfXdHfN9fiI3WpG
	 JyLfAeM76z1KGVECTKnXt7IkMLv+HKeYyNKcU36Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meir Lichtinger <meirl@nvidia.com>,
	Eran Ben Elisha <eranbe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/518] net/mlx5: Update the list of the PCI supported devices
Date: Tue, 15 Oct 2024 14:38:44 +0200
Message-ID: <20241015123917.612962911@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meir Lichtinger <meirl@nvidia.com>

[ Upstream commit dd8595eabeb486d41ad9994e6cece36e0e25e313 ]

Add the upcoming BlueField-3 device ID.

Signed-off-by: Meir Lichtinger <meirl@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 35e11cb883c9..f76a4860032c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1600,6 +1600,7 @@ static const struct pci_device_id mlx5_core_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */
+	{ PCI_VDEVICE(MELLANOX, 0xa2dc) },			/* BlueField-3 integrated ConnectX-7 network controller */
 	{ 0, }
 };
 
-- 
2.43.0



