Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CEC15FCFB;
	Mon, 27 May 2024 19:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838581; cv=none; b=BAFTiF7KhRfGIyYlnHC9GY7PFCFurysem+rMSdjYLgBE6/nrYs91hOHFb8nQfJXOA08GIYQXSkDkW4WM0pWmdsx60spQn8OfDMpkQ8pxbPdEGK6lKqaIiuW6ruVc+F3NtgTZg+OunUmjyaYtrpyApR9v2VEtSXe4JkOSNBdOCKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838581; c=relaxed/simple;
	bh=zcEIEW53WBCLDEEa1oDYVPTVgq9F0CbNJx2ztZuIpDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V86TIvqjHIt9ZREi8pUn0EGpG0PTiPw4BbpeuGqfmRj94cwCMiSpKS/AffcjOXB0ZLowLewc21Lno/TTlcy4IAedjY5w6qAfzUMYaA8bYe1EwGc9CBO0/Vp6AJsCDbIM5bONLax64xsscxXUc/rdCJrVGw1E88WX1viIClDu2Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HW5bqlxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HW5bqlxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8DEC32781;
	Mon, 27 May 2024 19:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838580;
	bh=zcEIEW53WBCLDEEa1oDYVPTVgq9F0CbNJx2ztZuIpDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HW5bqlxSs8ayx6Ap+d1AGmEes4CKNgwilFI1xqIi96Ab0kFp9AOmaK0icWRfPFlL3
	 c/xtTOoE5Cq3YLORqQsDQRZjiCqPgWJdq9Tnu8DRm6ILE7mM1F13zJeDXw+B3DZu6U
	 7Nzl7ggFqji5/RkxqTL9T7Hz5rR/+q/5q/PT4RJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 449/493] x86/insn: Add VEX versions of VPDPBUSD, VPDPBUSDS, VPDPWSSD and VPDPWSSDS
Date: Mon, 27 May 2024 20:57:31 +0200
Message-ID: <20240527185644.918502356@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit b8000264348979b60dbe479255570a40e1b3a097 ]

The x86 instruction decoder is used not only for decoding kernel
instructions. It is also used by perf uprobes (user space probes) and by
perf tools Intel Processor Trace decoding. Consequently, it needs to
support instructions executed by user space also.

Intel Architecture Instruction Set Extensions and Future Features manual
number 319433-044 of May 2021, documented VEX versions of instructions
VPDPBUSD, VPDPBUSDS, VPDPWSSD and VPDPWSSDS, but the opcode map has them
listed as EVEX only.

Remove EVEX-only (ev) annotation from instructions VPDPBUSD, VPDPBUSDS,
VPDPWSSD and VPDPWSSDS, which allows them to be decoded with either a VEX
or EVEX prefix.

Fixes: 0153d98f2dd6 ("x86/insn: Add misc instructions to x86 instruction decoder")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20240502105853.5338-4-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/x86-opcode-map.txt       | 8 ++++----
 tools/arch/x86/lib/x86-opcode-map.txt | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 940913550ed83..d1ccd06c53127 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -698,10 +698,10 @@ AVXcode: 2
 4d: vrcp14ss/d Vsd,Hpd,Wsd (66),(ev)
 4e: vrsqrt14ps/d Vpd,Wpd (66),(ev)
 4f: vrsqrt14ss/d Vsd,Hsd,Wsd (66),(ev)
-50: vpdpbusd Vx,Hx,Wx (66),(ev)
-51: vpdpbusds Vx,Hx,Wx (66),(ev)
-52: vdpbf16ps Vx,Hx,Wx (F3),(ev) | vpdpwssd Vx,Hx,Wx (66),(ev) | vp4dpwssd Vdqq,Hdqq,Wdq (F2),(ev)
-53: vpdpwssds Vx,Hx,Wx (66),(ev) | vp4dpwssds Vdqq,Hdqq,Wdq (F2),(ev)
+50: vpdpbusd Vx,Hx,Wx (66)
+51: vpdpbusds Vx,Hx,Wx (66)
+52: vdpbf16ps Vx,Hx,Wx (F3),(ev) | vpdpwssd Vx,Hx,Wx (66) | vp4dpwssd Vdqq,Hdqq,Wdq (F2),(ev)
+53: vpdpwssds Vx,Hx,Wx (66) | vp4dpwssds Vdqq,Hdqq,Wdq (F2),(ev)
 54: vpopcntb/w Vx,Wx (66),(ev)
 55: vpopcntd/q Vx,Wx (66),(ev)
 58: vpbroadcastd Vx,Wx (66),(v)
diff --git a/tools/arch/x86/lib/x86-opcode-map.txt b/tools/arch/x86/lib/x86-opcode-map.txt
index 940913550ed83..d1ccd06c53127 100644
--- a/tools/arch/x86/lib/x86-opcode-map.txt
+++ b/tools/arch/x86/lib/x86-opcode-map.txt
@@ -698,10 +698,10 @@ AVXcode: 2
 4d: vrcp14ss/d Vsd,Hpd,Wsd (66),(ev)
 4e: vrsqrt14ps/d Vpd,Wpd (66),(ev)
 4f: vrsqrt14ss/d Vsd,Hsd,Wsd (66),(ev)
-50: vpdpbusd Vx,Hx,Wx (66),(ev)
-51: vpdpbusds Vx,Hx,Wx (66),(ev)
-52: vdpbf16ps Vx,Hx,Wx (F3),(ev) | vpdpwssd Vx,Hx,Wx (66),(ev) | vp4dpwssd Vdqq,Hdqq,Wdq (F2),(ev)
-53: vpdpwssds Vx,Hx,Wx (66),(ev) | vp4dpwssds Vdqq,Hdqq,Wdq (F2),(ev)
+50: vpdpbusd Vx,Hx,Wx (66)
+51: vpdpbusds Vx,Hx,Wx (66)
+52: vdpbf16ps Vx,Hx,Wx (F3),(ev) | vpdpwssd Vx,Hx,Wx (66) | vp4dpwssd Vdqq,Hdqq,Wdq (F2),(ev)
+53: vpdpwssds Vx,Hx,Wx (66) | vp4dpwssds Vdqq,Hdqq,Wdq (F2),(ev)
 54: vpopcntb/w Vx,Wx (66),(ev)
 55: vpopcntd/q Vx,Wx (66),(ev)
 58: vpbroadcastd Vx,Wx (66),(v)
-- 
2.43.0



