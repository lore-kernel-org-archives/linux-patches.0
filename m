Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B22115CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9734C433B5;
	Tue,  8 Nov 2022 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916962;
	bh=l+R1gEp12J67Pcat2v/1p11MQq42VNv4uHYJ3g1gbj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+ZvSXkd3zuQgCX/T8r+R8lIFXeMD2pXQ9swlfiqIeOAKkSMLedAU02mC0Lpa2zd3
	 bA4aCdErJt0OnxhJfsn/7Z4TWfSZte2NBS/Uhp2HYI3en+WG29F8ORbXedpoMFCZZP
	 WcauXYV0Z+aNJZUXau6hpZUNb/Ad3x+GmqTTNWuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.0 157/197] perf/x86/intel: Add Cooper Lake stepping to isolation_ucodes[]
Date: Tue,  8 Nov 2022 14:39:55 +0100
Message-Id: <20221108133402.081125352@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kan Liang <kan.liang@linux.intel.com>

commit 6f8faf471446844bb9c318e0340221049d5c19f4 upstream.

The intel_pebs_isolation quirk checks both model number and stepping.
Cooper Lake has a different stepping (11) than the other Skylake Xeon.
It cannot benefit from the optimization in commit 9b545c04abd4f
("perf/x86/kvm: Avoid unnecessary work in guest filtering").

Add the stepping of Cooper Lake into the isolation_ucodes[] table.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221031154550.571663-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4891,6 +4891,7 @@ static const struct x86_cpu_desc isolati
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 5, 0x00000000),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 6, 0x00000000),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 7, 0x00000000),
+	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		11, 0x00000000),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_L,		 3, 0x0000007c),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE,		 3, 0x0000007c),
 	INTEL_CPU_DESC(INTEL_FAM6_KABYLAKE,		 9, 0x0000004e),


