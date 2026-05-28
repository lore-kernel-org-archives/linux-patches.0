Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20012DDC5;
	Thu, 28 May 2026 20:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999980; cv=none; b=M/lU8Llj7R7hSrBL6/iuZyvBV4xBK4vqTHfI9YKMFl/2EVrSOxHbAcqoAitWd+65OtW6vRuSydEyuRtprKmBCk1hgba7Ufq5i/Qmr40+N3PQJFbLNXVQLRWnkQCWfxoERxdNliyB4c2gmdGTfK9ZTRH6YObdbAorZaXv84mKNqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999980; c=relaxed/simple;
	bh=IH018Zf9+t5uVXQhNgMPcQ7uhSa6VrMNWJ9pbDGe6QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGQxGQ/HIi6fFZrGzoplAWQrLG+4T47Wdv+ZR5QSlC6lNhNrtZ3lChYRg9d62OazH40hNJW0DY3LGhFMx1+IfEV1CsA03U7W/Nvn96c2WGMi2aNw8UMKKHQuKljXADfBGBR4iGYJJP0UA8JO5svldF1J2s24sftiLcyGurft47s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpRQeLxU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpRQeLxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C541F000E9;
	Thu, 28 May 2026 20:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999978;
	bh=NVuj5DvsOX+gHc29pbRqDjbdll80JbzKfg7248DblaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IpRQeLxUfFoJpwP4sVzgjMG5EcfhgB1LFvdi43D5PuhgWTAIjZYGAKUaCdOfbtv9Y
	 M6Z0oIvE09HKeJUiJAHK/3QnAYviim8cRDmte0fI71TbdOFra3a4z4LpU+ii0422j/
	 me++1J6aHDHURvNhpv1vpZLXK3LGRn4/vayj2nh0=
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
Subject: [PATCH 6.18 232/377] powerpc: fix dead default for GUEST_STATE_BUFFER_TEST
Date: Thu, 28 May 2026 21:47:50 +0200
Message-ID: <20260528194645.107074648@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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



