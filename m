Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016730;
	b=j/2kTbG8B/M5g8VWDyz2Rwz3vZ8IIZMY6itWfJgeHP5EMDs8gvhPnfnDzNUcgz/DlsRB
	 TanJM2NWrGeRK1m0s6x5giYz8LIFLYEb4jmyxbW/Vb2HvDDkB42ZL2U47z12D6QOQT4Ci
	 VUzw9ahmUJVcS/gfrCQmY079YmUK2Mo7lxoC0QgEMXRhCFqPzYRv3i9AjaZu3SjlMfqy6
	 +Kvl033sCpFuPOOSLYg9R9J6r5ZrMXhzQJxP8YWefvqhSzxtHpGRwt0jOgjN66WRjrHWy
	 V5oh4uEP/2ZVU5ipWBvR2OoCEBuhX/Cw4vhHo47G/pd/RTw8ow1esLlfCUOJ9vDa1ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=25nJeG9NMFgDKzMkhxuXt76j4I6zPPP9Ss+A/VyRE7s=;
	b=N4ZONbQ+vZEyrxGcd10Kqg1QpLvX2kch0DLZYJ2YgxZdnntrKGhOcDdOZ5bjJLsbDPf9
	 yJ6KfKMF73CVDOoWR5dMDbYJxUBqZnIOlbcwiVee+MVS3bWuVOuSu7WFOE4LWmcL8ROEQ
	 4/F/dAVwALiCOwAZzB8Z7BglM77BHtpuQhANDK7sv9/KfOuY5Hp2IA50y4zQ1+OCVu1UZ
	 EprTxHg1LnLkVhFwursSZZFeh67BOMIzuTlYou8ewVIzyq88PBs7biXuBfxfP0vWK2Rax
	 T179c/SJxxRXFFKmOrp6Z4CX5LYn1AMX+s8nzFS1bQwna7Wv9k7Y3eNGCXik9OCd3aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m0BKSFP/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B192606A320;
	Wed, 18 Nov 2026 15:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m0BKSFP/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7451F000C4;
	Wed, 18 Nov 2026 15:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016729;
	bh=25nJeG9NMFgDKzMkhxuXt76j4I6zPPP9Ss+A/VyRE7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0BKSFP/DhUfl2lcT4tgWshqMiRxa9zVnYj1PbcQPTLK/gN9uJOr5/695Sb91VJcb
	 SoJFpxgSUPM6DnisbHQI9kJyjh8M7H9CLIox4XkmWZUnfBrzhkzEg49ru63XNxjJHj
	 EIx9drmW1NGfdzaiTWufnTxLJxQowRHY52PPjcJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0632/2651] randstruct: fix container_of() false positives after __mptr removal
Date: Wed, 18 Nov 2026 15:31:12 +0100
Message-ID: <20261118150310.438334973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 67beeb5621051eda74ca2171ea576c9602bb6cce ]

Commit f9e7a7564834 ("container_of: remove local __mptr variable") dropped
the "void *__mptr" temporary from container_of(). The randstruct GCC
plugin's find_bad_casts pass recognized the casts container_of() generates
by that variable's name:

	const_tree ssa_name_var = SSA_NAME_VAR(rhs1);
	/* skip bogus type casts introduced by container_of */
	if (ssa_name_var != NULL_TREE && DECL_NAME(ssa_name_var) &&
	    !strcmp(DECL_NAME_POINTER(ssa_name_var), "__mptr"))
		continue;

With the variable gone the suppression never fires, so every
container_of() whose container type is randomized now emits a note:

  include/linux/container_of.h:23:9: note: randstruct: casting between
    randomized structure pointer types (ssa): 'struct ocfs2_triggers' and
    'struct jbd2_buffer_trigger_type'
  fs/ocfs2/journal.c:524:16: note: in expansion of macro 'container_of'

The pass runs on GIMPLE, after folding, and for a member at offset 0 the
whole expression collapses to a bare copy that is indistinguishable from
an unsafe cast:

  to_ocfs2_trigger (struct jbd2_buffer_trigger_type * triggers)
  {
    _2 = triggers_1(D);   /* void * cast and subtraction gone */
    return _2;
  }

Match the type relationship instead. A cast from A * to B * is a
container_of() if B reaches a field of type A at offset 0 through a chain
of by-value members. The chain matters: container_of()'s member argument
may be a dotted path, as in ceph_inode(), which is container_of(inode,
struct ceph_inode_info, netfs.inode) and needs two levels. The search
is depth-bounded to 4 just in case, since real paths are generally one
or two members deep.

Requiring the cast happens at offset 0 is done because any other member
offset the subtraction survives folding and the cast's rhs is still
void *, which the pass already skips a few lines above.

A cast between two randomized types with no containment relationship is
still reported. Verified with:

	struct cred *f(struct file *f) { return (struct cred *)f; }

which is still flagged with the patch applied.

Clang's implementation is unaffected. It checks the cast as written, and
both the old and new macros cast from void *, which is always permitted;
a genuinely bad cast is rejected there as a hard error rather than a note.

Build tested ARCH=x86_64 defconfig with CONFIG_RANDSTRUCT_FULL=y and GCC
14.2.0: randstruct notes 52 before, 0 after.

Fixes: f9e7a7564834 ("container_of: remove local __mptr variable")
Assisted-by: Claude:claude-opus-5[1m]
Link: https://patch.msgid.link/20260903232438.60394-1-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 61 ++++++++++++++++++-
 1 file changed, 58 insertions(+), 3 deletions(-)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index ff65a4f87f240..e2bd9ba08089f 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -698,6 +698,63 @@ static void handle_local_var_initializers(void)
 	}
 }
 
+/*
+ * Does @container reach a field of type @member_type by a chain of
+ * by-value members? That is the relationship container_of() expresses --
+ * its @member argument may be a dotted path, e.g.
+ * container_of(inode, struct ceph_inode_info, netfs.inode) -- so a cast
+ * from @member_type * to @container * is legitimate rather than a
+ * layout-confusing one.
+ *
+ * container_of() used to leave a "void *__mptr" temporary behind, and this
+ * pass recognised such casts by that name. Commit f9e7a7564834
+ * ("container_of: remove local __mptr variable") removed it to stop nested
+ * container_of() shadowing itself, and the cast now folds to a bare SSA
+ * copy when the member sits at offset 0, leaving nothing syntactic to key
+ * on. Match the type relationship instead.
+ *
+ * The depth bound keeps this cheap; container_of() paths are one or two
+ * members deep in practice.
+ */
+#define CONTAINER_OF_MAX_DEPTH 4
+
+static bool is_container_of_cast(const_tree container, const_tree member_type,
+				 int depth)
+{
+	const_tree field;
+
+	if (container == NULL_TREE || depth > CONTAINER_OF_MAX_DEPTH)
+		return false;
+
+	if (TREE_CODE(container) != RECORD_TYPE &&
+	    TREE_CODE(container) != UNION_TYPE)
+		return false;
+
+	for (field = TYPE_FIELDS(container); field; field = DECL_CHAIN(field)) {
+		const_tree field_type;
+
+		if (TREE_CODE(field) != FIELD_DECL)
+			continue;
+
+		/*
+		 * Only a member at offset 0 can reach here: for any other
+		 * offset container_of()'s subtraction survives folding, the
+		 * cast's rhs stays void *, and the caller skipped it above.
+		 */
+		if (!integer_zerop(byte_position(field)))
+			continue;
+
+		field_type = TYPE_MAIN_VARIANT(TREE_TYPE(field));
+		if (field_type == member_type)
+			return true;
+
+		if (is_container_of_cast(field_type, member_type, depth + 1))
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * iterate over all statements to find "bad" casts:
  * those where the address of the start of a structure is cast
@@ -799,10 +856,8 @@ static unsigned int find_bad_casts_execute(void)
 #endif
 				MISMATCH(gimple_location(stmt), "op0", ptr_lhs_type, op0_type);
 			} else {
-				const_tree ssa_name_var = SSA_NAME_VAR(rhs1);
 				/* skip bogus type casts introduced by container_of */
-				if (ssa_name_var != NULL_TREE && DECL_NAME(ssa_name_var) && 
-				    !strcmp((const char *)DECL_NAME_POINTER(ssa_name_var), "__mptr"))
+				if (is_container_of_cast(ptr_lhs_type, ptr_rhs_type, 0))
 					continue;
 #ifndef __DEBUG_PLUGIN
 				if (lookup_attribute("randomize_performed", TYPE_ATTRIBUTES(ptr_rhs_type)))
-- 
2.53.0



