Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F48937CD45;
	Thu, 30 Jul 2026 15:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425810; cv=none; b=HZAv2dfbCSaBRKAGzbTpgJlZOKBw0G231Egv2eVrKMzNN9ii0hE7FCvmEKf2PPhpjQ7iBITDfyUNRecT2VbheGHiqq9ywqBXv6zwYI26vCs/WTflcdBqZ8/m61HH2L7y0MNz4jGdLw4P0zrs6cqXjLWPPFtvTyQevh2sOcgYofw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425810; c=relaxed/simple;
	bh=lWg0UOQecyVJS0ckKTd3ECN8OmaoRNzQX/jjJ7AO2aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiJN542HlzouieetJ00S0eQ4rBMkoPJZI2xVi9ZkFCcd+0Uo67fAS8K5IwjuEnixJ9bpE4ZF45CA3jQXcygpcD9aOs4VRNhN9bSnHhBrGOQyYJKV4f1yxxVoS2wC/LeMcgMo15S63/9Mzgp06HKwiUatz19HNlnj726MGudm6iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JudFECuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JudFECuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE811F000E9;
	Thu, 30 Jul 2026 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425809;
	bh=xq2SVjBGOjT4aCL63CpLPBRBUx9wPTLLRknJed9GhgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JudFECuYDyJSpI4KbwM+XppYo1W46fDGdKB2g8LGS2GnHla+7nSYwkMnZHvxijh0V
	 LtNwUFdvJx52Lwk3Dk3gcnz97P1iTjYRF7rZZ5dEIgxlqYq44qdxX3GhBrWf+FV8VS
	 n/nC9ZJ9vlHBBp9Er/tCVSLqSjiIsEopFLfP8jJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 200/602] selftests: af_unix: add USER_NS config
Date: Thu, 30 Jul 2026 16:09:52 +0200
Message-ID: <20260730141440.160725212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit f8b1abed736111f914b2c567d9a3db1f71e788e8 ]

This is required to use unshare(CLONE_NEWUSER).

This has not been seen on NIPA before, because the 'af_unix' tests are
executed with the 'net' ones, merging their config files. USER_NS is
present in tools/testing/selftests/net/config.

This issue is visible when only the af_unix config is used on top of the
default one. This is the recommended way to execute selftest targets.

Fixes: ac011361bd4f ("af_unix: Add test for sock_diag and UDIAG_SHOW_UID.")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260710-net-sft-fix-containers-v1-1-a2915c294ef5@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/af_unix/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/af_unix/config b/tools/testing/selftests/net/af_unix/config
index 37368567768cc0..9c4fb9c31c9506 100644
--- a/tools/testing/selftests/net/af_unix/config
+++ b/tools/testing/selftests/net/af_unix/config
@@ -1,3 +1,4 @@
 CONFIG_UNIX=y
 CONFIG_AF_UNIX_OOB=y
 CONFIG_UNIX_DIAG=m
+CONFIG_USER_NS=y
-- 
2.53.0



