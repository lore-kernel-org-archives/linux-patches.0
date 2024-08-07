Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C923374CC;
	Wed,  7 Aug 2024 15:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043554; cv=none; b=osXEmYJr/lDKQ7g1y63oPhJS/E/mTs+bDn5bbT9kKRyqE/cGJijUfuNeMwIj8+hLckZCDtmaVIpzjg0bLFiZZPSqnRflrHhZ27e9Fx4XKgrJbT/FxGB7bDllC0u7LI1nzd1rZ8peT+YlvcbSYbQ41FW986X7hN9/T110eHNxSYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043554; c=relaxed/simple;
	bh=GsqdLoMlSH+1+4TkJ5tdGBe5JnhUzbrVWYdkiEA7hrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mfE8xylGELbGz0patzlZReKfs5KxVeThfV2dgeUP494VMQV1Zpizfl+wpZAyVglu+r//YFed6IpnOMOLgM8o9fkMp3n4pL+GHJqxVKHJBLCGB7RDnQr9f7sk8LlDg9X7o5AsRFPvscQRlRAn5UpK071h6cTiJsE1VJ6nIMedIQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJD+5YcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJD+5YcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DB7C32781;
	Wed,  7 Aug 2024 15:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043553;
	bh=GsqdLoMlSH+1+4TkJ5tdGBe5JnhUzbrVWYdkiEA7hrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJD+5YcOrYyPjudWjgs9/qD+nGR2oLfOvW/VZ/n5QaDpob8Ae5mOEMAP6laHZy9TI
	 xvSwC2dMqJFpu5tRRw+WeBlvj/UTZBdD8+iPtKV+xj6DY9FhR+F8Mnz3BdNPK86gk0
	 nbpO9dSarEdMFD8nPb9kc9Rdv718uBcAIjmv+awM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Yangtao Li <frank.li@vivo.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/86] cpufreq: qcom-nvmem: Convert to platform remove callback returning void
Date: Wed,  7 Aug 2024 16:59:52 +0200
Message-ID: <20240807150039.677167604@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 402732324b17a31f7e5dce9659d1b1f049fd65d3 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: d01c84b97f19 ("cpufreq: qcom-nvmem: fix memory leaks in probe error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-nvmem.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-nvmem.c b/drivers/cpufreq/qcom-cpufreq-nvmem.c
index cb03bfb0435ea..91634b84baa87 100644
--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -374,7 +374,7 @@ static int qcom_cpufreq_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int qcom_cpufreq_remove(struct platform_device *pdev)
+static void qcom_cpufreq_remove(struct platform_device *pdev)
 {
 	struct qcom_cpufreq_drv *drv = platform_get_drvdata(pdev);
 	unsigned int cpu;
@@ -386,13 +386,11 @@ static int qcom_cpufreq_remove(struct platform_device *pdev)
 
 	kfree(drv->opp_tokens);
 	kfree(drv);
-
-	return 0;
 }
 
 static struct platform_driver qcom_cpufreq_driver = {
 	.probe = qcom_cpufreq_probe,
-	.remove = qcom_cpufreq_remove,
+	.remove_new = qcom_cpufreq_remove,
 	.driver = {
 		.name = "qcom-cpufreq-nvmem",
 	},
-- 
2.43.0



