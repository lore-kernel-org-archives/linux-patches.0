Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2A744AB68;
	Tue, 21 Jul 2026 21:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668830; cv=none; b=bbUCl8Lm6g3ckPFZWjLVYPLgqPw+WA7LytzX+Qu9P/ftr2k1P5pDp2m1JJWMvkMZe3d3Bcge2hO5k8tJXr8s9pzTbD1ZWXZACB4mJmcAFDD//6m9ymZbil6JvR2DGxoghqkb8Xi1AU4j2leJ948a/tacUe1NVckbrIUVfKBVV48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668830; c=relaxed/simple;
	bh=Nd3vW4wc60ghdiZnMo0l1BEnfQoNJzhT6QYJh1oc9no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgKnXRkjPmlbEup1tt65A5eGibbs72ep1n5ftPWtlWdQ/d7WnvBDrMoCclQ4PVhHPlHPkwhRZj21I3uKd8QodluD6lFvdFg6ybrT+j5yym7vvIXjHZ3W1CW2aJBxRXD0+F6b7tscwrrVseUjNjVRgOj5Ym14IuCeOk6j1UQDGlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWwjOEDz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWwjOEDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05A11F000E9;
	Tue, 21 Jul 2026 21:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668829;
	bh=TbYcesOwMd/XlmnehHmTTPKRPY9TI0JMxC62GZoDByQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWwjOEDzJJW+a99zhDymk/0zZGUvm98NeAK+ayGgrcFZoKpfkG2MY9kH0yQceST1R
	 TDuige2J+/dTFkCvAKdtMbaGmgPEml8+p1Z1n8ZBuBptU7O3nxNG2t5fTmGZRBd5Ja
	 FG+k0ILfEA9rAyDSgsjqgqc26XJurl9iZ6MAJWZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0323/1067] cpufreq: Documentation: fix sampling_down_factor range
Date: Tue, 21 Jul 2026 17:15:24 +0200
Message-ID: <20260721152431.818320630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengjie Zhang <zhangpengjie2@huawei.com>

[ Upstream commit 85524e651d20944399322d46fb97960337831d43 ]

The ondemand governor implementation accepts sampling_down_factor values
from 1 to 100000 via MAX_SAMPLING_DOWN_FACTOR, but the documentation in
admin-guide/pm/cpufreq.rst still says the valid range is 1 to 100.

Update the documentation to match the actual code.

Fixes: 2a0e49279850 ("cpufreq: User/admin documentation update and consolidation")
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Link: https://patch.msgid.link/20260518133457.2408463-1-zhangpengjie2@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/pm/cpufreq.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/pm/cpufreq.rst b/Documentation/admin-guide/pm/cpufreq.rst
index 6adb7988e0eb6d..d2f37309cca3b3 100644
--- a/Documentation/admin-guide/pm/cpufreq.rst
+++ b/Documentation/admin-guide/pm/cpufreq.rst
@@ -499,7 +499,7 @@ This governor exposes the following tunables:
 	of those tasks above 0 and set this attribute to 1.
 
 ``sampling_down_factor``
-	Temporary multiplier, between 1 (default) and 100 inclusive, to apply to
+	Temporary multiplier, between 1 (default) and 100000 inclusive, to apply to
 	the ``sampling_rate`` value if the CPU load goes above ``up_threshold``.
 
 	This causes the next execution of the governor's worker routine (after
-- 
2.53.0



