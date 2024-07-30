Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5715D18455F;
	Tue, 30 Jul 2024 16:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355673; cv=none; b=GMiuOONX38R6VEuTND3Ga/NTjcKIPaNIXUSnR2UrQXSXP0iRf8714NaLM9uiH1ovBP+uDDN3Hzfw2Zmg/rf5lu5VteSi/Ljb6i9irXsZM+lTYo5YjCIo5fDOUuMm1D3VwuIFKQ9ED/k3dBgqKqEZ3eyPEwl0SO7+RlHuK6K24cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355673; c=relaxed/simple;
	bh=j0iUWLP1R/vkf9bsVJpsGgy8s073a/erZnrjqHvbUv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxjmjnEcuUKBe57zQ375Frhv4bI6uUaSB7oZv0vIdmGGwyj/76PJK/KJgN1Ryg+xHWweowWr67iA7SB4ap5DCKTtlf6WBIvmioQcyjHNl+HipEYc8M6N6QOhp7BFBE15Virn1DBup10Z2mHC3nzuASkqu1vhiaDIncZL1J04WU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Hrl3ncC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Hrl3ncC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF973C32782;
	Tue, 30 Jul 2024 16:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355673;
	bh=j0iUWLP1R/vkf9bsVJpsGgy8s073a/erZnrjqHvbUv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Hrl3ncCBmTHZxm5cYhZkHIvGmWWhq8rC0TZMjJoGCtCSp4OchtCQWqQVPADm/07Z
	 lcdkM7yZfzkQHvpaAtipZPFvQ89Pv8dbT9kXwntwL9iLQklMqezpuzOJXQaLD4rnur
	 ILWzcmAKcAHnbetthOzDe3Q874Xf8lhKbHuflNzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/440] selftests/bpf: Close obj in error path in xdp_adjust_tail
Date: Tue, 30 Jul 2024 17:45:53 +0200
Message-ID: <20240730151620.575121883@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 52b49ec1b2c78deb258596c3b231201445ef5380 ]

If bpf_object__load() fails in test_xdp_adjust_frags_tail_grow(), "obj"
opened before this should be closed. So use "goto out" to close it instead
of using "return" here.

Fixes: 110221081aac ("bpf: selftests: update xdp_adjust_tail selftest to include xdp frags")
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Link: https://lore.kernel.org/r/f282a1ed2d0e3fb38cceefec8e81cabb69cab260.1720615848.git.tanggeliang@kylinos.cn
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index 39973ea1ce433..89366913a251c 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -217,7 +217,7 @@ static void test_xdp_adjust_frags_tail_grow(void)
 
 	prog = bpf_object__next_program(obj, NULL);
 	if (bpf_object__load(obj))
-		return;
+		goto out;
 
 	prog_fd = bpf_program__fd(prog);
 
-- 
2.43.0



