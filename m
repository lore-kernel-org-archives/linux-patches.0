Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E491A2C12;
	Tue, 18 Jun 2024 13:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716359; cv=none; b=VSVuqj16O3OJnYaQQAnGQgRo/7/Sua87E+8yfLI72APo9ZJYor7lXXVa24qE++cQV6fSQUFwZCICRWIXtIwxIoLoLr/t+OPNjGHZDc7vFXzKBbIQo8898hoSvk04x8W8eOosqi2qPXNk8CkgXPYb7hIm+ChLkExJYZ6XNua88xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716359; c=relaxed/simple;
	bh=ZjRzmUOTRr0RVnwuApAZzmGUpZ1YyIXYfrflcuwDLsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZi+LwLxx85HIhT3xB+AWNqRAwqwW1RivUt/NZuJ4gqjX58D2km9xTSAmEl07txzZtBTFjH2rxacncZwtqTCh+phMGM95yRMmpbjB9J1Dw8TtD9Svy2O7mVn5G3MNYaNEqqk3RVSTnASeP8mKRFELFqgocQV9EBDw6py4k3bWSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfrflJjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfrflJjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118B1C3277B;
	Tue, 18 Jun 2024 13:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716358;
	bh=ZjRzmUOTRr0RVnwuApAZzmGUpZ1YyIXYfrflcuwDLsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfrflJjm1FY0JEStdieS5nPJZGWao6u+sz4k0UFz0s88kBJetmK1/fm93X3WCYTW3
	 h35LxoD4rTpowLSy4ggoUz5BTAuy3E1JG/bjM7VPPh1gumddE99c0WDigjCPUu5XUd
	 D+LMs4Bzzo4RgZHdPZXOTqXIcW4sWKEpzZEG53Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olaf Kirch <okir@suse.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 588/770] nfsd: silence extraneous printk on nfsd.ko insertion
Date: Tue, 18 Jun 2024 14:37:21 +0200
Message-ID: <20240618123429.994659457@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 3a5940bfa17fb9964bf9688b4356ca643a8f5e2d ]

This printk pops every time nfsd.ko gets plugged in. Most kmods don't do
that and this one is not very informative. Olaf's email address seems to
be defunct at this point anyway. Just drop it.

Cc: Olaf Kirch <okir@suse.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 164c822ae3ae9..917fa1892fd2d 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1519,7 +1519,6 @@ static struct pernet_operations nfsd_net_ops = {
 static int __init init_nfsd(void)
 {
 	int retval;
-	printk(KERN_INFO "Installing knfsd (copyright (C) 1996 okir@monad.swb.de).\n");
 
 	retval = nfsd4_init_slabs();
 	if (retval)
-- 
2.43.0



