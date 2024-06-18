Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B432142E9E;
	Tue, 18 Jun 2024 12:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714911; cv=none; b=AQ1FQGLaQgcW/tGBYcv7LfQUdxIi7iuC7n0Z3l+6r627U36FjlIil6Lm367k4C4EGsDedXIpWGItESaATu21Mi4aiV5n9eUNidh6vA55SmVRBdhpzd+LfBXR6fabVKbGPpJE6pJ6udieqkuZn9Kv4BFd168cT7jjHG8HII/2Y64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714911; c=relaxed/simple;
	bh=25hCf61fvf0NvYUQOVxlh0k2Mo+DggVDUqXJFb3m8Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7lYtDGBd2vctg11el+UROM5wnQ/j9YyPKsufTh2GMt6XjT93eFnJKlo5+snqwLpus8SP+V5gGFFnT09OXlERcYQZLurQk3ZDFoypcPA2msfJi76z1Yobo92lw+8AlTzkn2LK9gBE9LWSLrpWZbI813XLfXGoQElRXbicaShT0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cA+Lge/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cA+Lge/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42DCC32786;
	Tue, 18 Jun 2024 12:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714911;
	bh=25hCf61fvf0NvYUQOVxlh0k2Mo+DggVDUqXJFb3m8Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cA+Lge/x63TZkbNzcehQuhEHYjHD7reVg9JzYipDhZZAzg5sJB2e2bqISzQ4UQvZ
	 7FW9O1Lj+NCBTO6/B/D5uJHOeUW/riCe5oPlmVi/CJrZYBRMRgBv3Xrw4JhvDm3pjM
	 FSpaG3Kuh+rlLju0sl8SXJZqP24imxYEHRsn+K1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yongjun <zhengyongjun3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/770] fs/lockd: convert comma to semicolon
Date: Tue, 18 Jun 2024 14:29:43 +0200
Message-ID: <20240618123412.295458965@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 3316fb80a0b4c1fef03a3eb1a7f0651e2133c429 ]

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/lockd/host.c b/fs/lockd/host.c
index 771c289f6df7f..f802223e71abe 100644
--- a/fs/lockd/host.c
+++ b/fs/lockd/host.c
@@ -163,7 +163,7 @@ static struct nlm_host *nlm_alloc_host(struct nlm_lookup_host_info *ni,
 	host->h_nsmhandle  = nsm;
 	host->h_addrbuf    = nsm->sm_addrbuf;
 	host->net	   = ni->net;
-	host->h_cred	   = get_cred(ni->cred),
+	host->h_cred	   = get_cred(ni->cred);
 	strlcpy(host->nodename, utsname()->nodename, sizeof(host->nodename));
 
 out:
-- 
2.43.0



