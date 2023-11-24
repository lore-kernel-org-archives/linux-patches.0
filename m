Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F9E381D6;
	Fri, 24 Nov 2023 18:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkS0zZSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AE4C433C7;
	Fri, 24 Nov 2023 18:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849566;
	bh=GxeRd5+j7q8f0byxzqLMf1Q3ZFwuCWyBmp18NUxP6XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkS0zZSVIjewHEUE8rvsZ8D8mep2miq68AXHgPuTe8A1pX7dEKCLCWil1ZNPl0OZe
	 xr3uxhDIw/7Z8uhOE0kpIIC9WCyqSTVV7oyf8MoUSnjc1pzyH5yJsNW5U1wsPDvol3
	 gLBjDCJsPzP7lRxof+7gmuUc5w+100yledhwHQv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/530] tools/power/turbostat: Enable the C-state Pre-wake printing
Date: Fri, 24 Nov 2023 17:46:38 +0000
Message-ID: <20231124172035.109141642@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yu <yu.c.chen@intel.com>

[ Upstream commit b61b7d8c4c22c4298a50ae5d0ee88facb85ce665 ]

Currently the C-state Pre-wake will not be printed due to the
probe has not been invoked. Invoke the probe function accordingly.

Fixes: aeb01e6d71ff ("tools/power turbostat: Print the C-state Pre-wake settings")
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 4e19bd2fa8b9f..785de89077de0 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5790,6 +5790,7 @@ void process_cpuid()
 	rapl_probe(family, model);
 	perf_limit_reasons_probe(family, model);
 	automatic_cstate_conversion_probe(family, model);
+	prewake_cstate_probe(family, model);
 
 	check_tcc_offset(model_orig);
 
-- 
2.42.0



