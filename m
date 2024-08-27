Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D771D1735;
	Tue, 27 Aug 2024 15:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772780; cv=none; b=Bw8u2HtcVAa10Mm//Ord4iK7bG/DuCoWEGcogY7yFTh8dyKfjjNeB+i97DPCdBAq6NtvzVWF16ySJ0L8dMVRic979k9o39lVLoiIo+jwgeTOgvMkjilsFuNCi0fTXCv7YK800Gzno5LrYwLS/DM/8t3qc15QJ5iRsXjizMWU8Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772780; c=relaxed/simple;
	bh=BKH3iHr8Gho3TbXNduNwgumitGKOPg+uQ6lRUp/bhzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCEukr74EKl8s5ruxqEr+9cxJWZmRBr12pvMWFOdsDjux1e3T9rX5AJRz5KaGuNhgk9LImNW+WIYFHDKDNBXp3nZ3nAFAZec7H2ni0RsJQbg50/Fu7TxSlDwvTGse3ldAEaX9MqRvHLKg+6BeRVABi+W+2E3CqclEsmlkvC8Ebk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08XoWk+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08XoWk+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C19FC61052;
	Tue, 27 Aug 2024 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772778;
	bh=BKH3iHr8Gho3TbXNduNwgumitGKOPg+uQ6lRUp/bhzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08XoWk+NXXH2ftQSuPyEG2fJxy8Uog+6/TdZ/yqetkgqbI2vJ6XQNeBJjO6rlw24R
	 nU7+Ua5Xk1vTuNoREgENb+6aefJ6v1s5XPLBqMwNs4KdwXmblQO+U/H5lytAMg1FL1
	 4vpVj9gTC8XlpmQ/ScHRmNL3z/bhLL8kZDtJ3LQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Piotr Raczynski <piotr.raczynski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.1 317/321] ice: fix W=1 headers mismatch
Date: Tue, 27 Aug 2024 16:40:25 +0200
Message-ID: <20240827143850.324780616@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

commit 66ceaa4c4507f2b598d37b528796dd34158d31bf upstream.

make modules W=1 returns:
.../ice/ice_txrx_lib.c:448: warning: Function parameter or member 'first_idx' not described in 'ice_finalize_xdp_rx'
.../ice/ice_txrx.c:948: warning: Function parameter or member 'ntc' not described in 'ice_get_rx_buf'
.../ice/ice_txrx.c:1038: warning: Excess function parameter 'rx_buf' description in 'ice_construct_skb'

Fix these warnings by adding and deleting the deviant arguments.

Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
Fixes: d7956d81f150 ("ice: Pull out next_to_clean bump out of ice_put_rx_buf()")
CC: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c     |    2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -892,6 +892,7 @@ ice_reuse_rx_page(struct ice_rx_ring *rx
  * ice_get_rx_buf - Fetch Rx buffer and synchronize data for use
  * @rx_ring: Rx descriptor ring to transact packets on
  * @size: size of buffer to add to skb
+ * @ntc: index of next to clean element
  *
  * This function will pull an Rx buffer from the ring and synchronize it
  * for use by the CPU.
@@ -973,7 +974,6 @@ ice_build_skb(struct ice_rx_ring *rx_rin
 /**
  * ice_construct_skb - Allocate skb and populate it
  * @rx_ring: Rx descriptor ring to transact packets on
- * @rx_buf: Rx buffer to pull data from
  * @xdp: xdp_buff pointing to the data
  *
  * This function allocates an skb. It then populates it with the page
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -349,6 +349,7 @@ int ice_xmit_xdp_buff(struct xdp_buff *x
  * ice_finalize_xdp_rx - Bump XDP Tx tail and/or flush redirect map
  * @xdp_ring: XDP ring
  * @xdp_res: Result of the receive batch
+ * @first_idx: index to write from caller
  *
  * This function bumps XDP Tx tail and/or flush redirect map, and
  * should be called when a batch of packets has been processed in the


