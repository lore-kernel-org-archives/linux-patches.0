Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F13F34C98A;
	Tue, 16 Dec 2025 12:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888441; cv=none; b=fyH0dH4t4WlhEsUXz64xgVYOKUl7XXmu4QjrncUoj6xaCYA7A5mRWnRQKH7QnBI+uI1rwkGSUJ1UDupSPDKwKhPLUTdZbYU2csEjpaC8KeqA8dO9DwF8byymwxMj7r5ZlnuFyWwBBrRfAHBlx6yDuGRQbTq8ZMcWjm/GG2cfvQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888441; c=relaxed/simple;
	bh=/qlpLGuxEQN6ZTkf2/jL7I8y2IQD6QtnJe/dKT8rnaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k+rliEZnJYandaNpqeUTlNmwcoSyWeEe2V6deFv7IyvnJqkNQMq01PvR9PjNNjNZIKn89NzCRZq4qjAxRH6Ax+NE1kgJ7ifR2kGcgMCYOIyP7JKT7z7LG0MnB+7cmKDLNeeX4gJP3PXrvZ1rxDDcFTTuhvR4P3ex0K1oluD/+pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FguRZR3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FguRZR3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C641DC4CEF1;
	Tue, 16 Dec 2025 12:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888441;
	bh=/qlpLGuxEQN6ZTkf2/jL7I8y2IQD6QtnJe/dKT8rnaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FguRZR3Vyx0ovhS9ZMc91cTfDngk4BzThz0zVJhTT+VyICERhylxbFGE+NuleAVsG
	 3tH5mEedUmVWWnS56PMbcq2hJuHu+JDF5usgegvMGgemViDGJI3pB2//SceIdkKNgk
	 ZQj54/Plo+JrJLCBGgnBtyHU1XmKZvV/vEOPRhIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Xi Pardee <xi.pardee@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 536/614] platform/x86:intel/pmc: Update Arrow Lake telemetry GUID
Date: Tue, 16 Dec 2025 12:15:03 +0100
Message-ID: <20251216111420.799890461@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Pardee <xi.pardee@linux.intel.com>

[ Upstream commit 644ab3bc98ee386f178d5209ae8170b3fac591aa ]

Update ARL_PMT_DMU_GUID value. Arrow Lake PMT DMU GUID has been updated
after it was add to the driver. This updates ensures that the die C6
value is available in the debug filesystem.

Bugzilla Link: https://bugzilla.kernel.org/show_bug.cgi?id=220421
Fixes: 83f168a1a437 ("platform/x86/intel/pmc: Add Arrow Lake S support to intel_pmc_core driver")
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Xi Pardee <xi.pardee@linux.intel.com>
Link: https://patch.msgid.link/20251014214548.629023-2-xi.pardee@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmc/core.h b/drivers/platform/x86/intel/pmc/core.h
index f4dadb696a314..d6818bd34768e 100644
--- a/drivers/platform/x86/intel/pmc/core.h
+++ b/drivers/platform/x86/intel/pmc/core.h
@@ -282,7 +282,7 @@ enum ppfear_regs {
 /* Die C6 from PUNIT telemetry */
 #define MTL_PMT_DMU_DIE_C6_OFFSET		15
 #define MTL_PMT_DMU_GUID			0x1A067102
-#define ARL_PMT_DMU_GUID			0x1A06A000
+#define ARL_PMT_DMU_GUID			0x1A06A102
 
 #define LNL_PMC_MMIO_REG_LEN			0x2708
 #define LNL_PMC_LTR_OSSE			0x1B88
-- 
2.51.0



