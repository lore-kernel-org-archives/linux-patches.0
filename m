Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831443;
	b=PlIO3s7xfHiEBsL8LjEO0s0gdvzsrl+Kw6MmHt0+EZeDoah0lq3k3IfLXVCu2hUtY1/Y
	 jCPh040x49UZ1YTdqtr5cy5wbTiARnE8RG/dA5R0IJDowlwVAvQoLRN5xhg0TDhv60anM
	 wMA1fF+KVCBk9R68mGKMuQnYhbv/ugOlJ/fCmMPkqofE5SC2NXpJffg9EhZ2YuCEPDRuB
	 F4kHrqduNKCWEmUOQtdnemFAiUMe2R+wSPpbnzu8U09g7E6BLRdBLgy19Hn6REplcvqmF
	 Swv5jktMNd0Wjuz++7bubyxdEM5H+3UogqnSNXapBG1oHYmsEfFMuaHmBr+byZwqgdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i3rr6l5VDZf0mrEb1AHmrJc0UTW8rjKiTpctvjHqVXs=;
	b=bqZ+5x/lR3B/q4NOyfbFOKBPQu1Gl99hk/9LiNjFI24fBGgvHK2OFFPoetqQeodP4ghp
	 qx4ZXsccLQyBR4WTCxVlP8FEcLZHsb7TNAUK3/DvUpZEPeoSKwcOwJX2uxkDrUpe36Xhm
	 etofOyGzbz0om/WUjXtQp+KL7FlDvBAZqR64/yvXFd3/uzx9kXe0JS7PHrb/bdFTGyzLJ
	 Uz4fT4+YHZNuptfJMgJD8AGJXNs5xIlX0pwzehOdaNkO76Sn2oBJILNGTfRpaw2RoTJht
	 Croq1y7UldxPtTSvpcKaItwX83hXmBtqhziabzsvPlt3FdHfsNKw7e5VHKjTy01FKJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GreY/fxP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A23606A328;
	Wed,  4 Nov 2026 22:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GreY/fxP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11C61F000C1;
	Wed,  4 Nov 2026 22:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831442;
	bh=i3rr6l5VDZf0mrEb1AHmrJc0UTW8rjKiTpctvjHqVXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GreY/fxP9A4FAAzcnXMefem3OiwJ55E4YzcSE+i2HOiG4qIGs3QrtEQF033W+9S73
	 jepTkkX4aeWb2NA6+J+dODNU5WAdqm1JFIP7WnKJ5IeXkdUmJpM7+8/sjCe6kfJ87/
	 RAYpGFtStoV/AlTyjUtEtFPS1LoJIUYQu0enNm/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Zhang <rmxpzlb@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.18 0704/1005] rust: rcpufreq_dt: add module alias
Date: Wed,  4 Nov 2026 16:07:17 -0500
Message-ID: <20261104211103.300416123@linuxfoundation.org>
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
@@ -219,4 +219,5 @@ module_platform_driver! {
     authors: ["Viresh Kumar <viresh.kumar@linaro.org>"],
     description: "Generic CPUFreq DT driver",
     license: "GPL v2",
+    alias: ["platform:cpufreq-dt"],
 }


