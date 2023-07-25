Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AA514263
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC47C433C7;
	Tue, 25 Jul 2023 10:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282547;
	bh=0pBgHVq4mTOtCop72Gda8pT3fJZDfhaKqq391zga7Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcliZwV9TC6CN8sHdxvW9UG11i88hCuzlOtwH1PG3VDb5TDaYiVlKMOXO9AOs6MgL
	 2ZADbY2oF3ZrZnAejhBdqultmifbK2b1gqTTr93B+QIJql0x9/DH2Fc4m01JK0tNcX
	 /WPDyJPQVzZe1AmsVqkWfrJ5lLlgZTGc1QldD4f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 169/227] drm/i915/perf: add sentinel to xehp_oa_b_counters
Date: Tue, 25 Jul 2023 12:45:36 +0200
Message-ID: <20230725104521.897781721@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrzej Hajda <andrzej.hajda@intel.com>

[ Upstream commit 785b3f667b4bf98804cad135005e964df0c750de ]

Arrays passed to reg_in_range_table should end with empty record.

The patch solves KASAN detected bug with signature:
BUG: KASAN: global-out-of-bounds in xehp_is_valid_b_counter_addr+0x2c7/0x350 [i915]
Read of size 4 at addr ffffffffa1555d90 by task perf/1518

CPU: 4 PID: 1518 Comm: perf Tainted: G U 6.4.0-kasan_438-g3303d06107f3+ #1
Hardware name: Intel Corporation Meteor Lake Client Platform/MTL-P DDR5 SODIMM SBS RVP, BIOS MTLPFWI1.R00.3223.D80.2305311348 05/31/2023
Call Trace:
<TASK>
...
xehp_is_valid_b_counter_addr+0x2c7/0x350 [i915]

Fixes: 0fa9349dda03 ("drm/i915/perf: complete programming whitelisting for XEHPSDV")
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230711153410.1224997-1-andrzej.hajda@intel.com
(cherry picked from commit 2f42c5afb34b5696cf5fe79e744f99be9b218798)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_perf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 3035cba2c6a29..d7caae281fb92 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -4442,6 +4442,7 @@ static const struct i915_range mtl_oam_b_counters[] = {
 static const struct i915_range xehp_oa_b_counters[] = {
 	{ .start = 0xdc48, .end = 0xdc48 },	/* OAA_ENABLE_REG */
 	{ .start = 0xdd00, .end = 0xdd48 },	/* OAG_LCE0_0 - OAA_LENABLE_REG */
+	{}
 };
 
 static const struct i915_range gen7_oa_mux_regs[] = {
-- 
2.39.2



