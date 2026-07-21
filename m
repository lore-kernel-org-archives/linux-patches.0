Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993A643551C;
	Tue, 21 Jul 2026 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649348; cv=none; b=WnnzwHOV8CscA+UpPYHyWP4IeonGBkMz12jcOFbR/DLwODE25ky/X8fbCiLpKpqcCNhpbHDjoKlDlSzDsDartPOLMW24wp3k4v5MZdYdmo13OlNQdruSIcFI4HNuyCYRZs9ecum5RUDxVzGCJqLWr+edEC/+PHciTYSvU6RCxF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649348; c=relaxed/simple;
	bh=JcetWXieKALcwl3JPeuxPvJqT1t2b+aM/uP/zx3oOdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzQjv2+iB09LUjaoAmJ/rAu/gn+jzOT6tCAh/saBc9XVWcXqPtH/2O3tK8ZAsyfvGAc/7FIp+I+N65tLxUfzgRqKLg9ig7RgvwyzD3rZz6YR5SfeohAEtjov8wpS82za6puGCOD7GKH9sCld/T2DxtG3ANnSLdCk1OMzzwCaR6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2vSAczW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2vSAczW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A94C1F000E9;
	Tue, 21 Jul 2026 15:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649347;
	bh=YNkZgxjHAqVh0w1lp0hNJ2dsHbiQXeb9PL/V5P7LIeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2vSAczW0DIWlAfH/XZzRY3vZsF3U4owGXNG4DaBbx+YKlsKt/SFEecGp879zVTTH
	 MY+rQQb5XfCxLFFNaNxot0Ni/JNVe5T/BXthrsRjiGFXC/RGmg4dfEgwGqmCsMVw23
	 IDFMXQo+s5IitjOi25s+tpgFPHeu1tKZDhjaxorA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0542/2077] cpufreq: Documentation: fix conservative governor freq_step description
Date: Tue, 21 Jul 2026 17:03:35 +0200
Message-ID: <20260721152605.593351573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index fdca59c955dcc9..8831cface58552 100644
--- a/Documentation/admin-guide/pm/cpufreq.rst
+++ b/Documentation/admin-guide/pm/cpufreq.rst
@@ -586,8 +586,8 @@ This governor exposes the following tunables:
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



