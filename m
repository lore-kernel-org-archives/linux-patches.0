Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3882F472F95;
	Tue, 21 Jul 2026 17:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656364; cv=none; b=YNKEThjEweUsP0rLbRHznwCM0Zvio0Ysp1bkx/CQdgU5VOjJwY8TN7bcdyJEukCllHKPN+VO5A7lmDaTkZ71iiE5hSV4kqGCEYjgvxNxslMngFTEtvxQLEesRpeIRmyg1Ow/YDMZ2/MSOs/1seIVMJ2D4BI7GM8wfhiEtR4nTjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656364; c=relaxed/simple;
	bh=N/CoArT9aknFWWpex9RpbXUr4aHbyAHWKkUrrPYNGs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLztFvgrrsNJe3Ig2xTdSCOXgP8MhTx/uNreBLSN/eJNajXJ2lSDOQ/mKYY/wUCf8rZULTKDi/KLtTZuKjbfTfTf5L7MqJb9rzI1UJkpVDQEvBvJYiwxIh1+YHXW6MravzCeVdxUQPwIBNLStYv2LqEBdBObXpQcDeoGbVgoVYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FublVd1p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FublVd1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3F81F00ACA;
	Tue, 21 Jul 2026 17:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656363;
	bh=oYPQ6NOmswktKk6rcnm9mMrKTKmqUoNBPt3U7PKzvdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FublVd1poHtVa2CvY0wF/S1cgKjx8t7QacB7HVnId/Uu5rY5SftsziwzlH6keyOix
	 LE4dFR0EZ72KZO4fpZOn6sbI1YHjW3pNo3E9AWzo0J3//SrMqe4OI4AArjPuHYb7Ib
	 baDrLqqQQ1vvs8vMbdP/7Xj+ZZRtfwMmabRnkEGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0358/1611] arm64: dts: tqma8mpql-mba8mpxl: configure sai clock in audio codec as well
Date: Tue, 21 Jul 2026 17:07:54 +0200
Message-ID: <20260721152523.198293237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 748835fcb2eb2120234aef9556d282272501b96b ]

With deferrable card binding the sound card driver tries to
get the mclk configuration before it is setup in sai3 node.
Fix this by setting the sai clock config for the audio codec as well.

Fixes: d8f9d8126582 ("arm64: dts: imx8mp: Add analog audio output on i.MX8MP TQMa8MPxL/MBa8MPxL")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
index ac05c05193c5be..be33cf691adf69 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
@@ -519,6 +519,9 @@ tlv320aic3x04: audio-codec@18 {
 		reset-gpios = <&gpio4 29 GPIO_ACTIVE_LOW>;
 		iov-supply = <&reg_vcc_1v8>;
 		ldoin-supply = <&reg_vcc_3v3>;
+		assigned-clocks = <&clk IMX8MP_CLK_SAI3>;
+		assigned-clock-parents = <&clk IMX8MP_AUDIO_PLL1_OUT>;
+		assigned-clock-rates = <12288000>;
 	};
 
 	se97_1c: temperature-sensor@1c {
-- 
2.53.0



