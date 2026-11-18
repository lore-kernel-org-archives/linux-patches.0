Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025452;
	b=XppUej9FfYUMuEjrzPnDmaCdguJ7GH6uIUfASPbczIxTVyz75x0AyPHgv//7b7qk2FOo
	 EXA4FJDWUAnZ+fYyf1y4ddd1KeIIjY2JpEuP5mwrkAAU5DGUFbbvKf+qpNUKvF5TAgxvB
	 qGIgAyQLDVnSgISa36gV7VYBb9ZfqZXx1PiOQOjXG7gWi/74MojvWqSLu3KWU46y88EQ3
	 1ylAAhew3g1gKiWGtFxLTcUPd+us/twHm3gah9SfO8IxaOuxrGLdUU/A6Vd/WZ+wL8+HE
	 3utxs5hMTWollb2emIO2eXZjekmp6wjlMXy6qmQvFPMCZ6B9XKCHflhHuGwo+Rhv+tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wpQuSy4oI7pKch3RbMqI1rcD5Rj+8XJG0IVpjhLgAME=;
	b=SlmCPMDUIqAR/K67QJkGrSCS72WRcjbrCkNnEMDtlNlVQR0GRz0eQjrGGzfA/PSShNfD
	 ysKS7Psdz+exK4AFkIUBONNOIirX7kkNq7+prFk+suQto2h/qWZgtSkI1+DvlqwaGcWh5
	 zsK4u/GfKOChIor5XmgsMKmiGpPeogorGiSKMpmoo038CMS7ABEpLqxauJqKxaDGDjhQw
	 pZlrtRXoVlOTpZB4QIYcPLi7LGoKbCIrghaI0alPSbjJ2f/u0oaAkP+Zwz5UX9HVPMkV8
	 wJuhG31p0TTVzYDkYa24bn4vASAXuGHc0L9EQr9M283wckb+Ce0zc8vmh6mUtRlOv0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f6mPWjLO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9355606A325;
	Wed, 18 Nov 2026 18:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f6mPWjLO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413141F000C7;
	Wed, 18 Nov 2026 18:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025451;
	bh=wpQuSy4oI7pKch3RbMqI1rcD5Rj+8XJG0IVpjhLgAME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6mPWjLONEoTgxNO7imWcqKo0lvS/m4yjS9cBg84n/17DEzkwwuQe8yhM+q27/OJM
	 6CvH1Bya6QYQwvGCuhskfKoZNA79RLLNS9VmmqjJ24gKaysUb/gpsHiv6QblAkRGvA
	 LSizZQHx/PtxkwXe7kqAft4rcqZGKHOBtkf0xa6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1084/2151] perf/marvell: cn10k_tad: Publish the OF module alias
Date: Wed, 18 Nov 2026 15:46:59 +0100
Message-ID: <20261118150201.752024178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 51ccb0befa05d..d7f09cb7c3265 100644
--- a/drivers/perf/marvell_cn10k_tad_pmu.c
+++ b/drivers/perf/marvell_cn10k_tad_pmu.c
@@ -424,6 +424,7 @@ static const struct of_device_id tad_pmu_of_match[] = {
 	{ .compatible = "marvell,cn10k-tad-pmu", .data = &tad_pmu_data },
 	{},
 };
+MODULE_DEVICE_TABLE(of, tad_pmu_of_match);
 #endif
 
 #ifdef CONFIG_ACPI
-- 
2.53.0



