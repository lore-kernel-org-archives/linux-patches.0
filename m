Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD81B411A09;
	Thu, 30 Jul 2026 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424025; cv=none; b=IVYGOy7gtB60tRYaPXIBjeQD+wNuGtvJlDwYCmgmjWYdgxkdoqEnmo67aqEfYu/KWTRD424g4fyGEXMItEQ4xHMbosi1FkvDu9hEXL89ZZi1bH9KN4lQuRURBPp1pmNy5RjbhNqhnbpmCPZ6+MNzWjhqzNWgeNxFiz1asBhXWSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424025; c=relaxed/simple;
	bh=Wzi5RLjZW+lMtdR1ZAKa/hkVv3iLBy1CbdTbilxPevM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrQuF/JtSEzR2/eZpxEb27YKFtVRKS6Fsfcwm4fyjDKmzSsHMjNZLtwCns4v0UbgpcicdQdl1VHEQBveenYN4S5lzB34ALnadte7ym0BSKF0zasA3zsq3ZS9OpDRfARLnwLzA6rI35oQMrqN8QlYTJ3CeOrH+75JXpid0E+JTXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQC8TFnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQC8TFnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1579F1F000E9;
	Thu, 30 Jul 2026 15:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424024;
	bh=NcdPyTmxPSFclV+DaIvzJ+YiXQ3uoz9ck1fVFC0NL3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQC8TFnKTisahKWjJQirxZTeP+kmea9DRg6SEIIdZ8dzpATgcGmvh61dyDjFj/2hW
	 bs+bzCnNmBnpYQmVX1lnhQj9Z+BTL/sxBm9PXweWRozRMxT5kF3XaLxAtVgRkdIDpN
	 LdKUKtG1kpg8A49XXh+cab7vw0LC8GYipPV+PEsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 248/675] selftests: af_unix: add USER_NS config
Date: Thu, 30 Jul 2026 16:09:38 +0200
Message-ID: <20260730141450.406707914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index b5429c15a53c75..41dbb03c747eb7 100644
--- a/tools/testing/selftests/net/af_unix/config
+++ b/tools/testing/selftests/net/af_unix/config
@@ -1,3 +1,4 @@
 CONFIG_AF_UNIX_OOB=y
 CONFIG_UNIX=y
 CONFIG_UNIX_DIAG=m
+CONFIG_USER_NS=y
-- 
2.53.0



