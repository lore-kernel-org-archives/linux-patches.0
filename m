Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270E631A04F;
	Mon, 18 Aug 2025 12:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521775; cv=none; b=tnXoxaszo+0xXAHO2nYP8WfElVaC8pSqn1GVu6i3IOKyCCDDh5PLvXbEYtxi6VOmy+eEe9zFrK/jjpP6a6XoSGJQXup13vZ78hA5yAWsKms/mxgb3cBRthE9Ae3NGQo5CjkZu1dpFFNJumYH6CXpu+8ZrMTtbOkObq5c7jm+DDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521775; c=relaxed/simple;
	bh=JTTlQpB7KIL+NzUM1fICSiBiCzJ0UZofqukCh6ux3xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKYsyYXw9PVAh0fU0eyt37VfokjzlVm3IYic6rKO7Dcl24bewJVz3UGHcCGfnpm7wGJHzO3X/FXBwnO2FxLBXDfRwF0aYqcDYq8tlLt8wDUPhLrfUjxyiInwGkqKlOgRLAGHE64d7IFq9/IYmmyLznnpAsf17KCCqQAvyjrzBGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmnkL48+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmnkL48+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC90C4CEEB;
	Mon, 18 Aug 2025 12:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521774;
	bh=JTTlQpB7KIL+NzUM1fICSiBiCzJ0UZofqukCh6ux3xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmnkL48+TfrTO6HKHzL1N+oS8O885UuYz0wpW+mQkhT9OpzqRqFLxrT39Ss0nuxBu
	 QxoQ9mnKCQ2SmRgcY6ZUtF8uUTAZ+X8K50rigSUlX8YJ0f8zV+4hx0SVeGfnSft96Q
	 g2dXoRsxY2oM6mn6toMnMtIKQP0COid7ToFi1vCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/444] cpufreq: intel_pstate: Add Granite Rapids support in no-HWP mode
Date: Mon, 18 Aug 2025 14:42:17 +0200
Message-ID: <20250818124453.096195440@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b86372aa341d..e90871092038 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2654,6 +2654,8 @@ static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
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



