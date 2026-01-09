Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4863333D50F;
	Fri,  9 Jan 2026 12:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960175; cv=none; b=UfqFTG8ZJGL1R31glQYwHZAyg1rLIx4gegue5+oRhUQtm2ZgIj1+f5O4bYSAVbwZQiUvOUeN1tfRutoyuWN6e0+lxenlO3UTT9Il9xf7ChsVwSyTDzmbsXlgRoXKmaRfOsrJnb31Jbe6Wzac2gW4eVLMo820g2Fi+3IwP8cImq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960175; c=relaxed/simple;
	bh=kLPGhu378T4PJ+AonNYcsabE4s3K+Udq65f7jXKRv9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIj7vt1/WR5thJubIPY5XVf+r4219L6295gvV+UmJ2NlRzjhO4XKCS85jQG/wsb/AzeR/nnzBqLk1P2Jh9fVd+2E0uJGb1yNP2/R7M/rtTsC28VBE5OFQ1bhK5CWh38e09Ckl1VEM6KcDA+sIpV9jKfI3MDPkEJxzTBRX7g75WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSqrnMFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSqrnMFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF0FC4CEF1;
	Fri,  9 Jan 2026 12:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960174;
	bh=kLPGhu378T4PJ+AonNYcsabE4s3K+Udq65f7jXKRv9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSqrnMFyjicDFp2VR3tshGkQrAQWwuz8MPbDP2IlMNFaubIErxsiEnXn0ft5SVz/s
	 s+SLad1nRFGNbMrvaE6klZY7j6AVMMDpDZ4/AvfYCid4Ve8d8Qp+kQ7lbnqD3IZQL9
	 YcQKclBlXmFQH0X3oNL7SGwL4RMxL5xom8L/MUfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hal Feng <hal.feng@starfivetech.com>,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 311/737] cpufreq: dt-platdev: Add JH7110S SOC to the allowlist
Date: Fri,  9 Jan 2026 12:37:30 +0100
Message-ID: <20260109112145.702588502@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hal Feng <hal.feng@starfivetech.com>

[ Upstream commit 6e7970cab51d01b8f7c56f120486c571c22e1b80 ]

Add the compatible strings for supporting the generic
cpufreq driver on the StarFive JH7110S SoC.

Signed-off-by: Hal Feng <hal.feng@starfivetech.com>
Reviewed-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt-platdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index c58c1defd7458..8b53388280d73 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -87,6 +87,7 @@ static const struct of_device_id allowlist[] __initconst = {
 	{ .compatible = "st-ericsson,u9540", },
 
 	{ .compatible = "starfive,jh7110", },
+	{ .compatible = "starfive,jh7110s", },
 
 	{ .compatible = "ti,omap2", },
 	{ .compatible = "ti,omap4", },
-- 
2.51.0



