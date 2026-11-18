Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034660;
	b=XtpRLdRMnHdQE+xYJEe1XSecregpGimx/ew9N5o8Ur8mXmfFeHW5SVUs/4E1dFoVmG0+
	 dG5vlpvEcY28qajO/Oqd2iKlCFmf9K4HpjUrUVTE//l+d5epqIO+XMUOd+DTNFgdN+9G+
	 3tQgy1oikNjGluPhY3qWxoBfI0dJ4zZkvUnjrSMptlZos3qrS567JKk7HC3R8+5OqsWpe
	 wOy0qYOpr2ck4Voow4j3aTbFLt3M8bPWUZK2AFFQL2wb+G8Fnyzu+7+20g2Q8Vj63bhGi
	 JWHJQ4HTs+EHCMx3tX75yiAsnragUKIxQH3BwdtUXg2KAcbKAYziwdngN9AnoLutI5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7X7L8vRBk2gG8LuT0H/CBy4bZEUmBbtEN4wPrXkyDTQ=;
	b=Ek3SrNMwRPiBXfmF7gpRODfm3eennQDR2PFJ5zi9YpK1mkxMT39p9bxJk49nUkTOWszK
	 CTUXOsCLJrOvt4yzp+zds2f4E2vzD3ur3idq6GGUGBi4I97PXvglL6Wy+v1HIQojRQSfU
	 ddOFvhbwvyIAZ2ZPxYRD4Ydb8BmCL41I9+bGIGodWcLm+e82/hFXT7oUN5Sky871O0BCi
	 Q25uVvDC2+WI00114jtd1wo4u7gXbnGYvh+1q3SIkUeln9ocIwpneDzLcv4dJOa/d2+zM
	 ZSNfg2Xp8O5M/ZjQr93M4fSWe7JRuReZpkI7Z1jcL3UPLz/GqIr5OhwkJY6uRt8lhjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZJUPOzP0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33218606A335;
	Wed, 18 Nov 2026 20:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZJUPOzP0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8578F1F000C4;
	Wed, 18 Nov 2026 20:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034660;
	bh=7X7L8vRBk2gG8LuT0H/CBy4bZEUmBbtEN4wPrXkyDTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZJUPOzP0hTgfkVBabrfC0W4RRo8JpaN5fSy709kJkXhOjycYm7vE6O455dSA+JuuE
	 wbFS7Lk/F/KPnlzaxteqNWkhOaO5zq/5Cz7OfiQYsSO78DeQAcoJS2J2eiFqal82Q+
	 JAp53Aih+QHYNpJ77/mzjbicqulFKPFEjTDTBefI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0449/3318] tracing/probes: Fix BTF kflag check for anonymous struct member access
Date: Wed, 18 Nov 2026 15:17:51 +0100
Message-ID: <20261118150330.226319180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 47e93045a2db80d24f5fef65adecc6b2b32efa23 ]

btf_find_struct_member() traverses into nested anonymous structures and
unions to find a struct member. However, get_bitoffset_of_field() in
trace_probe.c checked btf_type_kflag(type) using the outer parent type
instead of the actual anonymous structure/union that directly contains
the found member.

If the parent structure and anonymous structure have mismatched kflags
(e.g., the parent has kflag=0 while the anonymous structure has kflag=1
because it contains bitfields), the bitfield size encoded in the upper
8 bits of member->offset is erroneously treated as part of the byte/bit
offset, corrupting the resolved offset and failing to set last_bitsize.
Similarly, btf_find_struct_member() pushed anonymous member offsets
onto anon_stack without masking BTF_MEMBER_BIT_OFFSET() when kflag is set.

To fix this problem, update btf_find_struct_member() to return actual
containing structure/union type via member_type, use appropriate
__btf_member_bit_offset() to get bit offset, and use member_type for
btf_type_kflag() in get_bitoffset_of_field().

Link: https://lore.kernel.org/all/178827250904.123716.17452648791331881284.stgit@devnote2/

Fixes: c440adfbe302 ("tracing/probes: Support BTF based data structure field access")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260822095110.0772E1F000E9@smtp.kernel.org/
Assisted-by: Antigravity:gemini-3.7-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
[ sashal: Applied the BTF kflag fix inline in parse_btf_field() because the helper get_bitoffset_of_field() doesn't exist here, passing &mtype and testing btf_type_kflag(mtype). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_btf.c   | 19 +++++++++++--------
 kernel/trace/trace_btf.h   |  3 ++-
 kernel/trace/trace_probe.c |  5 +++--
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace_btf.c b/kernel/trace/trace_btf.c
index 40e66eb59abbc..43e3798011776 100644
--- a/kernel/trace/trace_btf.c
+++ b/kernel/trace/trace_btf.c
@@ -61,16 +61,17 @@ struct btf_anon_stack {
 
 /*
  * Find a member of data structure/union by name and return it.
- * Return NULL if not found, or -EINVAL if parameter is invalid.
- * If the member is an member of anonymous union/structure, the offset
- * of that anonymous union/structure is stored into @anon_offset. Caller
- * can calculate the correct offset from the root data structure by
- * adding anon_offset to the member's offset.
+ * Return NULL if not found, or ERR_PTR(-EINVAL) if parameter is invalid.
+ * If the member is a member of an anonymous union/structure, the bit offset
+ * of that anonymous union/structure is stored into @anon_offset.
+ * If @member_type is non-NULL, the actual containing structure/union type
+ * of the found member is stored into @member_type.
  */
 const struct btf_member *btf_find_struct_member(struct btf *btf,
 						const struct btf_type *type,
 						const char *member_name,
-						u32 *anon_offset)
+						u32 *anon_offset,
+						const struct btf_type **member_type)
 {
 	struct btf_anon_stack *anon_stack;
 	const struct btf_member *member;
@@ -94,14 +95,16 @@ const struct btf_member *btf_find_struct_member(struct btf *btf,
 			if (mtype && btf_type_is_struct(mtype) &&
 			    top < BTF_ANON_STACK_MAX) {
 				anon_stack[top].tid = tid;
-				anon_stack[top++].offset =
-					cur_offset + member->offset;
+				anon_stack[top++].offset = cur_offset +
+					__btf_member_bit_offset(type, member);
 			}
 		} else {
 			name = btf_name_by_offset(btf, member->name_off);
 			if (name && !strcmp(member_name, name)) {
 				if (anon_offset)
 					*anon_offset = cur_offset;
+				if (member_type)
+					*member_type = type;
 				goto out;
 			}
 		}
diff --git a/kernel/trace/trace_btf.h b/kernel/trace/trace_btf.h
index 4bc44bc261e6f..4bd26bceae23a 100644
--- a/kernel/trace/trace_btf.h
+++ b/kernel/trace/trace_btf.h
@@ -8,4 +8,5 @@ const struct btf_param *btf_get_func_param(const struct btf_type *func_proto,
 const struct btf_member *btf_find_struct_member(struct btf *btf,
 						const struct btf_type *type,
 						const char *member_name,
-						u32 *anon_offset);
+						u32 *anon_offset,
+						const struct btf_type **member_type);
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index d6bde7a03b57a..4265518ce967c 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -533,6 +533,7 @@ static int parse_btf_field(char *fieldname, const struct btf_type *type,
 {
 	struct fetch_insn *code = *pcode;
 	const struct btf_member *field;
+	const struct btf_type *mtype;
 	u32 bitoffs, anon_offs;
 	char *next;
 	int is_ptr;
@@ -561,7 +562,7 @@ static int parse_btf_field(char *fieldname, const struct btf_type *type,
 
 			anon_offs = 0;
 			field = btf_find_struct_member(ctx->btf, type, fieldname,
-						       &anon_offs);
+						       &anon_offs, &mtype);
 			if (IS_ERR(field)) {
 				trace_probe_log_err(ctx->offset, BAD_BTF_TID);
 				return PTR_ERR(field);
@@ -574,7 +575,7 @@ static int parse_btf_field(char *fieldname, const struct btf_type *type,
 			bitoffs += anon_offs;
 
 			/* Accumulate the bit-offsets of the dot-connected fields */
-			if (btf_type_kflag(type)) {
+			if (btf_type_kflag(mtype)) {
 				bitoffs += BTF_MEMBER_BIT_OFFSET(field->offset);
 				ctx->last_bitsize = BTF_MEMBER_BITFIELD_SIZE(field->offset);
 			} else {
-- 
2.53.0



