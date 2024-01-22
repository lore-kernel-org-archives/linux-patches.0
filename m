Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29556149010;
	Tue, 23 Jan 2024 00:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969198; cv=none; b=qoNJbkJoG0lD75tlQu/Oy8i8diDhayrrGuC84b4CYpmyv/+Rh9GIAeZTzAViM87cQwI18oUQ/fynL6eJT9zEhF65cukC7AKmq/v0xyNua3hdVkRdaNmv0RD63Pj71kiii6QLrt90y756z5hsctKofRpAwfDoJ/Gxd2zD3eGt0I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969198; c=relaxed/simple;
	bh=grY1Uk/Ze6ipzQhb+J9ibNcjopAAzQenAV/ahVKOTlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0AS80+OZuaiBw/IaDukgdOWpSHBlc4Fwu9wm+Y4FYYZkWqzQuxYjVHn/Db/562iLF6ov81AB9QGUaEK1A3Q1NaUjYTllT2lWP01CLJNqto16ZKmjESK0vfxzwbMWqM5BXZXB3pNWaJtlyTojtGp+oE5meGJ9R1R22Ru0PAB/Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=buJYJSCw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="buJYJSCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9648C433C7;
	Tue, 23 Jan 2024 00:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969198;
	bh=grY1Uk/Ze6ipzQhb+J9ibNcjopAAzQenAV/ahVKOTlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buJYJSCwc4TjzPbN3wN/5ieJBhlry5kbxSub7aqGnaq0hDe1laqGKwlFCmnncu8PM
	 xKj0Q//4UTzQ3x2kRZXtlGGMLtY4jLhZoE1/qKoNtMBtx6Eg1/00erpM66PiwuBZOc
	 Xrbg95efov2DDuaQ6YSk9o0v7S+YRlmUeXQK+MZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 092/641] arm64: dts: qcom: qrb4210-rb2: dont force usb peripheral mode
Date: Mon, 22 Jan 2024 15:49:56 -0800
Message-ID: <20240122235820.920473115@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Connolly <caleb.connolly@linaro.org>

[ Upstream commit 27c2ca90e2f34cd3c4849af996e1a96a69e700d3 ]

The rb2 only has a single USB controller, it can be switched between a
type-c port and an internal USB hub via a DIP switch. Until dynamic
role switching is available it's preferable to put the USB controller
in host mode so that the type-A ports and ethernet are available.

Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Fixes: eaa53a85748d ("arm64: dts: qcom: qrb4210-rb2: Enable USB node")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20231010-caleb-rb2-host-mode-v1-1-b057d443cd62@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
index a7278a9472ed..9738c0dacd58 100644
--- a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
+++ b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
@@ -518,7 +518,6 @@ &usb {
 
 &usb_dwc3 {
 	maximum-speed = "super-speed";
-	dr_mode = "peripheral";
 };
 
 &usb_hsphy {
-- 
2.43.0



