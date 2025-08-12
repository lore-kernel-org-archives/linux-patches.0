Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7052FE599;
	Tue, 12 Aug 2025 18:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023372; cv=none; b=a7ckjNdq+yAgNcqKDI86G1+iaatKi+WMUzFIbOPk4b86cH4nyiJBGqri6NPKefNjGoZiz/azFzTAG3TfmvFJHg/XkNYbycwYZkFkqtWkw0GW6IphbzT/PhAvY2ujwcH5DGMXuU3ynUBL/nyoX87xQp7x0SJm4y9rZcmlDONyz0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023372; c=relaxed/simple;
	bh=L0N1MqZykYJGJbGpYc3LF6qQlB6JPUGpTtT7Fyc/M68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efSRI4lmTREDg8BEfSgtVdVQL8JmQxlp6e2tkWl0ezSWjh1E+JZffiJR/bsM9g22Wt51CMUHT3exdE9H50Wa0KmqZt8U8rhaDF5IKYtLDW4y9oSkY6AB+fDON3Y9y7deccZfhC3zwc9XPjWOLWeAVpVGXo6cGyLSLVZCtTdpueg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oP7UzaFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oP7UzaFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA9BC4CEF0;
	Tue, 12 Aug 2025 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023372;
	bh=L0N1MqZykYJGJbGpYc3LF6qQlB6JPUGpTtT7Fyc/M68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oP7UzaFsTsUsJsChfxNoxnNY7JPDi9R5ybApURLgsxIC9pOhvP24GnJ4brVgotqpL
	 Em/vfJhHDCneDcogKqIjFG43HvQ4mY854MhNFn8F9BVoID9zA6WHqL0UmEl5mamVwN
	 /Bdre1sJByvwxBbGvQUsLq1Dyv2biqqjXqa6DMsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	kernel test robot <lkp@intel.com>,
	Jann Horn <jannh@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 027/627] eventpoll: fix sphinx documentation build warning
Date: Tue, 12 Aug 2025 19:25:22 +0200
Message-ID: <20250812173420.361121227@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

[ Upstream commit ecb6cc0fd8cd2d34b983e118aa61dd8c9b052d0d ]

Sphinx complains that ep_get_upwards_depth_proc() has a kerneldoc-style
comment without documenting its parameters.
This is an internal function that was not meant to show up in kernel
documentation, so fix the warning by changing the comment to a
non-kerneldoc one.

Fixes: 22bacca48a17 ("epoll: prevent creating circular epoll structures")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/r/20250717173655.10ecdce6@canb.auug.org.au
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507171958.aMcW08Cn-lkp@intel.com/
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/20250721-epoll-sphinx-fix-v1-1-b695c92bf009@google.com
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 7a7b044daadc..b22d6f819f78 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2190,9 +2190,7 @@ static int ep_loop_check_proc(struct eventpoll *ep, int depth)
 	return result;
 }
 
-/**
- * ep_get_upwards_depth_proc - determine depth of @ep when traversed upwards
- */
+/* ep_get_upwards_depth_proc - determine depth of @ep when traversed upwards */
 static int ep_get_upwards_depth_proc(struct eventpoll *ep, int depth)
 {
 	int result = 0;
-- 
2.39.5



