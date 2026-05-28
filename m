Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46882F260C;
	Thu, 28 May 2026 20:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998646; cv=none; b=FdqLISzWOncDzmINxSJr1Bm/QIUHzf0pYaxRionXymbGJ7Q54PgmbAgnGN6DEdLiXlQ9QAVf3dykKZNE0T/xzY0KeIWpqq1eBJdvPU5rgWba9NVXb2//xwLdcFbrOQFEtH5809cgR5PlBaXfmuS1xTErHShE9IQBXwndNFJJgMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998646; c=relaxed/simple;
	bh=atSQsk2i2kFhM8BGnWMNj7NEJJFpw+UGwj0gigSpKus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBuTuUfPSNjxuuGclxgnCUzbcEhvlIrav9iQK8Jd/WkeO0GH+NHuh5ij/fbBsqWniHiaidHwMMlA1IYtaoGKDKgGKh4vVOdfkW6X+4eMocNVK6jR8liKOkAlEjMFwgEJEGerhwfXRFbj/7qYHMy4y3AOlmY8H54jQCd5fE0ZkpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjIsZKp+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjIsZKp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563791F000E9;
	Thu, 28 May 2026 20:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998645;
	bh=o/Alw1AcOvkwoYb/OGjjUKEZ36ZWM630e9V9dWUwkDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HjIsZKp+8yihn29Ov/285tLqZzquVY9LJ8LcRduA0dPUuJLL8smx22uGUjsZRE/Ub
	 SLIRqk6rSfUaj3leFsRvqY/hzBqI/N0BUAtig9+9b9GgXSJFGjXuRY+/QZIchxG0xO
	 WjcWTJbwCmR1tNCBgwCLfxmJYvt4poJzwIdLsx4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Gautam Menghani <gautam@linux.ibm.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 248/461] powerpc: fix dead default for GUEST_STATE_BUFFER_TEST
Date: Thu, 28 May 2026 21:46:17 +0200
Message-ID: <20260528194654.328115604@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit aef656a0e6c01796190bb5bd2bdba1c644ed7811 ]

The GUEST_STATE_BUFFER_TEST config option should default
to KUNIT_ALL_TESTS so that if all tests are enabled then
it is included, but currently the 'default KUNIT_ALL_TESTS'
statement is shadowed by 'def_tristate n',
meaning that this second default statement is currently dead code.

It looks to me like the commit
6ccbbc33f06a ("KVM: PPC: Add helper library for Guest State Buffers")
intended to set the default to KUNIT_ALL_TESTS, but mistakenly
missed the def_tristate.

This dead code was found by kconfirm, a static analysis tool for Kconfig.

Fixes: 6ccbbc33f06a ("KVM: PPC: Add helper library for Guest State Buffers")
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Tested-by: Gautam Menghani <gautam@linux.ibm.com>
Reviewed-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260405161545.161006-1-julianbraha@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig.debug | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index f15e5920080ba..e8718bc13eeb1 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -83,11 +83,10 @@ config MSI_BITMAP_SELFTEST
 	depends on DEBUG_KERNEL
 
 config GUEST_STATE_BUFFER_TEST
-	def_tristate n
+	def_tristate KUNIT_ALL_TESTS
 	prompt "Enable Guest State Buffer unit tests"
 	depends on KUNIT
 	depends on KVM_BOOK3S_HV_POSSIBLE
-	default KUNIT_ALL_TESTS
 	help
 	  The Guest State Buffer is a data format specified in the PAPR.
 	  It is by hcalls to communicate the state of L2 guests between
-- 
2.53.0



