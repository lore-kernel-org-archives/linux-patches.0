Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833D819AD5C;
	Thu,  6 Jun 2024 14:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683372; cv=none; b=tcN19HhhzBDD7VSud2VQQtitP6UkJJ+B/CTp1fX/uc8YpJm8nsGM5HyJ9Z3k5mRC8+crHPGwtx/jRBMRFV6DP0GafBGeCB0QIF36C4adq7/dhkSKI/I1gbT9Jdqw0QkZfeKhmMzux9J2nx3YALdmqJE+Q6PolxoYINV0V/Dl/wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683372; c=relaxed/simple;
	bh=hP35jpauiAoknMKuEchWRr/hxt58931RxZMGhpO1Ao4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/n/fMk/cQrX7uolqiv/9poNtSSJUZTZkeMoyKvmHBaUEeYy4drlehXqy9229ZCBcaPllSVPVEsNGXUOyAm0bhHdEe58M3u1p0lp123JSXTrgn46e49pSc1faKbW9MS76QQwgDc75nok/lyE30E0qLLJLAPC9FBL++c5QuOtkbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmttYEFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmttYEFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591AAC32786;
	Thu,  6 Jun 2024 14:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683372;
	bh=hP35jpauiAoknMKuEchWRr/hxt58931RxZMGhpO1Ao4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmttYEFa1yvYStT/4ZYsYftYT42wpMKAeykygfvak/jGVoyljyMQorwyAN85AswFA
	 wD3w4HRyZ1KTY4GXNpc0OXzzJUc4vW9ZUbikAGTaTb4TQU//iwqF9KeYBOtUjyAn5i
	 OxpUyplwrrT9TZzeD3cf7qNsIMxv3b2SGgeMWDCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 256/473] x86/insn: Add VEX versions of VPDPBUSD, VPDPBUSDS, VPDPWSSD and VPDPWSSDS
Date: Thu,  6 Jun 2024 16:03:05 +0200
Message-ID: <20240606131708.430229388@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d94bc4e3e5849..8eaf140172c58 100644
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
index d94bc4e3e5849..8eaf140172c58 100644
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



