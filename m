Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63710241679;
	Tue, 27 May 2025 16:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364422; cv=none; b=C1Rp3UJsTtrKhvTy+kByDEgGJ8rSlmVTtfGP3srvhcn5ypErA/W2hJrgaqyDSPiA50Rcs2AWyqZtSyjdnETxGhJYu4SsdeiCNSV2+Zhv2NK2IH16Gz0WNqfyMOOu6+suCEQAFpuuFKu4gW8iqYDT6ybdTYPQjzXfezdGtetTf+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364422; c=relaxed/simple;
	bh=u+D4J3IdpXDGcHzvMvaW/aWGMrsgIVacNzbV3DpEZnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3neyTla1kcPyvu6To4mv0wUjaexkfLpiYudTl9mHfkqzbDLzZIESQVbQXjC4EIAuDZWfyrbfSTuV/TEnLpoVY4FEH4PxjY0DKn9Ma8Hj47d7pkSbAuwPhWZdWuzg3rZ4RSKwP8y2FkvF+ALMHmRKapLMl3duqiy/lWZCmsc6Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Ef/cECF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Ef/cECF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41AAC4CEE9;
	Tue, 27 May 2025 16:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364422;
	bh=u+D4J3IdpXDGcHzvMvaW/aWGMrsgIVacNzbV3DpEZnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Ef/cECF9XLEThequKLgWSvW+U3Ofy/3JDUJsg9n6HmIs9nd3oE+NcPNv1Gh7qlV+
	 2S8VUfTld5vGF7+0YJE4wyFKlPdZMK3iheg8Ibyc/2LQWK3yrbvhlcY7yKpHtDOp1J
	 ZSyOal+9wpJi3VniwEL35FoKw1FB313dsLtUoLxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/626] cpufreq: Add SM8650 to cpufreq-dt-platdev blocklist
Date: Tue, 27 May 2025 18:18:23 +0200
Message-ID: <20250527162445.476985562@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 78ad3221fe077..67bac12d4d55b 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -172,6 +172,7 @@ static const struct of_device_id blocklist[] __initconst = {
 	{ .compatible = "qcom,sm8350", },
 	{ .compatible = "qcom,sm8450", },
 	{ .compatible = "qcom,sm8550", },
+	{ .compatible = "qcom,sm8650", },
 
 	{ .compatible = "st,stih407", },
 	{ .compatible = "st,stih410", },
-- 
2.39.5



