Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428D0139D1C;
	Tue, 14 May 2024 11:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687065; cv=none; b=WO+/dIp64majA6p+Ne2gc8RLZOdJNMDBWIghWNcazTfY8omOxtKcWzOM38z/OXHAflufey2vnk4x/yqySSYqUXQ7f9emUudaVRP0eKfMvy+mIhk4qweaNpyuGo5yQqjefbgZIcg3tkBB0jMjQPH5klM9SQhep7IAmpypM8JLRjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687065; c=relaxed/simple;
	bh=kdGvPpIJSNHypTP6YxtRWiAvWoMTZoe4/sIUpE2gEro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2ajCH0ApCYHxgUPUAQ/i8Ys8aDa7VRDaDwNmu7mTH3peHgFhUibKCZLA8Rm6vRvOOx+UNzhvAKrwpJC2vnqmrpwO2XocqWwRvRcpOEm/V1x2CGYKwNh9jBTQwiB1F6XUCuzrU3xSjr8LlBNR/GW4bIhxzYhuz6ZbvBUxuLzB7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTCHlm+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTCHlm+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD82DC2BD10;
	Tue, 14 May 2024 11:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687065;
	bh=kdGvPpIJSNHypTP6YxtRWiAvWoMTZoe4/sIUpE2gEro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTCHlm+6IvgC7nyGUsfakIudxbqvU7XUm7+NAEpGAgNe2QdF74DfRmU7PpaPFH0yd
	 DTB+WEW7ALsCvLPyuRv3hhB/yJXWprLoJUPgbyMZdtVl//WP+jA+K/pdybK02EHEXy
	 zG51mC6khW580fOBlXnuY8Z13uTeEiPvse045O0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/84] fs/9p: translate O_TRUNC into OTRUNC
Date: Tue, 14 May 2024 12:20:03 +0200
Message-ID: <20240514100953.644902852@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joakim Sindholt <opensource@zhasha.com>

[ Upstream commit 87de39e70503e04ddb58965520b15eb9efa7eef3 ]

This one hits both 9P2000 and .u as it appears v9fs has never translated
the O_TRUNC flag.

Signed-off-by: Joakim Sindholt <opensource@zhasha.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index b1107b424bf64..ffce168296bd3 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -177,6 +177,9 @@ int v9fs_uflags2omode(int uflags, int extended)
 		break;
 	}
 
+	if (uflags & O_TRUNC)
+		ret |= P9_OTRUNC;
+
 	if (extended) {
 		if (uflags & O_EXCL)
 			ret |= P9_OEXCL;
-- 
2.43.0



