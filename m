Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB5E1A6162;
	Tue, 30 Jul 2024 16:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356554; cv=none; b=iUncY4srDF2JbYEJGTzbDpSuPRTFZyxw8eEV8/KSab1rEd1I2yenifEdw7Yi3Ee8oBbBcilEHFSus59AHbcjaLsFMjCmkfMuMvwOOEfUjwlPe8e9E15tKVHCv6mkaP3eo0vJvjpXpiipQgKuGw+AXSiNQ7KgdNKwl4QF+haNXFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356554; c=relaxed/simple;
	bh=90/OZpVcFjV699giLMypkrWPYD095dirsOJum+aq3lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Op7Ul8hn63Fbmm59ts7W3+/APuMkI0Zq8eVmmM9E6GRgTmgkGtXhsp84/rhHlpvJSg6Whum7o8wVq9+WerjaU9iFEtodjK86JqajsxmzZY2eQZ3qSqXTLJR0R0h4QcTcGjxYfrEvV6evVEuY+CVh8j3FnrUHMZ1B937Mda4ntk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzI/1bZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzI/1bZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B27C32782;
	Tue, 30 Jul 2024 16:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356554;
	bh=90/OZpVcFjV699giLMypkrWPYD095dirsOJum+aq3lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzI/1bZaOqa9UEuzW4awWai2/Z7pPQFZXEJTjS+FZXiFx56bT6KYAZUDkTNI8p4oJ
	 uKXiUUgWbangWL6VLd4Tha33rKrDYps9zB7KF+RKwcOt1PXp/AVcfj0M8bG5ch9Xwa
	 svetkL5oCy28yaOTxFNDi0ddPCtRbtm5Mnrsk80w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/568] selftests/bpf: Close obj in error path in xdp_adjust_tail
Date: Tue, 30 Jul 2024 17:44:28 +0200
Message-ID: <20240730151646.176202845@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f09505f8b0386..53d6ad8c2257e 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -222,7 +222,7 @@ static void test_xdp_adjust_frags_tail_grow(void)
 
 	prog = bpf_object__next_program(obj, NULL);
 	if (bpf_object__load(obj))
-		return;
+		goto out;
 
 	prog_fd = bpf_program__fd(prog);
 
-- 
2.43.0



