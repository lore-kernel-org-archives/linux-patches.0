Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CC91DF743;
	Wed,  6 Nov 2024 12:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895303; cv=none; b=YroTQ79KEYC1P12N1kvYx70zvHHE/YZVyNwI3vPmj14LehX7nJCDPQGyEi/JL5Wq67ut+Uh7uxJbUmST3FRAcRBvCSxhaVd8O65YRRZbbmr0Kk6PlZ1M2BWHN58l3+2ds1qTOh3opZU6K6eSOgOcG3eJ9RfrwnCHIcTL9B75Aks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895303; c=relaxed/simple;
	bh=U4+rQI15SqGx/n4M26R1PfTT5/o+5FV/lr25EPiEe7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zpeu55ApTT7zirHmR7pHYQWBDEpOuM0JK8O5qfVi/2TjqA1XTZCXn+ctrd42OhysSrC7cbf21d0Z/MFuwXqzLjDcGe6fP3dzEe+t7XDVWD+2lp5EUSbDLVtq6Zu9wfyKWQnwt+wg0UbiK9YZ+6H4U7tDv4J3byIjE4baDZX7EBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhqkGYz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhqkGYz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9866FC4CECD;
	Wed,  6 Nov 2024 12:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895303;
	bh=U4+rQI15SqGx/n4M26R1PfTT5/o+5FV/lr25EPiEe7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhqkGYz5R0M/YChEW2Lv+32QnH9YRLp8O41mpl/I+rLUzyFRsNMFC8QoPCXOxSmcE
	 du1en/JASGuTOCyvc/HCX9aPXzhF4G/z+MOJOpmRW8hDXlZL8LNSZkpjxtOWD5Ss2U
	 gMJv5XCC22OMs5GyE6gtRHTZ904JpZH8WKRchJrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 135/350] netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
Date: Wed,  6 Nov 2024 13:01:03 +0100
Message-ID: <20241106120324.244081242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 00781db114192..af33a7519b08c 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1464,7 +1464,7 @@ enum nft_object_attributes {
  *
  * @NFTA_FLOWTABLE_TABLE: name of the table containing the expression (NLA_STRING)
  * @NFTA_FLOWTABLE_NAME: name of this flow table (NLA_STRING)
- * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
+ * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration (NLA_NESTED)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
  */
-- 
2.43.0



