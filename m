Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A8258F089;
	Wed,  9 Sep 2026 14:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963541; cv=none; b=uuS9cUQ6xvf6+NqHgacygjSAWCryP0QMRAV99z7IELjg8/8gtjMPi2rqXh5xwlfByL6CcwhjXAVl1YCJXJL4+rlJlQlq2Yd6zoztRAjHyYHXyKBr5M34+5PRhyBU3BO8E22UAj6UgESoG/Gc09eTGTMJxDst2zN0RHmiNfm+UXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963541; c=relaxed/simple;
	bh=b5aAlpTbgwaaVhnBVjZjKoS0608jpHY9At6rd/iPPwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2a7waRuN8kROS5XguNgcqGRuPWfj9Smkc1HTvCFxx4xMIqGhRmQo1uTXxK2Wj8lxHFCblFip2uKD/J+RrZGRwGEYvzBJDlmPRFCSmCnv5btPKSvCGPupS6nVtEf8vMJo84mGqTR6YNvgqjErLUgu3JizrB5NxHgcyBocYe7X98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPfCC8yP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPfCC8yP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33B61F00A3D;
	Wed,  9 Sep 2026 14:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963540;
	bh=gaqI+NgbV9GcrEd4D2oKbYKEIEV4vM8Foo838fp2y/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iPfCC8yPa4Q4PChHipVmySyNy14VtqVxVN1MYmIQ2R4WMJVQ5AKG+mpgDNT6lQOwV
	 m6HrB4Um+UOKhBIewYfP98j8U6k38up7XSO+YqeeDfjnalAX1HpznQhTLsWqVK6ui7
	 C/oHHNvUGEwx+gxta3zmqaasx7WrhsnmsYEqRaJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 113/583] pmdomain: airoha: fix unselectable AIROHA_CPU_PM_DOMAIN kconfig
Date: Wed,  9 Sep 2026 15:36:38 +0200
Message-ID: <20260909134242.045943772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Christian Marangi <ansuelsmth@gmail.com>

commit 6d94c47a2e3a38170a0a141547e4c52fbe232cc3 upstream.

The AIROHA_CPU_PM_DOMAIN config was wrongly guarded under the Mediatek PM
Domains menu and was unselectable.

Move it outside the menu so it's now visible and correctly selectable by
default on Airoha SoC.

Cc: stable@vger.kernel.org
Fixes: 82e703dd438b ("pmdomain: airoha: Add Airoha CPU PM Domain support")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/mediatek/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pmdomain/mediatek/Kconfig
+++ b/drivers/pmdomain/mediatek/Kconfig
@@ -26,9 +26,12 @@ config MTK_SCPSYS_PM_DOMAINS
 	  Control Processor System (SCPSYS) has several power management related
 	  tasks in the system.
 
+endmenu
+
 config AIROHA_CPU_PM_DOMAIN
 	tristate "Airoha CPU power domain"
 	default ARCH_AIROHA
+	depends on ARCH_AIROHA || COMPILE_TEST
 	depends on HAVE_ARM_SMCCC
 	depends on PM
 	select PM_GENERIC_DOMAINS
@@ -37,5 +40,3 @@ config AIROHA_CPU_PM_DOMAIN
 
 	  CPU frequency and power is controlled by ATF with SMC command to
 	  set performance states.
-
-endmenu


