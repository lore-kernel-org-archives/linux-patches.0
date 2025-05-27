Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8961617B425;
	Tue, 27 May 2025 17:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366292; cv=none; b=aDRNZJoFl9U1rLPymijt66694qBol9HdBqK8VJJUAwIxELPBCuI98aXl8UC7kUclNfTgBunFt32nWdTC4yp6JKg/JdoEaIv5Lxl73mGAtB+EeNYqEU6TviHynR/zpQnFDUD39S0M3HzAMQLwipR8f6nO1wsm2jMiyPQkPeuXpr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366292; c=relaxed/simple;
	bh=YQLAfsAJMjRIRng3vvtqidBRuVfRdBxZQcR4eQmx/l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XycJuG2mT6HWeMf99gHx7Qivwb1DyJvMN/JVkrt/j0eRUXzbmVY3xHOQrZ5IAP1C/g/bT235eHqIbWD1P8QKOTzRq8JTtdNg6GqAiRRCZ8PbWuQOwqzBT1K+o1Sjgf9wkc8qZ/CPyrPuGRHjcBLDkLiVyKa6mjhpYncRe10iUpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQivTNEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQivTNEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F31C4CEE9;
	Tue, 27 May 2025 17:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366292;
	bh=YQLAfsAJMjRIRng3vvtqidBRuVfRdBxZQcR4eQmx/l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQivTNEKkQi/0OrjyMs9FN8TXVIj9ddrGAUxuAbhldY4IL7BvvFS0N2sM6As90b3B
	 hyEyuVk4TxmIReYUfXDfaKGpadj3/xOYdXpfZrFWTkyqghCEv7+EMx/JBJNgpKTg/m
	 TP6FV4t9KzxbOiEJ6v51x8lZUIZ/VxAYXwO13DZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 009/783] cpufreq: Add SM8650 to cpufreq-dt-platdev blocklist
Date: Tue, 27 May 2025 18:16:46 +0200
Message-ID: <20250527162513.424719846@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit fc5414a4774e14e51a93499a6adfdc45f2de82e0 ]

SM8650 have already been supported by qcom-cpufreq-hw driver, but
never been added to cpufreq-dt-platdev. This makes noise

[    0.388525] cpufreq-dt cpufreq-dt: failed register driver: -17
[    0.388537] cpufreq-dt cpufreq-dt: probe with driver cpufreq-dt failed with error -17

So adding it to the cpufreq-dt-platdev driver's blocklist to fix it.

Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt-platdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index 2aa00769cf09d..a010da0f6337f 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -175,6 +175,7 @@ static const struct of_device_id blocklist[] __initconst = {
 	{ .compatible = "qcom,sm8350", },
 	{ .compatible = "qcom,sm8450", },
 	{ .compatible = "qcom,sm8550", },
+	{ .compatible = "qcom,sm8650", },
 
 	{ .compatible = "st,stih407", },
 	{ .compatible = "st,stih410", },
-- 
2.39.5



