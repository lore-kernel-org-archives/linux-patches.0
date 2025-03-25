Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46592267F7E;
	Tue, 25 Mar 2025 12:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905885; cv=none; b=cjuLdP4kQqdQR9RQsUtP9gsEQGFJZP2nTC1NCARlVto1LfXihq5G53E748OjekQpODSuTxZhvpePKNbbYpZJdG96SOYmU3N3VPKIBUKde7JWI8X0kdrdSKTqsHY9M6szx6ShWhdKFE476WA6stJHOqg8X33zNcrQqcf63AsJnTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905885; c=relaxed/simple;
	bh=ruFdBrk1DP8ZmlfKHR8gu4eloB35eRkaGTT762FeiOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3ztepTLj3xeLW257FtbFwXqRxzwZBBwy/kWphtgUGWmo2dqg5En8LgBvaZICDiO8AIudx8EWLb7mqFElt2cBEF0muSAx+BQLwTveptvAZNNKe+KSGc+XB5i5gYsf5Jopg/ff5CYTNkU2iBKVUL0iWYNd3fg3XbQdMNPm0caHf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yu9El+iB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yu9El+iB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2D4C4CEED;
	Tue, 25 Mar 2025 12:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905885;
	bh=ruFdBrk1DP8ZmlfKHR8gu4eloB35eRkaGTT762FeiOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yu9El+iBxF0BBoAJ+kG0JrFqI1c0w8mZKFcjFaSrczKoM83KI6IdW101TjlQj3To9
	 Uh4jgF10zz55xwQJhLwW6jYBQwfotN72E7FYbz1hmZ/rmBm1BLuzsFvI50GfJwGWul
	 QbQjk4Yuhro5hr8cOi4LhanEHrUQIuG0cSn6a2iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Elwell <phil@raspberrypi.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 018/119] ARM: dts: bcm2711: Dont mark timer regs unconfigured
Date: Tue, 25 Mar 2025 08:21:16 -0400
Message-ID: <20250325122149.531601749@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/broadcom/bcm2711.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm2711.dtsi b/arch/arm/boot/dts/broadcom/bcm2711.dtsi
index 4fd0732a34d32..c06d9f5e53c80 100644
--- a/arch/arm/boot/dts/broadcom/bcm2711.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm2711.dtsi
@@ -451,8 +451,6 @@ IRQ_TYPE_LEVEL_LOW)>,
 					  IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) |
 					  IRQ_TYPE_LEVEL_LOW)>;
-		/* This only applies to the ARMv7 stub */
-		arm,cpu-registers-not-fw-configured;
 	};
 
 	cpus: cpus {
-- 
2.39.5



