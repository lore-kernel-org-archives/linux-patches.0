Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C001C69E;
	Sat,  3 Feb 2024 04:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933824; cv=none; b=doQ/sZ2bhDatH1mKRH0Yf6A6Av7Ni7/FQarLv82v5DMUSsxaYn4c1E2xFzxAjVuwNmlnRo38AUmnqfoFb4cWMneMkGcwd3LfjL7aDiP7YVsXTfUbhZdpxSm4OVAbYR2G6e3zWP14io5xNrvzzGbx7Nz/yxG2VcayWuHORRUQs3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933824; c=relaxed/simple;
	bh=T0lPEDpP6Ci9r6NyyQtQyTBPiU8oyrb+l+fPdnrHAI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSIEzi0yVfcOclxHUBZEASNTWFwosJWypwq5LpxdK/qJcWHiAyVEsA0y17WLkMyDMtEuetkFvPhf6x64qUO5wH1/o8jX90teGBfiTjr1CmCQB2e6ehiwVuUF5NNQz1eLiuxHcnpJg8XXyhhMAuZ101cYX2pxiKsWu/eHTSrvlVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzvGSVv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzvGSVv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D62C433F1;
	Sat,  3 Feb 2024 04:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933823;
	bh=T0lPEDpP6Ci9r6NyyQtQyTBPiU8oyrb+l+fPdnrHAI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzvGSVv4iSbOirmkFC2FhllhKfqpQ2Gj3FoFOyQ4Q14AGfuae/fHLjBpscb0rmIQ9
	 8M7QuHVGcF6QMp1ay/JMhRtOOZxB/yJqxODlMrLNNNd400qspz2yoLmli2QqFVsBQV
	 uP3I51+2XCSgyGEairFwBBuktxQW9UWBOmnRly3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 120/353] selftests/bpf: fix compiler warnings in RELEASE=1 mode
Date: Fri,  2 Feb 2024 20:03:58 -0800
Message-ID: <20240203035407.541265789@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 62d9a969f4a95219c757831e9ad66cd4dd9edee5 ]

When compiling BPF selftests with RELEASE=1, we get two new
warnings, which are treated as errors. Fix them.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20231212225343.1723081-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c        | 2 +-
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index 655095810d4a..0ad98b6a8e6e 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -1214,7 +1214,7 @@ static int cmp_join_stat(const struct verif_stats_join *s1,
 			 enum stat_id id, enum stat_variant var, bool asc)
 {
 	const char *str1 = NULL, *str2 = NULL;
-	double v1, v2;
+	double v1 = 0.0, v2 = 0.0;
 	int cmp = 0;
 
 	fetch_join_stat_value(s1, id, var, &str1, &v1);
diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index c3ba40d0b9de..c5e7937d7f63 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -70,7 +70,7 @@ static int open_xsk(int ifindex, struct xsk *xsk, __u32 queue_id)
 		.frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE,
 		.flags = XDP_UMEM_UNALIGNED_CHUNK_FLAG,
 	};
-	__u32 idx;
+	__u32 idx = 0;
 	u64 addr;
 	int ret;
 	int i;
-- 
2.43.0



