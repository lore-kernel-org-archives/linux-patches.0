Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546D51170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75DDC433C8;
	Mon, 11 Sep 2023 13:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440639;
	bh=LN4TVdbKgJsFLzXyrQG7vdjrHSjPri6zpl/n8aTYg7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgAI2oqTYiFWggCVFLv1V+039cP5vxPqujWd8t2l2pJGN66okQu6lt3j0TObo0U+p
	 Fy8wzcOiJOIak+3rVVH0hUh+5R33ilSBN9ioPlatD9KeQTevPb29JA8MRAtCgiG/0k
	 poVj6Thj1NTqObvHgXFeuEw1VQ4hA7f51m3hI3h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yipeng Zou <zouyipeng@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Li Zetao <lizetao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 132/739] selftests/bpf: Fix repeat option when kfunc_call verification fails
Date: Mon, 11 Sep 2023 15:38:51 +0200
Message-ID: <20230911134654.774682599@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yipeng Zou <zouyipeng@huawei.com>

[ Upstream commit 811915db674f8daf19bb4fcb67da9017235ce26d ]

There is no way where topts.repeat can be set to 1 when tc_test fails.
Fix the typo where the break statement slipped by one line.

Fixes: fb66223a244f ("selftests/bpf: add test for accessing ctx from syscall program type")
Signed-off-by: Yipeng Zou <zouyipeng@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Li Zetao <lizetao1@huawei.com>
Link: https://lore.kernel.org/bpf/20230814031434.3077944-1-zouyipeng@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/kfunc_call.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index a543742cd7bd1..2eb71559713c9 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -173,8 +173,8 @@ static void verify_fail(struct kfunc_test_params *param)
 	case tc_test:
 		topts.data_in = &pkt_v4;
 		topts.data_size_in = sizeof(pkt_v4);
-		break;
 		topts.repeat = 1;
+		break;
 	}
 
 	skel = kfunc_call_fail__open_opts(&opts);
-- 
2.40.1



