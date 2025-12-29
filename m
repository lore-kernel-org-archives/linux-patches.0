Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40D032C306;
	Mon, 29 Dec 2025 16:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024883; cv=none; b=Jcodh6wB3rnkkXq5KnDiP6PU2Gf97ejhifU29JoQfi2mPLLHcHujsROu6/Si2dFXFEtgeebmF2+nNvYimaQgKDQzDWp/G9qnSvQnazZLIVdqSBiswlvvNQOKxbmiPjTuFecUstCrLrzLxL/gNTNumu2TT/T7xjOSl0o07ZP3XRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024883; c=relaxed/simple;
	bh=Ctov9bwPZ+qMEzAQ3aL8tqbmm1cMRuEeSFYNCA68Ub8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMyF8SK444vr38h/etnC2VXBHIc6izOM1p5DoGavQCNohemi1Ys/cs2c0o4pR3tMRrXPnfFG8A9JJ6qpWA25VwfM6D8mXvkHbxEV+LuukkQRJxIvHhDZWmEti1T9Yci8jK7NsAE6XsFwWrtw8HK3AWXD3+nS/hVT80puX0HDGyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLNmMtvo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLNmMtvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DFEC4CEF7;
	Mon, 29 Dec 2025 16:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024882;
	bh=Ctov9bwPZ+qMEzAQ3aL8tqbmm1cMRuEeSFYNCA68Ub8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLNmMtvobS+puwWZ5xvfnQf9wUIG5PvUh4SjyXlSO3bjDQ1FXHGuoZ+eF3Gzjik3K
	 ndrceHQVlzDmSL6jUvFgY02xFSafH6UUNURavHMieYG0w/VL6Aq3qvOCQzIEc4JdtX
	 G9nNVnZmKbYywKTtux0gSyAtj3qpACnhNpKhddU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hal Feng <hal.feng@starfivetech.com>,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/430] cpufreq: dt-platdev: Add JH7110S SOC to the allowlist
Date: Mon, 29 Dec 2025 17:07:00 +0100
Message-ID: <20251229160724.825501112@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cd1816a12bb99..dc11b62399ad5 100644
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



