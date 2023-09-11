Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E1811715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA68BC433C7;
	Mon, 11 Sep 2023 15:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444951;
	bh=KrYrGeLCNjQ8KeRbgNJChZOii5P7ezgwiXpj7T0z9Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNt7bcbIR1h4UAuwkgOSedr1wBZIev6lmYNkzUVEJ9a7qGCMqaffWU/g2Kp4pR4mq
	 uDyKVU9QmJEzKvWaWxPtvEFF+JPuf24fKRA1FNBC5bsnyu3xQvxu97GenzlNxwQFGL
	 g/pNCKsBpDY6qZBaPzu5rK+atUaSY4ojrcS8JttQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yipeng Zou <zouyipeng@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/600] selftests/bpf: Clean up fmod_ret in bench_rename test script
Date: Mon, 11 Sep 2023 15:43:28 +0200
Message-ID: <20230911134638.768931579@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



