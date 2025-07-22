Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63432EAD00;
	Tue, 22 Jul 2025 14:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193289; cv=none; b=tJkN3CKK9/N5scvn5fqNWZu7WICQ4Bi1GxjQrF1yPY7b00gsOIJHq1HkIc+NSFsu9UhqBaN63c1GbBj3T4lZ3qh1XEEjza/ICiHaAPUAwf5O7qBejVzPEZlGl6fSvjRx95qJCBpJRWnhMMcjLEFULxIdFJE6z5lafRpcTG1HKT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193289; c=relaxed/simple;
	bh=curf9zAkOKH0m0vOOZzrsp45egrj8bJ0x8cxghIyZuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjaJEthjviQdfjOoIiagFm8nXBksDFHucgxDE3e2PBN27p82V+/jCMBv0pGEB6GWHjsl4k5ePvhdw+0byYpb2P2KJe/P0AOY34LZhBvicmjMLek+YvFANn83dzv7SwvRHkf4ovkMpRSqJVavTwzBVDSn+SFl+kQIN+3ck+SsPhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzceGbQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzceGbQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0F2C4CEEB;
	Tue, 22 Jul 2025 14:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193289;
	bh=curf9zAkOKH0m0vOOZzrsp45egrj8bJ0x8cxghIyZuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzceGbQLDRQdp4nlX78c3Geh8kspt5Yh8p8CelCj7vuTWiI3pzax/W6OEIkFprS2I
	 NsQE0Zd3R8v4daWdsNhIhdQDDrWpVvCVGBhRtuBijnmtmq29C0oAYN+nSCh85qR3CS
	 V3HzNZ7+0ZhcuNf0bfmUBxSDxgf2ZINenB7ypIwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Eran Ben Elisha <eranbe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 048/187] net/mlx5: Update the list of the PCI supported devices
Date: Tue, 22 Jul 2025 15:43:38 +0200
Message-ID: <20250722134347.538152035@linuxfoundation.org>
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

From: Maor Gottlieb <maorg@nvidia.com>

commit ad4f6df4f384905bc85f9fbfc1c0c198fb563286 upstream.

Add the upcoming ConnectX-10 device ID to the table of supported
PCI device IDs.

Cc: stable@vger.kernel.org
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1752650969-148501-1-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2257,6 +2257,7 @@ static const struct pci_device_id mlx5_c
 	{ PCI_VDEVICE(MELLANOX, 0x1021) },			/* ConnectX-7 */
 	{ PCI_VDEVICE(MELLANOX, 0x1023) },			/* ConnectX-8 */
 	{ PCI_VDEVICE(MELLANOX, 0x1025) },			/* ConnectX-9 */
+	{ PCI_VDEVICE(MELLANOX, 0x1027) },			/* ConnectX-10 */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */


