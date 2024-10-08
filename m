Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE9D1DE892;
	Tue,  8 Oct 2024 12:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389643; cv=none; b=O5CKdQHRtJfNHPmT/IiCxL8MfpkM8Yaqf+6OJKWK9hMP8TQv2HLH+wIDaWwBvHjnQ1WN7CzTJtce5UgNbKad4gysFHzvnoHa4h5b0Zdp13DmTJhD2O/fpcFCqxOx8NNYNLfXE1E0iAHApbVzB8VOVrSA3QzutHxh0qY3ayAu7XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389643; c=relaxed/simple;
	bh=VOr2TVCwRxderfHeOulA7YkRR2oQoHqL8XyNr8gw5nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlSV1S55+Cm+nFA+nIZQCt1urGJKLGkvcbkKFFOBnDsvJ8MBNfAElD5MJ//M4AQUJMd14WlKIB7K5FsZK+sotmgQpvOpf6PJBIaO7sBSOAhAj6NExwjo55eQU1Bwj3qkLCZw1KeT2ihmJ00IMzLYf6qoqJakRGFP6F6VQkp53Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFqBr9rW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFqBr9rW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558F3C4CEC7;
	Tue,  8 Oct 2024 12:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389642;
	bh=VOr2TVCwRxderfHeOulA7YkRR2oQoHqL8XyNr8gw5nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFqBr9rWic7bV7iz0V+hjczIrd9ATwdXMsA/j90tSQb2YJV4ykpd96R6f1xSuXe0v
	 bHbTVCaFe/CmGRKX3H/qxb6+oS88bM/af4jw8A0uuVPJ6JccAlyFNoLKWjPScOIZfW
	 BCRQ4Ky8WgC+YYpUaSxQpuzZAzfEl+xfVoH3/9Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 022/482] netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
Date: Tue,  8 Oct 2024 14:01:25 +0200
Message-ID: <20241008115649.172850591@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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



