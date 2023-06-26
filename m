Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7188511CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E300DC433C8;
	Mon, 26 Jun 2023 18:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687805182;
	bh=lTRwSPHBROFqwLOyaoBLJo3p+gy94bcON+DJtFYbU7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oERD1l0mXl/YIZ5nTfMiz+kv38MdPEeEltxXTHyK18M4HNhoZvOFQXW7ZF+kKcdTK
	 l21AdbGv0rZIrYVh4Wck9ew2uZdLV1aA4U8OFW0dh0ZfEJgnvKWG9zLEORSLUGdi/k
	 1gdTJQg2O2r5Q9Uw2q1SGEwotkbk7ljuuQV39D/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 78/81] netfilter: nftables: statify nft_parse_register()
Date: Mon, 26 Jun 2023 20:13:00 +0200
Message-ID: <20230626180747.590718981@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
References: <20230626180744.453069285@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 08a01c11a5bb3de9b0a9c9b2685867e50eda9910 upstream.

This function is not used anymore by any extension, statify it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    1 -
 net/netfilter/nf_tables_api.c     |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -205,7 +205,6 @@ static inline enum nft_registers nft_typ
 }
 
 int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest);
-unsigned int nft_parse_register(const struct nlattr *attr);
 int nft_dump_register(struct sk_buff *skb, unsigned int attr, unsigned int reg);
 
 int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8492,7 +8492,7 @@ EXPORT_SYMBOL_GPL(nft_parse_u32_check);
  *	Registers used to be 128 bit wide, these register numbers will be
  *	mapped to the corresponding 32 bit register numbers.
  */
-unsigned int nft_parse_register(const struct nlattr *attr)
+static unsigned int nft_parse_register(const struct nlattr *attr)
 {
 	unsigned int reg;
 
@@ -8504,7 +8504,6 @@ unsigned int nft_parse_register(const st
 		return reg + NFT_REG_SIZE / NFT_REG32_SIZE - NFT_REG32_00;
 	}
 }
-EXPORT_SYMBOL_GPL(nft_parse_register);
 
 /**
  *	nft_dump_register - dump a register value to a netlink attribute


