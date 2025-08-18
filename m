Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95638335BBB;
	Mon, 18 Aug 2025 13:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525061; cv=none; b=PDYj9UOEKryG3kbM0vzyA9YZP4AIaOFxAGGxf50C1WIrzAig/7hzxMkNWxjpXw0L958ozqgZOXheaRL5wOIrvienqo347hsHHVHCgutfQo2RiNXF9bMMFqrQjWMItze0OIlFWBahOLcJVuERUFjgBKP1JAaNh3Gcw72xNMLdmQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525061; c=relaxed/simple;
	bh=KOsfORvGshTI06uxeQelGdibS8Btebg/hpzZ0nANLNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGNEX/sEICF3ySUr7OkJRyR6HOQ5trtCW0YhfY1myVf3FAZL0O/4K2InYXfDV2vc20aPO4dA38k2+orZ/lRKUf63uv9RpMLw6CyUpu/D/ip6nnGWVNlDK2kUxzjLHFXwG4qkjs9HP3AdkTI+lJsO6mNlmVTIw5twaum0y76pCHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=em2t/8e2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="em2t/8e2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091F8C4CEEB;
	Mon, 18 Aug 2025 13:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525061;
	bh=KOsfORvGshTI06uxeQelGdibS8Btebg/hpzZ0nANLNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=em2t/8e23ID2qyWulUVC1NPjD8GFGkoxXmE07rOiSCbfw/Im/QTn088jhVo9J8/9J
	 dpmiWfkyS3sdoiCO/gKVSUA27qNYV/tPAKkHVRlefjSNx9f9ag8l8RmXSOqc9C5IA9
	 vbQDPIHWeM32mzh0ByQ0SPAnjmhrt3k96QhEqKB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 147/570] cpufreq: intel_pstate: Add Granite Rapids support in no-HWP mode
Date: Mon, 18 Aug 2025 14:42:14 +0200
Message-ID: <20250818124511.483760400@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit fc64e0421598aaa87d61184f6777b52614a095be ]

Users may disable HWP in firmware, in which case intel_pstate
wouldn't load unless the CPU model is explicitly supported.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20250623105601.3924-1-lirongqing@baidu.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 60326ab5475f..06a1c7dd081f 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2775,6 +2775,8 @@ static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
 	X86_MATCH(INTEL_TIGERLAKE,		core_funcs),
 	X86_MATCH(INTEL_SAPPHIRERAPIDS_X,	core_funcs),
 	X86_MATCH(INTEL_EMERALDRAPIDS_X,	core_funcs),
+	X86_MATCH(INTEL_GRANITERAPIDS_D,	core_funcs),
+	X86_MATCH(INTEL_GRANITERAPIDS_X,	core_funcs),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
-- 
2.39.5



