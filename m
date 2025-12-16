Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA0D336ED4;
	Tue, 16 Dec 2025 11:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884864; cv=none; b=ffkvhrA4mYMPT/5nrugUpCcNExzzSH+ETFmfgIpJ6XCCaTwpn6PKTaplZQwXZG5KoeDdIjB+sgZ3aG0iMhpnQKLuXzuzjyU24rj9YqfHyXZVGbxW5XOzTfyGCFUhVHRCKeydrnG7vLTEVUARR0jzYRheYEmVyJohzdrfp5mgNiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884864; c=relaxed/simple;
	bh=uaGnYfVXN9Opg3z8s0GETPl+fmf9sEKv9H4L+QSzdC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dvj86+TAsRy3cwalzG0SlZzJLbLYcoZTDUr3pPh6Bpvg4jYCbSgY2BH4KoNoHV2E95Mx8HpjHfpd6tKZhhgRV+3yFuoLaDai2/YQQUKycBXbWr5co9jOSzNtcl5sKtCVRX6EUmoVwmKJtxdT5v7xqAG0nRGVyX50j6a03nzV0DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRE/ZVtx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRE/ZVtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B7EC4CEF1;
	Tue, 16 Dec 2025 11:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884862;
	bh=uaGnYfVXN9Opg3z8s0GETPl+fmf9sEKv9H4L+QSzdC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRE/ZVtxr5tLe7qYSGxdhptEVzxZmogjKbWLQi2FVeWHPaEpmKckaVXHCs2HCi/Qg
	 //ikoiDKmC1rY9TjqitbWUGyPkPEcAMtmvpR3B0QyuT38vRt+tHuKbYKsQTOz7mgoU
	 nl3Z5Ku+3GbmGanl+2AS6zBvMB6XdRpPXi7xzS/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 278/354] clk: keystone: fix compile testing
Date: Tue, 16 Dec 2025 12:14:05 +0100
Message-ID: <20251216111330.987090524@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit b276445e98fe28609688fb85b89a81b803910e63 ]

Some keystone clock drivers can be selected when COMPILE_TEST is
enabled but since commit b745c0794e2f ("clk: keystone: Add sci-clk
driver support") they are never actually built.

Enable compile testing by allowing the build system to process the
keystone drivers.

Fixes: b745c0794e2f ("clk: keystone: Add sci-clk driver support")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index fb8878a5d7d93..db202b614017e 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -106,8 +106,7 @@ obj-$(CONFIG_ARCH_HISI)			+= hisilicon/
 obj-y					+= imgtec/
 obj-y					+= imx/
 obj-y					+= ingenic/
-obj-$(CONFIG_ARCH_K3)			+= keystone/
-obj-$(CONFIG_ARCH_KEYSTONE)		+= keystone/
+obj-y					+= keystone/
 obj-y					+= mediatek/
 obj-$(CONFIG_ARCH_MESON)		+= meson/
 obj-y					+= microchip/
-- 
2.51.0



