Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016104;
	b=A6MBRZ497eioufcQPSZCya17hxl8qOJI8Lp7v6yhUpJs7R6JBYc9B5vpnYjvWCiMadcB
	 sE5LguRd0pdKRPxAvf/rUbdmnpzdZMVuaItDEXFuXCtnFZC++HcA2LzKDhDo+nbZYCUQk
	 tBDz3H65S11pQYuHBoq6niIxGQ0mLK47h9djpVEGXVpH6gxFJwrcIn7JcZ2A64L2MKugY
	 hQemFoGiaef9BK9pUWDx9XxHWOHllrkHhH0BJ0mHcqBfAkZGAuDtYabwbGKMwotn0hOYf
	 LyrQ5lI7APJuTge+FfSIDMuPzb+9xDd8HfODjEdrTav239Mc6x8svUVi5rnBmvHr6bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F/xgoTGEm5/8vkpw4l649JDyfNHD8yu2gjmQpFsQAbc=;
	b=Dzmr87Ij/4rvu9iEixfOoZKECoS3mw61YRb9lWrXFw/NfPn30XBWB6Ns7526eglrtsgh
	 shcTelJ5kLMvAkPyD4/07X6JXIvVZ+9EIUmTG4ncyfyqUMZnoc0x2junWtc0bmd0+BYJR
	 dUxMErbAYmuBtoT76EL7hsdbyK4J5KPBvkVh1WbFa63RCC7K0kRWHDR3e9Fo0oDRaZiQZ
	 k308F/K0yATm08tt7SkhqGwGBFJtV3L0ah7A7Jjp09knKGFB/VBLCGDqRQR6Qh9XxEIsM
	 5/ozUXwEmlBeId6BF4ymRTsAXTsa09CJ9BBwaCOeu+E4VWNaReNWOa8QePaRQZerMvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KVGgefsk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE254606A332;
	Wed, 18 Nov 2026 15:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KVGgefsk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486AF1F000C5;
	Wed, 18 Nov 2026 15:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016103;
	bh=F/xgoTGEm5/8vkpw4l649JDyfNHD8yu2gjmQpFsQAbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVGgefsk5q8lkh2991IBp/nBlPoOx2+akF9ZHK9Yv0a+4jUUVO4qShRCWH4PbJCSI
	 UQEbkyFX5fuxmroGjMiRMifn4PrJmZHww7R3vB9Ovplveyklxtdv4dUU+h98O51R7N
	 vCPS8MhzbZihHBJxtd140chWEUnMGw/djgsNjAnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0383/2651] cpufreq/amd-pstate: Remove obsolete amd_dynamic_epp documentation
Date: Wed, 18 Nov 2026 15:27:03 +0100
Message-ID: <20261118150301.622320725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit c8663e0457e6e6c72006478f4b6da99060030ec1 ]

The amd_dynamic_epp command-line parameter was removed. Dynamic EPP
is now selected through the per-policy energy_performance_preference
attribute, which is already documented.

Fixes: 32692fcf61ed ("cpufreq/amd-pstate: Remove "amd_dynamic_epp" cmdline and "dynamic_epp" sysfs")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20260905010706.57380-1-kmehltretter@gmail.com
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 7 -------
 Documentation/admin-guide/pm/amd-pstate.rst     | 6 ------
 2 files changed, 13 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 4e64219c8da4c..3c2523dd6a8d7 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -501,13 +501,6 @@ Kernel parameters
 			disable
 			  Disable amd-pstate preferred core.
 
-	amd_dynamic_epp=
-			[X86]
-			disable
-			  Disable amd-pstate dynamic EPP.
-			enable
-			  Enable amd-pstate dynamic EPP.
-
 	amijoy.map=	[HW,JOY] Amiga joystick support
 			Map of devices attached to JOY0DAT and JOY1DAT
 			Format: <a>,<b>
diff --git a/Documentation/admin-guide/pm/amd-pstate.rst b/Documentation/admin-guide/pm/amd-pstate.rst
index 6fd72ba52df20..4c5d3d8acf645 100644
--- a/Documentation/admin-guide/pm/amd-pstate.rst
+++ b/Documentation/admin-guide/pm/amd-pstate.rst
@@ -481,12 +481,6 @@ For systems that support ``amd-pstate`` preferred core, the core rankings will
 always be advertised by the platform. But OS can choose to ignore that via the
 kernel parameter ``amd_prefcore=disable``.
 
-``amd_dynamic_epp``
-
-When AMD pstate is in auto mode, dynamic EPP will control whether the kernel
-autonomously changes the EPP mode. The default is disabled. It can be enabled
-with the kernel parameter ``amd_dynamic_epp=enable``.
-
 User Space Interface in ``sysfs`` - General
 ===========================================
 
-- 
2.53.0



