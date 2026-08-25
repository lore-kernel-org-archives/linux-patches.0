Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC0E481AA4;
	Tue, 25 Aug 2026 13:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666350; cv=none; b=sJ00vYLiXV59e3/EOz7IOtzoEHRzM8N/1d6gDVkmDIMwiyJEevZS2PvMp1kWpOg17cBlFWXUirt+1m3OMWY/5FInvFsZ1u0KTmMKaBbwRb0RUra+QKPKXYgSl7yLDj2Z9ogHMhQJ0zeCuX7QQrQbH14EW7ADriwBQoeZnWDZ/O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666350; c=relaxed/simple;
	bh=ZudYhkqtOxajUz0gAUuZBtTveWbT2TbzEyzCWq7Ju7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5umL74AmUj0s9nHg01Dk5WFY5thyDrIRxVLZ2bfGu0CcKfa6TFPKihbcPx/yznOt3t2mdVGOFahu7xCUsvRLQNfpgZxQVt7MwREn2VckUQK3XPNW5p2aeOHdg2ExlnaBG6fJo6CGUUWAQEYMWJv70dW41h7zFWQUj3XXeQmOs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1fsP2qo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1fsP2qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29F31F000E9;
	Tue, 25 Aug 2026 13:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666348;
	bh=CqyvRaCmu4lScP1kH4XEe0XWP6/+P/dwAOmRlgBnVLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y1fsP2qoQ/6sqSKoSWjOT3KPtGS43+1898CxbeAG+rhvHwio55Ili7c9mtDFD1wXn
	 i7y/uu//JCPYqsW4aCMqzBrO2VUlXX2dOFtYuYguD6LvuMwlUrmwrH10iy388F+FUT
	 SRukQFIhMfsVjsZ63HORfU2Sb5hbFIbUnhSDW2AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/57] net: ipv4: Publish fib_nlmsg_size()
Date: Tue, 25 Aug 2026 15:26:35 +0200
Message-ID: <20260825132541.810445975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit 1e7bdec6bbc7816cdc6a093374f4bf4e732c3d44 ]

Publish fib_nlmsg_size() to allow it to be used later on from
fib_alias_hw_flags_set().

Remove the inline keyword since it shouldn't be used inside C files.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4ff9548d8494 ("ipv4: Fix fib_nlmsg_size() for RTA_VIA nexthops")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_lookup.h    |    1 +
 net/ipv4/fib_semantics.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -44,6 +44,7 @@ int fib_dump_info(struct sk_buff *skb, u
 		  struct fib_rt_info *fri, unsigned int flags);
 void rtmsg_fib(int event, __be32 key, struct fib_alias *fa, int dst_len,
 	       u32 tb_id, const struct nl_info *info, unsigned int nlm_flags);
+size_t fib_nlmsg_size(struct fib_info *fi);
 
 static inline void fib_result_assign(struct fib_result *res,
 				     struct fib_info *fi)
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -460,7 +460,7 @@ int ip_fib_check_default(__be32 gw, stru
 	return -1;
 }
 
-static inline size_t fib_nlmsg_size(struct fib_info *fi)
+size_t fib_nlmsg_size(struct fib_info *fi)
 {
 	size_t payload = NLMSG_ALIGN(sizeof(struct rtmsg))
 			 + nla_total_size(4) /* RTA_TABLE */


