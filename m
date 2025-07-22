Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF7B2EA74A;
	Tue, 22 Jul 2025 13:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192310; cv=none; b=sTZpKlx5MHwiGA17WllKsy5Lz0HP5HiXch57cowhkYJ9Pd1NsRzACO52fHm4H3hCa8oFzS0oMStExEiPMgwH8G1zH0IaEUPyoLXs/ypi8pNM1fI5uf38AoF6/KJETzNUsESC1IriYeuHyzcV2G0Y1scyaASeJutElox1CikbjkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192310; c=relaxed/simple;
	bh=c4ifR8ovwSu9rrS0tY5LDqoMnnyG/5eZGsKlfN+3/EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRxArzKS5aoutcThLzQ055woXoekuG8UXcd0dCjkJFdauck63WDLZyzVS++7SqgezDLJuibIOmWnweEWiE+c2LQe6moCa0PPAb0L1wMTnk+Bj/I/vy9CvMGViQDAPlunQtQ1itrlRLekG6XMaeKhTdSLeAebZfw3DYGkwdRhGys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYt8Ku+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYt8Ku+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A04C4CEEB;
	Tue, 22 Jul 2025 13:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192309;
	bh=c4ifR8ovwSu9rrS0tY5LDqoMnnyG/5eZGsKlfN+3/EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYt8Ku+QU/nd2J4kyPQXPleXg2VwuzIxSQePTK5TGVnX83JylFHjD1TLu4qtu/3tN
	 OA8eRnNGQ0V2BSRcqpxpqHGNWWPHVH25DliGt4BYFkWxzyLrAjmsRII+kd7N5rsa0p
	 i/HxylQj+DFJ45l7g7DivY/DMfauQUnqf66ScgpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Eran Ben Elisha <eranbe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 027/111] net/mlx5: Update the list of the PCI supported devices
Date: Tue, 22 Jul 2025 15:44:02 +0200
Message-ID: <20250722134334.407505062@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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
@@ -2206,6 +2206,7 @@ static const struct pci_device_id mlx5_c
 	{ PCI_VDEVICE(MELLANOX, 0x1021) },			/* ConnectX-7 */
 	{ PCI_VDEVICE(MELLANOX, 0x1023) },			/* ConnectX-8 */
 	{ PCI_VDEVICE(MELLANOX, 0x1025) },			/* ConnectX-9 */
+	{ PCI_VDEVICE(MELLANOX, 0x1027) },			/* ConnectX-10 */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */


