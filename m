Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2A618E36C;
	Mon, 28 Oct 2024 06:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098032; cv=none; b=RZ6i5qC9mbfeAranem1/7fx/daXQz/dWmbQ50011QkAGludIRIVLiC8Ph585WmWx8k/NCqptjY3ZtAUiiINTvFyNBcZnPFhJtTYsuiZGW5+67QVm2txsBwJUsS452W2N8mo4PY4Sqa3OhcnHmrTPXuLIdYaxd2+t2uprJ74L+vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098032; c=relaxed/simple;
	bh=t0un3LxbGJVzqeRlx9eC67V+Yv68WhZkn/B66Kko31c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jP322hH+l4iUZXnY66xujzy8UczSB/bfYzePKwl4pJ/OahOlzgT4+iVMJbgm0oj0D3KYRhoYkvXwo1pwNGfnI9kp8AxSDmeykdYxwFGFpi1XxIUPTQjnCd4jpXRzZ4jnsYXiolUw29t1X6dDc0zpHn9fyo6fnZh2yYdXbwWRz0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htKt6P5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htKt6P5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A89EC4CEC3;
	Mon, 28 Oct 2024 06:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098031;
	bh=t0un3LxbGJVzqeRlx9eC67V+Yv68WhZkn/B66Kko31c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htKt6P5He+VeAucSXMeIXEzaKfIiTUwY8xjpOMT5Bqkhzzg1LKnQD3QDZNLCB31po
	 32FyV7kEAnkebG5bTW+J4z1b3wnBEcXneiRfS06J3pBJZG0nQwRRD2Qdxe2mexbkp2
	 ZxVoH+RxIBZCCD+3dJgKn4Me8IyEEumlZ/gfPLCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrone Wu <wudevelops@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 020/261] selftests/bpf: fix perf_event link info name_len assertion
Date: Mon, 28 Oct 2024 07:22:42 +0100
Message-ID: <20241028062312.518863457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyrone Wu <wudevelops@gmail.com>

[ Upstream commit 4538a38f654a1c292fe489a9b66179262bfed088 ]

Fix `name_len` field assertions in `bpf_link_info.perf_event` for
kprobe/uprobe/tracepoint to validate correct name size instead of 0.

Fixes: 23cf7aa539dc ("selftests/bpf: Add selftest for fill_link_info")
Signed-off-by: Tyrone Wu <wudevelops@gmail.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Link: https://lore.kernel.org/r/20241008164312.46269-2-wudevelops@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/fill_link_info.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fill_link_info.c b/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
index f3932941bbaaf..745c5ada4c4bf 100644
--- a/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
+++ b/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
@@ -67,8 +67,9 @@ static int verify_perf_link_info(int fd, enum bpf_perf_event_type type, long add
 
 		ASSERT_EQ(info.perf_event.kprobe.cookie, PERF_EVENT_COOKIE, "kprobe_cookie");
 
+		ASSERT_EQ(info.perf_event.kprobe.name_len, strlen(KPROBE_FUNC) + 1,
+				  "name_len");
 		if (!info.perf_event.kprobe.func_name) {
-			ASSERT_EQ(info.perf_event.kprobe.name_len, 0, "name_len");
 			info.perf_event.kprobe.func_name = ptr_to_u64(&buf);
 			info.perf_event.kprobe.name_len = sizeof(buf);
 			goto again;
@@ -79,8 +80,9 @@ static int verify_perf_link_info(int fd, enum bpf_perf_event_type type, long add
 		ASSERT_EQ(err, 0, "cmp_kprobe_func_name");
 		break;
 	case BPF_PERF_EVENT_TRACEPOINT:
+		ASSERT_EQ(info.perf_event.tracepoint.name_len, strlen(TP_NAME) + 1,
+				  "name_len");
 		if (!info.perf_event.tracepoint.tp_name) {
-			ASSERT_EQ(info.perf_event.tracepoint.name_len, 0, "name_len");
 			info.perf_event.tracepoint.tp_name = ptr_to_u64(&buf);
 			info.perf_event.tracepoint.name_len = sizeof(buf);
 			goto again;
@@ -96,8 +98,9 @@ static int verify_perf_link_info(int fd, enum bpf_perf_event_type type, long add
 	case BPF_PERF_EVENT_URETPROBE:
 		ASSERT_EQ(info.perf_event.uprobe.offset, offset, "uprobe_offset");
 
+		ASSERT_EQ(info.perf_event.uprobe.name_len, strlen(UPROBE_FILE) + 1,
+				  "name_len");
 		if (!info.perf_event.uprobe.file_name) {
-			ASSERT_EQ(info.perf_event.uprobe.name_len, 0, "name_len");
 			info.perf_event.uprobe.file_name = ptr_to_u64(&buf);
 			info.perf_event.uprobe.name_len = sizeof(buf);
 			goto again;
-- 
2.43.0



