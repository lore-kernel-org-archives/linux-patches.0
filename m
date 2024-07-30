Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2A5189B86;
	Tue, 30 Jul 2024 16:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355833; cv=none; b=fNIyUgMBKSm9puvVFPIPj4qFt0uJ4F4bDzx+FxrfemM69Tkw28ZjQLpHoWpzd4LKhTxI0eOaSXuBdYDY41ho2C7t2UY1DYkf0KrG1bK5K4MaDIs2zpyo2B0v12RSc4iqACxsmITgCXTkqekuvW6wbspI21mJyk+fTY/HYQ3P2DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355833; c=relaxed/simple;
	bh=8JdQDM5hYc4QvLRl6GM6AyzxQbK6ZwE19+39cAJUPss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKAjzCGZBzrTEZecuqYY4oErdEBqT65Q3ah1vzp++f3nBOZCK9iwSehDKpwaIy4lSZyvNgC8iArY566CljlnR0u7M4nHkSHB3E4zB9JbK8CA/NQOMLobn7PFmvFoosuFJRldXLnJpp2AAvhYDBNtFXXzPzc6wZZNtTSVHnLmbS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luRM6eHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luRM6eHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4C0C4AF0A;
	Tue, 30 Jul 2024 16:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355832;
	bh=8JdQDM5hYc4QvLRl6GM6AyzxQbK6ZwE19+39cAJUPss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luRM6eHBeXbyqe7KwjbrL9iz3AsNIMkN13lIxO/92nxkzWiafkA/ruW9EIbUfOhkN
	 /Liyr0vm0db8Mye/XdbHlXC5dKujsgFziQ77lX3J3qGyCIu4dOZZYodnXWo5ekbiJR
	 cZgv7XRETXrsXwwMfxcjzsuSMndeumY3qN3+6Mdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/568] x86/xen: Convert comma to semicolon
Date: Tue, 30 Jul 2024 17:43:21 +0200
Message-ID: <20240730151643.550022194@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 349d271416c61f82b853336509b1d0dc04c1fcbb ]

Replace a comma between expression statements by a semicolon.

Fixes: 8310b77b48c5 ("Xen/gnttab: handle p2m update errors on a per-slot basis")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20240702031010.1411875-1-nichen@iscas.ac.cn
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/p2m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 9bdc3b656b2c4..4c2bf989edafc 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -731,7 +731,7 @@ int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 		 * immediate unmapping.
 		 */
 		map_ops[i].status = GNTST_general_error;
-		unmap[0].host_addr = map_ops[i].host_addr,
+		unmap[0].host_addr = map_ops[i].host_addr;
 		unmap[0].handle = map_ops[i].handle;
 		map_ops[i].handle = INVALID_GRANT_HANDLE;
 		if (map_ops[i].flags & GNTMAP_device_map)
@@ -741,7 +741,7 @@ int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 
 		if (kmap_ops) {
 			kmap_ops[i].status = GNTST_general_error;
-			unmap[1].host_addr = kmap_ops[i].host_addr,
+			unmap[1].host_addr = kmap_ops[i].host_addr;
 			unmap[1].handle = kmap_ops[i].handle;
 			kmap_ops[i].handle = INVALID_GRANT_HANDLE;
 			if (kmap_ops[i].flags & GNTMAP_device_map)
-- 
2.43.0



