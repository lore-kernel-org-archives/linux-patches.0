Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744CF156F55;
	Mon, 16 Sep 2024 12:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488330; cv=none; b=MdRJsaImFaZqXzO1wXdgM6msKXDD+gqhiyhx3BNvnQIMrUlpvxqyEYes35ZFOHZUfWLKRlhwBoZTxyWdk0sXE+L56WYwN50RT/I99L8fcxz4TworKVcFPEnGVIFRaF8XDCHZ7B52PUjTlgh1OVqUSb7n3r7598I/Eh/wtQrPCxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488330; c=relaxed/simple;
	bh=ubdNv7B+STrCCMekL0KNBnNPgHmdQjcTw7+4zT7Oc0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoLrRLS8vISwe4fV7sVIPjnjclpPsQFp8jp70o5IocdQJUgWR5Sn7jmAFVwY8+FW5Wo1KaY5hUbQEIQAN3Ep4fd/U98Jvf4WFqfogv2IOfI3a5FTStbFilnPMBxIddZrY2er9BUNZURSjyOGAv6J4R7h2Gqte7vBIKK9xozLdcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGVRG7Et; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGVRG7Et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4EDC4CEC4;
	Mon, 16 Sep 2024 12:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488330;
	bh=ubdNv7B+STrCCMekL0KNBnNPgHmdQjcTw7+4zT7Oc0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGVRG7Et1R9oU5ikinalbh9iZBcRJCZkEFVSUIa8jQm+U5WzsCfdzwWZNzXoKVPc6
	 s42jjoAu8jNNSTHpDI729eaI9yVEz8RysZrqPEjQW+Rp8IKmsG1lQvS1Ij3IUU2Ygr
	 VI1Tdv0af6jppcCUjy5EDjsoZOjJZVy3dMEkEOAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 076/121] net/mlx5: Update the list of the PCI supported devices
Date: Mon, 16 Sep 2024 13:44:10 +0200
Message-ID: <20240916114231.674566704@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3e55a6c6a7c9..211194df9619 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2215,6 +2215,7 @@ static const struct pci_device_id mlx5_core_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x101f) },			/* ConnectX-6 LX */
 	{ PCI_VDEVICE(MELLANOX, 0x1021) },			/* ConnectX-7 */
 	{ PCI_VDEVICE(MELLANOX, 0x1023) },			/* ConnectX-8 */
+	{ PCI_VDEVICE(MELLANOX, 0x1025) },			/* ConnectX-9 */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */
-- 
2.43.0



