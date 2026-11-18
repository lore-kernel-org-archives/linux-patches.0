Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040808;
	b=EiWA11L7W6SEy8W4j9sEXEWoTquASzlaM/qZAtYFRE69hWAQEW7LiAqFkA0s7H5PolnP
	 DTvmaQBnO/fbRrdTaa4A/ngadmUvtVVltoZBoNQXDDNOQF5PMLLjKYzvj3J1uI4MVDP2U
	 K48hYxVk4wc/GB0GubRP8xzkfmYIl9FrRKtXmL8jXOs9sqUkVfNUkbTNEPv8yQ+L7Z7YE
	 U3lqkDSMdBPFe8HRWd7MKcTKXo0JpwlQPRfPOFqriqf8ylY1eTwbYrCA6ssoQtvvFp1iV
	 3TRPF44lESEYcFjXQukmS5v3tVGQGq2HFdutrN2FyrEYs3twPQ+JTGKHqpUNCDRQO4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G7ZFUO0FAoRz8VuM0swupzrkfkCCbQEipjVdoQVuvEo=;
	b=sDeOqeDN2iRuwfBYGIqBcAn1PZLKmfLDoGPcVRHDtNccVabzs9TxYnSRm9muZOyV6Xof
	 8DxlTRmnDIcCbQ7a/5sYvlEnZTerQ/vv1PWUhJlda4r4vhEHupznc6+LeCSQeP+Dtqu4b
	 DZAoiKxjhY5QXgG5hBM9/rCTF9PzeX5tKZJQJy7gOIpMUT2v6BS8eCZYxC2dtNfQZb0bW
	 F5xq6LA67Up8pgK97Y3foMlq6s/4NHKD7uHrO/FJv5WzPkz+iJ5NBGKGsBGqnF5RIq/47
	 h76f0XM/h1ejTzHoHolmv7DTC7bj5aPQZlSdIcplSKEbAn6gRnYA0yyvQMvQEpiC1YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fn+RXdSc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966D0606A31C;
	Wed, 18 Nov 2026 22:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fn+RXdSc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFCD1F000C4;
	Wed, 18 Nov 2026 22:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040808;
	bh=G7ZFUO0FAoRz8VuM0swupzrkfkCCbQEipjVdoQVuvEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fn+RXdScyZ+kOUiFfNNdW618Mwm0R311WaUYKp1XDCEjTUtreYwvyPKsifzCEW0s/
	 0uwZbtb1kOk9jBTe7mABlhPw5il7NdBInwG5ccbosadrJnh7FW/JHT0eZ+mfjgu+I7
	 emZke3tw12M1RMfpx3xSTxKMCU7AICWmt/llAlXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2582/3318] perf/marvell: cn10k_tad: Publish the OF module alias
Date: Wed, 18 Nov 2026 15:53:24 +0100
Message-ID: <20261118150438.654148502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit 848468c86f716e4552bd478d2f3c3f5d81bec7ac ]

The TAD PMU platform driver has ACPI and OF match tables, but only
the ACPI table is published. A Device Tree platform device emits an
OF modalias, so the ACPI alias does not select this module for it.

Publish the OF table inside CONFIG_OF and retain ACPI support.

Fixes: 036a7584bede ("drivers: perf: Add LLC-TAD perf counter support")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/marvell_cn10k_tad_pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/perf/marvell_cn10k_tad_pmu.c b/drivers/perf/marvell_cn10k_tad_pmu.c
index fec8e82edb955..afbb89d14e635 100644
--- a/drivers/perf/marvell_cn10k_tad_pmu.c
+++ b/drivers/perf/marvell_cn10k_tad_pmu.c
@@ -367,6 +367,7 @@ static const struct of_device_id tad_pmu_of_match[] = {
 	{ .compatible = "marvell,cn10k-tad-pmu", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, tad_pmu_of_match);
 #endif
 
 #ifdef CONFIG_ACPI
-- 
2.53.0



