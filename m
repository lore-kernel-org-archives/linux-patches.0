Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0578E3B2D1D;
	Tue, 21 Jul 2026 20:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666192; cv=none; b=YU9xz+k94i759is65+//DYR9b4ys2y4PMeeixQcJB7Lsl7W2wBlvTs6Vbpdmx4Udxv24d2BqWQRThXowGIdSGdlg3Fxkx9CuR89VzHewo4cF/Lz69gt7HmCekThlZp+UdGH8hW7oKq+z2CaogzGZiCl6YmRYnAT2g3OYrENBMxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666192; c=relaxed/simple;
	bh=sAVMjx16wTVtCB8qHFaMAI+tkNsCbCOkdf5Hy1suRIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXt5GZrBBv3kLoMGGBcJN9abD7H+DwYgQ03Ozw2TuCz+axD16/BVTS9+PQF6+fDPUG2fevxsuAZylq3JQpTn6PeAgK45BS4CN1lsr1llmVnLDxrtfLMudBEj6citft1TgLv53i+HwgagoaCPzc/jBjCh2ZwoRaCx2njs2i5lCHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+hDx9D2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+hDx9D2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD051F000E9;
	Tue, 21 Jul 2026 20:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666190;
	bh=hqHadh05Sr+d1hYN4ypXFQqcJWX7uMU6RlPhb3pz5To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+hDx9D20YLQR9Q1BZn2urk9FdzfhrLr16/Hzh5z50dpZnySqBY3gjsPQfBYnkANr
	 S7DdMl4PzW3rIfv8pFCPBmn7iNq3HX5t0ZIYOMqH7uy0sApCtaTPop1P1Zd1T8DYuD
	 wDDE8+XzeE0APnlDc3TFeatMqOeeW4ppNlNl1Y0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0588/1266] selftests/bpf: Initialize operation name before use
Date: Tue, 21 Jul 2026 17:17:05 +0200
Message-ID: <20260721152455.022108720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 55ffbe8a15b1254f44d56952fb425a10e3f15c31 ]

ASAN reports stack-buffer-overflow due to the uninitialized op_name.

Initialize it to fix the issue.

Fixes: 054b6c7866c7 ("selftests/bpf: Add verifier log tests for BPF_BTF_LOAD command")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/r/20260602-tools_build_fix_zero_init_bpf_only-v2-6-c76e5250ea1c@arm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/verifier_log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/verifier_log.c b/tools/testing/selftests/bpf/prog_tests/verifier_log.c
index 8337c6bc5b95b6..abc473c3741f53 100644
--- a/tools/testing/selftests/bpf/prog_tests/verifier_log.c
+++ b/tools/testing/selftests/bpf/prog_tests/verifier_log.c
@@ -317,6 +317,7 @@ static void verif_btf_log_subtest(bool bad_btf)
 	res = load_btf(&opts, true);
 	ASSERT_EQ(res, -ENOSPC, "half_log_fd");
 	ASSERT_EQ(strlen(logs.buf), 24, "log_fixed_25");
+	strscpy(op_name, "log_fixed", sizeof(op_name));
 	ASSERT_STRNEQ(logs.buf, logs.reference, 24, op_name);
 
 	/* validate rolling verifier log logic: try all variations of log buf
-- 
2.53.0



