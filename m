Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016685;
	b=O1dlUiBL7Ic1BBYV+6u0nvvbshG5GmpKenIcUk+1lDZNiMWxO04JA4iwL968DyHx2App
	 g5Z4924zeW1NGHKZrbywtTtr8cGyzV32YrhQBMs0DYl6RDZ7sB4yVrZ4p3Z+z8TEy42gw
	 vUeCjOxLeTegzF/PeHX88r3lU0HDuskK9mjouPjLauatbZAkkVXv8pR1+mun0xRLqf+X8
	 JoyHo80lOpUc/TEx9aHhE3bRB8woNjWfe/Z1gxS5KrAcakXtX3kCc/gI5GpFQXIMsZ5k0
	 lNNGrtBnf21t9ojp04illdx441etzDlH0NK1zKkkqdW4SnmbdcG7hYQQI4VzdrsRY9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=76sYmCuio3yX3N8noTzZ9NTS0gobDn+7VyGzCcTfGV8=;
	b=APMX0LpsIZZ+U+qJ1ojyGlL5tDS62IlvMo3z/B3Qgh2pZi/JXDxOQCREdD4NC93ZzOXU
	 v4NIOpm5hiM6m7o/W5MK40pyIq1tvR/89gKlhFqjI3aRe60GpFQjisf7DL3Dwo1AiT9/s
	 mI9l/N+PnqFhKOAx+/8e1kyctSYa+BX0Q18ThJ08jyubTKKHVPC66udIgz0Kwnh5+2m2B
	 PXB4GIHnsBrdl+QwcY6dbDkB7jVYps2F3CHtzQMTMS4HJj63S5kCMg7SP549xf5dqE0lU
	 6X6qcwh5Wd7NXy8zpG843farJfH8Q3ClerpO9v+OPjT1wClO6+FrFOtEoz6TupfHsaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ISgG1/Jx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF8A606A31C;
	Wed, 18 Nov 2026 15:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ISgG1/Jx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F26D1F000C4;
	Wed, 18 Nov 2026 15:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016684;
	bh=76sYmCuio3yX3N8noTzZ9NTS0gobDn+7VyGzCcTfGV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ISgG1/JxYLzoDjbDschJCtgBJD37f+dm8pjJapEq2FDOEnWi0bdnirhBWDtlIEAbK
	 RSMRae1ySLw9P0s453jfO8Um0O8b/3IQmLZHnKj/oesv1E0Ax1ibWtJmkJlEGU43lo
	 Dvk84JAS9J7iEpmnHXHSGqAmN/w2iFQrJZ3f1z34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0617/2651] bpftool: Compute map size of light skeletons at runtime
Date: Wed, 18 Nov 2026 15:30:57 +0100
Message-ID: <20261118150309.919756768@linuxfoundation.org>
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

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit a885470df10b1c0dbc011177c19d3fd3bb8af2e9 ]

bpftool rounds memory-mapped data map sizes to the host page size when
generating a light skeleton. The generated code therefore uses a 64K
mapping size when bpftool runs on a 64K-page host, even if the skeleton
runs on a 4K-page target. The target rejects the oversized map mmap(),
causing failure of loading the light skeleton.

When try to run 64K-page selftests on 4K-page VM, the error message does
not provide the reason about page size.

 test_atomics:PASS:atomics skeleton open 0 nsec
 test_atomics:FAIL:atomics skeleton load unexpected error: -12 (errno 22)
 #15      atomics:FAIL

Pass the original map value size and max entries to the generated code and
round mmap size to the runtime page size in the user-space light
skeleton helpers. This keeps generated light skeletons independent of the
build host page size.

Fixes: d510296d331a ("bpftool: Use syscall/loader program in "prog load" and "gen skeleton" command.")
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20260915161450.96249-1-leon.hwang@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/gen.c       | 26 ++++++-------------
 tools/lib/bpf/skel_internal.h | 48 +++++++++++++++++++++++++----------
 2 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index a50540ef6521c..ee680f7c21160 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -500,16 +500,6 @@ static void print_hex(const char *data, int data_sz)
 	}
 }
 
-static size_t bpf_map_mmap_sz(const struct bpf_map *map)
-{
-	long page_sz = sysconf(_SC_PAGE_SIZE);
-	size_t map_sz;
-
-	map_sz = (size_t)roundup(bpf_map__value_size(map), 8) * bpf_map__max_entries(map);
-	map_sz = roundup(map_sz, page_sz);
-	return map_sz;
-}
-
 /* Emit type size asserts for all top-level fields in memory-mapped internal maps. */
 static void codegen_asserts(struct bpf_object *obj, const char *obj_name)
 {
@@ -686,8 +676,8 @@ static void codegen_destroy(struct bpf_object *obj, const char *obj_name)
 		if (!get_map_ident(map, ident, sizeof(ident)))
 			continue;
 		if (is_skel_data(map, ident, sizeof(ident)))
-			printf("\tskel_free_map_data(skel->%1$s, skel->maps.%1$s.initial_value, %2$zu);\n",
-			       ident, bpf_map_mmap_sz(map));
+			printf("\tskel_free_map_data(skel->%1$s, skel->maps.%1$s.initial_value, %2$u, %3$u);\n",
+			       ident, bpf_map__value_size(map), bpf_map__max_entries(map));
 		codegen("\
 			\n\
 				skel_closenz(skel->maps.%1$s.map_fd);	    \n\
@@ -771,13 +761,13 @@ static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *h
 		\n\
 		\";							    \n\
 									    \n\
-				skel->%1$s = (__typeof__(skel->%1$s))skel_prep_map_data((void *)data, %2$zd,\n\
+				skel->%1$s = (__typeof__(skel->%1$s))skel_prep_map_data((void *)data, %2$u, %3$u,\n\
 								sizeof(data) - 1);\n\
 				if (!skel->%1$s)			    \n\
 					goto cleanup;			    \n\
 				skel->maps.%1$s.initial_value = (__u64) (long) skel->%1$s;\n\
 			}						    \n\
-			", ident, bpf_map_mmap_sz(map));
+			", ident, bpf_map__value_size(map), bpf_map__max_entries(map));
 	}
 	codegen("\
 		\n\
@@ -871,14 +861,14 @@ static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *h
 		if (bpf_map__type(map) == BPF_MAP_TYPE_PERCPU_ARRAY) {
 			codegen("\
 		\n\
-			err = skel_protect_map_data(skel->%1$s, &skel->maps.%1$s.initial_value, %2$zd);\n\
+			err = skel_protect_map_data(skel->%1$s, &skel->maps.%1$s.initial_value, %2$u, %3$u);\n\
 			if (err)					    \n\
 				return err;				    \n\
 		#ifdef __KERNEL__					    \n\
 			skel->%1$s = NULL;				    \n\
 		#endif							    \n\
 			",
-			ident, bpf_map_mmap_sz(map));
+			ident, bpf_map__value_size(map), bpf_map__max_entries(map));
 			continue;
 		}
 
@@ -890,11 +880,11 @@ static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *h
 		codegen("\
 		\n\
 			skel->%1$s = (__typeof__(skel->%1$s))skel_finalize_map_data(&skel->maps.%1$s.initial_value,\n\
-							%2$zd, %3$s, skel->maps.%1$s.map_fd);\n\
+							%2$u, %3$u, %4$s, skel->maps.%1$s.map_fd);\n\
 			if (!skel->%1$s)				    \n\
 				return -ENOMEM;				    \n\
 			",
-		       ident, bpf_map_mmap_sz(map), mmap_flags);
+		       ident, bpf_map__value_size(map), bpf_map__max_entries(map), mmap_flags);
 	}
 	codegen("\
 		\n\
diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
index 1f3f332dffbe9..9e16b8e8cb7c9 100644
--- a/tools/lib/bpf/skel_internal.h
+++ b/tools/lib/bpf/skel_internal.h
@@ -11,6 +11,7 @@
 #include <linux/bpf.h>
 #else
 #include <unistd.h>
+#include <sys/param.h>
 #include <sys/syscall.h>
 #include <sys/mman.h>
 #include <linux/keyctl.h>
@@ -127,7 +128,7 @@ static inline void skel_free(const void *p)
  * either bpf_probe_read_kernel() or bpf_copy_from_user() from initial_value
  * depending on bpf_loader_ctx->flags.
  */
-static inline void skel_free_map_data(void *p, __u64 addr, size_t sz)
+static inline void skel_free_map_data(void *p, __u64 addr, size_t val_sz, __u32 max_entries)
 {
 	if (addr != ~0ULL)
 		kvfree(p);
@@ -138,18 +139,20 @@ static inline void skel_free_map_data(void *p, __u64 addr, size_t sz)
 	 */
 }
 
-static inline void *skel_prep_map_data(const void *val, size_t mmap_sz, size_t val_sz)
+static inline void *skel_prep_map_data(const void *val, size_t val_sz, __u32 max_entries,
+				       size_t data_sz)
 {
 	void *addr;
 
-	addr = kvmalloc(val_sz, GFP_KERNEL);
+	addr = kvmalloc(data_sz, GFP_KERNEL);
 	if (!addr)
 		return NULL;
-	memcpy(addr, val, val_sz);
+	memcpy(addr, val, data_sz);
 	return addr;
 }
 
-static inline void *skel_finalize_map_data(__u64 *init_val, size_t mmap_sz, int flags, int fd)
+static inline void *skel_finalize_map_data(__u64 *init_val, size_t val_sz, __u32 max_entries,
+					   int flags, int fd)
 {
 	struct bpf_map *map;
 	void *addr = NULL;
@@ -172,9 +175,10 @@ static inline void *skel_finalize_map_data(__u64 *init_val, size_t mmap_sz, int
 	return addr;
 }
 
-static inline int skel_protect_map_data(void *p, __u64 *init_val, size_t sz)
+static inline int skel_protect_map_data(void *p, __u64 *init_val, size_t val_sz, __u32 max_entries)
 {
-	(void)sz;
+	(void)val_sz;
+	(void)max_entries;
 
 	kvfree(p);
 	*init_val = ~0ULL;
@@ -193,25 +197,39 @@ static inline void skel_free(void *p)
 	free(p);
 }
 
-static inline void skel_free_map_data(void *p, __u64 addr, size_t sz)
+static inline size_t skel_map_mmap_sz(size_t val_sz, __u32 max_entries)
 {
-	munmap(p, sz);
+	const long page_sz = sysconf(_SC_PAGE_SIZE);
+	size_t mmap_sz;
+
+	mmap_sz = roundup(val_sz, 8) * max_entries;
+	mmap_sz = roundup(mmap_sz, page_sz);
+	return mmap_sz;
 }
 
-static inline void *skel_prep_map_data(const void *val, size_t mmap_sz, size_t val_sz)
+static inline void skel_free_map_data(void *p, __u64 addr, size_t val_sz, __u32 max_entries)
 {
+	munmap(p, skel_map_mmap_sz(val_sz, max_entries));
+}
+
+static inline void *skel_prep_map_data(const void *val, size_t val_sz, __u32 max_entries,
+				       size_t data_sz)
+{
+	size_t mmap_sz = skel_map_mmap_sz(val_sz, max_entries);
 	void *addr;
 
 	addr = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE,
 		    MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	if (addr == (void *) -1)
 		return NULL;
-	memcpy(addr, val, val_sz);
+	memcpy(addr, val, data_sz);
 	return addr;
 }
 
-static inline void *skel_finalize_map_data(__u64 *init_val, size_t mmap_sz, int flags, int fd)
+static inline void *skel_finalize_map_data(__u64 *init_val, size_t val_sz, __u32 max_entries,
+					   int flags, int fd)
 {
+	size_t mmap_sz = skel_map_mmap_sz(val_sz, max_entries);
 	void *addr;
 
 	addr = mmap((void *) (long) *init_val, mmap_sz, flags, MAP_SHARED | MAP_FIXED, fd, 0);
@@ -220,11 +238,13 @@ static inline void *skel_finalize_map_data(__u64 *init_val, size_t mmap_sz, int
 	return addr;
 }
 
-static inline int skel_protect_map_data(void *p, __u64 *init_val, size_t sz)
+static inline int skel_protect_map_data(void *p, __u64 *init_val, size_t val_sz, __u32 max_entries)
 {
+	size_t mmap_sz = skel_map_mmap_sz(val_sz, max_entries);
+
 	(void)init_val;
 
-	if (mprotect(p, sz, PROT_READ))
+	if (mprotect(p, mmap_sz, PROT_READ))
 		return -errno;
 	return 0;
 }
-- 
2.53.0



