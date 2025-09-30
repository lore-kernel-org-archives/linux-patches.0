Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5906C303C9B;
	Tue, 30 Sep 2025 14:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244070; cv=none; b=HlYqqpVJTh+0J72Vevys8pn30z0aG88z+5aNRpstQ1mlFFKIdcxa+HmkJvz/Zr2wbENTttZV0YroqD6TzswQ8heUywfQut6/hyLXuAlS6xZs6s+MaNMC5HS4t5OEhzyqrapkxHwBcS6O7bSel/v2X8ngH9DBX1ld9u53/OtaV5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244070; c=relaxed/simple;
	bh=qBawuQWqGTeOsDGC9lDxWyOTTncKO2XJiEOt4inZK1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AaYCIoORaAWsQaMxe8WG7+VnNK60HckKMAruMjS0Gt+fF1xA57h4e0yBIL7IBDAI3hOnfQTtYoQZWaJirQG38OZNdATun35AfwGP0IgxaEN04ZGJGL00utPRcpuWD+IoDDNnJOKcXdpVE/PcuGkUGLHWIfR9uBHKL5YWRxQFxi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TL8bWMk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TL8bWMk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D6CC16AAE;
	Tue, 30 Sep 2025 14:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244069;
	bh=qBawuQWqGTeOsDGC9lDxWyOTTncKO2XJiEOt4inZK1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TL8bWMk6YxDgJSDbQ681JMkrFkWD5VYHP5+dd6I5c9HMaoAquo4q0uqPcr3Qu61/t
	 MgCw03MqVXWvM2VvxQu5HV36VkN48aQnX4VOoC0OU5W7TS/6c0CxN2qa9pAInhv5jC
	 n3K8OqE5izzpWx70oI0HJhKAnnjFIqOn9eEJFwe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Haiden <scott.b.haiden@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/122] NFSv4: Dont clear capabilities that wont be reset
Date: Tue, 30 Sep 2025 16:45:38 +0200
Message-ID: <20250930143823.274940227@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 973b708ff3328..c094413c17541 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3935,7 +3935,6 @@ int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle)
 	};
 	int err;
 
-	nfs_server_set_init_caps(server);
 	do {
 		err = nfs4_handle_exception(server,
 				_nfs4_server_capabilities(server, fhandle),
-- 
2.51.0



