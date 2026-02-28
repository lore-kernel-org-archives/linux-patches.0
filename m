Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2229F4BC033;
	Sat, 28 Feb 2026 17:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301351; cv=none; b=d5lvX/QwOC27IohfovfwFwW53ryOMpIYnB/hvjzuzSd/D1OzX1lQy2chdDZoLa0Ro+THQFH5sYKXJQyDrzE+vud/grYpJcj/mIr5y7viHrTpsfKJDPy1dp49kdrl25ZVfwwn22VQFhmr22gBHtSN84tHe+cLWHX0B4jt8BiETaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301351; c=relaxed/simple;
	bh=xmQi6+YKV9ITXwuL3p4IK8mL4FzIuikf+SuQGHCJe74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G32ZmMRDC9ubW6k5uhUZRm0XFkLaM/TBx9jxPCLK/c4GaN7H5BroG2xsFj7u/iQWkNlLEdqG/CnjblFCickG5CROYWIEc7hfZ3pj6bHKlpZ4/goetTtFmbZ8yo6BYP3Y8rJZGgkrmaVSQTPJqw3d16LmM6DR99reuTiGEyw+mGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gBFcN1O6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gBFcN1O6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCE7C116D0;
	Sat, 28 Feb 2026 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301351;
	bh=xmQi6+YKV9ITXwuL3p4IK8mL4FzIuikf+SuQGHCJe74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBFcN1O6ncBL311g2t80J6+rkHhN5Y9++L+wbWSmjaS6okI12iisrPeHwTt5bleWP
	 //93Nhpw7nqULR1FlaXX3jpvneckqYiFbCIO37vy5i7EbiOt+AeZsBUxbftPr1cQ76
	 feXkuiLO1trgmfnHiDBVP4g9Yz7n0dMKgtvhjVlusl+uIxm4lq/C5Cboed7QbmFGTi
	 VkEgXLBYKzsCHAA/9MKFLis07V7CKEAG5KzN/Je8pnpCQoo/C8lnnP5Byrv/5ntje7
	 Vs9UjgbdNdzWP4K4aLtYsAaPtQPgnE5tR6QVEKkzGceIbXGv0Up0ES1uA+3WQUBYSo
	 RtODWzX9kXp5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	stable@vger.kernel.org,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 538/752] platform/x86: ISST: Add missing write block check
Date: Sat, 28 Feb 2026 12:44:09 -0500
Message-ID: <20260228174750.1542406-538-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 0e5aef2795008c80c515f6fa04e377c6e5715958 ]

If writes are blocked, then return error during SST-CP enable command.
Add missing write block check in this code path.

Fixes: 8bed9ff7dbcc ("platform/x86: ISST: Process read/write blocked feature status")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260107060256.1634188-2-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
index 34bff2f65a835..f587709ddd473 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -612,6 +612,9 @@ static long isst_if_core_power_state(void __user *argp)
 		return -EINVAL;
 
 	if (core_power.get_set) {
+		if (power_domain_info->write_blocked)
+			return -EPERM;
+
 		_write_cp_info("cp_enable", core_power.enable, SST_CP_CONTROL_OFFSET,
 			       SST_CP_ENABLE_START, SST_CP_ENABLE_WIDTH, SST_MUL_FACTOR_NONE)
 		_write_cp_info("cp_prio_type", core_power.priority_type, SST_CP_CONTROL_OFFSET,
-- 
2.51.0

