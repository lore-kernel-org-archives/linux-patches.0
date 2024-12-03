Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77071DDC26;
	Tue,  3 Dec 2024 15:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240427; cv=none; b=gHInwZmPVon/K5HntClhFTJSXBvmcUNDRUukDuxN1dEQNLj7+LsndNmBZKT/vzD+qccJHA2DOQGrEOUG/s17Tzq6FkLsF9cvS07hzZ/CjMHHjr+brUmmb6GcJPlGJknfm9bSs8Ya+0BUnbJ2FWkZ/Zv5Z1pp+yrrv+dsUIXxOUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240427; c=relaxed/simple;
	bh=j2wWdGiEZtGLfwU29ujhm3AuHn4MJYug+pXCZRdwcuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfLXR9BMs2ey1ThyZWHesx5vijE9iVJygSs38VGK+SnlGuVvfrTebG3BtPgk5A8pi0o8pYPZ4jiULIAVwxy+APyQcVoeaUPRguzH1wEkDSIktoFH6VBGLtVyE+dOOI511eqQnqQrvZfYx7PoZglMgcnnkFowD2t7eCFkHsS/hj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywXRbduw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywXRbduw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F358C4CECF;
	Tue,  3 Dec 2024 15:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240426;
	bh=j2wWdGiEZtGLfwU29ujhm3AuHn4MJYug+pXCZRdwcuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywXRbduwUIczCJ4glKDCdB/NYFQPeOBjJFAUYID+idSPhgQVZElfd7/xrGU5d4ZJb
	 M7Lw8X1sD4fDcaYId7UzNnCWG/2KWF9sDKeKcsHr5SccfzW7AvqxHWKN7mi2m8Vm2j
	 o7IvfacY19jh2LEGJSnK+/wXlcJwf5yK57/fB2n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Morrisson <nmorrisson@phytec.com>,
	Wadim Egorov <w.egorov@phytec.de>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/826] arm64: dts: ti: k3-am62x-phyboard-lyra: Drop unnecessary McASP AFIFOs
Date: Tue,  3 Dec 2024 15:37:37 +0100
Message-ID: <20241203144748.814390648@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Morrisson <nmorrisson@phytec.com>

[ Upstream commit c33a0a02a29bde53a85407f86f332ac4bbc5ab87 ]

Drop the McASP AFIFOs for better audio latency. This adds back a
change that was lost while refactoring the device tree.

Fixes: 554dd562a5f2 ("arm64: dts: ti: k3-am625-phyboard-lyra-rdk: Drop McASP AFIFOs")
Signed-off-by: Nathan Morrisson <nmorrisson@phytec.com>
Reviewed-by: Wadim Egorov <w.egorov@phytec.de>
Link: https://lore.kernel.org/r/20241002224754.2917895-1-nmorrisson@phytec.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi b/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
index e4633af87eb9c..d6ce53c6d7481 100644
--- a/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
@@ -433,8 +433,6 @@ &mcasp2 {
 			0 0 0 0
 			0 0 0 0
 	>;
-	tx-num-evt = <32>;
-	rx-num-evt = <32>;
 	status = "okay";
 };
 
-- 
2.43.0



