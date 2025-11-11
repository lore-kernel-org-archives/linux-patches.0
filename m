Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0E84C97;
	Tue, 11 Nov 2025 00:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822746; cv=none; b=TYowbZvvWPJppsD7l5tgsDUSxhtl1L+CqJKrd8aOfWQjDbjULAO2eCIbtrJ2Jxm9Y12eF+yLxlNYJtdIeDPz+BUEvcho+sIgwyEvK92C8sZqSlLYTRQm5tvAzxtJLVvRyXwiEyn54ybSflXFOt1xKQvwD9D9JEROWqGjWm/vCgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822746; c=relaxed/simple;
	bh=WOhghtDlJSzqjeKFVvvDjoy4rLxkHQkjq30649K+wVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkSDcaB43lPiGaluFp/0p273B3UThTOFmFAatvMgLB3wyuL6Zx7tu/CnLykO4u8Ui22nN+1WlZjv3IDzJ4PbGBvayadV1JmV39cBr3p+foAkPCw8YjSl8Fnzsm7+uOCa6MSTRuTeSsu0baCz4hq7TgcMfodwN2HMTryeAtIbjMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jh9mSe2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jh9mSe2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FE7C4AF09;
	Tue, 11 Nov 2025 00:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822746;
	bh=WOhghtDlJSzqjeKFVvvDjoy4rLxkHQkjq30649K+wVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jh9mSe2Ko73FiLQaPWok/0S/n+xFnjI6QMHpvWy1qfoYmd3IY8gyda+MSI4Y8SzIP
	 eHXMsJKue0jNlaYv34RISSTx48sVH3NbOI/LujfLzkXZkC39rvUvfwGvJvWbUlFeDo
	 HMsSFhbHY6PNIwyrlADwy6mNxyAbwp85FrwjcKc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paresh Bhagat <p-bhagat@ti.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/565] cpufreq: ti: Add support for AM62D2
Date: Tue, 11 Nov 2025 09:39:13 +0900
Message-ID: <20251111004529.140998702@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ba621ce1cdda6..190e30b1c5532 100644
--- a/drivers/cpufreq/ti-cpufreq.c
+++ b/drivers/cpufreq/ti-cpufreq.c
@@ -308,6 +308,7 @@ static const struct soc_device_attribute k3_cpufreq_soc[] = {
 	{ .family = "AM62X", .revision = "SR1.0" },
 	{ .family = "AM62AX", .revision = "SR1.0" },
 	{ .family = "AM62PX", .revision = "SR1.0" },
+	{ .family = "AM62DX", .revision = "SR1.0" },
 	{ /* sentinel */ }
 };
 
@@ -453,6 +454,7 @@ static const struct of_device_id ti_cpufreq_of_match[]  __maybe_unused = {
 	{ .compatible = "ti,omap36xx", .data = &omap36xx_soc_data, },
 	{ .compatible = "ti,am625", .data = &am625_soc_data, },
 	{ .compatible = "ti,am62a7", .data = &am62a7_soc_data, },
+	{ .compatible = "ti,am62d2", .data = &am62a7_soc_data, },
 	{ .compatible = "ti,am62p5", .data = &am62p5_soc_data, },
 	/* legacy */
 	{ .compatible = "ti,omap3430", .data = &omap34xx_soc_data, },
-- 
2.51.0



