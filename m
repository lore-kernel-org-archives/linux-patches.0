Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38019611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C7BC433EF;
	Sun, 28 May 2023 19:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301300;
	bh=wupWEI6oDFRpR1L+AYSUYZEIfhSfz9b0pLTyfJAngQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcUNHWpJrPcWHFuYNuwqlv4NTkU5YDiW2RzcuJTKoKxQ2v4wd0IB/CvqEBIhXEukR
	 oDZlB0H4r1dwPofx+j5fZfVCBiez3EYDF2uq4cuUg8VfOQbzpN7k/1DOlCA8E6ZEVD
	 iz7hCjmh/hCkZEVxT7CUv1ToThsy3mtvzjwv4UBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 62/86] netfilter: nftables: statify nft_parse_register()
Date: Sun, 28 May 2023 20:10:36 +0100
Message-Id: <20230528190830.922304407@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
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

[ 08a01c11a5bb3de9b0a9c9b2685867e50eda9910 ]

This function is not used anymore by any extension, statify it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    1 -
 net/netfilter/nf_tables_api.c     |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -195,7 +195,6 @@ static inline enum nft_registers nft_typ
 }
 
 int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest);
-unsigned int nft_parse_register(const struct nlattr *attr);
 int nft_dump_register(struct sk_buff *skb, unsigned int attr, unsigned int reg);
 
 int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5624,7 +5624,7 @@ EXPORT_SYMBOL_GPL(nft_parse_u32_check);
  *	Registers used to be 128 bit wide, these register numbers will be
  *	mapped to the corresponding 32 bit register numbers.
  */
-unsigned int nft_parse_register(const struct nlattr *attr)
+static unsigned int nft_parse_register(const struct nlattr *attr)
 {
 	unsigned int reg;
 
@@ -5636,7 +5636,6 @@ unsigned int nft_parse_register(const st
 		return reg + NFT_REG_SIZE / NFT_REG32_SIZE - NFT_REG32_00;
 	}
 }
-EXPORT_SYMBOL_GPL(nft_parse_register);
 
 /**
  *	nft_dump_register - dump a register value to a netlink attribute


