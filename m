Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BF11D6DB5;
	Tue, 11 Nov 2025 00:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822520; cv=none; b=KTK/72kFIZ/VXI7CfZTAnqqGsv91s7O2knEdsmb72V536ZVXjLHFt6TWZJOycLeq/+gT04JW3atJWC/ld9EklKx9wBBzerQlDXI+e/ib4XdfhD8AqYIxwlFYMaaDVSd17uVM/cAON1u77ynIB2ZSkizbLUsUYhT2UXhqZ341GqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822520; c=relaxed/simple;
	bh=fDwfr4LCXz/Uq2TZ01ZihnsNCp/1/qzjcxcRwxsPRvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6gyjHVQsmvk6MSXNXWyhfXfkMLcsaLssQLVAynxfr3y16gSe2j29kW5HhlWwaAznzS7bavMf+BHiWRCLVfEZCNZv0TuWKwaluY3BQJPJFEWMLXv/pz0aUsEJuA09ToNM6pWy3RfZE3FkBYVOp+0rCibyvVaRkNmBT9qf5Tyllw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWfWbwqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWfWbwqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D609C4CEF5;
	Tue, 11 Nov 2025 00:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822520;
	bh=fDwfr4LCXz/Uq2TZ01ZihnsNCp/1/qzjcxcRwxsPRvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWfWbwqehNikNwplxLOSGJPSL1oBszLKjck+R4N1XuW1EYcPbQXGp+1YjyZj4qbmG
	 YxaL/HuzUo5tmVGkhPi7gLKG9ImVLnpASZ+jmUXIlrn9lDr9HsJdWqwKd1ujMtSOu0
	 649lH1k7HpQZCUY++zbgkFqqQPdRuHxi0OSzJmcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paresh Bhagat <p-bhagat@ti.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 129/849] cpufreq: ti: Add support for AM62D2
Date: Tue, 11 Nov 2025 09:34:59 +0900
Message-ID: <20251111004539.513153421@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paresh Bhagat <p-bhagat@ti.com>

[ Upstream commit b5af45302ebc141662b2b60c713c9202e88c943c ]

Add support for TI K3 AM62D2 SoC to read speed and revision values
from hardware and pass to OPP layer. AM62D shares the same configuations
as AM62A so use existing am62a7_soc_data.

Signed-off-by: Paresh Bhagat <p-bhagat@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/ti-cpufreq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/ti-cpufreq.c b/drivers/cpufreq/ti-cpufreq.c
index 5a5147277cd0a..9a912d3093153 100644
--- a/drivers/cpufreq/ti-cpufreq.c
+++ b/drivers/cpufreq/ti-cpufreq.c
@@ -310,6 +310,7 @@ static const struct soc_device_attribute k3_cpufreq_soc[] = {
 	{ .family = "AM62X", .revision = "SR1.0" },
 	{ .family = "AM62AX", .revision = "SR1.0" },
 	{ .family = "AM62PX", .revision = "SR1.0" },
+	{ .family = "AM62DX", .revision = "SR1.0" },
 	{ /* sentinel */ }
 };
 
@@ -457,6 +458,7 @@ static const struct of_device_id ti_cpufreq_of_match[]  __maybe_unused = {
 	{ .compatible = "ti,omap36xx", .data = &omap36xx_soc_data, },
 	{ .compatible = "ti,am625", .data = &am625_soc_data, },
 	{ .compatible = "ti,am62a7", .data = &am62a7_soc_data, },
+	{ .compatible = "ti,am62d2", .data = &am62a7_soc_data, },
 	{ .compatible = "ti,am62p5", .data = &am62p5_soc_data, },
 	/* legacy */
 	{ .compatible = "ti,omap3430", .data = &omap34xx_soc_data, },
-- 
2.51.0



