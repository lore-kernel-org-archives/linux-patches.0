Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE8E1990D1;
	Thu,  6 Jun 2024 14:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683130; cv=none; b=buqeatKyPCsfm9AkvgdYbVgv3Ai/9I9w4CU4EuUAm02LiQKs9IB61C0rZ4/q37mKNGh3aXSGwJrQhDG8UsCq7GeGbybpEGHAnxvgmZJ2xedsGa5ILp+V1O4gtm7ZMeN5PkP4mFADoXfktL5L29Y6uDGby0GfL3jahkTTTG3960A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683130; c=relaxed/simple;
	bh=vG2r3WqzwRPUUbs3wkivZziQD5/A+ssZkBkGXcXI5ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l5Oj1pYqxvZeI468ubu0y0/hYWuBE2KQalLt6aIr/VknDnAXPWu+UkhRVuVJyoahVQGuh5JqzxBxWHZtmwq7ELfATPVMSuxxpGGCnGIVYIsj8SKKXFvCjAups1RsyeqY2FZoVJ/at1AztcCF5CiSBkiCjuEgIeMgk+Zt1p+ZM8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxA07Tpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxA07Tpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA30FC32781;
	Thu,  6 Jun 2024 14:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683129;
	bh=vG2r3WqzwRPUUbs3wkivZziQD5/A+ssZkBkGXcXI5ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxA07Tprt3h7Y8/I35eKO4WyAR781zJb5NLMg+cwlOnSfA9FWy2lXvO9AsiMW0f+A
	 XL9RXvq8vvq7H/OomX3mGNwiUNOn0PJCdrSBWDEFTLA/J3kVVO0iig/2suyrHkdjXr
	 hQcrr9tTOkNHp3D12IIHbgrhJdjVNduXc27I9S8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/744] platform/x86: ISST: Add Grand Ridge to HPM CPU list
Date: Thu,  6 Jun 2024 15:55:45 +0200
Message-ID: <20240606131734.741539377@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 515a3c3a5489a890c7c3c1df3855eb4868a27598 ]

Add Grand Ridge (ATOM_CRESTMONT) to hpm_cpu_ids, so that MSR 0x54 can be
used.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20240422212222.3881606-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_if_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index 30951f7131cd9..1accdaaf282c5 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -721,6 +721,7 @@ static struct miscdevice isst_if_char_driver = {
 static const struct x86_cpu_id hpm_cpu_ids[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_D,	NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X,	NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT,	NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X,	NULL),
 	{}
 };
-- 
2.43.0



