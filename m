Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58BA343D6E;
	Mon, 18 Aug 2025 13:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523318; cv=none; b=RWlSTQiwEL79hGLTuF8WDlafyy/ssswOpqWqqmfHGLe7ryj8j1y5dgGZmCamaesW/dhJGukQPu+Ikco3wPcFGY73Bb3wcmatljUs+qEDYTA7agjZ8EZuXvXCNpAqCyVd7oqXF8AUfZ48bGYI8EGek+TtJMKPTSetTqFcwShEnow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523318; c=relaxed/simple;
	bh=YXCQJpPwUwMBuTsqrTXVw1CwHM4Pj4ikMs58iBAFnyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4ZXCa3y0l7G+mrCC5SXgis5Txfhn4BRe4Ohm8E0MPphq25LA1yVHACloNHgfZZAjtdKpSg4RkQ03uL1hyQ+t1OkGMM9bJQUOKjM6bMbGqEj+wbBSXrgy/oISEBtlZ1G2eIWaQ71N1whQIT9egeoR8n+lq0N2w0x8MddVojH29o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STEky8g/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STEky8g/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69454C4CEEB;
	Mon, 18 Aug 2025 13:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523317;
	bh=YXCQJpPwUwMBuTsqrTXVw1CwHM4Pj4ikMs58iBAFnyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STEky8g/HGyxXLkqlUsBmQu9osFVVrBkBzLMBp5sjapeBgXsmvilXZBvnrWnHaJdJ
	 tJ6bWjGBcMC+Vd6GxiNyvJElhLb4k9XGqIJVdfAgmdUJ3IpTbhyuXNBOIF3vMKheyv
	 pSarl1L3MSfhDDS6l+E6eyM9B7d+XNBOH54I9O3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 134/515] cpufreq: intel_pstate: Add Granite Rapids support in no-HWP mode
Date: Mon, 18 Aug 2025 14:42:00 +0200
Message-ID: <20250818124503.555616062@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index f9205fe199b8..c1c42c273d38 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2656,6 +2656,8 @@ static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
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



