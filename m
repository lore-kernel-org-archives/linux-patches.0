Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE0533A70E;
	Tue, 16 Jun 2026 17:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630579; cv=none; b=UqM74cW+RyddfdkQM+0oxcTYRHt7w5E+yr/DgNqOWVoOSa1mxe44/kpwliTcxS1Wc1AupIXXbLH7KNZcCmB7L9CZT1ejTcsSpE2YniCztNW+It+kx+gqJKRPqKkApvpG1eV77Irr9tJefB8F3kMtDSWZLqNpxCa8gtBviuWwyg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630579; c=relaxed/simple;
	bh=ftRVRZjVLrkS7hkUsqoHKwGSl/D5bAlBrEeKFtBpPKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quNykcRzHQ69+QzemTUhKwnaQ9UhgMzl+yVFFs/zORMCsnFy3wjy4oLP5Zu2sTqYxQd42GnBCVuZz8WDTv8RQgQPJQlB+XUSsqYxpuJB9zJ86k7/TnQeE8fcQ+gpTIjUtoi3Qerbg/Nlem5jGikqVCR8sFP/lcF6fPr6AAYfAN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMsm4MDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMsm4MDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FE61F000E9;
	Tue, 16 Jun 2026 17:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630578;
	bh=3UMz4hVpUAjgWNz3OTSO8dy6qBpJh9Jgr2axGBqn1KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMsm4MDB4IQPUX7prLk2j2vMKaUeC3FKAe3lDCQQItYEddcJAo8e/MCaX+ab/2f/w
	 qgMxzXRHUG/T0FiA1Cxwo5D91HgMZE2eo4DeFy8kjWfx/MVTQmMHeStfM9zki38eXm
	 358T00kW6GYLMv740iKXd55c6LtEoPBl/1Piid+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/522] Revert "selftests/bpf: Workaround strict bpf_lsm return value check."
Date: Tue, 16 Jun 2026 20:23:23 +0530
Message-ID: <20260616145128.402219260@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Paul Chaignon <paul.chaignon@gmail.com>

This reverts commit a1914d146622 ("selftests/bpf: Workaround strict
bpf_lsm return value check"). It seems it was picked up by mistake.

It applies to a selftest that didn't exist in 6.1. The whole selftest
was then backported as a stable-dep in commit 45108a7b4866
("selftests/bpf: Add tests for _opts variants of bpf_*_get_fd_by_id()")
(reverted as well in the next patch).

The new selftest covers the bpf_*_get_fd_by_id structures. Those don't
exist in 6.1 so the selftest shouldn't either.

Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c  | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c b/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c
index 568816307f7125..f5ac5f3e89196f 100644
--- a/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c
+++ b/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c
@@ -31,7 +31,6 @@ int BPF_PROG(check_access, struct bpf_map *map, fmode_t fmode)
 
 	if (fmode & FMODE_WRITE)
 		return -EACCES;
-	barrier();
 
 	return 0;
 }
-- 
2.53.0



