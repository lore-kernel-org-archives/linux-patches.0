Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C1F6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F54C433C7;
	Sun, 17 Sep 2023 19:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978617;
	bh=tT6hcY/P9FvXOH6QsQOtneTbudLAKI29/Nm2XuJk0yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kR6ScxQM9yp2a1ghi7FkRiVs7wyGqp4Q2WMDsV4oIRbd4yzx3nFq9+C9rDYI6CUBJ
	 hVxYA4OomstSJppfWXCMKZQ1wTG2KrS6r7RHmvyDJpVtXO9JGpY93R3eUhoczw+0LY
	 l9zwOXHBXrtqr+mhWVHAAdTtPB0eNLBzbGjTWZdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chang <liaochang1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/406] cpufreq: powernow-k8: Use related_cpus instead of cpus in driver.exit()
Date: Sun, 17 Sep 2023 21:08:55 +0200
Message-ID: <20230917191103.271267500@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Chang <liaochang1@huawei.com>

[ Upstream commit 03997da042dac73c69e60d91942c727c76828b65 ]

Since the 'cpus' field of policy structure will become empty in the
cpufreq core API, it is better to use 'related_cpus' in the exit()
callback of driver.

Fixes: c3274763bfc3 ("cpufreq: powernow-k8: Initialize per-cpu data-structures properly")
Signed-off-by: Liao Chang <liaochang1@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/powernow-k8.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index b9ccb6a3dad98..22d4c639d71db 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1101,7 +1101,8 @@ static int powernowk8_cpu_exit(struct cpufreq_policy *pol)
 
 	kfree(data->powernow_table);
 	kfree(data);
-	for_each_cpu(cpu, pol->cpus)
+	/* pol->cpus will be empty here, use related_cpus instead. */
+	for_each_cpu(cpu, pol->related_cpus)
 		per_cpu(powernow_data, cpu) = NULL;
 
 	return 0;
-- 
2.40.1



