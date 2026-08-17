Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC7133B6F4;
	Mon, 17 Aug 2026 15:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979190; cv=none; b=Qsffhy4nh6X2nyxsEL+yd9Zng1LOfqt2fkjbGL/LHC/4vDy9lmxR9hlGryRnE2My5lAv2GKAkrU6KOlFKNnwuas29cvJ2jZuTGNEGNZIuZXEOGrI0FDz2zSfwFF2C6MOQM0u27ajiBIMtfbdng0P3ZtoISXue2OpU8ldfE8S1vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979190; c=relaxed/simple;
	bh=ev8XgKmSW4nO3ir4UhPwxogk+qJpQKfXmvR/s2xzQYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJBFLOdDmlvUNffZzo17FcAIRmGbCSTTebWyXAEb1vyEnlfEeC/NDFgr98F2GFD2zIpWbQmvnv4RmepO0M7v2vpsbFhLVYp1fcutnMO12wNCD3bEM3ty7/uT896aO6PfmDi9eledP6Kn+sFdsuGpHe92JvBPnkNzZIrkR8w5lHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XN0LbeWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XN0LbeWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBDD1F00A3A;
	Mon, 17 Aug 2026 15:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979189;
	bh=xRPa9Je4G/ABcQoEIwbMkPwM3Y0UdYhaJniOaY4wEFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XN0LbeWqdTSYk78Tn3R33WvuHt5eUhFnTm2PdeIVyQp29+mzO5V6n+k8JUAYFliFQ
	 BmL1qXUpwTRqqk7QoyCH+ORDKsyMMh/BfntbQuepzE7hQZYV8nC2nn1fEHH+5dMqcp
	 RTKZJxeaPQwZFU+xvSS4MSU5riBLxjN3355bSBXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/609] selftests: af_unix: add USER_NS config
Date: Mon, 17 Aug 2026 15:27:14 +0200
Message-ID: <20260817132548.589597012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



