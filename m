Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994B536F8F1;
	Tue, 16 Jun 2026 15:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622777; cv=none; b=b2nrJ9lk+pqtPB+fDCLlsilVjE0mQ9zxeb4qd6xQPuy8arbd2cJBB6Yagqt9qHz4ztD2M3bb03KxDCbnrXYD5L9tkA5ZCm3R8xEmoLS/G31skqfzQ1/4b4xu4z+mKw9VhemHxE4rEeNhOas9p5/6UEBBZbqtkp/cjaiUuWRhXjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622777; c=relaxed/simple;
	bh=3p29ny5702MkXmKPzIaXWzWn4AEC3HZb+PIEilHAhxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0sS5XktWBXq0nK2av5mk82D1+hwob5GOKGlP//4fNtw6r+hQly7wpzOzk3Pn99shFbRSPawpFhWl0tvlUlHSFgndcHMuA1I+aMSdeI7jpt9aocANTBx+73wZhQ1jPcaskUggaYOMV6tRFxvdUJV3A0LF9hlCkYQVC4vIFoiGPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fu1Efm15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fu1Efm15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6141F00A3A;
	Tue, 16 Jun 2026 15:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622776;
	bh=/PeX7eaCJJPxJft52H+Z5uNozuu1jLnHr+IdaDztcPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fu1Efm15U0E8kZMvkt4hscy5rVY0+38xQXyFSvYjJi21uiiFxUM14I4uNru91TaRP
	 piLmFwmG2myLNfm/VOBU5ofIAphYQOT3HBb0yBYDlQ+2Md04ARa181fuRfYa9Ci6sI
	 +Sj9UEBtYN9Rv5w7DjI+xjSe3lRIZAuDnaekcke8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Val Packett <val@packett.cool>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 009/378] arm64: dts: qcom: x1-dell-thena: remove i2c20 (battery SMBus) and reserve its pins
Date: Tue, 16 Jun 2026 20:24:00 +0530
Message-ID: <20260616145110.274117576@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 4b15b03166cc5d28e9912287b1f9b6607c8710ec ]

i2c20 is used by the battmgr service on the ADSP to communicate with the
SBS interface of the battery. Initializing it from Linux would break the
battmgr functionality when booted in EL2. Mark those pins as reserved.

Fixes: e7733b42111c ("arm64: dts: qcom: Add support for Dell Inspiron 7441 / Latitude 7455")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Val Packett <val@packett.cool>
Link: https://lore.kernel.org/r/20260312005731.12488-2-val@packett.cool
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi b/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
index 217ca8c7d81dae..488129bb1ae198 100644
--- a/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
@@ -982,12 +982,6 @@ &i2c8 {
 	status = "okay";
 };
 
-&i2c20 {
-	clock-frequency = <400000>;
-
-	status = "okay";
-};
-
 &lpass_tlmm {
 	spkr_01_sd_n_active: spkr-01-sd-n-active-state {
 		pins = "gpio12";
@@ -1308,6 +1302,7 @@ right_tweeter: speaker@0,1 {
 &tlmm {
 	gpio-reserved-ranges = <44 4>,  /* SPI11 (TPM) */
 			       <76 4>,  /* SPI19 (TZ Protected) */
+			       <80 2>,  /* I2C20 (Battery SMBus) */
 			       <238 1>; /* UFS Reset */
 
 	cam_rgb_default: cam-rgb-default-state {
-- 
2.53.0



