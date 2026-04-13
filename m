Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0DC24DCF6;
	Mon, 13 Apr 2026 16:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096949; cv=none; b=tQEDgW/DQavW59tzZzPiYEb/nsGK+4WKZibQZLXmoukDAEn3qpr6nvhTZpV2YVPB46u4Q2aQAPtxFWiJ2EwvelfFzNHOCE3I+8LkSIjz9/wtN8KtnfWamsHA4BPo64yNzcxSH7YoH5veb4cwkBKSgciyLZPIHeirOjuGFy5W8zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096949; c=relaxed/simple;
	bh=lUOEWIt4c8yk73bH76GfOsDnUjsPZKk9ez+Kr/Ohv7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8LRMMT8WtzjxGpk5WyyfKjQhNmqxNK6XXpUkaz8tRqP9q8UrO4cgz2LnIaqhQ0jj4jQUZxajWN89/54Egyw22+DOd1+dxqAkU7Sm/qHBw1XUJ4V4l6Ebn+N2jd1FjKxHFDDFHYHlhzuUrwf8GbBfKjrACPzMrcskEzlaNBqGEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxegeJ2X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxegeJ2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D62C2BCAF;
	Mon, 13 Apr 2026 16:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096949;
	bh=lUOEWIt4c8yk73bH76GfOsDnUjsPZKk9ez+Kr/Ohv7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxegeJ2XVIl11Zwd4sF2Vq+39Q6350yOZdVwqEz28SOXXzW23xCILGmvz0Q4BNW1E
	 TysTL0mUttgdMyA3fn2ZVa7CzS1q6J+2IElv8JrOY9GGYTXXfuKu96JwD01PNuPDxG
	 4l8i+U3jmmXA8O3VAsSIXumvkHJTgaPz4wvXC/Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 36/50] net/mlx5: Update the list of the PCI supported devices
Date: Mon, 13 Apr 2026 18:01:03 +0200
Message-ID: <20260413155725.860067119@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2208,6 +2208,7 @@ static const struct pci_device_id mlx5_c
 	{ PCI_VDEVICE(MELLANOX, 0x1023) },			/* ConnectX-8 */
 	{ PCI_VDEVICE(MELLANOX, 0x1025) },			/* ConnectX-9 */
 	{ PCI_VDEVICE(MELLANOX, 0x1027) },			/* ConnectX-10 */
+	{ PCI_VDEVICE(MELLANOX, 0x2101) },			/* ConnectX-10 NVLink-C2C */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */


