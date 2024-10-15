Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EA51C07DF;
	Tue, 15 Oct 2024 13:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997844; cv=none; b=L/qrr+yqBcVf2gs1Qlh+O7b6EM48yAJQh52d5wzjJAASbpML4MKAuEpgedThJRIVL1O8wsUIgHGjGtCmj8yuvLpOARn1WaUp/w1DwJUBTnVrS7XwyWTzqxtiFcD5Q+yFsZwmCexLlZkImftBRdSTvy9l7dNBi49R9MVvyjliMjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997844; c=relaxed/simple;
	bh=4y+I1kiNXDl2tSQT+0ZwPvdGtKUxi+lBhxkVLkeuqdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M21g7av94oSgMLtAKia30YFr3WLK3K0nVaetkwEh+5Wg5r+SP7i1FpbnyPEt9TLF197fYRuF8KQFs3Q/3TJlD6q2oaeBCdoNDDRka/EUnza/xJRpBUypWvnKW2agVldU/tpMHH60sO9hfWhr2SWm75GhUMVzMdPuEFsOE/3PUQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ui9fRMUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ui9fRMUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA79C4CECE;
	Tue, 15 Oct 2024 13:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997843;
	bh=4y+I1kiNXDl2tSQT+0ZwPvdGtKUxi+lBhxkVLkeuqdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ui9fRMULtbjDMXnQ/+Vbwq2G6ISQKYQZBPxW+u1rqA3yArWDSIwawi5lI+miRC1QE
	 MlrhA0oIRBVHCGcfpFs+w3JtB0yvHsv7BWJbp0ARy0TcdswYX7Myxz467qVU/Ls36J
	 49NPtrKlgIINKRHQdJPZ/kTwZ6OQsbk+gvfBFeKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 272/518] netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
Date: Tue, 15 Oct 2024 14:42:56 +0200
Message-ID: <20241015123927.493515377@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 76f1ed087b562a469f2153076f179854b749c09a ]

Fix the comment which incorrectly defines it as NLA_U32.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 40d9005370939..702bcb7c9c73a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1602,7 +1602,7 @@ enum nft_flowtable_flags {
  *
  * @NFTA_FLOWTABLE_TABLE: name of the table containing the expression (NLA_STRING)
  * @NFTA_FLOWTABLE_NAME: name of this flow table (NLA_STRING)
- * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
+ * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration (NLA_NESTED)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
  * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
-- 
2.43.0



