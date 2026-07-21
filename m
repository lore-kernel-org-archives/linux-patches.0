Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4225415F3F;
	Tue, 21 Jul 2026 17:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656332; cv=none; b=mriBPfFuio1w4wgn8NyBlhFWEU/1Ea7F4KTlFV+wkLR15Ixdzue0X7t+2SJ4A9mcP90ue2AKn2U1fTwLCJvWuIAme5U15mmdmQI3pTMEC7Uz+1dYBPoREXYrIsE2aCms65Do7MWCy1nQJAbzsaaJfrpngDUAqBTVO1IMSYrFQt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656332; c=relaxed/simple;
	bh=3MPDorpbRB0VsOAsOsAUPyPRQ0ko6+5e66qrZ6MO05I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYqHuXxP3LjzTvO6c9ZVZPycCmZ9oysHqNDy7uRMXyduQzmScspbC2REUZvwOimrgtl03M6+t7w0qCI62JXVOjDW1CJInurwRLHyrMJVbo6Yjl4VLw41uGHyt4wDgiN6aG4g5gx5tVtRtncdHkf9NVqdfKIhQL+H7LQ+b5R0bOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlAPr+Ed; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlAPr+Ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1A51F000E9;
	Tue, 21 Jul 2026 17:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656331;
	bh=XOhV0Wvob9r/trM1MNfWBJNzKqdopa8WxtVFSTEgx3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlAPr+EdTDDY4HZ8iKCY8TkIxwYsbuEkjNJ1Xy2xjQhJFxmG6tYal9yghcLJVLnRE
	 46BiXaSZvZu4SlmH3WCuCJz5tEp2hGfPp8wlUgazLysSuD0QzW3CgqJ9YJIaMSXUS7
	 BZT1sKg9x2ME60jMZ60NszKRwNTFBmS2VWSPzuYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Chang <junxiao.chang@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0347/1611] x86/cpu: Remove obsolete aperfmperf_get_khz() declaration
Date: Tue, 21 Jul 2026 17:07:43 +0200
Message-ID: <20260721152522.929356239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index bc38b2d56f26af..92032422a8298d 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -84,7 +84,6 @@ static inline struct amd_northbridge *amd_init_l3_cache(int index)
 }
 #endif
 
-unsigned int aperfmperf_get_khz(int cpu);
 void cpu_select_mitigations(void);
 
 extern void x86_spec_ctrl_setup_ap(void);
-- 
2.53.0



