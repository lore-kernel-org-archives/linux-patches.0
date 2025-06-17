Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634072DF3C9;
	Tue, 17 Jun 2025 15:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174856; cv=none; b=u4rHXWzfkN5E50x3Wo8XI6IoPy5xNtU5gLpLoMaIs1tgVr7d7nL0YZ2LBHZvJuT0Umcx0kbbok70wNW3KQDpUlaDn/MWBxShJxX9Z/149up12MIanEXosxeVdYOqSOYFdRtGy9Fx4zPrNRvG8pH7jk63QtPLXnb3KC/mEvy+j78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174856; c=relaxed/simple;
	bh=7e/9s1So3Ws3z0J1UEizfqlQZI5iQLm/jvq0pWPHqEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVbuLn0gAtQNUEgbAyWceGie6IkyybCn+xKBANzq+ujrOnEZJosKxTJv1l2NbnKJJ1b//MT7XP1k1K6QaWjIiWJXk1GG4ECEXreftZTMPSnm1WgjKKH3PUbsSTZdLAlZom7ey3VieYZvFP25J3XyVq5cdd5+vvAsvP14aPfYtJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySkPFPhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySkPFPhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7828C4CEF0;
	Tue, 17 Jun 2025 15:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174856;
	bh=7e/9s1So3Ws3z0J1UEizfqlQZI5iQLm/jvq0pWPHqEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySkPFPhs4WnpP3lug4V3T1cSvDyl3mGM+9RYubO3BjN5sNV05YeLzMpLxlQewxHbs
	 OeWsMWX3Qrl6rPk/7huB/Gon/x3UTmhiH7vtqUDAOVEi9+q7rZyT8lwvL1+/QpLAuo
	 blWlEj2rxefGPPq+mICA4Anu6zJhk4AmAsFRY+6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 027/780] selftests: coredump: Raise timeout to 2 minutes
Date: Tue, 17 Jun 2025 17:15:35 +0200
Message-ID: <20250617152452.610532978@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit c6e888d02d51d1e9f9abf1587e6a5618375cac9f ]

The test's runtime (nearly 20s) is dangerously close to the limit (30s) on
qemu-system-riscv64:

$ time ./stackdump_test > /dev/null
real	0m19.210s
user	0m0.077s
sys	0m0.359s

There could be machines slower than qemu-system-riscv64. Therefore raise
the test timeout to 2 minutes to be safe.

Fixes: 15858da53542 ("selftests: coredump: Add stackdump test")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/dd636084d55e7828782728d087fa2298dcab1c8b.1744383419.git.namcao@linutronix.de
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/coredump/stackdump_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/coredump/stackdump_test.c b/tools/testing/selftests/coredump/stackdump_test.c
index 9da10fb5e597c..fe3c728cd6be5 100644
--- a/tools/testing/selftests/coredump/stackdump_test.c
+++ b/tools/testing/selftests/coredump/stackdump_test.c
@@ -89,7 +89,7 @@ FIXTURE_TEARDOWN(coredump)
 	fprintf(stderr, "Failed to cleanup stackdump test: %s\n", reason);
 }
 
-TEST_F(coredump, stackdump)
+TEST_F_TIMEOUT(coredump, stackdump, 120)
 {
 	struct sigaction action = {};
 	unsigned long long stack;
-- 
2.39.5



