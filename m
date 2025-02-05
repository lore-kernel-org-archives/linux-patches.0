Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4EA1FE453;
	Wed,  5 Feb 2025 14:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766987; cv=none; b=dDPj/apjuIpAW1HvSlglqxulNF9+3sElGBUCNm4e2Q89nUofHQQjiIB8FDEOGkhz2yeOBTMn53+YtsmAd79eGiOpvyWzW1k7kuoTnae2bA5h7KetqP4BCSqBcOhyJnO4Mc/nPbBhDobIBbo4kQJMT6yT+8sNMp+Q4itslDQMHwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766987; c=relaxed/simple;
	bh=9UPtRgvKae0hQa3m8V5Fogz8sLITH9KBBl0aANKY5cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjyzLUn4qAjnGz7wX8Pmw7sjGINcZCqN64CMukDh7Prqd4dR6cIcycyJjGxdgbVRIjMGxHmAUzr8YP3hTI8PSi8ExrQgqxiidDPQ3XEXqlJPZHkD7L4b8P3UApc5C1a1ssqfnzTmtD0tJj3I+S15OEf5Bqzp3RaCvT+ARWcjaRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7h8i+I+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7h8i+I+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B236C4CED1;
	Wed,  5 Feb 2025 14:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766987;
	bh=9UPtRgvKae0hQa3m8V5Fogz8sLITH9KBBl0aANKY5cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7h8i+I++p9P5YUNw5/3XguMsuZY5m3F+2We+XzymX8jN57lD1AhgYre0ww7w8Urx
	 07WhPYPb4exJB023wlUZBXneslvsn/e78i+9xWWyWBdnVRKTrygLGsnXl2SaFDB8MU
	 r1L80pqLBUbCNb4EhzZlRR2yyrqWr8NWfnve942U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Riesch <michael.riesch@wolfvision.net>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 389/590] arm64: dts: rockchip: fix num-channels property of wolfvision pf5 mic
Date: Wed,  5 Feb 2025 14:42:24 +0100
Message-ID: <20250205134510.150755342@linuxfoundation.org>
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

From: Michael Riesch <michael.riesch@wolfvision.net>

[ Upstream commit 11d07966c83f5eccf6b927cb32862aef58488e23 ]

The Rockchip RK3568 PDM block always considers stereo inputs. Therefore,
the number of channels must be always an even number, even if a single
mono microphone is attached.

Fixes: 0be29f76633a ("arm64: dts: rockchip: add wolfvision pf5 mainboard")
Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
Link: https://lore.kernel.org/r/20241218-b4-wolfvision-pf5-update-v1-1-1d1959858708@wolfvision.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5.dts b/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5.dts
index 170b14f92f51b..f9ef0af8aa1ac 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5.dts
@@ -53,7 +53,7 @@
 
 	pdm_codec: pdm-codec {
 		compatible = "dmic-codec";
-		num-channels = <1>;
+		num-channels = <2>;
 		#sound-dai-cells = <0>;
 	};
 
-- 
2.39.5



