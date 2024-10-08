Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE8C1DE2C4;
	Tue,  8 Oct 2024 12:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391158; cv=none; b=TW/8+sNq/pxH339KdI45GxlHLjeyfuWG6xx53PrvsoDtnEUrPYvoblLwn57zI54Y1L6pQZkmMtWcBqcisAOnmlwIKzLg930Wb2qi8CZo4/VQ0DGkRrhYOSjOOrMHMywkJHiCoROy1gc9Rlj2PKeQDHT9/RuUtOVTHCO2noLtDaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391158; c=relaxed/simple;
	bh=aHDv+SB7EpJuljfE3obw/1fethLULzD1isgBINxIuIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qN5MXrIYdRSCMuh0daIdkaeaFkfbMZS3h3ZonYPP7SbarO7OOZYkYT6LJTrbCGNMeohukAg2rTNsgIDBwqXLOY5U9T5e0ynvSxPel8oSyGtmEHLR78dHS23DWQ8+TPolLgsxEgS9rNK3iNuWVIg32dRAm8U1OvzdFg/NeKs7H0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N39jq3aI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N39jq3aI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06D0C4CECD;
	Tue,  8 Oct 2024 12:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391158;
	bh=aHDv+SB7EpJuljfE3obw/1fethLULzD1isgBINxIuIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N39jq3aI5TJ/9pkxYD2isNyV3NwY7xIzAzJHAQ8S922FJCbJnNpzRrsX32EDCNUXt
	 uTOlXM1/WXThRZ/r+y1gH8gF2L5Dqi/NpkNTUjo5F9IEpSvwAIsE6uoifByvecLirw
	 ipOwlfsS0DaW8mZ1cRJaS7hBfnN0MwGU4ct4iSO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 025/558] netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
Date: Tue,  8 Oct 2024 14:00:55 +0200
Message-ID: <20241008115703.214491463@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 639894ed1b973..2f71d91462331 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1694,7 +1694,7 @@ enum nft_flowtable_flags {
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



