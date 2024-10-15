Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A3C1D4154;
	Tue, 15 Oct 2024 11:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993362; cv=none; b=iwkeYw4CiqI3+zw+R11CG0Bih9pfgHlZS3ynR79xKShAlc7zSGdvnRzyT/YrfhomDcSPLcgTeGPLBubk7rVWWc/sBYXUkctkNQAanM1FeclddD7fNke1UC4lF68yjHVeG7GRpNwZ4NXOhuoelzB2mlR6551b7BhWCje9AoolmRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993362; c=relaxed/simple;
	bh=koMFuOWQ0ch9DhG+aHmQCJh+2ANpIqNzKziPRMGg3qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGoH04ppwFC++bxN2YT1qzanShfbkdOS0PY+XVubsqpuIdACqEGdl8QcbiDgpR903vJIb34rxOH3+1C3lwrLBzLBPp4hykIe1BEpUpxF4+lHiIktrG9ss9SMf0Gdqncc6JUTxeRHTTk4vfXssfxZQsLdhSB/6111PU/2/pZbxfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOQ44zX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOQ44zX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DF2C4CEC6;
	Tue, 15 Oct 2024 11:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993362;
	bh=koMFuOWQ0ch9DhG+aHmQCJh+2ANpIqNzKziPRMGg3qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOQ44zX/wmPrlt+KIoHUoJ3sYUT4ghiUJexMICCfWiXXYhIXr3SqecAFG7JIf4H58
	 v0CfvpcmCQgygjdPxVmxCWKx0kL+8IyPOcxk5L6EXeuk0i4ZQoBO1eq2M6H7atar5r
	 90i2LEKsRq6PXR+K6shPhK47APTaMXindtA8zPpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 381/691] netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
Date: Tue, 15 Oct 2024 13:25:29 +0200
Message-ID: <20241015112455.466296231@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c0edc1a2c8e65..598f782779f59 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1638,7 +1638,7 @@ enum nft_flowtable_flags {
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



