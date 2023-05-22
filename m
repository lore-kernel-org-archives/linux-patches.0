Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF557171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9FDC433D2;
	Mon, 22 May 2023 19:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783587;
	bh=1B2peXEYSMNCkoc61RSuBI2zOAqfgLGgcQDhB+PqCbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0CBJmDcGfUJ5kNsdNkWamu1TC7HXFnRXA2BAtYldv6e+gHtHyexy+TM+qZLdXq4R
	 3saWg9WPCTLoLmI89oPZQHm5CsWCVkyNnVDEH5dp26fpbVvhZsn9sxGeFeLE1gi8EI
	 gf59OwVstnAMs4Y+aDzRJYfUOsdsg5nvdrAALfu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Zeng <zenghao@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/292] samples/bpf: Fix fout leak in hbms run_bpf_prog
Date: Mon, 22 May 2023 20:07:32 +0100
Message-Id: <20230522190408.348534783@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
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
index 516fbac28b716..7f89700a17b69 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -315,6 +315,7 @@ static int run_bpf_prog(char *prog, int cg_id)
 		fout = fopen(fname, "w");
 		fprintf(fout, "id:%d\n", cg_id);
 		fprintf(fout, "ERROR: Could not lookup queue_stats\n");
+		fclose(fout);
 	} else if (stats_flag && qstats.lastPacketTime >
 		   qstats.firstPacketTime) {
 		long long delta_us = (qstats.lastPacketTime -
-- 
2.39.2



