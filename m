Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC631AC8AE;
	Thu, 15 Aug 2024 14:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731501; cv=none; b=JcLf9grUlRdwxVEWUhdu6Bwhrs6iBk/YWVkVGFQDFKlc/5rOGl+WIvXHWTdv+q2/c+/N3Cn7HPTHQjBQN9AiHCEAnBsSKnfvAvS6gWO5Jsks5l48lS7jxMoumKpP+vbjl8FgxC99+5L09lonAwKHw1fbJLSGWmtKvKDqJUFIcbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731501; c=relaxed/simple;
	bh=hvSoCQeEnSXomsYuMLrl83yGpdIy26IMFrXpa0m2ftI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBJcGtAtV0+yn6gOJZVqyhaZIJByVkaMzUWK9BDEbfrtHeXVheH9j2V7Q8oTtVNZ8fMKrnTvwMA8iwyj4fH74Ij/LUYCpBoy5p5VgTt3/VqYEZYVYx1SHf68m/nhEUadTKjhkNvrqb6OyJPbBpx2fFaOjDw/4HDMriikanZBhT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7xZ8V9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7xZ8V9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CA5C32786;
	Thu, 15 Aug 2024 14:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731501;
	bh=hvSoCQeEnSXomsYuMLrl83yGpdIy26IMFrXpa0m2ftI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7xZ8V9C3cyfDjQ1sIA2LXqK9MJ8LPvbwrbLNv8xMsyAwSXWUHWXe7hTwPJGvvVAx
	 nsv/utzVp3a2iLUFzpr4kPltEhBQ4ChCJM1zPYMhiIH/EVS5kp/27HQFyuoqa3Nk7d
	 NcF2z4hfYdMDce2MufI0wyoLQS6REpmwudlQqibA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 149/259] ASoC: Intel: Convert to new X86 CPU match macros
Date: Thu, 15 Aug 2024 15:24:42 +0200
Message-ID: <20240815131908.543219788@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit d51ba9c6663d7171681be357f672503f4e2ccdc1 ]

The new macro set has a consistent namespace and uses C99 initializers
instead of the grufty C89 ones.

Get rid the of the local macro wrappers for consistency.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lkml.kernel.org/r/20200320131510.594671507@linutronix.de
Stable-dep-of: 9931f7d5d251 ("ASoC: Intel: use soc_intel_is_byt_cr() only when IOSF_MBI is reachable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-intel-quirks.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/sound/soc/intel/common/soc-intel-quirks.h b/sound/soc/intel/common/soc-intel-quirks.h
index 645baf0ed3dd1..a88a91995ce1a 100644
--- a/sound/soc/intel/common/soc-intel-quirks.h
+++ b/sound/soc/intel/common/soc-intel-quirks.h
@@ -16,13 +16,11 @@
 #include <asm/intel-family.h>
 #include <asm/iosf_mbi.h>
 
-#define ICPU(model)	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_ANY, }
-
 #define SOC_INTEL_IS_CPU(soc, type)				\
 static inline bool soc_intel_is_##soc(void)			\
 {								\
 	static const struct x86_cpu_id soc##_cpu_ids[] = {	\
-		ICPU(type),					\
+		X86_MATCH_INTEL_FAM6_MODEL(type, NULL),		\
 		{}						\
 	};							\
 	const struct x86_cpu_id *id;				\
@@ -33,11 +31,11 @@ static inline bool soc_intel_is_##soc(void)			\
 	return false;						\
 }
 
-SOC_INTEL_IS_CPU(byt, INTEL_FAM6_ATOM_SILVERMONT);
-SOC_INTEL_IS_CPU(cht, INTEL_FAM6_ATOM_AIRMONT);
-SOC_INTEL_IS_CPU(apl, INTEL_FAM6_ATOM_GOLDMONT);
-SOC_INTEL_IS_CPU(glk, INTEL_FAM6_ATOM_GOLDMONT_PLUS);
-SOC_INTEL_IS_CPU(cml, INTEL_FAM6_KABYLAKE_L);
+SOC_INTEL_IS_CPU(byt, ATOM_SILVERMONT);
+SOC_INTEL_IS_CPU(cht, ATOM_AIRMONT);
+SOC_INTEL_IS_CPU(apl, ATOM_GOLDMONT);
+SOC_INTEL_IS_CPU(glk, ATOM_GOLDMONT_PLUS);
+SOC_INTEL_IS_CPU(cml, KABYLAKE_L);
 
 static inline bool soc_intel_is_byt_cr(struct platform_device *pdev)
 {
-- 
2.43.0



