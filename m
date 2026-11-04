Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831016;
	b=y3n1Ot0EoEDhQDDFLw+WhFelfV0kQOtZmvhskLnWTbbzUZEI/o3eRMaIM7PtZUOOy9o/
	 toonwLitYpeidxBkcG4L7PwFASzeyEq7nZFWfjzIXKKI0TXdfD4dGIFlociROkKbuC8RH
	 A/M/7KRb8IEnA5BZp5TPdvyliUqm+5yFQwLpox4PnCYoS7sYU4+p6kLRwzGVgUu6D8AwQ
	 dxdOGufKwgHEngj0DBg/GhRALNkS3j5yyz7OygftdLrOusNg2ZHNJ5HibbYNtI4mpgS1g
	 ea1nrVu3VZMqUgoOBQ495In6hcB6oz7W5bILxAW8jxtciWivMHwJ+6MXNyRLbD5rI9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Ok6k40uvK4L4eSz9CaRadnqhnYyC3ESPwG8OShOS/Y=;
	b=s0Kc9n0/Fv+/Yd+dTCrczme+r4yGZKInnM31LkeQvU1W8DcFXSC202S5h6fHve08XBgl
	 OTZAC5lsoRYZ43UQcv8CoqKlIDe4aVWI+/ZcWXFagNCgS7jmUrsOOSnQWrkgLAb8Tsoyk
	 UG2mnRJxQL/QqR6ol+GYkvDIXEPmjT+/xyf4IVMAsoa8RV6kkhIDsbbyG7f8cqVLVzpe4
	 evoBKI7TthZpH/rPDvJsE7LMgVynmCwSoYlLPViTaauAKyUToe1SjThxuhh+nZ6kdLr75
	 DlL9WdyCOuXsXrPwAQ5rq7EL741J7CLwW8AWRCJ+d0ScKowEduWny+lKkzjEbkmkEfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HrAvjgQB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E865606A843;
	Wed,  4 Nov 2026 22:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HrAvjgQB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114441F000C1;
	Wed,  4 Nov 2026 22:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831016;
	bh=4Ok6k40uvK4L4eSz9CaRadnqhnYyC3ESPwG8OShOS/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrAvjgQBmKjOIfTCA29hP38GkLz/+1s1Z89CkWsRdrQhMhZ96tZgwopp5lWmn8tQW
	 x09KskR6Of5CEwEZ6QoeUQm2cZ71TVNMgHizGyqvSP0Dqn2pdKNYZg74aQLEKqvwKH
	 l/DP2+Aqa5B/eFG1BesqrxzNIYDI/+Sz4++mQ1js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0458/1005] powercap: intel_rapl: Fix kernel panic during PMU unbind
Date: Wed,  4 Nov 2026 16:03:11 -0500
Message-ID: <20261104211056.864891159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumeet Pawnikar <sumeet4linux@gmail.com>

[ Upstream commit 916b61abba586d950a4d8264e2841cc5ccfa4df1 ]

rapl_package_add_pmu() fails internally at perf_pmu_register(),
and rapl_pmu_update() leaves the global rapl_pmu.pmu structure
zero-initialized via memset and returns an error. But any
previously probed packages retain has_pmu = true.

When the driver is subsequently unbound or removed,
rapl_package_remove_pmu_locked() sees has_pmu == true and
unconditionally calls perf_pmu_unregister(&rapl_pmu.pmu) on the
zeroed-out structure. This attempts a list_del_rcu() on a NULL
list head, immediately causing a kernel panic.

Fix this by checking if the PMU is actually registered before
attempting to unregister it.

Signed-off-by: Sumeet Pawnikar <sumeet4linux@gmail.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
[ rjw: Added empty line after the new conditional ]
Link: https://patch.msgid.link/20260822094657.12489-1-sumeet4linux@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index f08ac99f5e55e..977c4c90923d5 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -2106,7 +2106,9 @@ void rapl_package_remove_pmu(struct rapl_package *rp)
 			return;
 	}
 
-	perf_pmu_unregister(&rapl_pmu.pmu);
+	if (rapl_pmu.registered)
+		perf_pmu_unregister(&rapl_pmu.pmu);
+
 	memset(&rapl_pmu, 0, sizeof(struct rapl_pmu));
 }
 EXPORT_SYMBOL_GPL(rapl_package_remove_pmu);
-- 
2.53.0



