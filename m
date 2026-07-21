Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E34846A603;
	Tue, 21 Jul 2026 15:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649216; cv=none; b=a6yqJDNiBr8ciNEdrstJu7rv+OZMOoHeeyVnejZOilR+vGOXNxpaLkAD3B27HeIn1l9+jciO6mhwMwl+gGb4DxSqVx0LtPuKQTFz4ub0es3oxUqg5ItMqY/G446h3DZB3QmdPmEnj2aQt+oJM4iHIL98DIJYCoFXcxwi8+d4IV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649216; c=relaxed/simple;
	bh=oW+NxAsB+/8F0G2z4IXrLK2arhCNx39V+6EyNI2XPmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zxo0NStVxBRfvePoCWeTCj8C50N9Ejiqrni6ZRXgIsqvKZzFhK3kiIaREaoerVR8O07s0Otmex53kLTO5D6SndNr/b6V32HsJU+QiP4+hI1IxENIQy9TCuxi3HHfM462lDS6Czi3L4HYgH0V5ZJ/ZJ4u2tgdBpAP9p0I9tbPuUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpyGgYm1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpyGgYm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54951F000E9;
	Tue, 21 Jul 2026 15:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649215;
	bh=k3ZssowYqlyvKZnJg9dMO/oiF9yaP/IXUocVndkiuQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpyGgYm1P2c+YHm3KeaMXv4IljUsMPDKBUoUHzprOvxdv2QoS3wyRaUAfCcWPDRnX
	 8/dHrEhPpCHIoTveJYbFILqCI9aoSLJ/2J/sAzpDXcBese2Xncj4NeUIT9eUhkDTKa
	 0VCIptBu4hRVl2GdAAKpbtohCd+74MkEW4bRJODY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Chang <junxiao.chang@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0493/2077] x86/cpu: Remove obsolete aperfmperf_get_khz() declaration
Date: Tue, 21 Jul 2026 17:02:46 +0200
Message-ID: <20260721152604.439368348@linuxfoundation.org>
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

From: Junxiao Chang <junxiao.chang@intel.com>

[ Upstream commit a5f28da54f36f1a8b289d9bdd3e780b2ede0da6f ]

aperfmperf_get_khz() was replaced by arch_freq_get_on_cpu().
The remaining declaration in the header file is no longer used
and should be removed.

Fixes: f3eca381bd49 ("x86/aperfmperf: Replace arch_freq_get_on_cpu()")
Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://patch.msgid.link/20260606021514.1433619-1-junxiao.chang@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/cpu.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 5c7a3a71191a14..dca2d5845e4276 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -75,7 +75,6 @@ static inline struct amd_northbridge *amd_init_l3_cache(int index)
 }
 #endif
 
-unsigned int aperfmperf_get_khz(int cpu);
 void cpu_select_mitigations(void);
 
 extern void x86_spec_ctrl_setup_ap(void);
-- 
2.53.0



