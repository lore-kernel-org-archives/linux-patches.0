Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061056;
	b=gloXenwzHR/x3uihoTb1Yo4G2bYJhJEC6WmlQHoIv5EX1NmOmBM4zr9OlRUoWcd8kgSH
	 XSdVhiVm2VrywfR/Gd9rvNislltoUEyuTzI8gRdxHSJA3+zMDrTECNbqmsoVXhqlznRe/
	 oVXaCXVfz5k9wGGd/pfZe632szOKghg8uib6eiAG3V8aCqY6BKFhciEEKplfiIZIA23zE
	 LAsaFrZ4DsHGDwo5tn+/kt/697sa85CbyygxjoR69KpIA7fqLP5xt/krihWR8ODg7I8G+
	 ZQxBcbK9YPfKG6l7Wl/W66pQoSIyVJxCVPzDbeVwo9gddCLRcsUK5vg5VMBHko3xpjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h5dNXVhmyoN0papFR6Map1sLCB5H9TidQ/gg+0jtNyk=;
	b=QmsOif+47BWQbIeC//gzQ62PHozSQkuDHUXTRwVGL3zmMv1Zu8e3kEOjYJkaimEYCGSO
	 eLizeYJGSHsg8l1K3gR1cwIagu+HTq1sQ807tetOLb58YP9kDiTglLeWxLS0nDSRM53qO
	 Rm/zSn92vn61P3T34APLKbDmMe7YgwBDrhpH74lh3M+NujQA8fVsqy6QQDl3cF3gSkMMF
	 rsS1GrT+lKrUh6VfGBxm8erD7vTT8pp2vFr1+XZmzBL3AgtxL2CWAV+KWzresdpaIcfLT
	 WHphGAFCq0vDrmQk9I+GEBlgAKkny4qp2n3c7oEW5iflXIcfxXQ5EY2CrMa0r1bpxWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VzCTq8px;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACCC606A339;
	Sat,  7 Nov 2026 14:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VzCTq8px
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5461F0089F;
	Sat,  7 Nov 2026 14:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061055;
	bh=h5dNXVhmyoN0papFR6Map1sLCB5H9TidQ/gg+0jtNyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VzCTq8pxwhSs0lrzdQvHRPi9X8zPTLcXg/yrNfxh86G7h7cfEbNoyS8sYvvXqMSn/
	 slAKPgUQXVx8IoohdXnpZcsIGqhaBKMIlduA47/uccf2wHK+IYzaudFuCdQ3zWslBW
	 c3x+WomHDAxNolGE6qBv1RSIv5/XyxeQa+NG3fOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0387/1536] powercap: intel_rapl: Fix kernel panic during PMU unbind
Date: Sat,  7 Nov 2026 08:40:03 -0500
Message-ID: <20261107135008.481746782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4af20c36a8095..8a00e757f87d8 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -2101,7 +2101,9 @@ void rapl_package_remove_pmu(struct rapl_package *rp)
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



