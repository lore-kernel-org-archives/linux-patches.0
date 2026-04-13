Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9304327466A;
	Mon, 13 Apr 2026 16:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096609; cv=none; b=IDJL+bIbZYGKFbJdVZRSTNX4FA0D9TrKOi2vjAyxr0rC1tH+rfGl5xK2pYF+PivG+9pW4xRH4uWaxcdgXhK+xK37mZIGeio9XNLM4lDrg7PqWYJXpX1CinghHnEa+cLn+21H4D+4UstHU2Dvdpq/dmTGdaU5oXgLGQjxcFyqpAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096609; c=relaxed/simple;
	bh=hET9J01MtZ90TLc8HhqmHTp4nqC+4jesSrNzJ0EmJc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbe5iHM6ulIov/GHSB9nAIXjBEAouMAsgjXAx8a545afQb4mZ2o8n+B2wy2hpEPoQO+LkjDpX7E3Gla49FCm+l+r9+2aiqLVFT802AjrjpfG7K8Pw1Av1ifSTWpxQdM1WTZ4Vs6nPF7mqw5hzchhd++uEdjUXpDcu3ORuYVNgnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOp+m3Gv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOp+m3Gv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27760C2BCAF;
	Mon, 13 Apr 2026 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096609;
	bh=hET9J01MtZ90TLc8HhqmHTp4nqC+4jesSrNzJ0EmJc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOp+m3GvROU49hJNNy5tc/ZYchzMyOzLGlaShGUkhYPtKcGg1KxQes/iL3TQ85eIA
	 reX4FT7CK1fQCz/nXyC+XtYnFESCPzjju5lncOVPtH349VKkc3fqVLcza2TmVbg8WJ
	 MUpRa+LAh8m3jjFsRuOqbEOLW90xRZodjvimaNoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 45/83] net/mlx5: Update the list of the PCI supported devices
Date: Mon, 13 Apr 2026 18:00:13 +0200
Message-ID: <20260413155732.702411525@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

commit a9d4f4f6e65e0bf9bbddedecc84d67249991979c upstream.

Add the upcoming ConnectX-10 NVLink-C2C device ID to the table of
supported PCI device IDs.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260403091756.139583-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2238,6 +2238,7 @@ static const struct pci_device_id mlx5_c
 	{ PCI_VDEVICE(MELLANOX, 0x1023) },			/* ConnectX-8 */
 	{ PCI_VDEVICE(MELLANOX, 0x1025) },			/* ConnectX-9 */
 	{ PCI_VDEVICE(MELLANOX, 0x1027) },			/* ConnectX-10 */
+	{ PCI_VDEVICE(MELLANOX, 0x2101) },			/* ConnectX-10 NVLink-C2C */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */


