Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058DC1FBCB2;
	Tue,  8 Apr 2025 11:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110319; cv=none; b=s0z1rBodp5hi7b0qBf44Ukj9AFjzWZGUUed1w/HiQCbTrPFTy/zyYMlBrwnrsjPNmPX4z0gP3hhi+zNdGLGoRkpfBIwURXxZ/CJVH7F7Y1rOuCFrlZqSd3WjgouBOw9KXdUnRZqB+gIWcopTZbjUXav9tFWuxd8Z/e9IAs0Dsak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110319; c=relaxed/simple;
	bh=Q3M+z7G1RC06ZbNuPrGbHJQJMKPStv4Ql4+mgKvpazY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHB0eBswOh6JqeEQofeODX2CEV5aLlFVGXLT5p3zeM/vfOwe2uLc1HJxRRf+XLF9XfEL4Zn/Qom8dvzt1+1KQFpyDLUPqWu9bclQcgkb3gJFUi1rZC7GKS33eamrTvDNAtcVnF44tmbVZ/4h9ZlQWn327DIeHaXig7diNJixdgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGuB9Ynp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGuB9Ynp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88025C4CEE5;
	Tue,  8 Apr 2025 11:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110318;
	bh=Q3M+z7G1RC06ZbNuPrGbHJQJMKPStv4Ql4+mgKvpazY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGuB9YnpfgXUBwDYNOZK75sZyB9xKTLp0+GG5OtebE3FpcFSnbQ+GRW/6mX8w3P9h
	 Y4TxhHpsYakrN16aygY5ZA2qdHe08GwkFBiq4bopLf+KiSmNHI1kru13PIE65iK4eE
	 +msOp312eBtVQVLTc6VQJjGUfhwy6hzByr3fjvtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 020/731] cpufreq/amd-pstate: Add missing NULL ptr check in amd_pstate_update
Date: Tue,  8 Apr 2025 12:38:37 +0200
Message-ID: <20250408104914.735342054@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>

[ Upstream commit 426db24d4db2e4f0d6720aeb7795eafcb9e82640 ]

Check if policy is NULL before dereferencing it in amd_pstate_update.

Fixes: e8f555daacd3 ("cpufreq/amd-pstate: fix setting policy current frequency value")
Signed-off-by: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://lore.kernel.org/r/20250205112523.201101-11-dhananjay.ugwekar@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 32f1b659904bc..bd63837eabb4e 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -538,6 +538,9 @@ static void amd_pstate_update(struct amd_cpudata *cpudata, u8 min_perf,
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpudata->cpu);
 	u8 nominal_perf = READ_ONCE(cpudata->nominal_perf);
 
+	if (!policy)
+		return;
+
 	des_perf = clamp_t(u8, des_perf, min_perf, max_perf);
 
 	max_freq = READ_ONCE(cpudata->max_limit_freq);
-- 
2.39.5



