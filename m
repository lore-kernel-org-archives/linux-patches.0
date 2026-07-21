Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF8446AA71;
	Tue, 21 Jul 2026 15:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648411; cv=none; b=k1TyrsJSpVsS3Gp51uTGZE4LJvBbVmIPa0kKJxBA1G43UoTvPaH+hYBgxSjTKz8uhCk3CD710g+LUwDmhz/O+1XZLihFOLjYi97eooJNH90xXSDJc+wqoWgp11RkxWE3yor6NWxuU88TEK4BUMnTsOKjKkvrXekKQo17aL533U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648411; c=relaxed/simple;
	bh=sBogQOsWWCwgqjsaQ7fx4lLgHSxz3ULJFONDmoFERsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dn9aVowwHp5pUFXk36KjyXouW48dJuZEgslO/nVS/xNwj5HgQB7YzK8mYDW7k6UV6VJYW5YK1K1OkvE4Vn3G51DhJX0BdvbA7MqZI3Gce2Qcomk8RzLwxFHBpPbRaZBMH8bX1sup5bnADPNadmA5CQBDPuW+uqHrfUwpVQeTSuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNwNzcEu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNwNzcEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4B11F000E9;
	Tue, 21 Jul 2026 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648410;
	bh=h8cyIS8ZF+Bg5HGU7yYf1DVUEmQAPsZ95rqwpBlSxZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNwNzcEu/6JhsaeNcOoL0OsjFxPc5CqNWdWnfzDU3KmNLCbfkY1B2etrqOmv9E/sB
	 A53EyJI1nmfS3arGBayAlgTL5PLCpnot8Dnz319zQGXDcgvotY7FkNH0EAcj/RuYpX
	 fT4MKwkxIKf9j4U/woZ21qH1jEThA/0Vt6hYwFw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0190/2077] arm64: dts: qcom: glymur-crd: Drop forced host mode for USB SS0 and SS1
Date: Tue, 21 Jul 2026 16:57:43 +0200
Message-ID: <20260721152557.166975794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit d9dc254945756b44fa6f61b9cbd4adf0413c6a6f ]

The two USB Type-C ports on Glymur CRD are dual-role capable.

Do not force their controllers into host mode. Drop the explicit
'dr_mode = "host"' properties so they can use their default OTG mode
instead.

Fixes: c8b63029455b ("arm64: dts: qcom: glymur-crd: Enable USB support")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260415-dts-qcom-glymur-usb-role-switch-fix-v1-2-409e1a257f1f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur-crd.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur-crd.dts b/arch/arm64/boot/dts/qcom/glymur-crd.dts
index 35aaf09e4e2b47..c98dfb3941fa36 100644
--- a/arch/arm64/boot/dts/qcom/glymur-crd.dts
+++ b/arch/arm64/boot/dts/qcom/glymur-crd.dts
@@ -322,8 +322,6 @@ reset-n-pins {
 };
 
 &usb_0 {
-	dr_mode = "host";
-
 	status = "okay";
 };
 
@@ -353,8 +351,6 @@ &usb_0_qmpphy_out {
 };
 
 &usb_1 {
-	dr_mode = "host";
-
 	status = "okay";
 };
 
-- 
2.53.0



