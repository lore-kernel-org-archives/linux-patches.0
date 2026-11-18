Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022151;
	b=LJgg7ABPg4ju9hyk2kUuOZ5rA/G3TVQF7sKRU8Ag0Vayojlm8OKvWUjnq9z+nMoM6u8K
	 hBPp7c9i/saJ3aD/8N26u6vciXPp1mTKo+MQ3JkidU0Npr3mfn2z5VFPEJBEJLMoUjqG3
	 V3qFo8NQTEAQFJY+Ht/eMLPstvx0iWM7C1mhI+u/UQ142WFzYSpmnVBLNgOT2GwkVKQEQ
	 05Artnkydy05hmK/og1NrRv6qVmq9WLzmAU1/bXKqyWZN7EUOri84HRozMzEFRmHXx6Uw
	 Go9hhMi5VKmQlWzKe4inLvwS+WPVUs1RSKi1saxGmR34fzn4nx/E5+YbX4iki4Svh7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ke2k9OlzcX10BVaQsb1fi4LSzrSA/fRqlnMg0YWHW4Y=;
	b=jDmFVWakLuT+fe9NrLnLYk4Sgom03b+DzQ46y8AANmD57PhisbUiDN5y8B9wp7aCquS7
	 FqUvsqRJHulgGSegey7IMxG22/I9icj4Qipna5RFTx5i9Vpbk8P1wAnz8MiA8LRgEac6E
	 oOW6+fxtTIn4l4S++9RHrG3sVU/F7PTMMS0ZyhsDsBIza/nhMcYNKPtIX47YPLAF/c7vY
	 Uu1OtMZ2r0EctrpUzuuNQJRqtBdmDzTnQVMJgJ1tzFYW21c/w5Sse/l62phdsDr45TJQ7
	 PrDAxBZ0rZzxro2ML+TRVtVGvEr1DIrnPZ0hqKjmXtx0L1YJpdH1vhC/FSoxH15zmvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvaBms4F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E15606A331;
	Wed, 18 Nov 2026 17:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvaBms4F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61571F000CA;
	Wed, 18 Nov 2026 17:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022151;
	bh=Ke2k9OlzcX10BVaQsb1fi4LSzrSA/fRqlnMg0YWHW4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvaBms4FDjKMFgaBFHSTp4nQIyS7V0TYYiBpzRP/USDZJZ7tRNJleXkmSnc50a/Au
	 fgemHGLqLf84PP0XFYF9SxA7SUDuZchdWipyWXw9XARg3H3OMJyMxncMScYXRR899B
	 3IWJ4DtusqhABuyUmPTZfy5v02Q2xVZ+NPRp91hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dharmender Garg <dharmender.garg@broadcom.com>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2560/2651] bnge: cap RSS contexts and RX rings to the RSS table size
Date: Wed, 18 Nov 2026 16:03:20 +0100
Message-ID: <20261118150416.611983333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dharmender Garg <dharmender.garg@broadcom.com>

[ Upstream commit e8f6ca11167d4753386340ce88444b5445dff831 ]

The hardware supports at most BNGE_RSS_TABLE_MAX_TBL (8) RSS contexts.
They are stored in vnic->fw_rss_cos_lb_ctx[8] and back a 512-entry
(BNGE_MAX_RSS_TABLE_ENTRIES) indirection table and DMA buffer, so at
most 512 RX rings can be served by RSS.

bnge_cal_nr_rss_ctxs() has no upper bound, so with more RX rings it
returns more than 8 contexts: bnge_setup_vnic() writes past
fw_rss_cos_lb_ctx[], bnge_set_dflt_rss_indir_tbl() and
bnge_fill_hw_rss_tbl() write past the indirection table and its DMA
buffer, and the pad computation in bnge_set_dflt_rss_indir_tbl()
underflows into a huge memset().

Cap the number of contexts at BNGE_RSS_TABLE_MAX_TBL and the number
of RX rings at BNGE_MAX_RSS_TABLE_ENTRIES, so the sizes derived from
the ring count always fit the arrays.

Fixes: 627c67f038d2 ("bng_en: Add resource management support")
Signed-off-by: Dharmender Garg <dharmender.garg@broadcom.com>
Reviewed-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261026092757.9168-2-vikas.gupta@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnge/bnge_resc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c b/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
index 4711dd4945ffe..b540eed12fc6d 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
@@ -182,8 +182,9 @@ int bnge_cal_nr_rss_ctxs(u16 rx_rings)
 	if (!rx_rings)
 		return 0;
 
-	return bnge_adjust_pow_two(rx_rings - 1,
-				   BNGE_RSS_TABLE_ENTRIES);
+	return min_t(int, bnge_adjust_pow_two(rx_rings - 1,
+					      BNGE_RSS_TABLE_ENTRIES),
+		     BNGE_RSS_TABLE_MAX_TBL);
 }
 
 static u16 bnge_rss_ctxs_in_use(struct bnge_dev *bd,
@@ -459,6 +460,7 @@ static void _bnge_get_max_rings(struct bnge_dev *bd, u16 *max_rx,
 	}
 
 	*max_rx = min_t(int, *max_rx, max_ring_grps);
+	*max_rx = min_t(int, *max_rx, BNGE_MAX_RSS_TABLE_ENTRIES);
 }
 
 static int bnge_get_max_rings(struct bnge_dev *bd, u16 *max_rx,
-- 
2.53.0



