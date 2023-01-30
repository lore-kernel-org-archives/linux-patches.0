Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB26928EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CEFC433EF;
	Mon, 30 Jan 2023 14:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088051;
	bh=BBB+BznXy/rgGSR5BIEQW2gG66MQqO8f8nhRv9CuQQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWdEo3iTjpE+9Bu8Ym+cFwapgHvzRSURKFAE4SgOVVG6m2a6JLmzT9vsSW+sQ7oCH
	 sGYWpbwiRrDNBkBTuKfg0ENa6q9pU1PjvlCg/mHwPyOHNcybb9aYG8fph2uFqg4LGK
	 pwIDQbW1DCL/RsCKsWhsNx7pEzj9KCj4vw8KGwVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/204] cpufreq: Add Tegra234 to cpufreq-dt-platdev blocklist
Date: Mon, 30 Jan 2023 14:51:02 +0100
Message-Id: <20230130134320.622170191@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit 01c5bb0cc2a39fbc56ff9a5ef28b79447f0c2351 ]

Tegra234 platform uses the tegra194-cpufreq driver, so add it
to the blocklist in cpufreq-dt-platdev driver to avoid the cpufreq
driver registration from there.

Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt-platdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index ca1d103ec449..27a3b8800a35 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -133,6 +133,7 @@ static const struct of_device_id blocklist[] __initconst = {
 	{ .compatible = "nvidia,tegra30", },
 	{ .compatible = "nvidia,tegra124", },
 	{ .compatible = "nvidia,tegra210", },
+	{ .compatible = "nvidia,tegra234", },
 
 	{ .compatible = "qcom,apq8096", },
 	{ .compatible = "qcom,msm8996", },
-- 
2.39.0



