Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827127;
	b=EzYWOBhIe0UNiyLmcN1AlDTCeihaujrDihuQt6CT9cWwHgFwaZkVnnD7100Ov2SXyBt4
	 cMSi156BLmzeVSg1oSz36MpkJKmPHuQ3RSZJdhRH8Fng/W/UQxgJ9W8umSeF5HQsmWZY7
	 XcUdPVos4zHjlKED48ZaUueByuA0XLMRo2M2sb7CE2Qgm9nwoYblDlSthJ5VUPyvAojSw
	 ZaxnFPlUBYrAfNLRq08Gaj2ZzaUZk3bCBZOfU5frUO6u6xRX4jZA6h15OrxrAneU5GAxD
	 EYrvnqFlqfkr6JHGkM46DXGdRDFZuwbo83yMV3LJRYRWLCwDYdzn22DBu2N3yj/tJkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nIf1g1Fo2uPz8jXGwAAsoq0z3jD9xh1Qc8eAavuMCdE=;
	b=wPFXumlDjLl2e00BE/8EF4JOY0ghOpwkKIMF16C5sDYkPYC5J5ilIgvf1ZjFOWym05k+
	 /+q3hpVSJx4NtLZZHnr42qjPQFTRrjEThLBl/VuamS1ZUYdzykT8zbFy6OGvSbaOc3BJs
	 k/uvHpdj1Ket7mI8delGWo4nFBwDBsN9/zZXeAYYqPtTqUDJCVWcL090jUScBSn8fLlfL
	 pp473/JKfdFMI4U01E9aYo2BKwsu5hAeISi6KhTlRSCzzbAN76tl6hpAaY3yGg6C2COcY
	 F8kzYE9+pT0UMCGAqcj+4lgsdTkVcDhfWzqPKhhIBgN08fkCKOLBQ19yO0QMDREFjYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzamZFO2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CF3608C988;
	Wed,  4 Nov 2026 21:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzamZFO2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342E01F00A17;
	Wed,  4 Nov 2026 21:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827127;
	bh=nIf1g1Fo2uPz8jXGwAAsoq0z3jD9xh1Qc8eAavuMCdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzamZFO2ukTXbPBLrjfpycgT3ZYL0bCq9ZgI0F/BtHG4VlDutHUoISKCl/Dv65qiQ
	 gEihS1ow9FfsrTJeDpg/bWAy/rOWEv+L+jylOmfb5TR+OFbkMwrFLt0dNGqfUfVS9I
	 zSj4GNvjiEyFeWx3AySTxkH0V0xdH9uFq5lmyOU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Zhang <rmxpzlb@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 7.3 203/547] rust: rcpufreq_dt: add module alias
Date: Wed,  4 Nov 2026 16:06:27 -0500
Message-ID: <20261104211043.910510017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Zhang <rmxpzlb@gmail.com>

commit 53732733c7af437b0ed710a1df91a67a0d3dfc07 upstream.

Add the missing `platform:cpufreq-dt` module alias so that the driver
can be automatically loaded when the platform device is registered.

Fixes: 06149d8f2216 ("cpufreq: Add Rust-based cpufreq-dt driver")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Zhang <rmxpzlb@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/rcpufreq_dt.rs |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cpufreq/rcpufreq_dt.rs
+++ b/drivers/cpufreq/rcpufreq_dt.rs
@@ -225,4 +225,5 @@ module_platform_driver! {
     authors: ["Viresh Kumar <viresh.kumar@linaro.org>"],
     description: "Generic CPUFreq DT driver",
     license: "GPL v2",
+    alias: ["platform:cpufreq-dt"],
 }


