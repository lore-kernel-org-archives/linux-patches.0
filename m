Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEF5D528;
	Sun,  7 Sep 2025 20:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276778; cv=none; b=SU2UXDi+mBKE6+TF1YwD+CeQ1WxEKrHQaGWgtTfsFy+iBAhm3MprNe8H4OcSwxaXXKrHiyBNQshKGYY+g/SnVEonCA06PLOvt3gPmVPabXRt1Sex1orYsWm1ZSfoJxoL0Bhk+lTfEV4HHZrqHlXQTJV6QIIQxSjin0Ibs2Uz38o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276778; c=relaxed/simple;
	bh=dskBJn+Kw/KbtJnLcRZ/gdiJ8H0uN1DxEDlA84joXjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6PHgmnCvVhWNWRqDhimRmsN6VbiOwmykmOD5B577b8quqI07J554X6NTBWry5uvf9FvgCNHDzfdlfunrK63ajDyjlDQq+t/KjsI7S+wmMxpEMlYVw3rnXp/DUCadTnJufpGEHz1M6gtKl9666jV2unKk7o3IfJImzPjywGwwGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtDxmmwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtDxmmwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BE5C4CEF0;
	Sun,  7 Sep 2025 20:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276778;
	bh=dskBJn+Kw/KbtJnLcRZ/gdiJ8H0uN1DxEDlA84joXjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtDxmmwThQ7to14yCPNbM7YIdqtwn24BvAYgjXNgoAT2DhhOU4oHtx/cBDXT8Ia7w
	 U00Nf8wb0dID9rur9jTTyQcJeQcI09SgqeHoFVoBhXo/BArXJ3t9ugi/KJBiFXIDgU
	 0XcEqR1EjYdEf6Ts9tKMLAsu70dQBuRPspGoOqRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/121] perf bpf-utils: Constify bpil_array_desc
Date: Sun,  7 Sep 2025 21:59:04 +0200
Message-ID: <20250907195612.618958539@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 1654a0e4d576d9e43fbb10ccf6a1b307c5c18566 ]

The array's contents is a compile time constant. Constify to make the
code more intention revealing and avoid unintended errors.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250902181713.309797-3-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 01be43f2a0ea ("perf bpf-utils: Harden get_bpf_prog_info_linear")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-utils.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/bpf-utils.c b/tools/perf/util/bpf-utils.c
index 80b1d2b3729ba..64a5583446964 100644
--- a/tools/perf/util/bpf-utils.c
+++ b/tools/perf/util/bpf-utils.c
@@ -20,7 +20,7 @@ struct bpil_array_desc {
 				 */
 };
 
-static struct bpil_array_desc bpil_array_desc[] = {
+static const struct bpil_array_desc bpil_array_desc[] = {
 	[PERF_BPIL_JITED_INSNS] = {
 		offsetof(struct bpf_prog_info, jited_prog_insns),
 		offsetof(struct bpf_prog_info, jited_prog_len),
@@ -129,12 +129,10 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
 
 	/* step 2: calculate total size of all arrays */
 	for (i = PERF_BPIL_FIRST_ARRAY; i < PERF_BPIL_LAST_ARRAY; ++i) {
+		const struct bpil_array_desc *desc = &bpil_array_desc[i];
 		bool include_array = (arrays & (1UL << i)) > 0;
-		struct bpil_array_desc *desc;
 		__u32 count, size;
 
-		desc = bpil_array_desc + i;
-
 		/* kernel is too old to support this field */
 		if (info_len < desc->array_offset + sizeof(__u32) ||
 		    info_len < desc->count_offset + sizeof(__u32) ||
@@ -163,13 +161,12 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
 	ptr = info_linear->data;
 
 	for (i = PERF_BPIL_FIRST_ARRAY; i < PERF_BPIL_LAST_ARRAY; ++i) {
-		struct bpil_array_desc *desc;
+		const struct bpil_array_desc *desc = &bpil_array_desc[i];
 		__u32 count, size;
 
 		if ((arrays & (1UL << i)) == 0)
 			continue;
 
-		desc  = bpil_array_desc + i;
 		count = bpf_prog_info_read_offset_u32(&info, desc->count_offset);
 		size  = bpf_prog_info_read_offset_u32(&info, desc->size_offset);
 		bpf_prog_info_set_offset_u32(&info_linear->info,
@@ -192,13 +189,12 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
 
 	/* step 6: verify the data */
 	for (i = PERF_BPIL_FIRST_ARRAY; i < PERF_BPIL_LAST_ARRAY; ++i) {
-		struct bpil_array_desc *desc;
+		const struct bpil_array_desc *desc = &bpil_array_desc[i];
 		__u32 v1, v2;
 
 		if ((arrays & (1UL << i)) == 0)
 			continue;
 
-		desc = bpil_array_desc + i;
 		v1 = bpf_prog_info_read_offset_u32(&info, desc->count_offset);
 		v2 = bpf_prog_info_read_offset_u32(&info_linear->info,
 						   desc->count_offset);
@@ -224,13 +220,12 @@ void bpil_addr_to_offs(struct perf_bpil *info_linear)
 	int i;
 
 	for (i = PERF_BPIL_FIRST_ARRAY; i < PERF_BPIL_LAST_ARRAY; ++i) {
-		struct bpil_array_desc *desc;
+		const struct bpil_array_desc *desc = &bpil_array_desc[i];
 		__u64 addr, offs;
 
 		if ((info_linear->arrays & (1UL << i)) == 0)
 			continue;
 
-		desc = bpil_array_desc + i;
 		addr = bpf_prog_info_read_offset_u64(&info_linear->info,
 						     desc->array_offset);
 		offs = addr - ptr_to_u64(info_linear->data);
@@ -244,13 +239,12 @@ void bpil_offs_to_addr(struct perf_bpil *info_linear)
 	int i;
 
 	for (i = PERF_BPIL_FIRST_ARRAY; i < PERF_BPIL_LAST_ARRAY; ++i) {
-		struct bpil_array_desc *desc;
+		const struct bpil_array_desc *desc = &bpil_array_desc[i];
 		__u64 addr, offs;
 
 		if ((info_linear->arrays & (1UL << i)) == 0)
 			continue;
 
-		desc = bpil_array_desc + i;
 		offs = bpf_prog_info_read_offset_u64(&info_linear->info,
 						     desc->array_offset);
 		addr = offs + ptr_to_u64(info_linear->data);
-- 
2.51.0



