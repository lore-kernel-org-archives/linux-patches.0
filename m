Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028841;
	b=CTvBxFv7Cm3Nux9OlFrhdG8V5RJFMgT3ICgxRL2ko/b0EacTHKHtnRAb2oj9YBDNpOpI
	 trHEj4H25U1b8OHtr69nwg6gGADRZiSu4ISCWL70zCq5fv5pCRwY6bdTrRq7TMXToe2Mv
	 5VfzErGAymr1dz2zVlBd6+AMDoWyadrHx5MbkaSfUM30DunAJEdUEtKyfoIuigCSjNFRg
	 t5NSx0PMa9UYrG+BIpkwbU8ouLHOJlH7zsGjNiqD6EtAm6/YbuxhWHChpWtqrzr+KWHcs
	 fTZqYupqtHkS1qZxHr960Aai7LtQ7+m0ZjbXKuNVSybfSg6nX5N2CKCG7hy/EvyARWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/IaDr9L5+Hc/5nCsdjPFjnXSZ8ggEDf4LAec9wPdTC0=;
	b=hH6EXscmeSPw5ckbBQ+q1uTa7Sx9AV/5abTFktVDt1EEi+pRyUCkBBdEKOmNbNUKZK7g
	 EgABN3efwQvbMMOL3xBtFVk3ze5j1DbxYVfntOk1duq/fTzoALcttwMqIJq5utH5DEmgB
	 QXIbvz8Mdbcs+ALCCtSUWyLQWapZ1vWseHY0UdVbbeplcxGTF49MxjFGVdAEyafaDsAnR
	 HYUnMPGlyQSHSg2fkyh8SJ8ANv1H5Yj8AwmKs6dhb6FUxspYFAgaqjrsUwF9bxvGeZE2d
	 VtW28JGhYmDeLr9BMfKeWzukBpu9f6mQn7MeSn6rlJvz0f/j1FgEG5RY02bdoQVcE0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFOULp32;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA8160A262C;
	Wed, 18 Nov 2026 19:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFOULp32
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00BA1F000C9;
	Wed, 18 Nov 2026 19:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028841;
	bh=/IaDr9L5+Hc/5nCsdjPFjnXSZ8ggEDf4LAec9wPdTC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFOULp32FB0czXiJ+OXVpuK5S72s+sajZI6EVGOn9CVNuIudhRtzVPMsTlWqRR9FQ
	 TLm2XL3t3qsIl4gptxYVNPtTZxCKbRJqEo15Dp2c+Un9NQu/bp5RFYg2rJHV3zv+1S
	 FxtJWA7mSKCCJezvSIvCSqthhp6aJUWe1Np4l+Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0138/1756] libbpf: Improve log message formatting
Date: Wed, 18 Nov 2026 15:37:45 +0100
Message-ID: <20261118150013.663667946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit e8957c0dde3c945db2403beb3131a5ad84860b5f ]

Fix missing newlines and extraneous terminal spaces in messages.

Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/086884b7cbf87e524d584f9bf87f7a580e378b2b.1726475448.git.tony.ambardar@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: e40f61a31688 ("libbpf: Avoid overflow in BTF.ext bounds check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c          | 6 +++---
 tools/lib/bpf/btf_dump.c     | 2 +-
 tools/lib/bpf/btf_relocate.c | 2 +-
 tools/lib/bpf/libbpf.c       | 4 ++--
 tools/lib/bpf/relo_core.c    | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 56935f86a6963..65c31915034cd 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -2942,7 +2942,7 @@ static int btf_ext_setup_info(struct btf_ext *btf_ext,
 
 	/* If no records, return failure now so .BTF.ext won't be used. */
 	if (!info_left) {
-		pr_debug("%s section in .BTF.ext has no records", ext_sec->desc);
+		pr_debug("%s section in .BTF.ext has no records\n", ext_sec->desc);
 		return -EINVAL;
 	}
 
@@ -3030,7 +3030,7 @@ static int btf_ext_parse_hdr(__u8 *data, __u32 data_size)
 
 	if (data_size < offsetofend(struct btf_ext_header, hdr_len) ||
 	    data_size < hdr->hdr_len) {
-		pr_debug("BTF.ext header not found");
+		pr_debug("BTF.ext header not found\n");
 		return -EINVAL;
 	}
 
@@ -3292,7 +3292,7 @@ int btf__dedup(struct btf *btf, const struct btf_dedup_opts *opts)
 
 	d = btf_dedup_new(btf, opts);
 	if (IS_ERR(d)) {
-		pr_debug("btf_dedup_new failed: %ld", PTR_ERR(d));
+		pr_debug("btf_dedup_new failed: %ld\n", PTR_ERR(d));
 		return libbpf_err(-EINVAL);
 	}
 
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index a833d91886f87..0040b7b75d1f4 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1307,7 +1307,7 @@ static void btf_dump_emit_type_decl(struct btf_dump *d, __u32 id,
 			 * chain, restore stack, emit warning, and try to
 			 * proceed nevertheless
 			 */
-			pr_warn("not enough memory for decl stack:%d", err);
+			pr_warn("not enough memory for decl stack: %d\n", err);
 			d->decl_stack_cnt = stack_start;
 			return;
 		}
diff --git a/tools/lib/bpf/btf_relocate.c b/tools/lib/bpf/btf_relocate.c
index 8ef8003480dac..53d1f3541bce6 100644
--- a/tools/lib/bpf/btf_relocate.c
+++ b/tools/lib/bpf/btf_relocate.c
@@ -428,7 +428,7 @@ static int btf_relocate_rewrite_strs(struct btf_relocate *r, __u32 i)
 		} else {
 			off = r->str_map[*str_off];
 			if (!off) {
-				pr_warn("string '%s' [offset %u] is not mapped to base BTF",
+				pr_warn("string '%s' [offset %u] is not mapped to base BTF\n",
 					btf__str_by_offset(r->btf, off), *str_off);
 				return -ENOENT;
 			}
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 59ba53f1e77cd..084ae70c3a768 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -12819,7 +12819,7 @@ struct bpf_link *bpf_program__attach_freplace(const struct bpf_program *prog,
 	}
 
 	if (prog->type != BPF_PROG_TYPE_EXT) {
-		pr_warn("prog '%s': only BPF_PROG_TYPE_EXT can attach as freplace",
+		pr_warn("prog '%s': only BPF_PROG_TYPE_EXT can attach as freplace\n",
 			prog->name);
 		return libbpf_err_ptr(-EINVAL);
 	}
@@ -13892,7 +13892,7 @@ int bpf_object__open_subskeleton(struct bpf_object_subskeleton *s)
 		map_type = btf__type_by_id(btf, map_type_id);
 
 		if (!btf_is_datasec(map_type)) {
-			pr_warn("type for map '%1$s' is not a datasec: %2$s",
+			pr_warn("type for map '%1$s' is not a datasec: %2$s\n",
 				bpf_map__name(map),
 				__btf_kind_str(btf_kind(map_type)));
 			return libbpf_err(-EINVAL);
diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
index 4367378d272b3..90135cf307e91 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -1345,7 +1345,7 @@ int bpf_core_calc_relo_insn(const char *prog_name,
 					  cands->cands[i].id, cand_spec);
 		if (err < 0) {
 			bpf_core_format_spec(spec_buf, sizeof(spec_buf), cand_spec);
-			pr_warn("prog '%s': relo #%d: error matching candidate #%d %s: %d\n ",
+			pr_warn("prog '%s': relo #%d: error matching candidate #%d %s: %d\n",
 				prog_name, relo_idx, i, spec_buf, err);
 			return err;
 		}
-- 
2.53.0



