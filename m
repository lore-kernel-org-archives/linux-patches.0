Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014491CAA85;
	Wed, 19 Feb 2025 09:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955984; cv=none; b=Vm5SMZ6CdO+QqS/2mZARU2WHzEZnvxdVMbtnH9y3dULBPGPoZ/JyGZiY/pgSaa64Y9ehY3gQWCZG+TUWYyC+7w7oXxfNgEcEU2XiPqUsd1sXwNuP/fDQcmOU8LrOzMM6ujX9wVaMuQzD2XPLW/dIPttAGyCzXyTTGLhm6ovps2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955984; c=relaxed/simple;
	bh=yWd4yjiP3YK9AmamS+0p+MDxS69M4Hc84RmWEPphLQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSW7+pzqgEkbE9FRbmZSJHXMtppPxSTwdIYu3g2Q+G8V4lF8vnGIg4CZNmrn99DlEC3EdK/YUjvTMbdCmgp/a0Dv3xF5D7b6RhW2xKh0jmcZNQjm1iOlLs6/wBQPznqowBW8V1j7qMI5AZKZMCxrTnC2XePH3bkLNg2uEYMt3Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uk3f6KXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uk3f6KXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B14DC4CED1;
	Wed, 19 Feb 2025 09:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955983;
	bh=yWd4yjiP3YK9AmamS+0p+MDxS69M4Hc84RmWEPphLQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uk3f6KXrFQ0t86TegYPAv02t3F1zSle2tX/nKYEbcWCE4anzuQ+MPZWk5FFBZ1bCS
	 MOxwOuv8xlh8xTGWMMberlFazmc2AbaTD6JrlfWJSGGctV+8anUa3w6qkr952hdK0h
	 RCPKu1lI/jAPR4i2bc/xpZh/o+5DLpj5S600tlNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/578] OPP: Rearrange entries in pm_opp.h
Date: Wed, 19 Feb 2025 09:20:29 +0100
Message-ID: <20250219082653.884773666@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 754833b3194c30dad5af0145e25192a8e29521ab ]

Rearrange the helper function declarations / definitions to keep them in
order of freq, level and then bw.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: b44b9bc7cab2 ("OPP: fix dev_pm_opp_find_bw_*() when bandwidth table not initialized")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm_opp.h | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
index dc1fb58907929..3821f50b9b89c 100644
--- a/include/linux/pm_opp.h
+++ b/include/linux/pm_opp.h
@@ -121,17 +121,19 @@ unsigned long dev_pm_opp_get_suspend_opp_freq(struct device *dev);
 struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
 					      unsigned long freq,
 					      bool available);
+
 struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 					      unsigned long *freq);
 
+struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
+					     unsigned long *freq);
+
 struct dev_pm_opp *dev_pm_opp_find_level_exact(struct device *dev,
 					       unsigned int level);
+
 struct dev_pm_opp *dev_pm_opp_find_level_ceil(struct device *dev,
 					      unsigned int *level);
 
-struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
-					     unsigned long *freq);
-
 struct dev_pm_opp *dev_pm_opp_find_bw_ceil(struct device *dev,
 					   unsigned int *bw, int index);
 
@@ -247,32 +249,32 @@ static inline unsigned long dev_pm_opp_get_suspend_opp_freq(struct device *dev)
 	return 0;
 }
 
-static inline struct dev_pm_opp *dev_pm_opp_find_level_exact(struct device *dev,
-					unsigned int level)
+static inline struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
+					unsigned long freq, bool available)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
-static inline struct dev_pm_opp *dev_pm_opp_find_level_ceil(struct device *dev,
-					unsigned int *level)
+static inline struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
+					unsigned long *freq)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
-static inline struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
-					unsigned long freq, bool available)
+static inline struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
+					unsigned long *freq)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
-static inline struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
-					unsigned long *freq)
+static inline struct dev_pm_opp *dev_pm_opp_find_level_exact(struct device *dev,
+					unsigned int level)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
-static inline struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
-					unsigned long *freq)
+static inline struct dev_pm_opp *dev_pm_opp_find_level_ceil(struct device *dev,
+					unsigned int *level)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
-- 
2.39.5



