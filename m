Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2693C3B0AD6;
	Wed, 20 May 2026 17:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299239; cv=none; b=DsrXOqXy0WY6O5BeTPe0tJ454ghVtRJamDxFsLzAaUjHJBUv5nW0IyK95qUMEu/xz/4ImzyHR6QTZhX5e/7d46fueOTcE+quL45E9Ja8XitTJTEUxabsWgyaqBMgr4KHU2InfyAcBM3/zAQq8blqrOYy00iaVJuBsn1Wt7bH+1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299239; c=relaxed/simple;
	bh=Qb2uUeBd2bQNxYTrtZJfj8n9USloSgpadxt2v7PM3Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByThJ9tlaP/2gMnX2FCv4vztGyXuhNY8Y+CQ0QeOg6Hk8qui0ghFDov3IgvYOzSGw8AaLjjsIqexiliWE2mjVoB/CDEp0PH4Xi71HQUVp/KMJ9HsMHbO/C/tLeM4oIirii+jLTGlOepY67JTJ1huKEswK3xVi676VAuf8XxURXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iQXy4UZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iQXy4UZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0A81F000E9;
	Wed, 20 May 2026 17:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299238;
	bh=Bt5q1IDmek0HkLfDr6TF6CGLl+BbVkPzlIiOsOaIcMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2iQXy4UZZR1jIaRzvirQcPDH8imnR/5bIO+JYkW4E6/wvKcirhOKG5fMqc0DLkFqG
	 LQ17oR+nfdokoCFppnmx7YqlxW/yfvfk2TALwzLEM9yM+9ytGs5n7C/eftmNCSeUnC
	 2BN1mv0R938teoMgU77qSyndiP7bVtHmpHhV9MmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 716/957] nstree: fix func. parameter kernel-doc warnings
Date: Wed, 20 May 2026 18:19:59 +0200
Message-ID: <20260520162150.075060234@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 43eb354ecb471426e97b0ce6a0c922ec20f82027 ]

Use the correct parameter name ("__ns") for function parameter kernel-doc
to avoid 3 warnings:

Warning: include/linux/nstree.h:68 function parameter '__ns' not described in 'ns_tree_add_raw'
Warning: include/linux/nstree.h:77 function parameter '__ns' not described in 'ns_tree_add'
Warning: include/linux/nstree.h:88 function parameter '__ns' not described in 'ns_tree_remove'

Fixes: 885fc8ac0a4d ("nstree: make iterator generic")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260416215429.948898-1-rdunlap@infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nstree.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/nstree.h b/include/linux/nstree.h
index 8b86366904739..4e2af7a973684 100644
--- a/include/linux/nstree.h
+++ b/include/linux/nstree.h
@@ -45,7 +45,7 @@ static inline void __ns_tree_add(struct ns_common *ns, struct ns_tree *ns_tree)
 
 /**
  * ns_tree_add_raw - Add a namespace to a namespace
- * @ns: Namespace to add
+ * @__ns: Namespace to add
  *
  * This function adds a namespace to the appropriate namespace tree
  * without assigning a id.
@@ -54,7 +54,7 @@ static inline void __ns_tree_add(struct ns_common *ns, struct ns_tree *ns_tree)
 
 /**
  * ns_tree_add - Add a namespace to a namespace tree
- * @ns: Namespace to add
+ * @__ns: Namespace to add
  *
  * This function assigns a new id to the namespace and adds it to the
  * appropriate namespace tree and list.
@@ -63,7 +63,7 @@ static inline void __ns_tree_add(struct ns_common *ns, struct ns_tree *ns_tree)
 
 /**
  * ns_tree_remove - Remove a namespace from a namespace tree
- * @ns: Namespace to remove
+ * @__ns: Namespace to remove
  *
  * This function removes a namespace from the appropriate namespace
  * tree and list.
-- 
2.53.0



