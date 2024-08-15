Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A236A1714D0;
	Thu, 15 Aug 2024 13:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728583; cv=none; b=KEgyyt5F72j2m9jJSoaaMCwA5SYJLiHv+elPVXQW9xMJIk3v2bivDn8LCUG9lWnwSyfZDqoJlAzKALd6r+bI8BO+k+7EOEgOB0FYfyXFJduG1OjxGAjSPuC2K6br7g44OvDlVa98AjuMCxmzTDNCEv6DBH9CDkeztvCVVIQZ/pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728583; c=relaxed/simple;
	bh=K+HNh5NYi4fTvex+pY40mu6lHyyUyhoDQ3aW/ODeSG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQ9YYk2GVNp3YpHevBb3xSi9TtQT7dUUOfRSoIB91OjIVGuITKh4mMILRxR1V9KBYyIqM2dGN2TgbB91yPd5XBP08YQEpXpYL2PqeWRkxwA3qX8uC9OzxxJ5mwNnsFC9a+iGIMFXNUwSYv/ZAT2jtTF0+DL8KOJD/Rby2cmNbGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Rv9Tf6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Rv9Tf6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF17DC32786;
	Thu, 15 Aug 2024 13:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728583;
	bh=K+HNh5NYi4fTvex+pY40mu6lHyyUyhoDQ3aW/ODeSG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Rv9Tf6UoZO8j6cYAzmFutBICXgSNPVfXJdPO8CI7o9xPwj/SMnQIA5Vxwh9KP6L9
	 F9a+D1pKwOUJqJZn/A4t8LFYFu9QYgl76lZyzZbFZl/rxEW5ODR1Cu2MR16GPSS6Ee
	 IuEaYffV33j6xHMqOD6EUTFu92Fv+g7KA1LRYjyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/196] x86/xen: Convert comma to semicolon
Date: Thu, 15 Aug 2024 15:22:12 +0200
Message-ID: <20240815131852.659411721@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index f9b31eb6846c4..8cbdc5e6863c3 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -733,7 +733,7 @@ int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 		 * immediate unmapping.
 		 */
 		map_ops[i].status = GNTST_general_error;
-		unmap[0].host_addr = map_ops[i].host_addr,
+		unmap[0].host_addr = map_ops[i].host_addr;
 		unmap[0].handle = map_ops[i].handle;
 		map_ops[i].handle = ~0;
 		if (map_ops[i].flags & GNTMAP_device_map)
@@ -743,7 +743,7 @@ int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 
 		if (kmap_ops) {
 			kmap_ops[i].status = GNTST_general_error;
-			unmap[1].host_addr = kmap_ops[i].host_addr,
+			unmap[1].host_addr = kmap_ops[i].host_addr;
 			unmap[1].handle = kmap_ops[i].handle;
 			kmap_ops[i].handle = ~0;
 			if (kmap_ops[i].flags & GNTMAP_device_map)
-- 
2.43.0



