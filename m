Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773B7240611;
	Tue, 29 Apr 2025 18:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950731; cv=none; b=vA+1XqWF2EhbWFNCbEAjPUHpJaYzpIvxW4rh6TCDwNBaK7hTlHuTdUFV0oCcdj85LiuzZmbMk8pSzBIYRo4QczRmIb1bqDuOrvUV9DuUwq2p91umVSQ60dfrIDeSBA0lS9Io5vUXzwlryidwZNFGhmirOF6/vY+6fIUJtrRnWkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950731; c=relaxed/simple;
	bh=nEwHaSZOEAhkBct8JurOTjvC7W5GF1Vkgv3kLo+Ic5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOr/GN7i97mAma8LDSFsXh1pE2FjKf7CvKFIPH5tbq/cJ3y9v3/+ifHaVY0LBI1lq6LHfDYVNaBcWaoqGIb7c/V0TMkaWsn5yDP7EEzuDU+ypDfTWXPQAeNTR35rLKnRy9H0gB6rDoWC9HrqcB6hNCJMraq0OtGaZBslHXPxLFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/CqVcGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/CqVcGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59ACBC4CEE3;
	Tue, 29 Apr 2025 18:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950730;
	bh=nEwHaSZOEAhkBct8JurOTjvC7W5GF1Vkgv3kLo+Ic5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/CqVcGq0cNKlr0M5Vy8DV/yrRrYsdd/9nki9c9jUL0wMn0/I6wPw+s3/DSS8d00g
	 477+H5Y3awZL+HPTHQo/BQMecZI4ApTUXuwhl//3+RVOCoXv729J1UGccaq0EVYIP4
	 qPodcu7cmah3AfUQCEdzyWRA+ii42dyjxxZys840=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pi Xiange <xiange.pi@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Christian Ludloff <ludloff@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tony Luck <tony.luck@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	John Ogness <john.ogness@linutronix.de>,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	x86-cpuid@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/204] x86/cpu: Add CPU model number for Bartlett Lake CPUs with Raptor Cove cores
Date: Tue, 29 Apr 2025 18:44:34 +0200
Message-ID: <20250429161106.997841961@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pi Xiange <xiange.pi@intel.com>

[ Upstream commit d466304c4322ad391797437cd84cca7ce1660de0 ]

Bartlett Lake has a P-core only product with Raptor Cove.

[ mingo: Switch around the define as pointed out by Christian Ludloff:
         Ratpr Cove is the core, Bartlett Lake is the product.

Signed-off-by: Pi Xiange <xiange.pi@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Christian Ludloff <ludloff@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: "Ahmed S. Darwish" <darwi@linutronix.de>
Cc: x86-cpuid@lists.linux.dev
Link: https://lore.kernel.org/r/20250414032839.5368-1-xiange.pi@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index f81a851c46dca..652c0137e909f 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -159,6 +159,8 @@
 #define INTEL_FAM6_GRANITERAPIDS_D	0xAE
 #define INTEL_GRANITERAPIDS_D		IFM(6, 0xAE)
 
+#define INTEL_BARTLETTLAKE		IFM(6, 0xD7) /* Raptor Cove */
+
 /* "Hybrid" Processors (P-Core/E-Core) */
 
 #define INTEL_FAM6_LAKEFIELD		0x8A	/* Sunny Cove / Tremont */
-- 
2.39.5



