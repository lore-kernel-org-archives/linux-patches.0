Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024297;
	b=qEyHzOZHCk4wcl6yAX42hJS8sxysrJfsFriUXj7M+YlV1edwTOc0DH0GSDs9WlNNcNIN
	 pav6Rg40bkFtJ7gcdicPs9QOpAEWZhBsGAOmRKagIv9PATVf6AG4VGSzD4hwzfsaWZV82
	 7rQZcGLN2DHhdpXE4CuxgZajL33myLMPwzv78f0dVGHwumnDJmIwc3zEhDSlk/RvSRkUs
	 Q/tnnc9pO0GF/7X0I7UPYNMdPCNrvkWLtQiuJTSMwjDbT7NJhIII/uk1kk9BGaXmf32Dz
	 H0Qq49myL7uxRpFHCg61PA2kXGctJRjyGeG9fLN8fhLygljgWYFuyZKxePEBm2BggTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OIgfFK8e9Lh9PHcz8XYkYz8ElzCHwCeNjrCUXO8bqdE=;
	b=XSfTGlix9jeaIM6ScJcjzM9hj6ueKV1+sGxILZG5MwoWJm55wOVeLW/jvrweMKt/aXA9
	 ykedOVWnEPvXUwtyKmKZu+VO7FSUcnXIdBsymzUDd/yqpvnIK6D5uxTnum16di8yaHteP
	 FT6yhQE3QgtiB2vh301r//Og/wymgUnLn1yatmvlRMzNRapArfFoJJ08+GEkV7FksiuMd
	 gKiiGkqgKYfGEcPH9H/FmVwnuBuyb8AJivKvRbhCEAOO4ereCXPLbYm119gNeh8MqicZg
	 om8upHzfseQGnbqHBxHMzUHy/v5yhh2kYYhE9BR2Bh2Lx6M1Q/EbNTxGlzzCHChzOrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zO6RrZix;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24287606A32A;
	Wed, 18 Nov 2026 17:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zO6RrZix
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7572B1F000C4;
	Wed, 18 Nov 2026 17:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024297;
	bh=OIgfFK8e9Lh9PHcz8XYkYz8ElzCHwCeNjrCUXO8bqdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zO6RrZixT2O63SlOW1p57L/l+TdbnO+UlfKYtjPt3AjkQIxjfsiytrlQPKoeDqyD0
	 g1dRZoZYr+pyJPq5Iq0Mq9eFgZIS1F4rqam1UXqWRn2wK4kR+JvYduL6LWRzxpi57e
	 THQFJp2m4oW/4YPMDgiJLA1QRANYzVih2SCgeloA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0675/2151] bpftool: Fix CPU IDs in per-CPU map output
Date: Wed, 18 Nov 2026 15:40:10 +0100
Message-ID: <20261118150146.403540807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit dbf8cef936c7783ca909c38097a69f73173a19a7 ]

bpftool uses dense per-CPU value-buffer slots when printing per-CPU map
values. It also uses the slot index as the CPU ID, which produces
incorrect labels when the possible CPU mask is sparse, such as 0,2-3.

Parse the possible CPU mask and use the corresponding logical CPU ID in
plain, JSON, and BTF-formatted output. Keep the dense slot index for
accessing the per-CPU value buffer.

Pass the parsed CPU count together with the CPU ID array so that the
printed CPU IDs and loop bounds come from the same possible-CPU mask.
Propagate CPU-ID lookup and map output errors through the shared output
path to its callers.

Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
Signed-off-by: Hui Su <sh_def@163.com>
Link: https://lore.kernel.org/bpf/20260813155131.1022745-3-sh_def@163.com/
Link: https://lore.kernel.org/bpf/20260923004243.969919-2-sh_def@163.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c | 40 ++++++++++++++++
 tools/bpf/bpftool/main.h   |  1 +
 tools/bpf/bpftool/map.c    | 95 +++++++++++++++++++++++++-------------
 3 files changed, 103 insertions(+), 33 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index e8daf963ecef4..8f68d36830e5a 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -31,6 +31,7 @@
 #include <bpf/bpf.h>
 #include <bpf/hashmap.h>
 #include <bpf/libbpf.h> /* libbpf_num_possible_cpus */
+#include <bpf/libbpf_internal.h>
 #include <bpf/btf.h>
 #include <zlib.h>
 
@@ -655,6 +656,45 @@ unsigned int get_possible_cpus(void)
 	return cpus;
 }
 
+int get_possible_cpu_ids(int **cpu_ids)
+{
+	const char *possible_cpus_file = "/sys/devices/system/cpu/possible";
+	bool *mask = NULL;
+	int mask_sz, nr_cpus = 0;
+	int *ids = NULL;
+	int i, res;
+
+	*cpu_ids = NULL;
+
+	res = parse_cpu_mask_file(possible_cpus_file, &mask, &mask_sz);
+	if (res) {
+		p_err("failed to parse possible CPU mask: %s", strerror(-res));
+		return res;
+	}
+
+	for (i = 0; i < mask_sz; i++)
+		nr_cpus += mask[i];
+
+	ids = calloc(nr_cpus, sizeof(*ids));
+	if (!ids) {
+		p_err("mem alloc failed");
+		res = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0, nr_cpus = 0; i < mask_sz; i++) {
+		if (mask[i])
+			ids[nr_cpus++] = i;
+	}
+	*cpu_ids = ids;
+	ids = NULL;
+	res = nr_cpus;
+out:
+	free(ids);
+	free(mask);
+	return res;
+}
+
 static char *
 ifindex_to_name_ns(__u32 ifindex, __u32 ns_dev, __u32 ns_ino, char *buf)
 {
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 1130299cede0b..c320f24592a11 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -216,6 +216,7 @@ void print_hex_data_json(uint8_t *data, size_t len);
 
 unsigned int get_page_size(void);
 unsigned int get_possible_cpus(void);
+int get_possible_cpu_ids(int **cpu_ids);
 const char *
 ifindex_to_arch(__u32 ifindex, __u64 ns_dev, __u64 ns_ino, const char **opt);
 
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 941d73b737de3..7cedd96729688 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -70,7 +70,7 @@ static void *alloc_value(struct bpf_map_info *info)
 
 static int do_dump_btf(const struct btf_dumper *d,
 		       struct bpf_map_info *map_info, void *key,
-		       void *value)
+		       void *value, const int *cpu_ids, int cpu_cnt)
 {
 	__u32 value_id;
 	int ret = 0;
@@ -93,15 +93,15 @@ static int do_dump_btf(const struct btf_dumper *d,
 		jsonw_name(d->jw, "value");
 		ret = btf_dumper_type(d, value_id, value);
 	} else {
-		unsigned int i, n, step;
+		unsigned int step;
+		int i;
 
 		jsonw_name(d->jw, "values");
 		jsonw_start_array(d->jw);
-		n = get_possible_cpus();
 		step = round_up(map_info->value_size, 8);
-		for (i = 0; i < n; i++) {
+		for (i = 0; i < cpu_cnt; i++) {
 			jsonw_start_object(d->jw);
-			jsonw_int_field(d->jw, "cpu", i);
+			jsonw_int_field(d->jw, "cpu", cpu_ids[i]);
 			jsonw_name(d->jw, "value");
 			ret = btf_dumper_type(d, value_id, value + i * step);
 			jsonw_end_object(d->jw);
@@ -130,7 +130,8 @@ static json_writer_t *get_btf_writer(void)
 }
 
 static void print_entry_json(struct bpf_map_info *info, unsigned char *key,
-			     unsigned char *value, struct btf *btf)
+			     unsigned char *value, struct btf *btf,
+			     const int *cpu_ids, int cpu_cnt)
 {
 	jsonw_start_object(json_wtr);
 
@@ -150,12 +151,12 @@ static void print_entry_json(struct bpf_map_info *info, unsigned char *key,
 			};
 
 			jsonw_name(json_wtr, "formatted");
-			do_dump_btf(&d, info, key, value);
+			do_dump_btf(&d, info, key, value, cpu_ids, cpu_cnt);
 		}
 	} else {
-		unsigned int i, n, step;
+		unsigned int step;
+		int i;
 
-		n = get_possible_cpus();
 		step = round_up(info->value_size, 8);
 
 		jsonw_name(json_wtr, "key");
@@ -163,10 +164,10 @@ static void print_entry_json(struct bpf_map_info *info, unsigned char *key,
 
 		jsonw_name(json_wtr, "values");
 		jsonw_start_array(json_wtr);
-		for (i = 0; i < n; i++) {
+		for (i = 0; i < cpu_cnt; i++) {
 			jsonw_start_object(json_wtr);
 
-			jsonw_int_field(json_wtr, "cpu", i);
+			jsonw_int_field(json_wtr, "cpu", cpu_ids[i]);
 
 			jsonw_name(json_wtr, "value");
 			print_hex_data_json(value + i * step,
@@ -183,7 +184,7 @@ static void print_entry_json(struct bpf_map_info *info, unsigned char *key,
 			};
 
 			jsonw_name(json_wtr, "formatted");
-			do_dump_btf(&d, info, key, value);
+			do_dump_btf(&d, info, key, value, cpu_ids, cpu_cnt);
 		}
 	}
 
@@ -245,7 +246,7 @@ print_entry_error(struct bpf_map_info *map_info, void *key, int lookup_errno)
 }
 
 static void print_entry_plain(struct bpf_map_info *info, unsigned char *key,
-			      unsigned char *value)
+			      unsigned char *value, const int *cpu_ids, int cpu_cnt)
 {
 	if (!map_is_per_cpu(info->type)) {
 		bool single_line, break_names;
@@ -273,9 +274,9 @@ static void print_entry_plain(struct bpf_map_info *info, unsigned char *key,
 
 		printf("\n");
 	} else {
-		unsigned int i, n, step;
+		unsigned int step;
+		int i;
 
-		n = get_possible_cpus();
 		step = round_up(info->value_size, 8);
 
 		if (info->key_size) {
@@ -284,9 +285,9 @@ static void print_entry_plain(struct bpf_map_info *info, unsigned char *key,
 			printf("\n");
 		}
 		if (info->value_size) {
-			for (i = 0; i < n; i++) {
-				printf("value (CPU %02u):%c",
-				       i, info->value_size > 16 ? '\n' : ' ');
+			for (i = 0; i < cpu_cnt; i++) {
+				printf("value (CPU %02d):%c",
+				       cpu_ids[i], info->value_size > 16 ? '\n' : ' ');
 				fprint_hex(stdout, value + i * step,
 					   info->value_size, " ");
 				printf("\n");
@@ -742,7 +743,7 @@ static int do_show(int argc, char **argv)
 
 static int dump_map_elem(int fd, void *key, void *value,
 			 struct bpf_map_info *map_info, struct btf *btf,
-			 json_writer_t *btf_wtr)
+			 json_writer_t *btf_wtr, const int *cpu_ids, int cpu_cnt)
 {
 	if (bpf_map_lookup_elem(fd, key, value)) {
 		print_entry_error(map_info, key, errno);
@@ -750,7 +751,7 @@ static int dump_map_elem(int fd, void *key, void *value,
 	}
 
 	if (json_output) {
-		print_entry_json(map_info, key, value, btf);
+		print_entry_json(map_info, key, value, btf, cpu_ids, cpu_cnt);
 	} else if (btf) {
 		struct btf_dumper d = {
 			.btf = btf,
@@ -758,9 +759,9 @@ static int dump_map_elem(int fd, void *key, void *value,
 			.is_plain_text = true,
 		};
 
-		do_dump_btf(&d, map_info, key, value);
+		do_dump_btf(&d, map_info, key, value, cpu_ids, cpu_cnt);
 	} else {
-		print_entry_plain(map_info, key, value);
+		print_entry_plain(map_info, key, value, cpu_ids, cpu_cnt);
 	}
 
 	return 0;
@@ -833,6 +834,8 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 	void *key, *value, *prev_key;
 	unsigned int num_elems = 0;
 	struct btf *btf = NULL;
+	int *cpu_ids = NULL;
+	int cpu_cnt = 0;
 	int err;
 
 	key = malloc(info->key_size);
@@ -845,6 +848,14 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 
 	prev_key = NULL;
 
+	if (map_is_per_cpu(info->type)) {
+		cpu_cnt = get_possible_cpu_ids(&cpu_ids);
+		if (cpu_cnt < 0) {
+			err = cpu_cnt;
+			goto exit_free;
+		}
+	}
+
 	if (wtr) {
 		err = get_map_kv_btf(info, &btf);
 		if (err) {
@@ -876,7 +887,8 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 				err = 0;
 			break;
 		}
-		if (!dump_map_elem(fd, key, value, info, btf, wtr))
+		if (!dump_map_elem(fd, key, value, info, btf, wtr,
+				   cpu_ids, cpu_cnt))
 			num_elems++;
 		prev_key = key;
 	}
@@ -893,6 +905,7 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 exit_free:
 	free(key);
 	free(value);
+	free(cpu_ids);
 	free_map_kv_btf(btf);
 
 	return err;
@@ -1035,17 +1048,30 @@ static int do_update(int argc, char **argv)
 	return err;
 }
 
-static void print_key_value(struct bpf_map_info *info, void *key,
-			    void *value)
+static int print_key_value(struct bpf_map_info *info, void *key,
+			   void *value)
 {
 	json_writer_t *btf_wtr;
 	struct btf *btf;
+	int *cpu_ids = NULL;
+	int cpu_cnt = 0;
+	int err = 0;
 
-	if (get_map_kv_btf(info, &btf))
-		return;
+	if (map_is_per_cpu(info->type)) {
+		cpu_cnt = get_possible_cpu_ids(&cpu_ids);
+
+		if (cpu_cnt < 0) {
+			err = cpu_cnt;
+			goto out;
+		}
+	}
+
+	err = get_map_kv_btf(info, &btf);
+	if (err)
+		goto out;
 
 	if (json_output) {
-		print_entry_json(info, key, value, btf);
+		print_entry_json(info, key, value, btf, cpu_ids, cpu_cnt);
 	} else if (btf) {
 		/* if here json_wtr wouldn't have been initialised,
 		 * so let's create separate writer for btf
@@ -1055,7 +1081,7 @@ static void print_key_value(struct bpf_map_info *info, void *key,
 			p_info("failed to create json writer for btf. falling back to plain output");
 			free_map_kv_btf(btf);
 			btf = NULL;
-			print_entry_plain(info, key, value);
+			print_entry_plain(info, key, value, cpu_ids, cpu_cnt);
 		} else {
 			struct btf_dumper d = {
 				.btf = btf,
@@ -1063,13 +1089,16 @@ static void print_key_value(struct bpf_map_info *info, void *key,
 				.is_plain_text = true,
 			};
 
-			do_dump_btf(&d, info, key, value);
+			do_dump_btf(&d, info, key, value, cpu_ids, cpu_cnt);
 			jsonw_destroy(&btf_wtr);
 		}
 	} else {
-		print_entry_plain(info, key, value);
+		print_entry_plain(info, key, value, cpu_ids, cpu_cnt);
 	}
 	free_map_kv_btf(btf);
+out:
+	free(cpu_ids);
+	return err;
 }
 
 static int do_lookup(int argc, char **argv)
@@ -1114,7 +1143,7 @@ static int do_lookup(int argc, char **argv)
 	}
 
 	/* here means bpf_map_lookup_elem() succeeded */
-	print_key_value(&info, key, value);
+	err = print_key_value(&info, key, value);
 
 exit_free:
 	free(key);
@@ -1404,7 +1433,7 @@ static int do_pop_dequeue(int argc, char **argv)
 		goto exit_free;
 	}
 
-	print_key_value(&info, key, value);
+	err = print_key_value(&info, key, value);
 
 exit_free:
 	free(key);
-- 
2.53.0



