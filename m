Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD81034AB00;
	Thu,  2 Jul 2026 16:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009631; cv=none; b=AWioN9HJwBI1aYrWzd8R9McKl61AnQewGApltBS7fHpVYt7ZigN4eqJOd0O/kA6pNgw4ZWtn/cooh2aQMLuhBWZzHwIxZ3HvUMlyVLE2wx72WcDTHSDbqTNU0e5KEWaDtJ1Feg0PhHf1mP9Jw7hUbD+YCzHiOH0vU/P/d1pWP/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009631; c=relaxed/simple;
	bh=v++s4XDU20RS3MeAf54rTXassj25M2wzGZuKnsOOKz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfITxmGC/nl2HRLqacsEBF3yMuRLRLff73GvigVggmhDRNAhWvLxK+LUDHxk8QFuEkw/0MjQ9rt3yOPbPz6J92aGflTQnn1fzWr0Et7KARuGrdF/aQ3fQZEwDxrSENC/0bvSVReiwp1yfEe3RLUAd7+q1lU0KA3zG7mdzsbTmas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fH4xkAiZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fH4xkAiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C731F00A3A;
	Thu,  2 Jul 2026 16:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009628;
	bh=m0nbLyqYIK98U4VVXfRZO1LLHhmhWjCsf8CrUcglCQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fH4xkAiZ7RSjCcc2HD1GyvpK6I702Q2EIeB4Y0ACHCqTdBAk4hSJT45T9Bod0O+ud
	 IPDR/kDeAPwNXef866KHNI8JPBLklHsz9OK2BinrlaZRBLGs2Hrib6Xsvnl00flD4g
	 RFj6Wr10qONMe/5Tz8JWBFIByd2B6l1s8FuYDbNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Yijia Wang <wangyijia.yeah@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/95] kselftest/arm64: signal: Skip SVE signal test if not enough VLs supported
Date: Thu,  2 Jul 2026 18:19:30 +0200
Message-ID: <20260702155109.778546293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yijia Wang <wangyijia.yeah@bytedance.com>

[ Upstream commit 78c09c0f4df89fabdcfb3e5e53d3196cf67f64ef ]

On platform where SVE is supported but there are less than 2 VLs available
the signal SVE change test should be skipped instead of failing.

Reported-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220524103149.2802-1-cristian.marussi@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Yijia Wang <wangyijia.yeah@bytedance.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/signal/testcases/fake_sigreturn_sve_change_vl.c       | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sve_change_vl.c b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sve_change_vl.c
index bb50b5adbf10de..915821375b0a44 100644
--- a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sve_change_vl.c
+++ b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sve_change_vl.c
@@ -6,6 +6,7 @@
  * supported and is expected to segfault.
  */
 
+#include <kselftest.h>
 #include <signal.h>
 #include <ucontext.h>
 #include <sys/prctl.h>
@@ -40,6 +41,7 @@ static bool sve_get_vls(struct tdescr *td)
 	/* We need at least two VLs */
 	if (nvls < 2) {
 		fprintf(stderr, "Only %d VL supported\n", nvls);
+		td->result = KSFT_SKIP;
 		return false;
 	}
 
-- 
2.53.0



