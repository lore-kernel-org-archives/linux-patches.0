Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9361F4FC2;
	Wed,  6 Nov 2024 13:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898269; cv=none; b=N8NPl+hhW8eBt4EyiqNxe8L59BOVA92QJDezsBMq+kogjErZeZXwMtIX+qyMSJYWQargBCDE7t872ZdJtXpFv+3v4/8QfJLBg7nknWwL9rFheCToJOfad0x5B+xxLpaLS/5KUhArUMvSnqOrWVqgDLXBcYmZ9vRWWAeshp+4mww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898269; c=relaxed/simple;
	bh=okvmIKWA9VtHKhVrxvwD7DCGOYPjPBfzHHA++ejqXwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0ccQE5s/NqLft1mX/kKhWDH+z1KPhDqKRVxLGsQP4lAqMQAnHTAO440etxmgjhdSzXpumZ36B3U+TsNvgjgWLOb2yEhqEX/CW5qJNdX92pis7FULSu0IKi4AEPwE9OuDDKrcWHfjGMpGEmPx/emg+Nj1Ei0gC0Jpo64yvC38M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avGbnTq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avGbnTq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D53C4CED3;
	Wed,  6 Nov 2024 13:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898269;
	bh=okvmIKWA9VtHKhVrxvwD7DCGOYPjPBfzHHA++ejqXwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avGbnTq1ai+8QMdJGqyeq7DQv5ezP2fFwf/qQzykDmQDqw57eMLeC0QjJjCoK3MiG
	 v7g2NmfkYz835CQwf9ycm09/DBseyFiVu6bQwITkSqe/GiecX3M/ntcYhq13mDtnSm
	 noMp43rjMwCXUPioI3NBlOdJHBkvBdJnY7CYouL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 180/462] netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
Date: Wed,  6 Nov 2024 13:01:13 +0100
Message-ID: <20241106120335.963512815@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3e6c61d026e35..0ddfe330f6425 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1516,7 +1516,7 @@ enum nft_object_attributes {
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



