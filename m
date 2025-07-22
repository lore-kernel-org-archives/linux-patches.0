Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02FF433A8;
	Tue, 22 Jul 2025 13:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192114; cv=none; b=YaG/LzZfJ5C/k9mM4A1MlBBOM25nTywpmyY7g2QsLR9gKWKwWiPys19VerLBvnqlIHmCs5xWUcv8MaDUaVQog/flm4J7tjKWXWPhS0oux9tZ8C3sG35vwyoCex8hOgPpkCKmO0IbYu85C/hqI0m0VpmF38zQMvL7v9xpXskuoDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192114; c=relaxed/simple;
	bh=XQ8umlCMpIW1e5Ib634r8XtmxCIReATbfhAh/GptKsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frjQP7TQ4uT4JW54m5Qcpp4h2oXKOGW26AwcArtEg9l15jTkrH29AczjkbFjV+pQfbj3igM6SEq3iwQu68bQWqu1VmeX8XUYxm9U8tcd9lcmTjwrY8LRY3+tWZ0Y6GuMerkHRFE/1bCvpP4M4jZTcBnXocrvOCeNt0fuQiB/iMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0StJ2ecP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0StJ2ecP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB35C4CEEB;
	Tue, 22 Jul 2025 13:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192113;
	bh=XQ8umlCMpIW1e5Ib634r8XtmxCIReATbfhAh/GptKsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0StJ2ecPbCCdtHwNY2ID0i9Lik2ujM0d6F1zH4Q7sqFkoBcaDqOnyLRnLAN65GSsY
	 jjYFfw2OGdy40V+IcfwmXypdzszcXHwxziUCmMqQCpwimpZFew7YYQ90Hir+rvxlCs
	 +wY0ZC8lI5yxlveU+FVn5Uz7ca39JBcHQnL5wQC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Eran Ben Elisha <eranbe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 16/79] net/mlx5: Update the list of the PCI supported devices
Date: Tue, 22 Jul 2025 15:44:12 +0200
Message-ID: <20250722134328.979672976@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2035,6 +2035,7 @@ static const struct pci_device_id mlx5_c
 	{ PCI_VDEVICE(MELLANOX, 0x1021) },			/* ConnectX-7 */
 	{ PCI_VDEVICE(MELLANOX, 0x1023) },			/* ConnectX-8 */
 	{ PCI_VDEVICE(MELLANOX, 0x1025) },			/* ConnectX-9 */
+	{ PCI_VDEVICE(MELLANOX, 0x1027) },			/* ConnectX-10 */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */


