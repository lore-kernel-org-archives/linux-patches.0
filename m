Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040087;
	b=DizYtd853Jhf6jGzLlJhbYXJvu6S7JM6pf+BPqDfEPeJrdtEYBBkujUjIBjGfY511wZL
	 +OJn39IeT2eAW5YsHNtHyu/IfA9iuDvJDvMZQBEnb6VACMXW5/c4wwaz6E2hnfCMlahqr
	 NBV9cAkJAN9BjFEqazNOf+183xscNmg2nVHtWW2L9i/KqBuupRcV6b0EUhFs0iIq5Y5gE
	 H5W1Ig/KdjN/KLg9jPbCBtYPiCvyPd1oBwzOM5wuJI80Qothd5kHCXzIOM97IbyfLBLUC
	 TtnelURv4u13LWC4zwAe/TDTCP6k6FcyAPxC/tlD/gByHwf+rzU5B+rkHPU8CePca1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9wXLedoDCrq6CSafJpXGvFHOV2ZhxK6ckloVzltujtQ=;
	b=wzJhl8oZ81d+yAXCxFiWMsSkdg240neS8+iP0s6mgq8jLS58Moe+V0+1S59D89GrttyD
	 RJWO2ShmcdD9nw0nnEfVqUEsYchw5+AghR6b6CtLu68/bgNWIs64EXsUWG8r15WIp22b5
	 gT19cyh5yb97OvQmoRIgbtJalTgVo3mFGJSmyS5CVsQNY4YM129Odpe1E5HWrHQSXcaCk
	 DnlMvxtHsbp9PKohtKdQ7zMlEGdsluGlKUaRCpZD24uv0OcbTE4R1aIcsIBtBURe/34dc
	 SZl2cHvENQGrG7vGwsX8J2Zj2hRFMubs8+KwHaeCDouBD0ekad0bG2F2zal4SaF221w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ki60TMa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCB8606A31C;
	Wed, 18 Nov 2026 22:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ki60TMa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1802F1F000C4;
	Wed, 18 Nov 2026 22:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040087;
	bh=9wXLedoDCrq6CSafJpXGvFHOV2ZhxK6ckloVzltujtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ki60TMaAn1SUc+OANmUWiO4CNE6EemOEOF3FKTedl7eWB5VMHbT32x4GAeapd/1X
	 zq5BfLKe57kGxHBeIZ8PTAiaqckHLS5gQKdjoUJzkMfWPau+B1lrdv51H0BRoBdv8m
	 sMGOWpV6aOnsQlOVRyDcryPse7vl5XBm6H6dCTs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <quentin@isovalent.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2333/3318] bpftool: Add support to display uprobe_multi links
Date: Wed, 18 Nov 2026 15:49:15 +0100
Message-ID: <20261118150431.639921252@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit a7795698f8b6c48283fa4334eb313bc1350b2864 ]

Adding support to display details for uprobe_multi links,
both plain:

  # bpftool link -p
  ...
  24: uprobe_multi  prog 126
          uprobe.multi  path /home/jolsa/bpf/test_progs  func_cnt 3  pid 4143
          offset             ref_ctr_offset     cookies
          0xd1f88            0xf5d5a8           0xdead
          0xd1f8f            0xf5d5aa           0xbeef
          0xd1f96            0xf5d5ac           0xcafe

and json:

  # bpftool link -p
  [{
  ...
      },{
          "id": 24,
          "type": "uprobe_multi",
          "prog_id": 126,
          "retprobe": false,
          "path": "/home/jolsa/bpf/test_progs",
          "func_cnt": 3,
          "pid": 4143,
          "funcs": [{
                  "offset": 860040,
                  "ref_ctr_offset": 16111016,
                  "cookie": 57005
              },{
                  "offset": 860047,
                  "ref_ctr_offset": 16111018,
                  "cookie": 48879
              },{
                  "offset": 860054,
                  "ref_ctr_offset": 16111020,
                  "cookie": 51966
              }
          ]
      }
  ]

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/bpf/20231125193130.834322-7-jolsa@kernel.org
Stable-dep-of: dbf8cef936c7 ("bpftool: Fix CPU IDs in per-CPU map output")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/link.c | 105 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 103 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 2e5c231e08ac7..00ecc67b54712 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -293,6 +293,37 @@ show_kprobe_multi_json(struct bpf_link_info *info, json_writer_t *wtr)
 	jsonw_end_array(json_wtr);
 }
 
+static __u64 *u64_to_arr(__u64 val)
+{
+	return (__u64 *) u64_to_ptr(val);
+}
+
+static void
+show_uprobe_multi_json(struct bpf_link_info *info, json_writer_t *wtr)
+{
+	__u32 i;
+
+	jsonw_bool_field(json_wtr, "retprobe",
+			 info->uprobe_multi.flags & BPF_F_UPROBE_MULTI_RETURN);
+	jsonw_string_field(json_wtr, "path", (char *) u64_to_ptr(info->uprobe_multi.path));
+	jsonw_uint_field(json_wtr, "func_cnt", info->uprobe_multi.count);
+	jsonw_int_field(json_wtr, "pid", (int) info->uprobe_multi.pid);
+	jsonw_name(json_wtr, "funcs");
+	jsonw_start_array(json_wtr);
+
+	for (i = 0; i < info->uprobe_multi.count; i++) {
+		jsonw_start_object(json_wtr);
+		jsonw_uint_field(json_wtr, "offset",
+				 u64_to_arr(info->uprobe_multi.offsets)[i]);
+		jsonw_uint_field(json_wtr, "ref_ctr_offset",
+				 u64_to_arr(info->uprobe_multi.ref_ctr_offsets)[i]);
+		jsonw_uint_field(json_wtr, "cookie",
+				 u64_to_arr(info->uprobe_multi.cookies)[i]);
+		jsonw_end_object(json_wtr);
+	}
+	jsonw_end_array(json_wtr);
+}
+
 static void
 show_perf_event_kprobe_json(struct bpf_link_info *info, json_writer_t *wtr)
 {
@@ -459,6 +490,9 @@ static int show_link_close_json(int fd, struct bpf_link_info *info)
 	case BPF_LINK_TYPE_KPROBE_MULTI:
 		show_kprobe_multi_json(info, json_wtr);
 		break;
+	case BPF_LINK_TYPE_UPROBE_MULTI:
+		show_uprobe_multi_json(info, json_wtr);
+		break;
 	case BPF_LINK_TYPE_PERF_EVENT:
 		switch (info->perf_event.type) {
 		case BPF_PERF_EVENT_EVENT:
@@ -666,6 +700,33 @@ static void show_kprobe_multi_plain(struct bpf_link_info *info)
 	}
 }
 
+static void show_uprobe_multi_plain(struct bpf_link_info *info)
+{
+	__u32 i;
+
+	if (!info->uprobe_multi.count)
+		return;
+
+	if (info->uprobe_multi.flags & BPF_F_UPROBE_MULTI_RETURN)
+		printf("\n\turetprobe.multi  ");
+	else
+		printf("\n\tuprobe.multi  ");
+
+	printf("path %s  ", (char *) u64_to_ptr(info->uprobe_multi.path));
+	printf("func_cnt %u  ", info->uprobe_multi.count);
+
+	if (info->uprobe_multi.pid)
+		printf("pid %d  ", info->uprobe_multi.pid);
+
+	printf("\n\t%-16s   %-16s   %-16s", "offset", "ref_ctr_offset", "cookies");
+	for (i = 0; i < info->uprobe_multi.count; i++) {
+		printf("\n\t0x%-16llx 0x%-16llx 0x%-16llx",
+			u64_to_arr(info->uprobe_multi.offsets)[i],
+			u64_to_arr(info->uprobe_multi.ref_ctr_offsets)[i],
+			u64_to_arr(info->uprobe_multi.cookies)[i]);
+	}
+}
+
 static void show_perf_event_kprobe_plain(struct bpf_link_info *info)
 {
 	const char *buf;
@@ -792,6 +853,9 @@ static int show_link_close_plain(int fd, struct bpf_link_info *info)
 	case BPF_LINK_TYPE_KPROBE_MULTI:
 		show_kprobe_multi_plain(info);
 		break;
+	case BPF_LINK_TYPE_UPROBE_MULTI:
+		show_uprobe_multi_plain(info);
+		break;
 	case BPF_LINK_TYPE_PERF_EVENT:
 		switch (info->perf_event.type) {
 		case BPF_PERF_EVENT_EVENT:
@@ -831,8 +895,10 @@ static int show_link_close_plain(int fd, struct bpf_link_info *info)
 
 static int do_show_link(int fd)
 {
+	__u64 *ref_ctr_offsets = NULL, *offsets = NULL, *cookies = NULL;
 	struct bpf_link_info info;
 	__u32 len = sizeof(info);
+	char path_buf[PATH_MAX];
 	__u64 *addrs = NULL;
 	char buf[PATH_MAX];
 	int count;
@@ -874,6 +940,39 @@ static int do_show_link(int fd)
 			goto again;
 		}
 	}
+	if (info.type == BPF_LINK_TYPE_UPROBE_MULTI &&
+	    !info.uprobe_multi.offsets) {
+		count = info.uprobe_multi.count;
+		if (count) {
+			offsets = calloc(count, sizeof(__u64));
+			if (!offsets) {
+				p_err("mem alloc failed");
+				close(fd);
+				return -ENOMEM;
+			}
+			info.uprobe_multi.offsets = ptr_to_u64(offsets);
+			ref_ctr_offsets = calloc(count, sizeof(__u64));
+			if (!ref_ctr_offsets) {
+				p_err("mem alloc failed");
+				free(offsets);
+				close(fd);
+				return -ENOMEM;
+			}
+			info.uprobe_multi.ref_ctr_offsets = ptr_to_u64(ref_ctr_offsets);
+			cookies = calloc(count, sizeof(__u64));
+			if (!cookies) {
+				p_err("mem alloc failed");
+				free(cookies);
+				free(offsets);
+				close(fd);
+				return -ENOMEM;
+			}
+			info.uprobe_multi.cookies = ptr_to_u64(cookies);
+			info.uprobe_multi.path = ptr_to_u64(path_buf);
+			info.uprobe_multi.path_size = sizeof(path_buf);
+			goto again;
+		}
+	}
 	if (info.type == BPF_LINK_TYPE_PERF_EVENT) {
 		switch (info.perf_event.type) {
 		case BPF_PERF_EVENT_TRACEPOINT:
@@ -909,8 +1008,10 @@ static int do_show_link(int fd)
 	else
 		show_link_close_plain(fd, &info);
 
-	if (addrs)
-		free(addrs);
+	free(ref_ctr_offsets);
+	free(cookies);
+	free(offsets);
+	free(addrs);
 	close(fd);
 	return 0;
 }
-- 
2.53.0



