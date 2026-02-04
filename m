Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3334018859B;
	Wed,  4 Feb 2026 15:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218132; cv=none; b=HNFX5mch/3e7U97VEDQnyXWqfKJsfyhmrVfn7iflVlzLHAgiE4CTmO/VXgyq0JTXQP8Dt3mK+oE1ZHIr20yf/6k1Uo4hUzd+Q3GRhQoaoLQv2d0mdXmW17RuMbyNVotX8Q5NcOzvGa58zCwXZ5faZvIfN1uPup1S2o4nStqNoBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218132; c=relaxed/simple;
	bh=J9jSNQzr+oZB4xp6Gh//phlGJwhKLd5OIOSQM6S6ok0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXqEnSdQ9Jzwtzg0yHyCRjRglxdZC4Ji487WI7bNQJoROjnikuQbN6/alvK7ubjLmW9LqysDgSqOurCmMVcFJ4mVxSKmeiwW5iqihwvMjcpB7ySWHEzRJk5Rv5kvyRX5TdLbLo7qVl6276FYP11QqKyEdYc5QhKC4z+PDEC4Csc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zrk97qyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zrk97qyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D08C4CEF7;
	Wed,  4 Feb 2026 15:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218132;
	bh=J9jSNQzr+oZB4xp6Gh//phlGJwhKLd5OIOSQM6S6ok0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zrk97qykizqdMMl4ki/z7FezFwDyDhjDMZhdw0pctTfU2liqvlHUmH9trhU3KWi8C
	 J6dDNQAzJGaryDhhTIcTrjvd9+MpwHBQ0XyWcFz/W5Zo2/NDOKi2dO1c1fRTQZWYfO
	 Uem8c5XvBLkY3gLxv6pz8MKPh4tAsabmZecsfbDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Geraldo Nascimento <geraldogabriel@gmail.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 221/280] arm64: dts: rockchip: remove redundant max-link-speed from nanopi-r4s
Date: Wed,  4 Feb 2026 15:39:55 +0100
Message-ID: <20260204143917.559421006@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geraldo Nascimento <geraldogabriel@gmail.com>

[ Upstream commit ce652c98a7bfa0b7c675ef5cd85c44c186db96af ]

This is already the default in rk3399-base.dtsi, remove redundant
declaration from rk3399-nanopi-r4s.dtsi.

Fixes: db792e9adbf8 ("rockchip: rk3399: Add support for FriendlyARM NanoPi R4S")
Cc: stable@vger.kernel.org
Reported-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/6694456a735844177c897581f785cc00c064c7d1.1763415706.git.geraldogabriel@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
[ adapted file path from rk3399-nanopi-r4s.dtsi to rk3399-nanopi-r4s.dts ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts
@@ -73,7 +73,6 @@
 };
 
 &pcie0 {
-	max-link-speed = <1>;
 	num-lanes = <1>;
 	vpcie3v3-supply = <&vcc3v3_sys>;
 };


