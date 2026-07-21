Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8482043D501;
	Tue, 21 Jul 2026 22:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671457; cv=none; b=VUzpmx6EQRuRnrTUobXaja0w5eJmG+nxBG6pC2g+mjsrl6tOZEY34quWElrVJLaFxZfNAqay8ZgSySmoIpJrz+GHeIypVJUp4v91JwcgUITtEwPo+XBGc0SIeecNiWeWzvJEWcDVXZM992lj8EAI4bPgoP3TzhOfva8i9FexVYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671457; c=relaxed/simple;
	bh=L/cHwBs14/0FM4rZ7xjGmP1wr7Dysbf+eoEsK9u2lYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tESIl6DgSZq2GW1SYzQd0Yf/jwmnDO3oZ9yLjRxH/mN4p55VvxoLNoDTMxPL3yqLzXZ2JZMI7IpZn+JnMXy+80dyCQrY9x5b5BXURblT5YiXHOPoIS35nJI/O0j3pDGjGMHXDIUWZFTLGu8vVxaE+IMEWrwKojoqx1xihmlUpvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBllVskU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBllVskU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD0F1F000E9;
	Tue, 21 Jul 2026 22:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671456;
	bh=Q2CtTx5fmQk+ZpLZQjgGxFC8EdczVp8NgTl/fHofDto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBllVskUr4u+ojgyndVVpdgEuGevH3P1LQKanCJFS+36xKbubfB7JOwybFS2b4MZB
	 27+5LSUorMOth2r5wm2U3Z73Zb8lJYqkviETpzBWCG9tLfDtRbh6E/pH9CxbBT6trt
	 yCpcoH36msLBR1e0LrcHJ24SWFbLBmwyY0lkrSPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 252/843] cpufreq: Documentation: fix sampling_down_factor range
Date: Tue, 21 Jul 2026 17:18:07 +0200
Message-ID: <20260721152411.693554274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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



