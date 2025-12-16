Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E545534F491;
	Tue, 16 Dec 2025 11:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885662; cv=none; b=LmC05HYzuNOhK49Z+Issv4Fp9UrCjIKlN9ai+kHLb0/CDMa5d+9AxWN9fupavRKUpakbcpfugEzGJfOZdw+zhwQbzbFMkWXh9eGVTUjfRMMdIBJCLa3dQ4OZWsO2VSxbo9CLQ5k5qoRv2IUD7SR2jRyYGywXLwYhz2sku+BTaZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885662; c=relaxed/simple;
	bh=ttr2rVh15JazMUSuKKfOyUrSOc1MnNqo7QtrjrSa8gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smGCNnVc+UxuTYd2ZT5CYiHhy0MNct951Cl+8P89pAHqU5iaE38VWfogO+9OCxdymBx6HVRQvv6JnJmMGwx/RBP/EtLXERKNy8lwxRbkiuEHNsjceafW2lojt6y/v0EZCd+WjITYi65I/v4i30YNtmVbKXtFV8kg1oPdj3lN5zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVOCGzGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVOCGzGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2ECC4CEF1;
	Tue, 16 Dec 2025 11:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885661;
	bh=ttr2rVh15JazMUSuKKfOyUrSOc1MnNqo7QtrjrSa8gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVOCGzGcUFgKRwQHMzmsMnA8OuR8fJ/qTzVwVaQUWvsh7kOL/qCDg91RiX/9Lv1pt
	 OLZS6wKDbLRmsDhF6+oB5Ejvsf8DvRbBUcN3mHHc/kCU2y02JAW5+ZT2d5Lpsnyxzk
	 F+2rGsRZw81klEetcda95YF17meSmKIX7kvV/6PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 173/507] ARM: dts: omap3: beagle-xm: Correct obsolete TWL4030 power compatible
Date: Tue, 16 Dec 2025 12:10:14 +0100
Message-ID: <20251216111351.785661022@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit f7f3bc18300a230e0f1bfb17fc8889435c1e47f5 ]

The "ti,twl4030-power-beagleboard-xm" compatible string is obsolete and
is not supported by any in-kernel driver. Currently, the kernel falls
back to the second entry, "ti,twl4030-power-idle-osc-off", to bind a
driver to this node.

Make this fallback explicit by removing the obsolete board-specific
compatible. This preserves the existing functionality while making the
DTS compliant with the new, stricter 'ti,twl.yaml' binding.

Fixes: 9188883fd66e9 ("ARM: dts: Enable twl4030 off-idle configuration for selected omaps")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Link: https://lore.kernel.org/r/20250914192516.164629-3-jihed.chaibi.dev@gmail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/omap3-beagle-xm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ti/omap/omap3-beagle-xm.dts b/arch/arm/boot/dts/ti/omap/omap3-beagle-xm.dts
index 08ee0f8ea68fd..71b39a923d37c 100644
--- a/arch/arm/boot/dts/ti/omap/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/ti/omap/omap3-beagle-xm.dts
@@ -291,7 +291,7 @@ codec {
 		};
 
 		twl_power: power {
-			compatible = "ti,twl4030-power-beagleboard-xm", "ti,twl4030-power-idle-osc-off";
+			compatible = "ti,twl4030-power-idle-osc-off";
 			ti,use_poweroff;
 		};
 	};
-- 
2.51.0



