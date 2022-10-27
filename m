Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1628487
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503D2C433D6;
	Thu, 27 Oct 2022 17:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890082;
	bh=qG3jeIdZbuRtFqsEPnnBUqCPnaEZ9/NXS2rmDuHFa5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6s65MXk+hxM9f+kHxNThShJm53md84JBg0sXISiDpL6O9YnoTz9Xp0qCXX3ZDiAH
	 H250O+e8BE0hVV+4R4t1Hzg6a7I1fZh8B+e/7qBgGt6AasJ2jnIHTtAFsMDv5egVqQ
	 WdP6MJVbWrCubJ2/ti0Yv2amoMHXdb3SmTITw1Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.15 16/79] cpufreq: tegra194: Fix module loading
Date: Thu, 27 Oct 2022 18:55:14 +0200
Message-Id: <20221027165055.501953260@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jon Hunter <jonathanh@nvidia.com>

commit 1dcaf30725c32b26daa70d22083999972ab99c29 upstream.

When the Tegra194 CPUFREQ driver is built as a module it is not
automatically loaded as expected on Tegra194 devices. Populate the
MODULE_DEVICE_TABLE to fix this.

Cc: v5.9+ <stable@vger.kernel.org> # v5.9+
Fixes: df320f89359c ("cpufreq: Add Tegra194 cpufreq driver")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/tegra194-cpufreq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cpufreq/tegra194-cpufreq.c
+++ b/drivers/cpufreq/tegra194-cpufreq.c
@@ -279,6 +279,7 @@ static struct cpufreq_driver tegra194_cp
 	.init = tegra194_cpufreq_init,
 	.attr = cpufreq_generic_attr,
 };
+MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
 
 static void tegra194_cpufreq_free_resources(void)
 {


