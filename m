Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17A71DF24C;
	Wed,  6 Nov 2024 12:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894957; cv=none; b=qUI/IAM3xg67emuC6ro0IkCY07fG+DCSo5gFMHCTqFc2+FCXSkv/6jV4MNXkzCdS0Kvix1dA918oetSTD2IxewmyNefZAIfbq6MntNk6OdBM/itvf2WlTBcRTmRkV/FJtdXoRKY6tHN7lhmkdqcKnjqlYo6Pvy3OJeZe9PHUfEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894957; c=relaxed/simple;
	bh=P7xJSIrFubOT4g6yuMpmWMC409qDEb8wVi64W190aaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBRIAwqwnJ0adWSHDi1C6J2sYiXlvoOPR47E+TBfWAsGhSun7sYSmjyRYprXCsa40DaLjZfEX7TmhnGZ3rWhUk/fsBaP184GJaxhzDCr3AyAq+wpy3syuXaLvnVEXtc+UPanDvl4GBSOH1nLq4w8XaU6Sy4jPNLdTeT4uAYtue0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXtNS2wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXtNS2wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E549C4CECD;
	Wed,  6 Nov 2024 12:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894956;
	bh=P7xJSIrFubOT4g6yuMpmWMC409qDEb8wVi64W190aaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXtNS2wbXckJZ3MdH9Jxlj8QheHtthqE3YtUa5mrLKUmVB243VswlWYRh2KAnj+GL
	 jvzaAMhqdQ42Pn0aPPlNnXttyR1cJsuZRCarPkwnxgUvp5Vj9HkPtOtFsUvWlRqPdP
	 YnNGiBfJG4VIVsiug/VhnzT7FDN3SCKPV2SPGERc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eran Ben Elisha <eranbe@mellanox.com>,
	Aya Levin <ayal@mellanox.com>,
	Saeed Mahameed <saeedm@mellanox.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/350] net/mlx5: Update the list of the PCI supported devices
Date: Wed,  6 Nov 2024 12:58:57 +0100
Message-ID: <20241106120321.099718865@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit 85327a9c415057259b337805d356705d0d0f4200 ]

Add the upcoming ConnectX-6 Dx.

In addition, add "ConnectX Family mlx5Gen Virtual Function" device ID.
Every new HCA VF will be identified with this device ID. Different VF
models will be distinguished by their revision id.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index e09bd059984e..908984464c13 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1642,6 +1642,8 @@ static const struct pci_device_id mlx5_core_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x101a), MLX5_PCI_DEV_IS_VF},	/* ConnectX-5 Ex VF */
 	{ PCI_VDEVICE(MELLANOX, 0x101b) },			/* ConnectX-6 */
 	{ PCI_VDEVICE(MELLANOX, 0x101c), MLX5_PCI_DEV_IS_VF},	/* ConnectX-6 VF */
+	{ PCI_VDEVICE(MELLANOX, 0x101d) },			/* ConnectX-6 Dx */
+	{ PCI_VDEVICE(MELLANOX, 0x101e), MLX5_PCI_DEV_IS_VF},	/* ConnectX Family mlx5Gen Virtual Function */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */
-- 
2.43.0



