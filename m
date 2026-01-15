Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D493A7F43;
	Thu, 15 Jan 2026 17:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497218; cv=none; b=OEr6FOP8tzfn4AUnjGCboLFUz6uKs79757/lW/kB0n8PEVpz7qAxqaz4YkzekA9xFNFeh1tW+PNK3Xje5nZGUFS/r6itfjfCo1qJlENs/YP7SzJN23U9FXbiUKsRMqaxp7mTsG7lDZBmfTG8hcH+forvjBF4Cc3SPSidBYmXt6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497218; c=relaxed/simple;
	bh=sIffCSSsX4H5ff3K8OrDYVUNXj8ZVcrZXxYPC0XTLPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DuC3EabDCGU7d41hw+htDZb8jr8Upxc4guOZGOfOePfbVo0GEC1dnMc0woogm8tP3fzNtVROtANXeyeBK1sSZ3IamujAMhkjv71zXtc8CQNOsu6UU5RAF/pL2Lvv+6J108DDPckcLUkJIj+wWOFhk4wg6LvC25ljLFkn2V+iMAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzmsNs1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzmsNs1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A01C116D0;
	Thu, 15 Jan 2026 17:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497217;
	bh=sIffCSSsX4H5ff3K8OrDYVUNXj8ZVcrZXxYPC0XTLPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gzmsNs1jD9JQh/gDKtSzMFRia+cSHKixNnuPP7TJmbe7KqoWr4wEBEh5RHE2JXa7z
	 z0O+QKcSz+FnOftbnGzuxbyy7cxocN4fCAsXaCKZ39YaA1n1/JtJrOCUcZwVOXKgh1
	 yeXjJ9nfCslbKjdv34yr+RRXZqeaqkl4QpVT/Q0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Hanxiao <chenhx.fnst@fujitsu.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 58/72] NFS: trace: show TIMEDOUT instead of 0x6e
Date: Thu, 15 Jan 2026 17:49:08 +0100
Message-ID: <20260115164145.603997392@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Hanxiao <chenhx.fnst@fujitsu.com>

[ Upstream commit cef48236dfe55fa266d505e8a497963a7bc5ef2a ]

__nfs_revalidate_inode may return ETIMEDOUT.

print symbol of ETIMEDOUT in nfs trace:

before:
cat-5191 [005] 119.331127: nfs_revalidate_inode_exit: error=-110 (0x6e)

after:
cat-1738 [004] 44.365509: nfs_revalidate_inode_exit: error=-110 (TIMEDOUT)

Signed-off-by: Chen Hanxiao <chenhx.fnst@fujitsu.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: c6c209ceb87f ("NFSD: Remove NFSERR_EAGAIN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/misc/nfs.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/trace/misc/nfs.h
+++ b/include/trace/misc/nfs.h
@@ -52,6 +52,7 @@ TRACE_DEFINE_ENUM(NFSERR_JUKEBOX);
 		{ NFSERR_IO,			"IO" }, \
 		{ NFSERR_NXIO,			"NXIO" }, \
 		{ ECHILD,			"CHILD" }, \
+		{ ETIMEDOUT,			"TIMEDOUT" }, \
 		{ NFSERR_EAGAIN,		"AGAIN" }, \
 		{ NFSERR_ACCES,			"ACCES" }, \
 		{ NFSERR_EXIST,			"EXIST" }, \


