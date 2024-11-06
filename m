Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB581EABD0;
	Wed,  6 Nov 2024 12:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896601; cv=none; b=rEFdu6tYf0hgY7fd9wU0GTZnKNnnLnHznMjXf7/BmHB9qoEf4lRT/tfWLMGfoIW0uafiCNDqxhfLeVe+RKGqzCrj1v1zrxNrw0Mrx4hwdFArrCw3yz6NQbtC8PV29uMHpSXR8N6Yg61ODsDoHC3vVL1kOMfZMGaOxF8VPS48xNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896601; c=relaxed/simple;
	bh=K9h8cW3cmA/vl3PkuKgkqgouNjelEzbKb3U94Cx1rtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxjtSz6aKQr+ByDtXm++zVfH9AihhD2ZRIR4lBNLT0mfOMYMircjwaHvrw0DyH8aZkwBL4awHhjU3uGoiS4CYR4VW65/F1bCyn+i6KX2EMUMU/YqZQCGf++Pb7GKPyPESrL1rKoaP6jSIpiB1k140VbvKht2x4yCOp0ODt3SSHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UIp7dI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UIp7dI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6B5C4CED4;
	Wed,  6 Nov 2024 12:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896601;
	bh=K9h8cW3cmA/vl3PkuKgkqgouNjelEzbKb3U94Cx1rtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0UIp7dI5hnqmXzQA/LQluf2o0M6TlAGu8nUR+kHCUnUlNxXU3AKRnqjrb7GzU68J9
	 4HQO7i5gwgNNhCUVLUgR6FJpwxJtkWDYmwa8D9gtxgQ+knXNkFGNRmCH3jVEOdIX1X
	 HG83r9eD5KPjkhwzJbcbGx1osILFONR4du3CTZYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Li RongQing <lirongqing@baidu.com>,
	Simon Horman <horms@kernel.org>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/110] net/smc: Fix searching in list of known pnetids in smc_pnet_add_pnetid
Date: Wed,  6 Nov 2024 13:03:37 +0100
Message-ID: <20241106120303.464909607@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 82ac39ebd6db0c9f7a97a934bda1e3e101a9d201 ]

pnetid of pi (not newly allocated pe) should be compared

Fixes: e888a2e8337c ("net/smc: introduce list of pnetids for Ethernet devices")
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Link: https://patch.msgid.link/20241014115321.33234-1-lirongqing@baidu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_pnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index ed9cfa11b589f..7824b32cdb66c 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -744,7 +744,7 @@ static int smc_pnet_add_pnetid(struct net *net, u8 *pnetid)
 
 	write_lock(&sn->pnetids_ndev.lock);
 	list_for_each_entry(pi, &sn->pnetids_ndev.list, list) {
-		if (smc_pnet_match(pnetid, pe->pnetid)) {
+		if (smc_pnet_match(pnetid, pi->pnetid)) {
 			refcount_inc(&pi->refcnt);
 			kfree(pe);
 			goto unlock;
-- 
2.43.0



