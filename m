Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BAE1A6160;
	Tue, 30 Jul 2024 16:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356994; cv=none; b=lFKKt8fb2EBZ8Zrb5Jz70wOxdiXWJrlK5Odql2b7SmWCL9zznCj7h6bqCeYUgsblZ7j/2RDwtmZk/4MSS1plZCp+kyYZ4Q9QsdlZl6gsCxvLEYztxO6aGpJ9SPbXhEJSCefPPHjmrVOMj0F+g9omUSmwg2UMJiHcyHy79kIpuCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356994; c=relaxed/simple;
	bh=i8pgX3ZTm8KkuHnEGGZ3WQ0Wj+gvf/6ZhxDcX2B/kh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lR8gBUgcV6UKkVM0+kCAFmYbLlqP24Su4fAo7cjHbYSfuM0guVWI88lx+nZtKx39ybSXI8pOuGbQS+9vxqDNNc48YmFusyCPFwsiPedPSRnZmELIal+bOV5MyrtL86+2CKrj0I811K1w4iHMO0Z7eAOA67E8FYmr2IxuLPXxhfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+X2x1Y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+X2x1Y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F79BC32782;
	Tue, 30 Jul 2024 16:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356994;
	bh=i8pgX3ZTm8KkuHnEGGZ3WQ0Wj+gvf/6ZhxDcX2B/kh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+X2x1Y8qA3zx66fpP4nLIdMD1Te8l4ZABlDY0a2ueGv8mqZO/xCjELlLTFt5ADwX
	 mEO7bUln/9UjKBSFU8xigwzLsvfLXgLpIROoDZq/UIKJerSH80Tlk8kz4PWD2Z1K+n
	 6Y008/3ZSM3Mhr2vv/jpyhXGIJVIJfNr1eyFWKfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 208/809] netfilter: nf_tables: rise cap on SELinux secmark context
Date: Tue, 30 Jul 2024 17:41:24 +0200
Message-ID: <20240730151732.822671153@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e29630247be24c3987e2b048f8e152771b32d38b ]

secmark context is artificially limited 256 bytes, rise it to 4Kbytes.

Fixes: fb961945457f ("netfilter: nf_tables: add SECMARK support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index aa4094ca2444f..639894ed1b973 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1376,7 +1376,7 @@ enum nft_secmark_attributes {
 #define NFTA_SECMARK_MAX	(__NFTA_SECMARK_MAX - 1)
 
 /* Max security context length */
-#define NFT_SECMARK_CTX_MAXLEN		256
+#define NFT_SECMARK_CTX_MAXLEN		4096
 
 /**
  * enum nft_reject_types - nf_tables reject expression reject types
-- 
2.43.0



