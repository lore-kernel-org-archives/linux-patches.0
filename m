Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FFA18A6D7;
	Wed,  5 Feb 2025 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766810; cv=none; b=jZ+bLrpFwnUJyHk+q5CIt4bDBesD7qR0aDUwcF4O6TUEsm+qXdeqBsvqH3qdrDLm3zDOXJKOA5I5x6R1qXKwIoKuI4EgTfrYOM2JnYa8BWNd1imMMgQdIw1fN8W77/5sYTuogNUvSxiI7DEeUxkxylth40qucfrG/SPwqkSovoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766810; c=relaxed/simple;
	bh=bw2Cqr+HFtsfEu6E44MC8VRjrbTuOGH2rB9QX2RCDA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SiWXh9zY/AElxmNjompyaYfB5GgIZGoeAa7VN2TerrbYuB0HFkj81roNB463fzzx0B/k9+VC4zRjukv6HEMcPhpQsuQaRWDMO4IS3hg8qwEdSVT/Ek7Lhmbfs756jmdE/LV6Ri1/hjoigeq7nrsNVUS8ef8l3jHJHxB+UDSdxWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elh6Dgkm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elh6Dgkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692E8C4CED1;
	Wed,  5 Feb 2025 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766809;
	bh=bw2Cqr+HFtsfEu6E44MC8VRjrbTuOGH2rB9QX2RCDA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elh6DgkmbnSqDHCRvzlEr4XZ/XPa7qx0uQfnSh1UxE8vKwuHQEr52TN+SVr1o9vD3
	 OhcXNvls5m3LLkbarvQ9qFQiIa/QtGtCQajRbqvlA7JNyMv5eJegr5yqqlemJo5x2K
	 SRLcZGh8vBNt4L7U4iHiNzmE2/WskmCHydG1i3l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Liu <b-liu@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 364/590] arm64: dts: ti: k3-am62a: Remove duplicate GICR reg
Date: Wed,  5 Feb 2025 14:41:59 +0100
Message-ID: <20250205134509.196285184@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Brattlof <bb@ti.com>

[ Upstream commit 6f0232577e260cdbc25508e27bb0b75ade7e7ebc ]

The GIC Redistributor control range is mapped twice. Remove the extra
entry from the reg range.

Fixes: 5fc6b1b62639 ("arm64: dts: ti: Introduce AM62A7 family of SoCs")
Reported-by: Bin Liu <b-liu@ti.com>
Signed-off-by: Bryan Brattlof <bb@ti.com>
Link: https://lore.kernel.org/r/20241210-am62-gic-fixup-v1-2-758b4d5b4a0a@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
index 16a578ae2b412..56945d29e0150 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
@@ -18,7 +18,6 @@
 		compatible = "arm,gic-v3";
 		reg = <0x00 0x01800000 0x00 0x10000>,	/* GICD */
 		      <0x00 0x01880000 0x00 0xc0000>,	/* GICR */
-		      <0x00 0x01880000 0x00 0xc0000>,   /* GICR */
 		      <0x01 0x00000000 0x00 0x2000>,    /* GICC */
 		      <0x01 0x00010000 0x00 0x1000>,    /* GICH */
 		      <0x01 0x00020000 0x00 0x2000>;    /* GICV */
-- 
2.39.5



