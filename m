Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AC56FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20FEC433C7;
	Sun, 17 Sep 2023 20:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981740;
	bh=r59RjgYv4e7NFE7LyggbkOx/Nbg21c8E/rE6Vf5Cy4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7pPSNo0RoxW0n3kxcy2BpmW123jg8+Vv/z0WHUWiNmDMSIz9DMAaWn78FFYs+lxY
	 quSqTMNrDNF8njbdp3rq/mpKwJEJCWClDQjaI7QHIsZjCEyLgQrmsJZFXOZJ+LZqxR
	 xv0pr64jMC+mq1L24mDcNLfC75gn9I8R4Wn38GvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yipeng Zou <zouyipeng@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/511] selftests/bpf: Clean up fmod_ret in bench_rename test script
Date: Sun, 17 Sep 2023 21:08:47 +0200
Message-ID: <20230917191116.280315807@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yipeng Zou <zouyipeng@huawei.com>

[ Upstream commit 83a89c4b6ae93481d3f618aba6a29d89208d26ed ]

Running the bench_rename test script, the following error occurs:

  # ./benchs/run_bench_rename.sh
  base      :    0.819 ± 0.012M/s
  kprobe    :    0.538 ± 0.009M/s
  kretprobe :    0.503 ± 0.004M/s
  rawtp     :    0.779 ± 0.020M/s
  fentry    :    0.726 ± 0.007M/s
  fexit     :    0.691 ± 0.007M/s
  benchmark 'rename-fmodret' not found

The bench_rename_fmodret has been removed in commit b000def2e052
("selftests: Remove fmod_ret from test_overhead"), thus remove it
from the runners in the test script.

Fixes: b000def2e052 ("selftests: Remove fmod_ret from test_overhead")
Signed-off-by: Yipeng Zou <zouyipeng@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230814030727.3010390-1-zouyipeng@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/benchs/run_bench_rename.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/benchs/run_bench_rename.sh b/tools/testing/selftests/bpf/benchs/run_bench_rename.sh
index 16f774b1cdbed..7b281dbe41656 100755
--- a/tools/testing/selftests/bpf/benchs/run_bench_rename.sh
+++ b/tools/testing/selftests/bpf/benchs/run_bench_rename.sh
@@ -2,7 +2,7 @@
 
 set -eufo pipefail
 
-for i in base kprobe kretprobe rawtp fentry fexit fmodret
+for i in base kprobe kretprobe rawtp fentry fexit
 do
 	summary=$(sudo ./bench -w2 -d5 -a rename-$i | tail -n1 | cut -d'(' -f1 | cut -d' ' -f3-)
 	printf "%-10s: %s\n" $i "$summary"
-- 
2.40.1



