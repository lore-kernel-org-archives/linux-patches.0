Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044AE260585;
	Thu, 27 Nov 2025 15:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255734; cv=none; b=Re5DNVZlJfvdBu268Z9hydHOPp9hxLN/k/2jS3MLmTCld391vU2egDhXwhec+HaHDL/yRy3ZrIQQmU955X76UL5BYXbjj/qA5UCpFsgOwSW9o4503W5gG0I92aw+4GTvrsStP0US9Uu0yuz5fvJFPP1PadoZ7RJT4NlUQHc4HNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255734; c=relaxed/simple;
	bh=Iv9gfxhkJB/yj2dOJgWF4XNg9ZRWr+iYFEW3ksd6doY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8iDRFiq8vUVCAg/T3/6pa0nFOYpaYuNqHkcICiffZ4ed0rI5BQIpp96oNRga+1YwJ6E+UJHmz6xHRmVY/NFDzK/4Yv1GWbmg88sMmzUqJ7XDTWmxIAeMxs5+id6dnu3mIi6GNTxkJh+smTetDNJqUU8o/YHfjk5SSHPp7zLBdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzV6dDdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzV6dDdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8320DC113D0;
	Thu, 27 Nov 2025 15:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255733;
	bh=Iv9gfxhkJB/yj2dOJgWF4XNg9ZRWr+iYFEW3ksd6doY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zzV6dDdEa7WqeQvefMJ9o+P1QDO5Bw+AW0BqX1Ns3JkpZhy/Q3qDOryQ9WJHEfKqr
	 l7dxwCVQ9/A3/XrxIdZEMulJ+ubFxSQE5fQTtAUJD0ELk7Aa8O2XEa2JYfamC98tKs
	 cw2/7izSy5cCm7nnYfIxWRrnpOqqCpuY6OMIJfa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 094/175] mips: dts: econet: fix EN751221 core type
Date: Thu, 27 Nov 2025 15:45:47 +0100
Message-ID: <20251127144046.394724092@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 09782e72eec451fa14d327595f86cdc338ebe53c ]

In fact, it is a multi-threaded MIPS34Kc, not a single-threaded MIPS24Kc.

Fixes: 0ec488700972 ("mips: dts: Add EcoNet DTS with EN751221 and SmartFiber XP8421-B board")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/econet/en751221.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/econet/en751221.dtsi b/arch/mips/boot/dts/econet/en751221.dtsi
index 66197e73d4f04..2abeef5b744a8 100644
--- a/arch/mips/boot/dts/econet/en751221.dtsi
+++ b/arch/mips/boot/dts/econet/en751221.dtsi
@@ -18,7 +18,7 @@
 
 		cpu@0 {
 			device_type = "cpu";
-			compatible = "mips,mips24KEc";
+			compatible = "mips,mips34Kc";
 			reg = <0>;
 		};
 	};
-- 
2.51.0



