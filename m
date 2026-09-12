Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D3843E07C;
	Sat, 12 Sep 2026 12:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216215; cv=none; b=UOmjsFZ44QwQ2pddnxLGggtFdbP8hdnR/9t6TSI3lDjtoDqbdxMFTjzNdPlkBh9f8Xmimd+h8lF78kajqJTjWcmOfPMppHhhIf47RSJFdXWN+1U/JVErg2SNOlz3izr2Y2a+uEFY1Mg+QJ4ZxqvzGtJfmjIUy8LDYty6Viv/mek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216215; c=relaxed/simple;
	bh=VxYNABKcRhtsG98UGWJd5qGwaTKZeybe3HL8B9Asb/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKtbC837vtnJMgkrkW5uZHSPjEPo4K3w+KHiP90OlxCagCi1wgECPBwA1BMha2W0kDQzCqvpLelzVNc4ab2nxsj0wQX1a1qUfOGhzceslNjJ31NWhVzwaOC5I+I+xJwqzSgY4+i2yMii6YcG3G44gmyoZdaZRyA/SjEQrGm/F1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uko2IZun; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uko2IZun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D031F000FF;
	Sat, 12 Sep 2026 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216213;
	bh=tJJrBUxB9r8XEoL36P0iU3iVPt8jaWxGslbguUFGQY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uko2IZunTdxWoNpB/w8A2XwWJb62icNeO22yHbPXMgfER+a4l/elzU9lyyjqMcE/W
	 5IZgMJViSTtXs6/B91Nc+aMBK1/GdplslYxLj1Hz9wwLDQTVf1XdcZcUjWY17LdG/Z
	 Pptl/xWcIOTxIcaD2vkxM7geMK1c+NdOffyBX6xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0654/1376] ACPI: CPPC: Add IS_OPTIONAL_CPC_REG macro to judge if a cpc_reg is optional
Date: Sat, 12 Sep 2026 08:51:20 +0200
Message-ID: <20260912065622.118491869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit e3d7935a6c6138da51626d2b956a079dd0e6671b ]

In ACPI 6.5, s8.4.6.1 _CPC (Continuous Performance Control), whether
each of the per-cpu cpc_regs[] is mandatory or optional is defined.

Since the CPC_SUPPORTED() check is only for optional _CPC fields,
another macro to check if the field is optional is needed.

Reviewed-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250411093855.982491-2-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 9dfd13f80c85 ("cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index fd6a83e3d4301..9f158353b3603 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -129,6 +129,20 @@ static DEFINE_PER_CPU(struct cpc_desc *, cpc_desc_ptr);
 #define CPC_SUPPORTED(cpc) ((cpc)->type == ACPI_TYPE_INTEGER ?		\
 				!!(cpc)->cpc_entry.int_value :		\
 				!IS_NULL_REG(&(cpc)->cpc_entry.reg))
+
+/*
+ * Each bit indicates the optionality of the register in per-cpu
+ * cpc_regs[] with the corresponding index. 0 means mandatory and 1
+ * means optional.
+ */
+#define REG_OPTIONAL (0x1FC7D0)
+
+/*
+ * Use the index of the register in per-cpu cpc_regs[] to check if
+ * it's an optional one.
+ */
+#define IS_OPTIONAL_CPC_REG(reg_idx) (REG_OPTIONAL & (1U << (reg_idx)))
+
 /*
  * Arbitrary Retries in case the remote processor is slow to respond
  * to PCC commands. Keeping it high enough to cover emulators where
-- 
2.53.0



