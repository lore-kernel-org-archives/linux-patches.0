Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015196;
	b=G3JlHxbHaAD89L9APbPRQ+sDP1vQQd5PE/3zr+yz288VpEfeq/jsRS2wJAUTVB2mA4NL
	 UqRCshCFx7N025Iww7XBPMk7zyyW01edL4/U99RNntqqVTVSbTAttMb6cPnROgyIMVmln
	 LjCrX7XvQFzgJWzRTiXUCNdTsXBJob6UgjRE9aSww/r173ZBevNgEDnxLjDOWlcp2B7Ib
	 uUkT/OOULW6SzFGYUIzZTw/CwTqQGiOGbsdbQR2NZkXMYFLPgAC8OHRVx3MD3Et34bj2L
	 JJpVgEr/wc5eP1WYex8ZGaJ55P6tsEnCCJk5FPBVNrf+5Rt5w/dzeV1nvihEuwWntzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Jx3IbBEf4+1bLf6NeeNY2hfw05Wr22ufTNUvmi/qO8=;
	b=BQKRkWPpalF5dJU+rpTPM0it6Gp/t0AodcuAqgqMsESIQHyBC8R3WC+l7mXCxaLzlAot
	 FTNzV6j8E2Qp3Ty5PeHhs0oyNreG082v/CqYgV0rjHB5wE7fS4Td/KHZTnnr2z6sgG9Gr
	 VfTuj437ZvdTM9uwIQ5aZ5ejt6600fs/fyjWC54WEve58MPQfcj0O5O5X4t2O/jDhHhpl
	 7Ovr/0c4TBjneI+6Y3D16Q7yt4NIEhvtGnSXe0tJKwEFMR863sIeXFtwo4PR9aRsDy4cA
	 pjlatJZvcJhnNgwURqRmuNMwHTxpBXMFOrVLMVtoCkLBr8gRQaZBB7iVuOuD53459HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sEVHN0UX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31008606A320;
	Wed, 18 Nov 2026 15:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sEVHN0UX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702F41F000C4;
	Wed, 18 Nov 2026 15:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015196;
	bh=+Jx3IbBEf4+1bLf6NeeNY2hfw05Wr22ufTNUvmi/qO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sEVHN0UXeveqNEBdgM3Inle4XZOaz3AASwbLqrWZu+cv3uTVziUO7+L8jDgAKt/k2
	 SkbQKh7ERH1IfIYist3Hw6jWrulTb6ZTO1J8HvtaJElMI7VTSmx5MmRzXLxOcjIKHh
	 ehh3PVmzII8rOpRIJVXWyKxHLbkWGF3KUU0D/N/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0088/2651] bpftool: Dont drop a type in the sorted C dump
Date: Wed, 18 Nov 2026 15:22:08 +0100
Message-ID: <20261118150251.079242708@linuxfoundation.org>
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

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit ff01f88a91368c264efb071c13f2b27b4d5c1d2b ]

The C dump sorts types by default, so that generated headers are
diffable. The sorted dump emits one type fewer than the unsorted dump
of the same BTF.

dump_btf_c() starts its loop at index 1 to skip the void type at BTF
type ID 0. That holds for the unsorted dump, where the array index is
the type ID, but not after qsort(): position 0 is then the lowest
ranked type, and btf_type_rank() ranks an anonymous enum 0 while void
takes the default rank of 10. So the enum is skipped, and void is
emitted instead as a no-op.

Fixes: 94133cf24bb3 ("bpftool: Introduce btf c dump sorting")
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/r/20260828215207.3105313-7-ihor.solodrai@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf.c                                     | 6 +++++-
 .../testing/selftests/bpf/bpftool_btf_dump_sorted.expected  | 4 ++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index c9589026da8d6..bca0a3982f09b 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -805,9 +805,13 @@ static int dump_btf_c(const struct btf *btf,
 
 		if (sort_dump)
 			datums = sort_btf_c(btf);
-		for (i = 1; i < cnt; i++) {
+		for (i = 0; i < cnt; i++) {
 			int idx = datums ? datums[i].index : i;
 
+			/* type ID 0 is void, skip it */
+			if (idx == 0)
+				continue;
+
 			err = btf_dump__dump_type(d, idx);
 			if (err)
 				goto done;
diff --git a/tools/testing/selftests/bpf/bpftool_btf_dump_sorted.expected b/tools/testing/selftests/bpf/bpftool_btf_dump_sorted.expected
index a9c6b688ffd79..5470b2b432291 100644
--- a/tools/testing/selftests/bpf/bpftool_btf_dump_sorted.expected
+++ b/tools/testing/selftests/bpf/bpftool_btf_dump_sorted.expected
@@ -21,6 +21,10 @@
 #endif
 #endif
 
+enum {
+	E0 = 1,
+};
+
 struct holey {
 	int c;
 	long: 32;
-- 
2.53.0



