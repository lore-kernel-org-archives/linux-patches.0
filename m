Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2505E2F2340;
	Tue, 17 Jun 2025 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176265; cv=none; b=O+CFZKd0L89gRSLW0yI5/lybbeAyWZxVMIN1hfsq+PtopgfCU+dlJ3XWne9IUxK56J3U/c2UnOVileT1twRZBowGa4wLzLXiOv2SiFBn0H9OuwBB/VNRrNBMFM7I6+a9AmFH3nlh+MnnC8bpkvkavkVv72mN/+XxbP/HxtE3Ny8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176265; c=relaxed/simple;
	bh=3odTpND66rAcQlNjMxe9r2IEVyvP8BytCWBsm1SGejU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxEeU9TnxpvON6rCf4s2gCECkYODuId0OSXzha8XUxFYR8AKJCD8HAuuBCveAGgm7E5M3WAagl9ZFsC+H84qXNZZqK5EJBEVSdrNcjbJESosSGtOFliRHVL9s6odFS54djJtdv8gIJ7ul+PwnzZobhclAtLhU5lb53s0ia1C6Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KO8jgmre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KO8jgmre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8695AC4CEE3;
	Tue, 17 Jun 2025 16:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176265;
	bh=3odTpND66rAcQlNjMxe9r2IEVyvP8BytCWBsm1SGejU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KO8jgmreaRZKttDpc2zHJ6odnDDsZxKIVjfphyIcx1Lv8eYPmD6bb6is/raq+GNt2
	 NhHVtE7Fh92jTo/AJ83NXeEoRstKJvEtWo8TOHtTMoFamxbKiqrstBtkLBSSJSU2yp
	 /9m29gFe4zk0vQRews9pFaSbz/1hxM9FeiMUYfSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Kumar Bhaskar <skb99@linux.ibm.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 170/780] selftests/bpf: Fix bpf_nf selftest failure
Date: Tue, 17 Jun 2025 17:17:58 +0200
Message-ID: <20250617152458.406575271@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saket Kumar Bhaskar <skb99@linux.ibm.com>

[ Upstream commit 967e8def1100cb4b08c28a54d27ce69563fdf281 ]

For systems with missing iptables-legacy tool this selftest fails.

Add check to find if iptables-legacy tool is available and skip the
test if the tool is missing.

Fixes: de9c8d848d90 ("selftests/bpf: S/iptables/iptables-legacy/ in the bpf_nf and xdp_synproxy test")
Signed-off-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250409095633.33653-1-skb99@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index dbd13f8e42a7a..dd6512fa652be 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -63,6 +63,12 @@ static void test_bpf_nf_ct(int mode)
 		.repeat = 1,
 	);
 
+	if (SYS_NOFAIL("iptables-legacy --version")) {
+		fprintf(stdout, "Missing required iptables-legacy tool\n");
+		test__skip();
+		return;
+	}
+
 	skel = test_bpf_nf__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "test_bpf_nf__open_and_load"))
 		return;
-- 
2.39.5



