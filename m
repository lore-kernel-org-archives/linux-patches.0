Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623063;
	b=ie57JakTjkaFaYI5XnfgWoUiaygCMrlVDae7tBinpWzxOtHlg9BALmcJpUf+xTF4ZLmR
	 pLb3Nmhh8qaJ4PFvUJteEQv6zO78WqEFSyfTgKbldenbqAl40nza/IZV9HKEB+aVrXw+h
	 gKufrmVIYZPDnq1bY0jnpBnbBeGtfia2fIiQ2xq575dH4Vn2Lxu/k/3y/mAAUQ/H0UE3V
	 GVHlh8qAznAcF25apxacLy1ceKU1KaeTptxrm60LfQRFmVo2ZnjGpmPNleZ78NPDeB556
	 R5wX9P7t9EuXD9EE6TVoxr43Oe3NSvkXQVX0fPbhidV7kD3yJja7vPMNXsZGJSjLiLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZBLv5spX3K0+4sN8n7f1pomGqOzdv0ZXYW8euRnmbPg=;
	b=R/R+Kgoy4WKemg5qwyW9cIZ+7pUxm/pY9K1Yt8/Kjb4yh1t/gWOKMgv4XuLFLoehERWo
	 MNcIeWWwUmY7baePMCF7h4Gxctt1i54Pqpw0rxF1+UJ8lyZrLqBV8zrPjcmSaRTBM2EAH
	 2/KFzmL2+6r7dY95ZVjqws0dOqe/MXCtKU+B+HCpHUW9uoFiwEbmMWZQLcITZzDSqxir1
	 8NGhEz8oMIbs2P1FPdoptiqS0a8iyCX5J9FCZsa1yXTjYOQzrYDyNXKbP39h5/i1qePDS
	 ih0vSnwwSzt+umNcJKsbwit8PAxqz+GaJHxHLSDbHAACDVhp1TsEogMqm5Tl1ywC71g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z9Cew1eu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0B0606A31E;
	Wed, 25 Nov 2026 16:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z9Cew1eu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B86A1F000C4;
	Wed, 25 Nov 2026 16:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623062;
	bh=ZBLv5spX3K0+4sN8n7f1pomGqOzdv0ZXYW8euRnmbPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z9Cew1euU5yZnq8Fio58zgSskmn8RFtVp66PrVvZ3DoPewPn1YPsmaSpucY9n+0hP
	 HOWQhPdAdC8NfnGRHHdjxxtGk+Lz3REX5497ILeShfmMEP25QP6+7ZgrQjJYZRb+x+
	 /KNmVMfOnAJQ774uDi3ZXERZlGP6nwv54xpEA/yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jiabin Deng <dengjiabin2023@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 693/990] net/mlx5e: SHAMPO, Disable end padding when relaxed ordering is supported
Date: Wed, 25 Nov 2026 15:34:20 +0100
Message-ID: <20261125143838.321372643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiabin Deng <dengjiabin2023@gmail.com>

commit 68c183619f24982a635930697bf8e148f2d78f71 upstream.

When SHAMPO and relaxed ordering writes are enabled, aligned RQ end
padding can corrupt received TCP data. Due to reordering, alignment
padding written at the end of one packet can overwrite data from the
next packet.

The current RQ end padding selection avoids alignment padding for LRO,
but not for SHAMPO. Extend the condition to SHAMPO to prevent this
corruption.

The issue was observed in a two-host test using a BlueField-3 NIC and
an NVIDIA H20 GPU. In the original test with MTU 1500, 354 of 400
transfers contained corrupted data before the fix. After applying this
change, all 400 transfers across eight message sizes from 32 KiB to
4 MiB, with 50 transfers per size, completed successfully, with no
incorrect bytes or corrupted intervals.

Fixes: e5ca8fb08ab2 ("net/mlx5e: Add control path for SHAMPO feature")
Closes: https://lore.kernel.org/r/CAFxp=AY2cVRQrZvB9WNnigbsobuw11NMG-cagHx0_V+ur2ToFw@mail.gmail.com
Link: https://lore.kernel.org/r/atZKOtjrb9HKSNHF@dtatulea-c5.nvidia.com
Suggested-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jiabin Deng <dengjiabin2023@gmail.com>
Link: https://patch.msgid.link/20261110035723.26587-1-dengjiabin2023@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -873,10 +873,11 @@ static void mlx5e_build_rx_cq_param(stru
 
 static u8 rq_end_pad_mode(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
 {
-	bool lro_en = params->packet_merge.type == MLX5E_PACKET_MERGE_LRO;
+	bool no_pad = params->packet_merge.type == MLX5E_PACKET_MERGE_LRO ||
+		      params->packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO;
 	bool ro = MLX5_CAP_GEN(mdev, relaxed_ordering_write);
 
-	return ro && lro_en ?
+	return ro && no_pad ?
 		MLX5_WQ_END_PAD_MODE_NONE : MLX5_WQ_END_PAD_MODE_ALIGN;
 }
 


