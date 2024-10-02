Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDCE1D043C;
	Wed,  2 Oct 2024 13:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875570; cv=none; b=etz7MSAzLFKJzQF4030hJUdRQV1KFnYbW3+pf3xFWehiMR2P3fwpfxnjOEPcb9RDxIr0tMhlI5CFqQOMkpUH5xT+FvVrbBCiC3ddMM/KamMBgbuYC5lEaISTEaGlmcLexyYkMoDV6At2MiAPTUUT6iAnGlkAqDQlvIu/qk8kx7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875570; c=relaxed/simple;
	bh=6atKlorYMMGUkljL2JmGKDEbUbd0Jv6QEADLjewtrzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8tkQKt3pF/Qw9rR7fN6gtAXaAcJ2udzQ0kE0qjhNSWvptR5SUvbLlUY/v6XQtfpd4s6QGc2W1zOjykjQNWcWAQcL0cpoOftE54iuPg9MruA8Ch9/9HvMC9MYHVWTBGsSUyErcHVeeIFF0uXKFFVKi4VdJv+H0yhx/DHO82Ew/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOMgjCwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOMgjCwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AB9C4CEC5;
	Wed,  2 Oct 2024 13:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875570;
	bh=6atKlorYMMGUkljL2JmGKDEbUbd0Jv6QEADLjewtrzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOMgjCwqbGw7DX59zua3Gho0tN9ZZOdp6meXCP+CGjG2WhGQ2hKRJ8n7DTPViws5d
	 kQqEK6s3QvnKIoecswDvrbhqG+WChQIXrVJUqgwd2qoIHVPFoSyDzpDAIF7GXk6s1/
	 dcukWJf31F47uL7t4sxdo+hsE2uxNs+zNGay4vKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 146/695] arm64: dts: rockchip: Correct vendor prefix for Hardkernel ODROID-M1
Date: Wed,  2 Oct 2024 14:52:24 +0200
Message-ID: <20241002125828.311727776@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 735065e774dcfc62e38df01a535862138b6c92ed ]

The vendor prefix for Hardkernel ODROID-M1 is incorrectly listed as
rockchip. Use the proper hardkernel vendor prefix for this board, while
at it also drop the redundant soc prefix.

Fixes: fd3583267703 ("arm64: dts: rockchip: Add Hardkernel ODROID-M1 board")
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240827211825.1419820-3-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts b/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts
index a337f547caf53..6a02db4f073f2 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts
@@ -13,7 +13,7 @@
 
 / {
 	model = "Hardkernel ODROID-M1";
-	compatible = "rockchip,rk3568-odroid-m1", "rockchip,rk3568";
+	compatible = "hardkernel,odroid-m1", "rockchip,rk3568";
 
 	aliases {
 		ethernet0 = &gmac0;
-- 
2.43.0



