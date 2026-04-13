Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F49302146;
	Mon, 13 Apr 2026 16:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097070; cv=none; b=OH4SSzcVS5VitIN2WdpCphRuW1Yl6fnwL2PgxuCvpHv8DMEqdhyMzv6aYHhnNBruBTawCE2bV9ojhxb9D0t2fu04Av6iwETWtLJrcRczgGcMvBxDthEPS2HBn1fGIZkkiUobv/pbZXRQ9VXb+DOi7EKgC8S/a7B6wxWp4JmLYqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097070; c=relaxed/simple;
	bh=6EESIWGCD5R14TwOCBpaZLjA25HQAuFN3MI+D1SXoDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8ytdqDmHpU7jF6ifKzBFKz6NMOdN+1QyqnTpxU+5z4iA9VmYZ//+i+I1s/wkXsXLLbLjo0IaAt+qjTt+oHmwuV/BuN5igf3TPcF873OLGe0OSOe50Xxeo3w+uVPjuDg1GoSw9a/kzzMmTXvtVkhQoUQicYIvNMq93xo3eTkOfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJweTO2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJweTO2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A465CC2BCAF;
	Mon, 13 Apr 2026 16:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097070;
	bh=6EESIWGCD5R14TwOCBpaZLjA25HQAuFN3MI+D1SXoDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJweTO2jy9b0L3m8ti8J65wQz2cRKv3GvinmKPFLX8/s8B2DGxyOndDhzCkCIvibp
	 ZrOV6x2ZnZi2IDQEeL9QYd/fo2bG3cyFDttqf6eKg0IF4ZSNWSydLFrBbFJSe1WDah
	 quxFIa+4F+lTfbQtp2L9letx8QfFYMcC5epZTmnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 49/55] net/mlx5: Update the list of the PCI supported devices
Date: Mon, 13 Apr 2026 18:01:23 +0200
Message-ID: <20260413155726.661784314@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2043,6 +2043,7 @@ static const struct pci_device_id mlx5_c
 	{ PCI_VDEVICE(MELLANOX, 0x1023) },			/* ConnectX-8 */
 	{ PCI_VDEVICE(MELLANOX, 0x1025) },			/* ConnectX-9 */
 	{ PCI_VDEVICE(MELLANOX, 0x1027) },			/* ConnectX-10 */
+	{ PCI_VDEVICE(MELLANOX, 0x2101) },			/* ConnectX-10 NVLink-C2C */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */


