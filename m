Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D010533F590;
	Sat, 30 May 2026 17:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162688; cv=none; b=IbnQXESE1gALlaayscOYyTPQX5zE5QDgxq+cQ/SMxXkR9a3keKEsUIV3Zls2msNHDm6dDYL9XLXvcNLdCw0x6GjHMK+0t9mBIgl43JMCAaewbalnYF/TXSHTzlEY6S+L/Awos0vSKZP2d+Nip4SZdHcb38o66bhWbDZQipjUsoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162688; c=relaxed/simple;
	bh=yCk01z/PN4Q9G3UEAHdfYMzrAxf1Hs2jSjdE4TUxi60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7mmm/zhHl0UtByjBoCbL5C+tSUmWQHvp8rfYY42IzyYDMxjQVOIZXGY7PNQBqmUXnC4Clz5K+ieEXSU4wg61o60y4TAaZJrhC5YO5+WvOw6fpSIATU3zlrxccs0l52LmJuaY3aZBcvFDHxl/XPWz2vR93t9BfKo6Q3OkgHIrgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFrHuzxH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFrHuzxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2151F00893;
	Sat, 30 May 2026 17:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162687;
	bh=lZNSbKdrlCaE/7fsHkb7Dk/CkJzmn6mvm4hRL/z+SCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hFrHuzxHiIPAmvB6uArH9mwHaxtG8YQ2ZG0GHF0bHSK8nbmJnH3cXWWHWUNELWOvi
	 ouK5pNHs4TondVO3ipR/sBfoIqIVI6YfmhRavOTDux7JgDykh1FHAQdHojsLtIUm9F
	 N2MMyRorZVcpl+7hvWpzUvt/tzVU1kyrO+dx8S/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/776] pinctrl: intel: Fix the revision for new features (1kOhm PD, HW debouncer)
Date: Sat, 30 May 2026 17:55:25 +0200
Message-ID: <20260530160240.547681972@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cc64eda155f57..3854600329628 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1532,7 +1532,7 @@ static int intel_pinctrl_probe(struct platform_device *pdev,
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



