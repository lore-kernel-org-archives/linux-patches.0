Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A3E20EB;
	Mon, 14 Oct 2024 14:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916827; cv=none; b=YEhARij3zNFcj6X0jt4MZN3+HZZA6B1RcmT62UcMGoIQMInb0TfhcMzugMsLqUNkLigepD+RlMOXpnOsncf40T+6/0iZpl3zTqsNo5kKLasFaUNVCvTdnE+2779N+PQDTAdOg/AXVv1jGQUgJhRsBl2RLwsIubD78ki8aFySnrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916827; c=relaxed/simple;
	bh=PShpwdKSwSm9L99SUBhFzdi4ybApZUkPQYhmVblxbwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEPNUhe4CZjysIuNGbRWOQB7QcnlfBZIjzHcT3K7ugKbAPd6VBKM3EpSalbr6isVU2FSQPBU+mlTTW0p2C1vlp6lM9OeMwAbUju+r0sGNftsarq3KJHNXES16KBC6kYTy3f+0RU4BmwrDjosfOow+QXu6IVKVkMc1GAOowXxlf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnNaiPP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnNaiPP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05090C4CEC3;
	Mon, 14 Oct 2024 14:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916827;
	bh=PShpwdKSwSm9L99SUBhFzdi4ybApZUkPQYhmVblxbwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnNaiPP+xoc4ih6m/SI1t2d53XjQlmuUVA0iGzfcykT+phfZKmKBS9NCGUokviCk3
	 awcQzIxwiSySXqDk+SAHewa9YF21b1AVQk3biMs2Ie183coGGLkHDZF3KLXIrY6k18
	 gdvc5suHpLa5gT7cb8XoYXjwVa/Ker4MGsqvSocg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/213] jbd2: fix kernel-doc for j_transaction_overhead_buffers
Date: Mon, 14 Oct 2024 16:19:10 +0200
Message-ID: <20241014141044.709380851@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 7e8fb2eda9885ea2d13179a4c0bbf810f900ef25 ]

Use the correct struct member name in the kernel-doc notation
to prevent a kernel-doc build warning.

include/linux/jbd2.h:1303: warning: Function parameter or struct member 'j_transaction_overhead_buffers' not described in 'journal_s'
include/linux/jbd2.h:1303: warning: Excess struct member 'j_transaction_overhead' description in 'journal_s'

Fixes: e3a00a23781c ("jbd2: precompute number of transaction descriptor blocks")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20240710182252.4c281445@canb.auug.org.au/
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240723051647.3053491-1-rdunlap@infradead.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/jbd2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 8553dc1d0e898..f0bc9aa5aed3f 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1084,7 +1084,7 @@ struct journal_s
 	int			j_revoke_records_per_block;
 
 	/**
-	 * @j_transaction_overhead:
+	 * @j_transaction_overhead_buffers:
 	 *
 	 * Number of blocks each transaction needs for its own bookkeeping
 	 */
-- 
2.43.0



