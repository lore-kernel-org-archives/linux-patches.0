Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A3618C903;
	Tue, 30 Jul 2024 16:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355507; cv=none; b=l4lAqvULT/qFhXkTkjhe3r7aACjHSl4vaNYgZFlvbbQ9qPj71yd88vUVvKlhUGNY2Lg5eMRBHP0/p5oWqiYgQOWCoVvHbyxf1y9clNaqeuNMKh8Oe94xUUiV+RcLynZDGvMlMfMTIALa4/Nqlk03n+bkIaDxk2octHzTovPjqKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355507; c=relaxed/simple;
	bh=8rRsalH//nBjkoac6H1e3H34pnV1bRjUXGU045LY1vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLRVgOC+t0EK9x/rV1DWQTlTMFR0A0l3BOPj5IjrrLn4DaKK3yvDySpOhwPQQ9mhuJrNBu7qHtBapTtftJXPTYq0x8BuN8RDF1pZsWX3zX+vAFunZ05jJeO404uPay1Fy053ScKuuZEsoGQqj0FfCix/J2jwZ+UujIoRCYGvBGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IF4DPym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IF4DPym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1366AC4AF0A;
	Tue, 30 Jul 2024 16:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355507;
	bh=8rRsalH//nBjkoac6H1e3H34pnV1bRjUXGU045LY1vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IF4DPymJTO+vpAnpRZxU5BsYQAhpfIL7ax51EsVWPnXNmaUVei+KXKjIQXLwtMeu
	 OdiNc8utLvF2n78Wgo3JqwspJJx6di+O3Jp8pPBhyMF6UeqxHIqRf04eKTzVQCpFdH
	 qh3oGXTLX3SGevswDjvLc0ZXiAoIGPBci3aZsfmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/568] arm64: dts: rockchip: Increase VOP clk rate on RK3328
Date: Tue, 30 Jul 2024 17:42:51 +0200
Message-ID: <20240730151642.362675326@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 0f2ddb128fa20f8441d903285632f2c69e90fae1 ]

The VOP on RK3328 needs to run at a higher rate in order to produce a
proper 3840x2160 signal.

Change to use 300MHz for VIO clk and 400MHz for VOP clk, same rates used
by vendor 4.4 kernel.

Fixes: 52e02d377a72 ("arm64: dts: rockchip: add core dtsi file for RK3328 SoCs")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240615170417.3134517-2-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 3778fe5c42a4b..126165ba1ea26 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -822,8 +822,8 @@ cru: clock-controller@ff440000 {
 			<0>, <24000000>,
 			<24000000>, <24000000>,
 			<15000000>, <15000000>,
-			<100000000>, <100000000>,
-			<100000000>, <100000000>,
+			<300000000>, <100000000>,
+			<400000000>, <100000000>,
 			<50000000>, <100000000>,
 			<100000000>, <100000000>,
 			<50000000>, <50000000>,
-- 
2.43.0



