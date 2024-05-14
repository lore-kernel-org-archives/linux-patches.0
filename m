Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423E26CDC9;
	Tue, 14 May 2024 11:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685507; cv=none; b=PLqjZ0NxpllqPaoNtRU/EjLb7n5py1f9z0CNDLIHxvL04aVQNbv18esgseTO4CwYfAp+UIErXSPdp5UJ5BNE0GRH24bZXcWbgkUUQ37toZWT8+6c4BZy4xCBcc77YSwuLhvf9PzAymlqqcMHr90aUAOMvWldssIBam3/T+8h0Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685507; c=relaxed/simple;
	bh=MC3ScjkDu9z4zxuD8vbHu/zTRDwx3PdZ3BIwQ+wEbqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q8doqGDMJlagfv/xYnpbadp3vEDpy8UW+loO9oLgkL9qWKKtFy9dluYSaIvD7s+eN8Axi1vXZUSIjChLLTKEfLL1u7chYxWG9/rtH/QmTwNm6LlAXxVsJfh8yjcADGgCCSX6hgm3/rIwHcdYaxP71x1TiqZeL4o+ua2WlDyP1fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/6wnc6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/6wnc6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A030AC2BD10;
	Tue, 14 May 2024 11:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685507;
	bh=MC3ScjkDu9z4zxuD8vbHu/zTRDwx3PdZ3BIwQ+wEbqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/6wnc6BZMvdISx+cU5y/1jdDeE16IIjt1sV6tdYZuFvhl58IE8FedFcnWCAPJ3pr
	 8qDlxzLuB+/fHmhynwgucLYGGeqDxaNmi7RillMceLjElSsh8xz5fzXYYYsyoioDXi
	 S6zElcORLzr4TRluGxapQNOkdQgIq2hnkrjmCduU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/301] platform/x86: ISST: Add Granite Rapids-D to HPM CPU list
Date: Tue, 14 May 2024 12:17:20 +0200
Message-ID: <20240514101038.636414018@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

[ Upstream commit d8c2d38c4d1dee8fe8e015b9ebf65bdd8e4da99b ]

Add Granite Rapids-D to hpm_cpu_ids, so that MSR 0x54 can be used.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20240415212853.2820470-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_if_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index 08df9494603c5..30951f7131cd9 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -719,6 +719,7 @@ static struct miscdevice isst_if_char_driver = {
 };
 
 static const struct x86_cpu_id hpm_cpu_ids[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_D,	NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X,	NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X,	NULL),
 	{}
-- 
2.43.0



