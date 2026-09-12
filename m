Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520CE371887;
	Sat, 12 Sep 2026 10:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208088; cv=none; b=FMUKKxbAG8rtpq84jgnS/YaOilJo5hlqUkKEqYr/HAMuIWBfG593hZZ5+VLWlncFEHxCL65nwidUy/gAz7+q3nOsSMtlA56jalOE6vEXVsN/yjQvCE/0IuKyxHY1NuYuCx1Doq1crMLs+TIOtr4vvktEMfhlkw59C0rXJonTBo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208088; c=relaxed/simple;
	bh=ILBMpWXYTfSWW0fTo8e96AeXVUJ7aoSHNXfuulmt36E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejgpTllNYs7IZWyklm4xpGltn4RDQur8siWI0TjTcnaHoC20Sl/C8JNYxp+0Ya3XF7zK4o4xhLOQpV5GvJwyYDOb2Y1DEdCYAbXmtzVssoWN4zpCu74+rn+CQVt4gWSpHsKkM1HpZVtQqfOe/8QQSVduAj9rzV+BXeDg4Tt7VKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qf4YMuaY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qf4YMuaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890F01F000FF;
	Sat, 12 Sep 2026 10:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208087;
	bh=PZY/bU3bJQb4B07c1oj0XNm6GF9EAvayGF7E441YkNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qf4YMuaY4y1azASFEB5kwodw5NIatfJslbuTc351R+DsxiZvSoDssHZPdEGEBRLPD
	 AG+X5RsyidjFWAP38Cle1qFGlomlgYqKGAOhlOK732fDY2X2fQ3VYINoWmurJLUmXb
	 9Se+DQNMqaEpKDIm/I/ZGA9RXJ7zA7MBWaP1M+wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiong <xiongl24@chinatelecom.cn>,
	Xibo Wang <wangxb12@chinatelecom.cn>,
	Qianheng Peng <pengqh1@chinatelecom.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0544/1518] cpufreq: amd-pstate-ut: Skip tests when amd-pstate driver is not active
Date: Sat, 12 Sep 2026 08:45:13 +0200
Message-ID: <20260912065635.749174111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Qianheng Peng <pengqh1@chinatelecom.cn>

[ Upstream commit 8d31bb1451643f328db0cea0e21e63ef54b4faf2 ]

The crash issue may occur when modprobe amd_pstate_ut on intel platform.

   amd_pstate_ut: 1    amd_pstate_ut_acpi_cpc_valid  success!
   amd_pstate_ut: 2    amd_pstate_ut_check_enabled   success!
   BUG: kernel NULL pointer dereference, address: 0000000000000080
   #PF: supervisor read access in kernel mode
   #PF: error_code(0x0000) - not-present page
   PGD 0 P4D 0
   Oops: 0000 [#1] SMP NOPTI
   CPU: 0 PID: 20300 Comm: modprobe
   Kdump: loaded Tainted: G O 6.6.0-0010.rc1.ctl4.x86_64 #1
   Hardware name: FiberHome R2200 V5/Xeon Boards, BIOS 3.1a 02/24/2020
   RIP: 0010:amd_pstate_ut_check_perf+0x141/0x280 [amd_pstate_ut]
   Call Trace:
    <TASK>
    amd_pstate_ut_init+0x1b/0xff0 [amd_pstate_ut]
    ? __pfx_amd_pstate_ut_init+0x10/0x10 [amd_pstate_ut]
    do_one_initcall+0x42/0x2e0
    ? kmalloc_trace+0x26/0x90
    do_init_module+0x60/0x240
    __se_sys_init_module+0x185/0x1c0
    do_syscall_64+0x62/0x190
    entry_SYSCALL_64_after_hwframe+0x76/0x7e
    </TASK>

Add state detection to amd pstate driver to prevent amd_pstate_ut driver
from testing on non-AMD platforms.

Fixes: 14eb1c96e3a3 ("cpufreq: amd-pstate: Add test module for amd-pstate driver")
Suggested-by: Li Xiong <xiongl24@chinatelecom.cn>
Suggested-by: Xibo Wang <wangxb12@chinatelecom.cn>
Signed-off-by: Qianheng Peng <pengqh1@chinatelecom.cn>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Link: https://lore.kernel.org/r/1784191899-28957-1-git-send-email-pengqh1@chinatelecom.cn
(ML: adjust title)
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate-ut.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate-ut.c b/drivers/cpufreq/amd-pstate-ut.c
index 447b9aa5ce40b..93b80bf992a6a 100644
--- a/drivers/cpufreq/amd-pstate-ut.c
+++ b/drivers/cpufreq/amd-pstate-ut.c
@@ -273,6 +273,11 @@ static int amd_pstate_ut_check_driver(u32 index)
 static int __init amd_pstate_ut_init(void)
 {
 	u32 i = 0, arr_size = ARRAY_SIZE(amd_pstate_ut_cases);
+	enum amd_pstate_mode mode = amd_pstate_get_status();
+
+	/* don't test if no running amd-pstate driver */
+	if (mode == AMD_PSTATE_UNDEFINED || mode == AMD_PSTATE_DISABLE)
+		return -EOPNOTSUPP;
 
 	for (i = 0; i < arr_size; i++) {
 		int ret = amd_pstate_ut_cases[i].func(i);
-- 
2.53.0



