Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625619;
	b=m4gzbP8et+E4IL21Wnvkm/GLyK4svlWPiG2KBQaHFz9XMrg2hea3zhrpn7s23zAmLWZl
	 huUUZP7+ukIRkVnRnlljLOgp6798iL7lyb0b0RjmDancXMsK+6Mzfuk0EHSlToEkf5CFf
	 aYY8WumIuCWuc4aLe3nZh5kB77YHs569gr6zFPv4GNefRJ/kk9hhSio80ZR7UQ19xtYqx
	 zRZugo624tTMH5K1e3rNcKvQTAZMRvn8YVlbPtYeCaimb8cytIUHQhOB9anfQ5QpwADoY
	 0knBqdie7CMDA0cmYtosa8fvH8fgMcpzq+IPOFkheQnvuUMT1RqSE7s8iypD0m4gKpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eTeqzDD+Ddrj0OhrIo4BGVlkNXx20f0VhNmyqpjHKdE=;
	b=bGPBA2lYigrfGVNMNmenXutV3NIzN4et0jZpaSHEwaHWXz8CNiGHRVnjUtrAGEGs1UzF
	 lscOyDuQbkhwlHeToygoicE0PoONri0HUXXFv+yFYqV4ftbA2EhFZ5uxx4j4wPfPdZ+Ww
	 ZrunSavrlVm5xkNMWpVDbYDTU18QLvWSmYdVxgROknmhDyRdt9jZ8E9mSf8SjXMplSF8v
	 +swQnmXt8iEaDnrT2ZVv8eiMRECC3SUEtoXX1gSoglw/mWHusoAFe7MMQ7oi3AU8IDCRM
	 DAaRUitKn/Q6z4ZA6iTM2cvIUv/1ZPySdfL2DIKu59SvUO7kPlJMl/+mlBFGnj4RzqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NnSXaQVt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7786B606A331;
	Wed, 25 Nov 2026 16:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NnSXaQVt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C5A1F000E1;
	Wed, 25 Nov 2026 16:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625619;
	bh=eTeqzDD+Ddrj0OhrIo4BGVlkNXx20f0VhNmyqpjHKdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NnSXaQVtHCijYASjpplOuTDCNWMcpss8TfSVG7w0VR6vA/zRBafEsaDHV6f5pmovz
	 d+yPeErBBgvzOyQx4htaHPVdOxe+Ou2j0m0TyAQSNUWvT3Sq0EZM7YLRFTHUZ5eAtv
	 msP8skAz0kLeETtwnGo77KwA+/vyjHj7ewuxLl8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jiabin Deng <dengjiabin2023@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 577/816] net/mlx5e: SHAMPO, Disable end padding when relaxed ordering is supported
Date: Wed, 25 Nov 2026 15:35:25 +0100
Message-ID: <20261125143902.536306626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -887,10 +887,11 @@ static void mlx5e_build_rx_cq_param(stru
 
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
 


