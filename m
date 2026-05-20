Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FA7366075;
	Wed, 20 May 2026 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296607; cv=none; b=HFxds7TdlSXJLybF9HNknI+l2rM/aCUZ/nJpwEZBnCsJL43ilL9JZrOVO6o8hcLLPIMitcXUzBuEXuqX93C7w9nRtyBSDNTT1BDyoGKa2NrMbifbzgMa8YcE9pC5OQmCwFbhQ7DfJvbRJH4uwVrtwul/eo3GZXi2OdWtGqvb418=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296607; c=relaxed/simple;
	bh=0/Xc83+DOvzJgIlRpqaW2NzMj7EiKPCMFXlwJ8M3Hug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAol3m9gdJCn0f11tUW0p+SejC/bG682q90BQvyNaqML/sd1/8Zwlu4xirvgRtkxQ9IVQgQwedNs2kB3iQKJ9xrn0uGNFKlhsTeBq5E5tFwsHZsc6/BU7sXwM109iNMRkj1BhIv9mK5kmbQ3iOY/9n3/ZIEXXtdXEMAnS8gx2jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwVZyCZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwVZyCZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BD01F00893;
	Wed, 20 May 2026 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296606;
	bh=CrUMsV3iCDUkU6on9jR1Y/C/jXLba7RsLx47UzZk9QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VwVZyCZIfujvL5dhvp6vIIjUIosV3TKjs45L3GqRDJ7GAle7C7WOjvV4gVFz9lZbe
	 WnAYO2aQaub733LShmJCW9AgZMSeCg5zqKWUKXkSTHdsNM3WXkpS61mkoF3wz5sH4C
	 omkZZbfzAhYS/p6RORYf+i/vkkuEVJ7EcJdX3NFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0861/1146] nstree: fix func. parameter kernel-doc warnings
Date: Wed, 20 May 2026 18:18:31 +0200
Message-ID: <20260520162207.725054402@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 175e4625bfa6d..5b64d45728819 100644
--- a/include/linux/nstree.h
+++ b/include/linux/nstree.h
@@ -61,7 +61,7 @@ static inline void __ns_tree_add(struct ns_common *ns, struct ns_tree_root *ns_t
 
 /**
  * ns_tree_add_raw - Add a namespace to a namespace
- * @ns: Namespace to add
+ * @__ns: Namespace to add
  *
  * This function adds a namespace to the appropriate namespace tree
  * without assigning a id.
@@ -70,7 +70,7 @@ static inline void __ns_tree_add(struct ns_common *ns, struct ns_tree_root *ns_t
 
 /**
  * ns_tree_add - Add a namespace to a namespace tree
- * @ns: Namespace to add
+ * @__ns: Namespace to add
  *
  * This function assigns a new id to the namespace and adds it to the
  * appropriate namespace tree and list.
@@ -81,7 +81,7 @@ static inline void __ns_tree_add(struct ns_common *ns, struct ns_tree_root *ns_t
 
 /**
  * ns_tree_remove - Remove a namespace from a namespace tree
- * @ns: Namespace to remove
+ * @__ns: Namespace to remove
  *
  * This function removes a namespace from the appropriate namespace
  * tree and list.
-- 
2.53.0



