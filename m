Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4D41C9B61;
	Tue,  8 Oct 2024 12:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391570; cv=none; b=OosxlP+Bqn7yq9eLbAeMXMhWhO7atRrPrGMORJeGQz6M0kj0chuz+rG78fvMvsX0Ph7rXgzRon1KtHvBgCRK9SKQ0yDn2OLYNWLyFI8Fr9J8iFyjK+CPujBttWrufSuuZ4FTdBzzqOSP3j07kzH+fY1PvE4Knw/jVeZRcDZqR28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391570; c=relaxed/simple;
	bh=ZO6qsB5MbsgZRKCPHriMToDSCO5oboI1O+EGFjvgRv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oH1aEAIrauu3qC75B0oWhnLvIvECBkwyyYyCpJg4MG8U6OrHeIU2NREz1sdmFqeVlSKI+5+zPtUyd9ZYCWtdIRifgfiIICcLs/GwfNLFxv51ssPrFn8kYfPpfWO1WA6KOgg6QOL6Z8hk/lCCdUv7r0W5HC2t6G9blpE2ErX62YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjiuamDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjiuamDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892E1C4CEC7;
	Tue,  8 Oct 2024 12:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391569;
	bh=ZO6qsB5MbsgZRKCPHriMToDSCO5oboI1O+EGFjvgRv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjiuamDaHoSMqh3LU6CbXHOnGr6+bon2YQHSl+6TomqZ7TPaHPwRJmQbK6n1xUUa5
	 yK5nrk5EQ63DOp36xx+Qq4AFVCwjlJEmJ4yEVSOEO10t0TNjktTEWENWLqjUhXuOv/
	 ZLUbyofBkRqBW80V5m3qPHkRvCMVsc6whqt8nZq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Shanavas.K.S" <shanavasks@gmail.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 156/558] x86/bugs: Add missing NO_SSB flag
Date: Tue,  8 Oct 2024 14:03:06 +0200
Message-ID: <20241008115708.500790997@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Sneddon <daniel.sneddon@linux.intel.com>

[ Upstream commit 23e12b54acf621f4f03381dca91cc5f1334f21fd ]

The Moorefield and Lightning Mountain Atom processors are
missing the NO_SSB flag in the vulnerabilities whitelist.
This will cause unaffected parts to incorrectly be reported
as vulnerable. Add the missing flag.

These parts are currently out of service and were verified
internally with archived documentation that they need the
NO_SSB flag.

Closes: https://lore.kernel.org/lkml/CAEJ9NQdhh+4GxrtG1DuYgqYhvc0hi-sKZh-2niukJ-MyFLntAA@mail.gmail.com/
Reported-by: Shanavas.K.S <shanavasks@gmail.com>
Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240829192437.4074196-1-daniel.sneddon@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d4e539d4e158c..be307c9ef263d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1165,8 +1165,8 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 
 	VULNWL_INTEL(INTEL_CORE_YONAH,		NO_SSB),
 
-	VULNWL_INTEL(INTEL_ATOM_AIRMONT_MID,	NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_INTEL(INTEL_ATOM_AIRMONT_NP,	NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(INTEL_ATOM_AIRMONT_MID,	NO_SSB | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | MSBDS_ONLY),
+	VULNWL_INTEL(INTEL_ATOM_AIRMONT_NP,	NO_SSB | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
 
 	VULNWL_INTEL(INTEL_ATOM_GOLDMONT,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 	VULNWL_INTEL(INTEL_ATOM_GOLDMONT_D,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
-- 
2.43.0



