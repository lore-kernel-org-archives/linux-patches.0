Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3671A36C5BF;
	Wed, 20 May 2026 16:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295725; cv=none; b=Gi2sdZEwyQRrItd8+xTPGuGSEiUI3bpsbwYd2vq1W+25VJaAF/XfRqWykml8ZPLDKY/Tkur4FNQDv4r27WsJsL5U0lgc8IrELDGK7DHggjifm1xb0cb5k9cftuz4DdLwGtQwwWTqCnahEgc192KbbNFum5S9T1MF4Rm9KrmJkJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295725; c=relaxed/simple;
	bh=YqCDV8QVBQo3IRyadBYqo9lGh2ShNa0kG8Igh3r0dA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI6MSICutONBb1rxkt1jTiQpdWAv6B6+0xqz6ijb5tLNYxgOK5qzEtPlFvP8zlQoyQOG01nuxaTfoa80JJMybBqnnsN1M5UbFDtJkb7i/7tibCE1lkiUw//eqb1KC7J45D6tjcZ7WaBG4w53oyi72qmuw2V12X0CR6Xh4XW5MIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgEtIr23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgEtIr23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961CB1F000E9;
	Wed, 20 May 2026 16:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295724;
	bh=t368K4RjiBJTgeFwz4ySpCAas9nrkf1RlTGhIJJtXKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sgEtIr23IEvauddE5qxwEGPERdRwTgBTHOSd5hUbBWqcTknNf2dHusX5OY0HLrpOR
	 uPNcdTPDbYDq2SVW2lPiouTDlTlQ5WWx7KZ1Q9cRGKzB+JonnraTV/Xst2lc9afllt
	 rzmOFVWoVCHe0HVRBf2doBF8H7Rhwr7kHmh8HtsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor@kernel.org>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0529/1146] arm64: dts: qcom: sm7225-fairphone-fp4: Fix conflicting bias pinctrl
Date: Wed, 20 May 2026 18:12:59 +0200
Message-ID: <20260520162200.153257645@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit be7c1badb0b934cfe88427b1d4ec3eb9f52ba587 ]

The pinctrl nodes from sm6350.dtsi already contain a bias-* property, so
that needs to be deleted, otherwise the dtb will contain two conflicting
bias-* properties.

Reported-by: Conor Dooley <conor@kernel.org>
Closes: https://lore.kernel.org/r/20260310-maritime-silly-05e7b7e03aa6@spud/
Fixes: c4ef464b24c5 ("arm64: dts: qcom: sm7225-fairphone-fp4: Add Bluetooth")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20260319-fp4-uart1-fix-v1-1-f6b3fedef583@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index a3c2b26736f47..3964aae47fd4e 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -1019,12 +1019,14 @@ &qup_uart1_cts {
 	 * the Bluetooth module drives the pin in either
 	 * direction or leaves the pin fully unpowered.
 	 */
+	/delete-property/ bias-disable;
 	bias-bus-hold;
 };
 
 &qup_uart1_rts {
 	/* We'll drive RTS, so no pull */
 	drive-strength = <2>;
+	/delete-property/ bias-pull-down;
 	bias-disable;
 };
 
@@ -1035,12 +1037,14 @@ &qup_uart1_rx {
 	 * in tri-state (module powered off or not driving the
 	 * signal yet).
 	 */
+	/delete-property/ bias-disable;
 	bias-pull-up;
 };
 
 &qup_uart1_tx {
 	/* We'll drive TX, so no pull */
 	drive-strength = <2>;
+	/delete-property/ bias-pull-up;
 	bias-disable;
 };
 
-- 
2.53.0



