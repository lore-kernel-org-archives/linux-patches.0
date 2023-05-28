Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9A0611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EC3C433EF;
	Sun, 28 May 2023 19:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302935;
	bh=lOBkcsDzQUuW9Pi45KkisUhzKMdnKzR9v4PV7zWt69I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cmmLjuMBMIStzJSHpDJIrhNF+GBGCWVe6MOJNum4+Di2uRc9x47VY97T+uYnctXA
	 0i+jXJMAzHzAViNszZH6yc2atxOzsM5Z+5y3RAHzMptNISKqqYGMBcOUUedtgqOu1S
	 uQeYR/r5/gZ6hmWmIz8DRDFMnpCC7gxQ2SzvSGDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Zeng <zenghao@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/211] samples/bpf: Fix fout leak in hbms run_bpf_prog
Date: Sun, 28 May 2023 20:09:39 +0100
Message-Id: <20230528190845.037754185@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hao Zeng <zenghao@kylinos.cn>

[ Upstream commit 23acb14af1914010dd0aae1bbb7fab28bf518b8e ]

Fix fout being fopen'ed but then not subsequently fclose'd. In the affected
branch, fout is otherwise going out of scope.

Signed-off-by: Hao Zeng <zenghao@kylinos.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230411084349.1999628-1-zenghao@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/hbm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index ff4c533dfac29..8e48489b96ae9 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -308,6 +308,7 @@ static int run_bpf_prog(char *prog, int cg_id)
 		fout = fopen(fname, "w");
 		fprintf(fout, "id:%d\n", cg_id);
 		fprintf(fout, "ERROR: Could not lookup queue_stats\n");
+		fclose(fout);
 	} else if (stats_flag && qstats.lastPacketTime >
 		   qstats.firstPacketTime) {
 		long long delta_us = (qstats.lastPacketTime -
-- 
2.39.2



