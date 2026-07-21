Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1EB46A5FD;
	Tue, 21 Jul 2026 15:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649032; cv=none; b=AjJooYhrl4M3AIBTQD6+UtcjCp/b4pbbR7iTNBtlIHIzZms9j33PNVudIwud/rDK8bp3Lw6DGkbGIz6pTZKgnDrTAw86JEC8Gl/9zkvyY7rfyjYkTKNJhrNru1T/rTmCcNoOKsjPD/1nXpg4ept7kG7Gry+XM3xWE/WjT9mppuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649032; c=relaxed/simple;
	bh=dzkvdaRoUj9/4/kj128+hqYUCq8nKiQ0nk1IlFWPdt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jE82OoT4ALApxA84HtPX5wtMA6EMYxdlZ9ZT1Tgsw7n3FV9VjEQqaRKRFoE1xroDrsvyaTq1IBJtMPQU6DrttqLsbXecGPqs+LIBiMCzNITMNkLXMOqTnWn55lR6SYIED2PuUT41hwy1hfeVCBnSWji+aqRulZaj0FS/Rq8GWzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weZXjywL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weZXjywL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA591F000E9;
	Tue, 21 Jul 2026 15:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649031;
	bh=Nr0xZTfzBedn/wJmLECOGArrBmO6NKGBVBj04+LmyCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=weZXjywL85dyM2JBbDL4knWVVPA3JfjIr/n3ErOnf0CMd0bjtajx/d61VgZwbicZc
	 OPOc853sOfdNUTohY0a6cHx+NYdG1gRvBJ4g+fMXdGn2wULUaX8PiJwz5xMIpxnbxX
	 CmYlVJfacMmWk4FL2UKR3jFxNRddjK1YLenncz7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0425/2077] x86/cpu: Keep the PROCESSOR_SELECT menu together
Date: Tue, 21 Jul 2026 17:01:38 +0200
Message-ID: <20260721152602.765686888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1df61a8b2d01c560822a0421f2a76af7fda34c1f ]

Having a stray kconfig symbol in the middle of the PROCESSOR_SELECT menu
(this symbol plus its dependent symbols) causes the menu dependencies
not to be displayed correctly in "make {menu,n,g,x}config".

Move the BROADCAST_TLB_FLUSH symbol away from the PROCESSOR_SELECT menu
so that the list of processors is displayed correctly.

Fixes: 767ae437a32d ("x86/mm: Add INVLPGB feature and Kconfig entry")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20260519173526.10985-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig.cpu | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index d7ba9219cb47dc..df003a42d25a6d 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -334,10 +334,6 @@ menuconfig PROCESSOR_SELECT
 	  This lets you choose what x86 vendor support code your kernel
 	  will include.
 
-config BROADCAST_TLB_FLUSH
-	def_bool y
-	depends on CPU_SUP_AMD && 64BIT
-
 config CPU_SUP_INTEL
 	default y
 	bool "Support Intel processors" if PROCESSOR_SELECT
@@ -458,3 +454,7 @@ config CPU_SUP_VORTEX_32
 	  makes the kernel a tiny bit smaller.
 
 	  If unsure, say N.
+
+config BROADCAST_TLB_FLUSH
+	def_bool y
+	depends on CPU_SUP_AMD && 64BIT
-- 
2.53.0



