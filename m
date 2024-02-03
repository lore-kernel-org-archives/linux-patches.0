Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F58017593;
	Sat,  3 Feb 2024 04:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933566; cv=none; b=f2S3Ts9e7Usf9g7glsHCWbi87lViYAl3HXs+QU/aPs4aTH3H9biKJax3/e1N9looj3MAS6usLQn9WPGGfvZPYYW7tyMcW0mKarOIA9iuWBU+MlOEawk7z/0JezCF5i09wH6T9Cx7b/Ow3l+vhgYeF6n0l1H0jaPjoZT9qcjQ1aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933566; c=relaxed/simple;
	bh=HnVtE6xo9PWn0x864uID6ZXdyL9Xp5GoLfSuclzIbUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOR5ezDv82uCI3uumuX07Z7xLzo7Mn2jSB0WrYw0mwfEe6yWIiUXUadvP5fg1ndU3smFZnd8XSNOe50wpckyQiDke+NX7yqtS7BkxbCRUiRURtFb0LL4a4PpF8UFvdnN5TvgZQagm07HBnFiWMZ58OdtCgY503PMd9sVo20J+Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAMzTGas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAMzTGas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A02EC433C7;
	Sat,  3 Feb 2024 04:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933566;
	bh=HnVtE6xo9PWn0x864uID6ZXdyL9Xp5GoLfSuclzIbUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAMzTGasHDUdZtIjaoyDYCnvq795wVZidC/WbhxdHy8IzSsUVAh2AlyEGV6ypxKLa
	 6BakMi9ibeVeVb6V1UGgt4hTm5LXVjUT5nJCPZ+Rajv24ohH6e06DdG5xLc1ePFHv6
	 TJzTgqsn54jtuusQauj/Pv5Zlm3Q4a8agNq5+fGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/322] selftests/bpf: fix compiler warnings in RELEASE=1 mode
Date: Fri,  2 Feb 2024 20:03:38 -0800
Message-ID: <20240203035403.055343876@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 613321eb84c1..adb77c1a6a74 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -68,7 +68,7 @@ static int open_xsk(int ifindex, struct xsk *xsk, __u32 queue_id)
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



