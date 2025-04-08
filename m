Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D82826A0A6;
	Tue,  8 Apr 2025 10:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109840; cv=none; b=Cw/e1IJ6Pid46V7PYJ3kYtQcXX53x651DOPnv9STJKWv+szQSjsvS3HD5buFyMcl7LDq+NoFkxIqz5b6KJeuh7ZC/7QR+5++FSs9WoTbdCHCYb10hfRuD1LtuIR+C9remwY6sxyMlu+NEv4gqslWXF2680K+FEa4v2G7yZLWVhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109840; c=relaxed/simple;
	bh=3smmB//ksvIgOVcLsOYH3eM+nogxv6sU5kQKZcjV0JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ne/uP0VpvUj0sEjeBe2hJ6bVlTwM2cylh2JpNvZfgV9N3ZA0+woerrp1ag7eJsW8IjtjqveRt5PWGedKwf0zFzqjK9woQA40DGbtyqhT4R6z5kh5sUCsT7rJHtWhheB0XsfZsgFC6581bfiRHeqmzEUyY6ueNWwJ7Df4nfyZtY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWLeNLqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWLeNLqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6274C4CEE5;
	Tue,  8 Apr 2025 10:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109840;
	bh=3smmB//ksvIgOVcLsOYH3eM+nogxv6sU5kQKZcjV0JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWLeNLqhJAp7HGtqpRKiEammfMB3UwU+57jcXu9xeQe/4+0GXmRu9/Mi9ZoeakGB8
	 tUEbaTP7cbArLzHnNjreKZPlkZZ4nXNpvMxw+97UUMCOyPvE0bYe1245/jcUteLmH9
	 Uk6NfexsRHkFdSeVQzLZBcK8gLxV+W1eq2sNgYr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Elwell <phil@raspberrypi.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/227] ARM: dts: bcm2711: Dont mark timer regs unconfigured
Date: Tue,  8 Apr 2025 12:47:29 +0200
Message-ID: <20250408104822.528064467@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Elwell <phil@raspberrypi.com>

[ Upstream commit c24f272ae751a9f54f8816430e7f2d56031892cc ]

During upstream process of Raspberry Pi 4 back in 2019 the ARMv7 stubs
didn't configured the ARM architectural timer. This firmware issue has
been fixed in 2020, which gave users enough time to update their system.

So drop this property to allow the use of the vDSO version of
clock_gettime.

Link: https://github.com/raspberrypi/tools/pull/113
Fixes: 7dbe8c62ceeb ("ARM: dts: Add minimal Raspberry Pi 4 support")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250222094113.48198-1-wahrenst@gmx.net
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2711.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.dtsi
index 0f559f2653920..9bb98338609b6 100644
--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -424,8 +424,6 @@ IRQ_TYPE_LEVEL_LOW)>,
 					  IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) |
 					  IRQ_TYPE_LEVEL_LOW)>;
-		/* This only applies to the ARMv7 stub */
-		arm,cpu-registers-not-fw-configured;
 	};
 
 	cpus: cpus {
-- 
2.39.5



