Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FC71A6192;
	Tue, 30 Jul 2024 16:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357298; cv=none; b=UGb0TWB4UvzIfOcuw0l4wlPB5Sl/2SEZRIfuw4GOtaXCho7arRZvwzsWxfe9B4X7Wm8RpuDlYYr6C1fVgYTYn4cR4IOWrWVN5Tj4CjFWX/7/nFlncXwjSB5yCWyl72UpvPNwqp5hWTvScyW+UuYVkZp2ySpZ8wvo9rZ13LMSGYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357298; c=relaxed/simple;
	bh=zlSt1rfnGnnlM4n2A/99j1a79p4NGCNrmoGRwnH5GH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXp6GoEaWVtkpWxlLmiIBSy5htCRz+RKYUkUZG1KDSKCHevYAiE/Thq2+hPtmXA//Rjr4imBicf2tBLA/aU7swUftPW2Dy1TOduy0KUPVRPlxYHjGRYecy2ZzXMVKf1bIJP2GoQ85/yqPkTpXwnhEOg66KgnkNtr80F+FwPDAi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlI2mqlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlI2mqlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19F9C4AF0E;
	Tue, 30 Jul 2024 16:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357298;
	bh=zlSt1rfnGnnlM4n2A/99j1a79p4NGCNrmoGRwnH5GH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlI2mqlGYETfaVv54dG4wFkHAfeY7bRAqhnVgdPXrx7Izan9tVN6WvXIkXZgBPJ4H
	 QavdynhAHXuPrZL20hTmLjfADDk3PkgjoT5DIsiD81/H8HZllsVRZGtfowc736Zz+0
	 2g/i0Q2PqtWZRZjskbDgTQasgR3kPODgDjRhzvO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 241/809] selftests/bpf: Close obj in error path in xdp_adjust_tail
Date: Tue, 30 Jul 2024 17:41:57 +0200
Message-ID: <20240730151734.121677603@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



