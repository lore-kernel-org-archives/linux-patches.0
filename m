Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6277F18E34E;
	Mon, 28 Oct 2024 06:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097213; cv=none; b=eYulb59TlDVlSprRP+kqLrtdpfCuIza5B8ZbpbjN2I1sUf7xDyoP1Qu63+Mv8P/ng5YyR7AMjv4Y9ETANWDBaLrXNnGoNf5j8dDUhxaT6m8CuC0ESn8czWjU8/4hoSaEby2H2YOaT8vTivoTEG0kO5bYpA7wvXiDheIBtTKPY4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097213; c=relaxed/simple;
	bh=m+5LCA5GsNcCgqfI3IlfbZZX50TQBnc3a1/5vLYHcBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbQkWCaQKnNcVxbLF7BTkyhAwYSvb55SoDKyIdVghpwwK7yC4jDNMH/4UxsJ+XBGzcNm/wBKTK8Q6DaoSMzt78+inPsJipR+wbVdmfJVMAlscRpPWiYzY1+C1yt2AMMaD5iVAwy2XtcFy6pGAnDJ+LOtFjh7861D8HLE7NiJqX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMjlrGBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMjlrGBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B27BC4CECD;
	Mon, 28 Oct 2024 06:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097212;
	bh=m+5LCA5GsNcCgqfI3IlfbZZX50TQBnc3a1/5vLYHcBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMjlrGBN27vEHtQIe3lp+ueEVelYxTgJ+7KOnb3Gb7OavTcPbDr8WwuDdZOclxleE
	 2NQriaOKKQCzw34+z80lSjC88XvSJKjcYLE63+0ohf9gzz0Zvh/zmj692IOdAMPO7P
	 0JtuHJr1Y5h+9tKSwJlYpgQBDSb0V4dejcE+hSx8=
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
Subject: [PATCH 6.1 033/137] net/smc: Fix searching in list of known pnetids in smc_pnet_add_pnetid
Date: Mon, 28 Oct 2024 07:24:30 +0100
Message-ID: <20241028062259.651216004@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 21b8bf23e4ee6..399314cfab90a 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -749,7 +749,7 @@ static int smc_pnet_add_pnetid(struct net *net, u8 *pnetid)
 
 	write_lock(&sn->pnetids_ndev.lock);
 	list_for_each_entry(pi, &sn->pnetids_ndev.list, list) {
-		if (smc_pnet_match(pnetid, pe->pnetid)) {
+		if (smc_pnet_match(pnetid, pi->pnetid)) {
 			refcount_inc(&pi->refcnt);
 			kfree(pe);
 			goto unlock;
-- 
2.43.0



