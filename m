Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BA73148A7;
	Mon, 13 Oct 2025 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369210; cv=none; b=KTdE5u7pJNYItABAdOWuTvigNS37zylpX5f8UAPZpFkBB4CaP3wuK6rMqR0tZNUzvCELYfRn8VAJK7/QCYUrPlIfO/aFLgL3gLTh+rYzJyt7lnK93Np00HcPkvOli1yZEwUOzvtlqy/oyE3AuQhoUsMUK17iMy2aYFbSdOTpA+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369210; c=relaxed/simple;
	bh=pj+Ho1HSziqp1nrc8lPRnNjMNLH+Sk945piiY2wG+xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNjAhnsDj5c2cVZwsSzCtAjFulbz3WbEG8GP/IlB50pTyqrWdqP7HkZTgx/xBIJjSVuNrBMyRMxUI/lsVny2f7bIq+OoowafdBSSJ9FHop97kqD/RTgv1yPUo/0vOm33SIwDwnvfByTkv4dwREwDadpqRRQMA9pZ6R62OsuUOpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSdAUaLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSdAUaLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F4DC116D0;
	Mon, 13 Oct 2025 15:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369209;
	bh=pj+Ho1HSziqp1nrc8lPRnNjMNLH+Sk945piiY2wG+xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSdAUaLO1BinPrFemvSW/La0+Ge61Eq6zOZdrnCDsX7jZMdxa42wHDpppsAF/7K6L
	 BoGpPHOSlZ4zU0FRVcyB+0nQXJaadNmCmKg/usy2eeKcDT4AbmOEGl/hTFwz6Hi+cd
	 lcu4wZW8IqPytDMl2cfW/k5fqg3q3VKWt4Mw7yZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 133/563] arm64: dts: allwinner: t527: avaota-a1: Add ethernet PHY reset setting
Date: Mon, 13 Oct 2025 16:39:54 +0200
Message-ID: <20251013144416.110718397@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 8dc3f973b2ff7ea19f7637983c11b005daa8fe45 ]

The external Ethernet PHY has a reset pin that is connected to the SoC.
It is missing from the original submission.

Add it to complete the description.

Fixes: c6800f15998b ("arm64: dts: allwinner: t527: add EMAC0 to Avaota-A1 board")
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20250908181059.1785605-9-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun55i-t527-avaota-a1.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun55i-t527-avaota-a1.dts b/arch/arm64/boot/dts/allwinner/sun55i-t527-avaota-a1.dts
index b9eeb6753e9e3..e7713678208d4 100644
--- a/arch/arm64/boot/dts/allwinner/sun55i-t527-avaota-a1.dts
+++ b/arch/arm64/boot/dts/allwinner/sun55i-t527-avaota-a1.dts
@@ -85,6 +85,9 @@ &mdio0 {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		reset-gpios = <&pio 7 8 GPIO_ACTIVE_LOW>; /* PH8 */
+		reset-assert-us = <10000>;
+		reset-deassert-us = <150000>;
 	};
 };
 
-- 
2.51.0



