Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149A518C039;
	Wed,  5 Feb 2025 14:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766862; cv=none; b=Zs3gP4oMHbnx5KB2t3Qee6z+NVamL87ORBZrmVES4wmVsLncUONfBVGOW1X5CBcfl664e8xrIcHnf2MNPJ4UEDfSw9Goxf70tzb1kbV3UW8WbzEov+vFPEaQcLZr3o62Ihs5x4kOK2JfrtY7ZgB7ArQue1W/Xuiaph7zZ/QPmec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766862; c=relaxed/simple;
	bh=yfbAVcsjPS/rvApQDjR5AnJNHzE8F2P5PZniOaMcWhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nak5xURgrlYm8+s9mGRBRbh8qr90oZhVqaRm6rBU0WlhTg4+zUVnacO8JvnhOHr99lys2yb80Sq914NSIw6q5EEIj2ltyLmQWfqsTqTv7mgR0F6WG8vk/X1YHznv4+JUsA9s3Th+tv7ZYs0O8s1Xr76/zTXziyVZR5Wm/hIljs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSxb+bEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSxb+bEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC93C4CED1;
	Wed,  5 Feb 2025 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766861;
	bh=yfbAVcsjPS/rvApQDjR5AnJNHzE8F2P5PZniOaMcWhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSxb+bEAlREOD9oU8P50y4bwpmaoQ/WNilL+K0nsz7C0FY9qfa7vusx2ihBX7OhoK
	 2/DH1Uh+shRHlh9KCFZcS5HMp3RLhd1kCg46vc/+e1yeCSTb68fOXG6PS2U1PFiOzI
	 8DIsivxWL+nCJpaOXoJKsgfOKdFlSsrck1WjPPq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Chourasia <vishalc@linux.ibm.com>,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 321/623] tools: Sync if_xdp.h uapi tooling header
Date: Wed,  5 Feb 2025 14:41:03 +0100
Message-ID: <20250205134508.501601429@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Chourasia <vishalc@linux.ibm.com>

[ Upstream commit 01f3ce5328c405179b2c69ea047c423dad2bfa6d ]

Sync if_xdp.h uapi header to remove following warning:

  Warning: Kernel ABI header at 'tools/include/uapi/linux/if_xdp.h'
  differs from latest version at 'include/uapi/linux/if_xdp.h'

Fixes: 48eb03dd2630 ("xsk: Add TX timestamp and TX checksum offload support")
Signed-off-by: Vishal Chourasia <vishalc@linux.ibm.com>
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20250115032248.125742-1-yoong.siang.song@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/uapi/linux/if_xdp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
index 2f082b01ff228..42ec5ddaab8dc 100644
--- a/tools/include/uapi/linux/if_xdp.h
+++ b/tools/include/uapi/linux/if_xdp.h
@@ -117,12 +117,12 @@ struct xdp_options {
 	((1ULL << XSK_UNALIGNED_BUF_OFFSET_SHIFT) - 1)
 
 /* Request transmit timestamp. Upon completion, put it into tx_timestamp
- * field of union xsk_tx_metadata.
+ * field of struct xsk_tx_metadata.
  */
 #define XDP_TXMD_FLAGS_TIMESTAMP		(1 << 0)
 
 /* Request transmit checksum offload. Checksum start position and offset
- * are communicated via csum_start and csum_offset fields of union
+ * are communicated via csum_start and csum_offset fields of struct
  * xsk_tx_metadata.
  */
 #define XDP_TXMD_FLAGS_CHECKSUM			(1 << 1)
-- 
2.39.5



