Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7461170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF64C433C8;
	Mon, 11 Sep 2023 14:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441694;
	bh=1bSRE9NTM0PzhJOrlrbm0sz8ZA2wzMGp+C6LVSvS6wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfYEgPtxhU6GwX5Jo0/fvdi4Ye/mQEIS3DNP6TDrjHXwpTkw2Go9ilcqTUdb0R6fN
	 Zq9r6yTttoFX1vdXaf/yAEvAzxMUVVPZk9Zm+UWOf3yueEFNcBxhsB0RqDFkq9oIY1
	 7G6Gc7f0a2jQKnIePVFM4SUlTg9iQ7FdXKA/6lPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 504/739] kernfs: add stub helper for kernfs_generic_poll()
Date: Mon, 11 Sep 2023 15:45:03 +0200
Message-ID: <20230911134705.212093555@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 79038a99445f69c5d28494dd4f8c6f0509f65b2e ]

In some randconfig builds, kernfs ends up being disabled, so there is no prototype
for kernfs_generic_poll()

In file included from kernel/sched/build_utility.c:97:
kernel/sched/psi.c:1479:3: error: implicit declaration of function 'kernfs_generic_poll' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
                kernfs_generic_poll(t->of, wait);
                ^

Add a stub helper for it, as we have it for other kernfs functions.

Fixes: aff037078ecae ("sched/psi: use kernfs polling functions for PSI trigger polling")
Fixes: 147e1a97c4a0b ("fs: kernfs: add poll file operation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Link: https://lore.kernel.org/r/20230724121823.1357562-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kernfs.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 73f5c120def88..2a36f3218b510 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -550,6 +550,10 @@ static inline int kernfs_setattr(struct kernfs_node *kn,
 				 const struct iattr *iattr)
 { return -ENOSYS; }
 
+static inline __poll_t kernfs_generic_poll(struct kernfs_open_file *of,
+					   struct poll_table_struct *pt)
+{ return -ENOSYS; }
+
 static inline void kernfs_notify(struct kernfs_node *kn) { }
 
 static inline int kernfs_xattr_get(struct kernfs_node *kn, const char *name,
-- 
2.40.1



