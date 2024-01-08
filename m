Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2574C3A0;
	Mon,  8 Jan 2024 15:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3KX4ZYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B47BC433A9;
	Mon,  8 Jan 2024 15:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728247;
	bh=bRMekkLmvcaIOp3kNPUpB1DlvaHxfzfoCo9cTuGkPE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3KX4ZYNrEylqJQoURtdYTijPIrtHR6VNHuwCC7qLxogtCrR3lteyEIC1EqYpDfsr
	 gsQ0X1Tr3hjzdcMCOe8kXB0CKMQkg0+pMEi+iTfTGSiCgY7sf/n+/DNWyvc59yvrr+
	 8WzvpzB1+2IkpOUpHPqB1CwpN4NnC7tek2imy1ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/150] octeontx2-af: Fix marking couple of structure as __packed
Date: Mon,  8 Jan 2024 16:34:28 +0100
Message-ID: <20240108153512.066899463@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 0ee2384a5a0f3b4eeac8d10bb01a0609d245a4d1 ]

Couple of structures was not marked as __packed. This patch
fixes the same and mark them as __packed.

Fixes: 42006910b5ea ("octeontx2-af: cleanup KPU config data")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index d027c23b8ef8e..aaff91bc7415a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -514,7 +514,7 @@ struct npc_lt_def {
 	u8	ltype_mask;
 	u8	ltype_match;
 	u8	lid;
-};
+} __packed;
 
 struct npc_lt_def_ipsec {
 	u8	ltype_mask;
@@ -522,7 +522,7 @@ struct npc_lt_def_ipsec {
 	u8	lid;
 	u8	spi_offset;
 	u8	spi_nz;
-};
+} __packed;
 
 struct npc_lt_def_apad {
 	u8	ltype_mask;
-- 
2.43.0



