Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEB61863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3086C433EF;
	Wed, 28 Dec 2022 15:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240684;
	bh=0W5PciXOOC4YYnnlUwPHAcov1CTEah3PwDTi+Nvw6/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vg76RTdi/9LF0nhz8NSSBkRhQrRyBF2zv6wMm4zuRIelcW59lZ9QKxTV/E7TpXzmu
	 3Ho1E3uz4MdIIAmAknx7ygGbccrDiFK+iZC3MeaF3oLulzT3HbMjbJQNI3okBTohAQ
	 Xjo5C+Ue5qG+drZPj/ZKyJKlcHc1vtVy8tqxsOEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0155/1146] cpufreq: amd_freq_sensitivity: Add missing pci_dev_put()
Date: Wed, 28 Dec 2022 15:28:14 +0100
Message-Id: <20221228144334.368667327@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 91fda1f88c0968f1491ab150bb01690525af150a ]

pci_get_device() will increase the reference count for the returned
pci_dev. We need to use pci_dev_put() to decrease the reference count
after using pci_get_device(). Let's add it.

Fixes: 59a3b3a8db16 ("cpufreq: AMD: Ignore the check for ProcFeedback in ST/CZ")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd_freq_sensitivity.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/amd_freq_sensitivity.c b/drivers/cpufreq/amd_freq_sensitivity.c
index 6448e03bcf48..59b19b9975e8 100644
--- a/drivers/cpufreq/amd_freq_sensitivity.c
+++ b/drivers/cpufreq/amd_freq_sensitivity.c
@@ -125,6 +125,8 @@ static int __init amd_freq_sensitivity_init(void)
 	if (!pcidev) {
 		if (!boot_cpu_has(X86_FEATURE_PROC_FEEDBACK))
 			return -ENODEV;
+	} else {
+		pci_dev_put(pcidev);
 	}
 
 	if (rdmsrl_safe(MSR_AMD64_FREQ_SENSITIVITY_ACTUAL, &val))
-- 
2.35.1



