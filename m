Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7189415F05;
	Tue, 21 Jul 2026 18:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656839; cv=none; b=Re8DQgnjOrxZj03UZKbcm85S0tYuBOBYU1pSqTaoAAaLyRBCLSptUmqrN9bVnxn1CFQHPYqmcOBtN61tyoF3YBAUaLlAOwnaQ3pjTTrcUPRk+lTo+c7NZ8GEfG4CAic4jTmevfXaM1F62EYZ7sNEu9VaTxHlr83ZcApeiebtziY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656839; c=relaxed/simple;
	bh=m+lgXC1Ew0/bBQHUvxO2oqk3Pw5UL2voRfFZzocjUoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dz6AEEENbJ+9R3OH5HFAdlZFVap8SIp1RND948KmbX3jAy30thhIiRBg+u3Cw/LhX29nm01u6qQXwkHpmIwCdQHtmCLslVhfVrXBsy5F9I1j7tYC3ZziMehO/l8jccY/7OSZBb0IxZbffajcex+beDX7M5l8I5ajNTExxa5PnC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APlEOUj8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APlEOUj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6D51F00A3D;
	Tue, 21 Jul 2026 18:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656838;
	bh=MN1+r2W/IFGVSrTgcbnxCZjBB3xP7XCClc3Q0ejn7t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APlEOUj8f0d3p9NoPVwxX3mJYglf5CZONr64CB5CTpjK9g5Xw80hvDjZB8sTrvUml
	 +Qvt6Do21essZF+EKBAaF3RnyuKQWL8t4NXdAkrLC/fl5lyEvtY6rGC1IwfchMXCwL
	 97pbU6vSDl+cBKErb4vDaUWJURd9l5tydtM/jwcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0538/1611] selftests/bpf: Initialize operation name before use
Date: Tue, 21 Jul 2026 17:10:54 +0200
Message-ID: <20260721152527.462775903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



