Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044451;
	b=bsv3fYniphM2+97jI30dQ3A3yRv6rC9nQ6OVhLLsxGaev6yniDwm6WGrgyDMkFqSP9Gw
	 3Q3twgWG6AhxanOUfkfpnfidkDKNjnvfEWZ7jZul3WcLvAOIKbsdrMVsQM5KkfTLGYeby
	 FdL+ewQ4fKJr+rBPOVo2UfPif2GLR2QK5Ax3Y4clLDTZGvKxlV4KHY9wIuQSesYl4GyGz
	 uN5PufVWnXmEZ1R88hQR1b8RsIRsdW4FGDfCHItKz6k6uwfO8ymvIgign9XXvQntDCpYI
	 0Z7tACVS5DEQL1IwmtTptGRDULaQcFOnuwrQWadPxhvTz2dyYkDWisTzRrkeRFlzc2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d5BjAWMNaX18tquonqtDCW2LCXHNR9ZnSaaxU2kSCxU=;
	b=wdzRERtH4wk5K1S3lFVRBq7M0jPb7BZtsEJl7zAnOleb79PydVoGCnHQxyP7FAIiuvh3
	 70hpkY+W0Na4J5Lk8O4Sq1owsRRjio4vJwWnqUo/v6IAXg/t8f/K3z1tDSS46Fh2bxL68
	 w+ceI1aaAAQYZb9pYhYf8mhw5bzFW1aytsAg/pnZbjBZkzCu9nW8f1Xd2Gx4me0kXlnI9
	 CbZAdvGv67XqAaIlnOq+qNT0kIuAG9c8YgJbW0rKDCmXfOzFQivj5AymaNb7CEpyqwP9Y
	 Qmd+8fH7KOCwfi252svoeTMq8oiQY+iPCnj4YIn8b0tNuOU+AuL6BRsUS+FZodlVRmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qM5f+RyH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7319D606A31C;
	Wed, 18 Nov 2026 23:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qM5f+RyH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA6D1F000C4;
	Wed, 18 Nov 2026 23:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044451;
	bh=d5BjAWMNaX18tquonqtDCW2LCXHNR9ZnSaaxU2kSCxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qM5f+RyHQwJYM3rjk5A3sbndnmTvvwORlPm2SET267acRRWctKW+Zs/tTn5D6+EXL
	 eseg2WqtFhZ0BkytD9dIo/fXK7SMW13+zqQCXDsm2/nDtwMOqikmIrwPc+25kIaXLp
	 +cPHDrKRsNxHh3cpeUD7bgpPBCW+/NxVum6BuLzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0523/2857] Revert "interconnect: Dont access req_list while its being manipulated"
Date: Wed, 18 Nov 2026 15:25:57 +0100
Message-ID: <20261118150220.301261172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 8401bc2c188030fb14d1cb43c402a1cf42d86dd2.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/core.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 180015512aa40..40e2f110c5339 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -162,8 +162,6 @@ static struct icc_path *path_init(struct device *dev, struct icc_node *dst,
 
 	path->num_nodes = num_nodes;
 
-	mutex_lock(&icc_bw_lock);
-
 	for (i = num_nodes - 1; i >= 0; i--) {
 		node->provider->users++;
 		hlist_add_head(&path->reqs[i].req_node, &node->req_list);
@@ -174,8 +172,6 @@ static struct icc_path *path_init(struct device *dev, struct icc_node *dst,
 		node = node->reverse;
 	}
 
-	mutex_unlock(&icc_bw_lock);
-
 	return path;
 }
 
@@ -783,16 +779,12 @@ void icc_put(struct icc_path *path)
 		pr_err("%s: error (%d)\n", __func__, ret);
 
 	mutex_lock(&icc_lock);
-	mutex_lock(&icc_bw_lock);
-
 	for (i = 0; i < path->num_nodes; i++) {
 		node = path->reqs[i].node;
 		hlist_del(&path->reqs[i].req_node);
 		if (!WARN_ON(!node->provider->users))
 			node->provider->users--;
 	}
-
-	mutex_unlock(&icc_bw_lock);
 	mutex_unlock(&icc_lock);
 
 	kfree_const(path->name);
-- 
2.53.0



