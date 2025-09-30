Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42CB2FC881;
	Tue, 30 Sep 2025 14:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243816; cv=none; b=K8P0xEwQMHXvc30V44B++wkTSYo8e5NFQUfpcjmn7jLyxy7ZMZiEutz4h4Tw+35/IlfPjfLvTHahTHv5XytLI2srB8dsLM6Xo3a3G6hjpoPXaa4dsAe5ra7K11qnEBaC7ON/6lJ8LxrsgJ7bKxaShL5bU3ngMzsh39hdw4TNKzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243816; c=relaxed/simple;
	bh=xTLPw/2KPMmJKYR3YTEH0qWuKB/i3L5XaKk/otqgY0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvIy+vP0CDR75mkmvot+nXbfoCOUFDEwy8ufo7vXnSuy99PevoF0Qjx3T7yGRFZKNATCy36ZgDnWUKhl9T9CmgGeO0vHHvsxdyyt9O/fhX2gkYXb3cWHIKnNhh95MF3k2nxPEE7bmYzjKVK31OXkp8VmJTH7DoCRSsqPatEUJK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EI3Jj+eX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EI3Jj+eX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BFEC4CEF0;
	Tue, 30 Sep 2025 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243815;
	bh=xTLPw/2KPMmJKYR3YTEH0qWuKB/i3L5XaKk/otqgY0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EI3Jj+eXkmVskcCcL6s+NmP3fWZDPtfqKzzQTxgAOIIucb1zoxIPI9ZEy8tXOakqX
	 0iDTpgIxDHBD2NOPCxDX97OeJgb9meRurIU6VPuUAaFvhjFbfh1yiH70xBVJYlQMG4
	 RFvziwV9qx5OYvk6s4N+66VkCcbmyUJP+1TzCTQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Haiden <scott.b.haiden@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/81] NFSv4: Dont clear capabilities that wont be reset
Date: Tue, 30 Sep 2025 16:46:05 +0200
Message-ID: <20250930143819.801409937@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 31f1a960ad1a14def94fa0b8c25d62b4c032813f ]

Don't clear the capabilities that are not going to get reset by the call
to _nfs4_server_capabilities().

Reported-by: Scott Haiden <scott.b.haiden@gmail.com>
Fixes: b01f21cacde9 ("NFS: Fix the setting of capabilities when automounting a new filesystem")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 5f8de86b27982..f511087d5e1c2 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3885,7 +3885,6 @@ int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle)
 	};
 	int err;
 
-	nfs_server_set_init_caps(server);
 	do {
 		err = nfs4_handle_exception(server,
 				_nfs4_server_capabilities(server, fhandle),
-- 
2.51.0



