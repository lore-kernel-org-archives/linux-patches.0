Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029548;
	b=IlrCQHJJOwX0Zu7H7z83gle98o20dsp6QOzMrQ1BxxexpDqx7W2lCV/TE/Lrj1xlpRd+
	 lvh9xCUART5BrUoraEc9x2IduQQt5Ipy+ygoHPrsz9TP1Ta0wnORLm4zH5LDPPbjyaRT3
	 Ooa7zo8TEiAAoJfU6wsUKiqIpWrvdMNqE+GFGhJLtP/P+l/I+eQMaqADo8pG54SHsfdBh
	 a7057r92k0nlD+9A4HQKj+dZgQ8ugdbcD8pgfb5xiREHEJMlbgwQ3IB+okpH5qt/0iWHn
	 SnkM0YEzTjWIwciicMweHG6F4wwBGRsDbQnS+XIiMM+aD2YPZ+QeGX8dCzesaVYDzhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hUYbcim79Cf0Hvz/Nr26+MwKzDJY2ZIo70/LYDeqC+c=;
	b=Gq+a/4IGR7Xl93QE6TKspis7ufKtasSNhunb5PJkHJyQ9y7JNngvjq/8NKGdmQqLJtv6
	 ynb2WpUSNyDUgwLxXIjZirnWKdaR24K8iKwxy2xfA3oBUn8niyGblOEy4R6D3GMyEBN+I
	 Ve+aeSMZ1C1UnU/P+k9piFqNuObTf1ZR5eeQ8Kk3xA+TAj/RGKlqh9mz8YsLLDF5vv+n0
	 jL/1+yCVzeE2WWwom4AVOhAsUiYOPY6ggJapKlYfnKBMpZ51J6qJeF5T7HSnF8T4OXONr
	 1VRwcztBH3pf96dXPm2JZFoP+SbXCLZ4QqSGEyObbQDI7WRQb8Y/b9+tQ4USgDYYAaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kI3b3Ldx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1ED6606A320;
	Wed, 18 Nov 2026 19:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kI3b3Ldx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E9E1F000C4;
	Wed, 18 Nov 2026 19:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029547;
	bh=hUYbcim79Cf0Hvz/Nr26+MwKzDJY2ZIo70/LYDeqC+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kI3b3Ldx13kc7Va79yPWyx3FsETs2zUwJ5hzofdwiuxyxUA0a6cz93ATFfcf9HkML
	 SgyRiDRCXAgd+yLhGlzuLEdGVyZ8bbMgwgr62p2U6G1w9FLMv2f3FNbsLnhhmdbB+p
	 q7TCdEw90/w1hBfmQfR1gn065g64S54rFM2Rgmy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0390/1756] libbpf: Support opening bpf objects of either endianness
Date: Wed, 18 Nov 2026 15:41:57 +0100
Message-ID: <20261118150024.210508188@linuxfoundation.org>
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

[ Upstream commit bcc60abd67c7741a065480df4875534f62f758b1 ]

Allow bpf_object__open() to access files of either endianness, and convert
included BPF programs to native byte-order in-memory for introspection.
Loading BPF objects of non-native byte-order is still disallowed however.

Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/26353c1a1887a54400e1acd6c138fa90c99cdd40.1726475448.git.tony.ambardar@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: e18e82ba9ed5 ("libbpf: fix log level propagation for light skeleton loaders")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c          | 51 +++++++++++++++++++++++++++------
 tools/lib/bpf/libbpf_internal.h | 10 +++++++
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 084ae70c3a768..68de6bc7ad74a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -696,6 +696,8 @@ struct bpf_object {
 	/* Information when doing ELF related work. Only valid if efile.elf is not NULL */
 	struct elf_state efile;
 
+	unsigned char byteorder;
+
 	struct btf *btf;
 	struct btf_ext *btf_ext;
 
@@ -942,6 +944,20 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
 	return 0;
 }
 
+static void bpf_object_bswap_progs(struct bpf_object *obj)
+{
+	struct bpf_program *prog = obj->programs;
+	struct bpf_insn *insn;
+	int p, i;
+
+	for (p = 0; p < obj->nr_programs; p++, prog++) {
+		insn = prog->insns;
+		for (i = 0; i < prog->insns_cnt; i++, insn++)
+			bpf_insn_bswap(insn);
+	}
+	pr_debug("converted %zu BPF programs to native byte order\n", obj->nr_programs);
+}
+
 static const struct btf_member *
 find_member_by_offset(const struct btf_type *t, __u32 bit_offset)
 {
@@ -1507,6 +1523,7 @@ static void bpf_object__elf_finish(struct bpf_object *obj)
 
 	elf_end(obj->efile.elf);
 	obj->efile.elf = NULL;
+	obj->efile.ehdr = NULL;
 	obj->efile.symbols = NULL;
 	obj->efile.arena_data = NULL;
 
@@ -1572,6 +1589,16 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 		goto errout;
 	}
 
+	/* Validate ELF object endianness... */
+	if (ehdr->e_ident[EI_DATA] != ELFDATA2LSB &&
+	    ehdr->e_ident[EI_DATA] != ELFDATA2MSB) {
+		err = -LIBBPF_ERRNO__ENDIAN;
+		pr_warn("elf: '%s' has unknown byte order\n", obj->path);
+		goto errout;
+	}
+	/* and save after bpf_object_open() frees ELF data */
+	obj->byteorder = ehdr->e_ident[EI_DATA];
+
 	if (elf_getshdrstrndx(elf, &obj->efile.shstrndx)) {
 		pr_warn("elf: failed to get section names section index for %s: %s\n",
 			obj->path, elf_errmsg(-1));
@@ -1600,19 +1627,15 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 	return err;
 }
 
-static int bpf_object__check_endianness(struct bpf_object *obj)
+static bool is_native_endianness(struct bpf_object *obj)
 {
 #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
-	if (obj->efile.ehdr->e_ident[EI_DATA] == ELFDATA2LSB)
-		return 0;
+	return obj->byteorder == ELFDATA2LSB;
 #elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
-	if (obj->efile.ehdr->e_ident[EI_DATA] == ELFDATA2MSB)
-		return 0;
+	return obj->byteorder == ELFDATA2MSB;
 #else
 # error "Unrecognized __BYTE_ORDER__"
 #endif
-	pr_warn("elf: endianness mismatch in %s.\n", obj->path);
-	return -LIBBPF_ERRNO__ENDIAN;
 }
 
 static int
@@ -3954,6 +3977,10 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 		return -LIBBPF_ERRNO__FORMAT;
 	}
 
+	/* change BPF program insns to native endianness for introspection */
+	if (!is_native_endianness(obj))
+		bpf_object_bswap_progs(obj);
+
 	/* sort BPF programs by section name and in-section instruction offset
 	 * for faster search
 	 */
@@ -8054,7 +8081,6 @@ static struct bpf_object *bpf_object_open(const char *path, const void *obj_buf,
 	}
 
 	err = bpf_object__elf_init(obj);
-	err = err ? : bpf_object__check_endianness(obj);
 	err = err ? : bpf_object__elf_collect(obj);
 	err = err ? : bpf_object__collect_externs(obj);
 	err = err ? : bpf_object_fixup_btf(obj);
@@ -8560,8 +8586,15 @@ static int bpf_object_load(struct bpf_object *obj, int extra_log_level, const ch
 		return libbpf_err(-EINVAL);
 	}
 
-	if (obj->gen_loader)
+	/* Disallow kernel loading programs of non-native endianness but
+	 * permit cross-endian creation of "light skeleton".
+	 */
+	if (obj->gen_loader) {
 		bpf_gen__init(obj->gen_loader, extra_log_level, obj->nr_programs, obj->nr_maps);
+	} else if (!is_native_endianness(obj)) {
+		pr_warn("object '%s': loading non-native endianness is unsupported\n", obj->name);
+		return libbpf_err(-LIBBPF_ERRNO__ENDIAN);
+	}
 
 	err = bpf_object_prepare_token(obj);
 	err = err ? : bpf_object__probe_loading(obj);
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 71a2355bba9e7..227fd84ed4a8e 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -617,6 +617,16 @@ static inline bool is_ldimm64_insn(struct bpf_insn *insn)
 	return insn->code == (BPF_LD | BPF_IMM | BPF_DW);
 }
 
+static inline void bpf_insn_bswap(struct bpf_insn *insn)
+{
+	__u8 tmp_reg = insn->dst_reg;
+
+	insn->dst_reg = insn->src_reg;
+	insn->src_reg = tmp_reg;
+	insn->off = bswap_16(insn->off);
+	insn->imm = bswap_32(insn->imm);
+}
+
 /* Unconditionally dup FD, ensuring it doesn't use [0, 2] range.
  * Original FD is not closed or altered in any other way.
  * Preserves original FD value, if it's invalid (negative).
-- 
2.53.0



