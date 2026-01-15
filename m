Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2903986334;
	Thu, 15 Jan 2026 17:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498752; cv=none; b=JKs29c7ZiRRuzPMu8vQ+FoGL3FjbV23JbiE/Lm+aXz9XCTnxkvODQJ+Ckv3FCViySARqdZW358OtO60qbYor3/Y1QRqOdOE8xyk/PYEzGKLYh5c/TebCITlbq2BUnbGpKdBbtFCevJ0gRWweWYEdzNX8KCjcn1WBRQ7c8I+NHJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498752; c=relaxed/simple;
	bh=v36icPnHLlt1mgM+Yncit7Sy/pCDMRiXQA+ufVRNtLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtvbF0oEU8jTN1t5KeqDdJhJmm3KbjsYJ0IaTFKrvE35cR3XhCfzb9Shbd1KeO59jMULjF0P0hWf+9t7K94UeEEnX9soH/jo5X/mO/BfOZW3MI55oCC6EAGOomyN1eA5UpqYmreBaVjZzhwEBNQmZhi0tma8fkmKNM7ieWNL3HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryCnnF8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryCnnF8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC956C116D0;
	Thu, 15 Jan 2026 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498752;
	bh=v36icPnHLlt1mgM+Yncit7Sy/pCDMRiXQA+ufVRNtLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryCnnF8g9KOLFmKyWPjwgkf4c8c+y2shZQJH0tBRenb/hoRVCtk8QeYuTWbNtGCrJ
	 Gr/Eqnxm3R9SjcugC+/RWbpg5n6WTHfp+00AB/iwZ/6ljZJCbDRc/61BzjuYMklNz6
	 UEMJRVE15k82mKxwDu1ceamzf2Cd2pW3HrdES9pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Hanxiao <chenhx.fnst@fujitsu.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 542/554] NFS: trace: show TIMEDOUT instead of 0x6e
Date: Thu, 15 Jan 2026 17:50:08 +0100
Message-ID: <20260115164305.942970814@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


