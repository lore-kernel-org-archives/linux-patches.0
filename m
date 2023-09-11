Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8142A11715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C40C433C8;
	Mon, 11 Sep 2023 15:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444948;
	bh=BVTObnbdlrZ+R2Gx+7m/EyPMjFEP4pXYBvA5VqKJndY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeSqAXJ4gXLaNulAkPG8Aie0HV41hAWTxLNsKVgspYaKwbLT0XP2ezwlEys3CDoMM
	 M0WW6bRV5qlu804ikektoWae6qCcBQPghM75sCV2/MnDQDxOTkGLMMKqjp5+jZPgQ8
	 BK5fxt5F5spewwxiHni9xBHFxcQqgkP8s6pN0o3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yipeng Zou <zouyipeng@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Li Zetao <lizetao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/600] selftests/bpf: Fix repeat option when kfunc_call verification fails
Date: Mon, 11 Sep 2023 15:43:27 +0200
Message-ID: <20230911134638.740910141@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5af1ee8f0e6ee..36071f3f15ba1 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -171,8 +171,8 @@ static void verify_fail(struct kfunc_test_params *param)
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



