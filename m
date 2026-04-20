Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F585332919;
	Mon, 20 Apr 2026 15:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700155; cv=none; b=GEYso22tdLXR20Yjn/TRR4qaWJtyDF0TZh4JWWOaVvycJgrTg75NWxetyOt2a+qhNsKuE/1fnljQVB0aF92v0A7XUnwGp9wCvRYYA0zxOqaznwET4W9Sg0ieXhvd04bAN0KhzEH7r+6AR1Ccu9DaeD6DROjRfHIPAKntQSfI+KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700155; c=relaxed/simple;
	bh=kD46m8Yua7ucd6KzIYJSYRvwHIqm8BetGF+yO5ylFdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzN5qEjFhhPTkfAIehqEpxDztQT2fq1WxT6O8O3XI1cvJTVby9hoxJ3MdP8HkJq7IIITc+QCyP0HMzf/Rvvi1AiBXm/+od9zNLoMxEhSwQIO2P6xUabeof+3ZLDO3p4507mcdHw2P8crXlpJ7n+yO7oaTo0giQxfuZYBeNneJRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzAWjqr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzAWjqr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4982C19425;
	Mon, 20 Apr 2026 15:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700155;
	bh=kD46m8Yua7ucd6KzIYJSYRvwHIqm8BetGF+yO5ylFdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzAWjqr1OPZsnNISLCIOMLXHpnaCGNSINFc0hnaeZu0CBdDBvCKvxTALYI/kbLHsu
	 n/cPoR5BPP8/yR4kiOInSOFdZoF1nEjEf786hj/wIKnuAfK9CWNXNUcnPHdE+OioYy
	 PstiX9YXh5bIQ6s+uoG4o2jLQIBNsgVgGDelYBaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 036/220] pinctrl: intel: Fix the revision for new features (1kOhm PD, HW debouncer)
Date: Mon, 20 Apr 2026 17:39:37 +0200
Message-ID: <20260420153935.335433827@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a4337a24d13e9e3b98a113e71d6b80dc5ed5f8c4 ]

The 1kOhm pull down and hardware debouncer are features of the revision 0.92
of the Chassis specification. Fix that in the code accordingly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index cf9db8ac0f42e..106835b5ee5a5 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1610,7 +1610,7 @@ int intel_pinctrl_probe(struct platform_device *pdev,
 		value = readl(regs + REVID);
 		if (value == ~0u)
 			return -ENODEV;
-		if (((value & REVID_MASK) >> REVID_SHIFT) >= 0x94) {
+		if (((value & REVID_MASK) >> REVID_SHIFT) >= 0x92) {
 			community->features |= PINCTRL_FEATURE_DEBOUNCE;
 			community->features |= PINCTRL_FEATURE_1K_PD;
 		}
-- 
2.53.0



