Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69A62580D7;
	Thu, 28 May 2026 20:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999453; cv=none; b=LOd1Y6z97De/2yjKr6sGjd5fP4b2DvFOtpBTqn1u11N8PlLDhaI0D7HgP+zaeIC83eYEh5G34wg9FEcfmaVI+qfKZmiS9+WeYuyqJtz2d07EGGfyMQN40epz6D5AqGcyO0Q+SHMG9vbgChAFxxWabNyZBf3g934msZ7+eUdCYOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999453; c=relaxed/simple;
	bh=gIa7C5Qm0dgoLrltdCkgnk5HwDPkWf4efn58BngbTBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tm0oLb+trI1Yr/+yTGYCoHIEWbWltuREzrGqMrdFVQwImcwoBNyDwc2DuRgyWYGC/ylgSJORfd11+AuxYa7LlZFQVkQyss4FAG54QhgKj38c8VXgA2u9cAkugkgqK3U3+zyTJvQu7hDOvRS3a2/wgMPe4VqkNRpoc0jMzXLy2ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJEHVXHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJEHVXHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C3C1F000E9;
	Thu, 28 May 2026 20:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999452;
	bh=YiZ40Dx7Bgg1hMOR4Xj0eAXAX/oYQhRyXIHeoDiBtqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJEHVXHd8FH2SrdPndB/PrftHepJKmVVgeSN3pUdqznbtU126DyLXtruiG4EbMNmm
	 K0kjcx0KnUary234tVxpJQjGS8t5v5wQklBgjU7PhTvJaTD1eYDbDvmHztI4AeuZAk
	 4TunMqlpHy7XRILUYN6XrawUaWBWsgOOOpd+d0MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Menglong Dong <menglong8.dong@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 071/377] tracing: fprobe: Remove unused local variable
Date: Thu, 28 May 2026 21:45:09 +0200
Message-ID: <20260528194640.421605147@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit 90e69d291d195d35215b578d210fd3ce0e5a3f42 ]

The 'ret' local variable in fprobe_remove_node_in_module() was used
for checking the error state in the loop, but commit dfe0d675df82
("tracing: fprobe: use rhltable for fprobe_ip_table") removed the loop.
So we don't need it anymore.

Link: https://lore.kernel.org/all/175867358989.600222.6175459620045800878.stgit@devnote2/

Fixes: e5a4cc28a052 ("tracing: fprobe: use rhltable for fprobe_ip_table")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Menglong Dong <menglong8.dong@gmail.com>
Stable-dep-of: 0ac0058a74ac ("tracing/fprobe: Check the same type fprobe on table as the unregistered one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -561,8 +561,6 @@ static int fprobe_addr_list_add(struct f
 static void fprobe_remove_node_in_module(struct module *mod, struct fprobe_hlist_node *node,
 					 struct fprobe_addr_list *alist)
 {
-	int ret = 0;
-
 	if (!within_module(node->addr, mod))
 		return;
 	if (delete_fprobe_node(node))
@@ -571,8 +569,7 @@ static void fprobe_remove_node_in_module
 	 * If failed to update alist, just continue to update hlist.
 	 * Therefore, at list user handler will not hit anymore.
 	 */
-	if (!ret)
-		ret = fprobe_addr_list_add(alist, node->addr);
+	fprobe_addr_list_add(alist, node->addr);
 }
 
 /* Handle module unloading to manage fprobe_ip_table. */


