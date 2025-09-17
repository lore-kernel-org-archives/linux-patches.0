Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218621DE894;
	Wed, 17 Sep 2025 12:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112613; cv=none; b=B4jaHroigz3IBEJerTFANoPnVRGSFgeoeFsp4KozMQpEjk4/8BqvwE6/vEQDnEv9KIqCZLHi3EaKJ9+K8v+ythUpew+QqH63hd7bMHxE1GlpmRFfspJ7BPv1f8aSIp3VdGVF60cynOEDCjOiBGQvBRmGjJOyclhF8PmDmU6Fbns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112613; c=relaxed/simple;
	bh=4H4lD3pjslTXRlnjPOxwr2dcH/vNM/x8qanpQuDeazg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZApMAqrdC6Bp2x8ipNyHfYY8bVBSngyztBBa6xUEYb+hbzW3HIF8h5Lv+SwZKvsxomkMGEbaKPSDFa/DFlR5ZEOL+s4p2484Per1ampCpieybJpdO1LT//sRsfmFe0FeEaiUxkbHfZiABY+6EPVVaHQeoIyyyAM/VkYO1PVwlgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifHUkbkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifHUkbkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597F0C4CEF0;
	Wed, 17 Sep 2025 12:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112612;
	bh=4H4lD3pjslTXRlnjPOxwr2dcH/vNM/x8qanpQuDeazg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifHUkbkNd7PMkmcvvim1OSIqSlU/7tIdS8pjbU3nT0HgshMWzQ25ETLGEG3pKlQA/
	 Kcjl2nS+N3zo2uL0lWn7Bgwi+91iskEAI5MHWhkMFIxcvAMQmG8T0t3hduW2Yq4CYK
	 0Rwpp3DGlb2nQQb29KLaCywdB9T4XxgWAIee6liY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 024/189] NFSv4: Clear the NFS_CAP_XATTR flag if not supported by the server
Date: Wed, 17 Sep 2025 14:32:14 +0200
Message-ID: <20250917123352.445033789@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 4fb2b677fc1f70ee642c0beecc3cabf226ef5707 ]

nfs_server_set_fsinfo() shouldn't assume that NFS_CAP_XATTR is unset
on entry to the function.

Fixes: b78ef845c35d ("NFSv4.2: query the server for extended attribute support")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 3bcf5c204578c..97bd9d2a4b0cd 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -890,6 +890,8 @@ static void nfs_server_set_fsinfo(struct nfs_server *server,
 
 	if (fsinfo->xattr_support)
 		server->caps |= NFS_CAP_XATTR;
+	else
+		server->caps &= ~NFS_CAP_XATTR;
 #endif
 }
 
-- 
2.51.0



