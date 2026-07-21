Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AF144AB60;
	Tue, 21 Jul 2026 21:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669019; cv=none; b=sPshGq5tmo9y1/IC2ljXvmh9+Oj0xSbJ+9Q86s3DC5oYXDuFh//8ccviL2Zl26CBU//aDI0ltYD/pJTAT+Rt/seQqDdueb8I5IECo75RId0mGqDVOW641aZqfZS0/cPxBxm64YtLsEcLyUDdG7ngUAcFWClNAxQJYNchKzGPqnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669019; c=relaxed/simple;
	bh=tqK1ZTAs0uetgufnyQDLLuwnETznoDzRsE2xX9FgOZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlP/mYgT760SWQuPrH2yxFPqm5Ca5LxTJ0KEeGkmsyzdU50iy+qU0MGrN8LfEZ4wnAFnDtWa2/RS7ueIds0g8OQdaEQCesGQQcZjW5MxgF+8sWzAIOl5s0DTAmUK+O1LxYGeFIQT8/EkE7oL3T45pK7DIO4NA0pqfWWz+2bL7aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3jHiQWA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3jHiQWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD481F000E9;
	Tue, 21 Jul 2026 21:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669018;
	bh=+L9M4fqsWt0iRIyx3rQALjQZ2g4wxkaBLQ2jeyONAZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V3jHiQWAijWZYRXlDbcbglYLlyd1r2pV03LfRUr0ZdWKLaRkd+4HBhOc769GwHMfs
	 4Yrw8u+4GH6V/Sc8ykGIUkmdeIZwXhZhL7GDIc7eDsWq1hzr2Y8XgmP6mHWM6Xfehx
	 6LKwU+UMT7YuJmiHXEUYorBS49Cz1GFBIT12ddGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0396/1067] cpufreq: Documentation: fix conservative governor freq_step description
Date: Tue, 21 Jul 2026 17:16:37 +0200
Message-ID: <20260721152433.490412034@linuxfoundation.org>
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

[ Upstream commit 03120e1425262c7d11f93362a88e579a1720390b ]

The conservative governor documentation incorrectly states that setting
freq_step to 0 will use the default 5% frequency step. In reality, since
at least commit 8e677ce83bf4 ("[CPUFREQ] conservative: fixup governor to
function more like ondemand logic"), freq_step=0 has always caused the
governor to skip frequency updates entirely.

Correct the documentation to reflect the actual behavior: freq_step=0
disables frequency changes by the governor entirely.

Fixes: 2a0e49279850 ("cpufreq: User/admin documentation update and consolidation")
Signed-off-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
[ rjw: Subject adjustment ]
Link: https://patch.msgid.link/20260603055635.1549943-1-zhangpengjie2@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/pm/cpufreq.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/pm/cpufreq.rst b/Documentation/admin-guide/pm/cpufreq.rst
index d2f37309cca3b3..5247eabb92065a 100644
--- a/Documentation/admin-guide/pm/cpufreq.rst
+++ b/Documentation/admin-guide/pm/cpufreq.rst
@@ -569,8 +569,8 @@ This governor exposes the following tunables:
 	100 (5 by default).
 
 	This is how much the frequency is allowed to change in one go.  Setting
-	it to 0 will cause the default frequency step (5 percent) to be used
-	and setting it to 100 effectively causes the governor to periodically
+	it to 0 disables frequency changes by the governor entirely and setting
+	it to 100 effectively causes the governor to periodically
 	switch the frequency between the ``scaling_min_freq`` and
 	``scaling_max_freq`` policy limits.
 
-- 
2.53.0



