Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9EE145B0C;
	Mon, 16 Sep 2024 12:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488119; cv=none; b=bWqqtMyD0czZPKzi2NYVrKlxw4xuk4nJgD/ET3kr/HbLa1FcvRLTOrVeiCNbjeKsjO7JkeenG8CLAiZUBqUb2fNs19xGTdsm+UlTp9dsjx/IphPCGYVhyvAkaFYkOb3K1hK5JZar/LARLjMk8wLI/O26ZVCXb8sI3LQZyNgWzlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488119; c=relaxed/simple;
	bh=Uba+Wv5ApOVz2unbXMhNp88W7wmi6JYhdafjeTdxJ1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBBIN5GmoVOkAakaPx++5YgqeEiEdomBaOvde6OYpwBXNJkYHsJ4uAc4bbru8lF8ezRc0i6rCKg5GwSnhGsMzxvaKhbIZ8SxunsK3RxpUKBDYhsgswvz1dvk7nQX5E3zAvqe0Lv3MbmOLVYKxO5k8oob60z5ICZxv9p7NJQaPoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJLNs1Js; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJLNs1Js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3853C4CEC4;
	Mon, 16 Sep 2024 12:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488119;
	bh=Uba+Wv5ApOVz2unbXMhNp88W7wmi6JYhdafjeTdxJ1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJLNs1JsRwaUYFWo8TxhKQx74OX0SJ3asfdQ92zKYwn+aUByB2+brGSUhXLu2wLF7
	 RVwlddwy7Y/rda0IJKq6LZ577A/rnVU5mjlpRh0VA7rde7H00zdZhkZLDer/cRl4bH
	 BmG9fcy6HiLj2N7um3hUDoJzY3nBAg/R0lq0/GJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 40/63] net/mlx5: Update the list of the PCI supported devices
Date: Mon, 16 Sep 2024 13:44:19 +0200
Message-ID: <20240916114222.483820098@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 67849b1c0bb7..76af59cfdd0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2025,6 +2025,7 @@ static const struct pci_device_id mlx5_core_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x101f) },			/* ConnectX-6 LX */
 	{ PCI_VDEVICE(MELLANOX, 0x1021) },			/* ConnectX-7 */
 	{ PCI_VDEVICE(MELLANOX, 0x1023) },			/* ConnectX-8 */
+	{ PCI_VDEVICE(MELLANOX, 0x1025) },			/* ConnectX-9 */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */
-- 
2.43.0



