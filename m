Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017311;
	b=dzttwsBJ4TbggRMqDutDyq5EfnOuzeID+ia1A8zfIkrlNqsis4U0qUjglrYgLUZOAw+1
	 8SSbOnxBdlRyDFbNStBJCf0TICuaooKIFx30G82e2WB4WmhmgM67XP8vno6/KQ8K1vqgH
	 VE7kKGWKShK4fQSXP9+aHPYmG5nsx2vgYgkn5YZ3NNXsVLPrP67+CJZFVtS+ISEJaSVee
	 hYrr25ZvDjcXostcWomrhkel9u8iOQPFGgq1aMGxrpQbWCeyPN38nQ8wSGSujhjgEngLg
	 jrs+e+4Cr12qrZB4gdBsbj+vOC+eSdKJMMekG9EInzoc9wrf7fG6ZrIhfGZ+jIrKICg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7GbuVmHerfvyPR4LAgEIEjPQJ2+XWRcw6CcSCk4MRmk=;
	b=X6+AFJVQeM3gn5osc4v/waqE0ak0/lu++Umh68qVdV3WV+YypfGScajCcEQImog3DvMX
	 5WaVMKLOv+M4wQ/L6DM/CxuMoyYkaQezwZMGsUw6lOhSkaQQa199EgbdAN8ZJTsPe1x8t
	 moSN1fKmoMBnWYFHA88yZsl+otfZcigD/PSJKjpa1yAFJ5l/L2jLpnH2bQBpFYhF13j+x
	 pi31akGaLxKyOmUre03arJiWK8HmX2YwLfxK9cypsgiRXi0Jd+pf2rR+ua7QgERe4/x9e
	 Gt+ruzyIH4Gbr2CvgQigx7tKMWnbeW6BP4U21JC7XU+11YujgwqFVnC5CzUf+VtDfyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mu0V4qLB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ADD606A320;
	Wed, 18 Nov 2026 15:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mu0V4qLB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD9E1F000C4;
	Wed, 18 Nov 2026 15:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017311;
	bh=7GbuVmHerfvyPR4LAgEIEjPQJ2+XWRcw6CcSCk4MRmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mu0V4qLBuJN7lrv3dlv0JQU30YW1vsjkJ8p7rQO5gG8nWS4bHOYGqDJqMDfXcH/Ai
	 uV7llVOgxnE7/b36Rrftfgm/jIVqp0aVTzRycvMdKa80YEF82ELJzTft8rx1a1ULde
	 Y58Bs9IZkJ5WQ7PzlYRnTsBL5XBTsTcVdXLuqdAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0840/2651] arm64: dts: qcom: x1-asus-vivobook-s15: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:34:40 +0100
Message-ID: <20261118150318.116525507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 94a0d3a2595821878de98d495e89691f694a2083 ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: d0e2f8f62dff ("arm64: dts: qcom: Add device tree for ASUS Vivobook S 15")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-9-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1-asus-vivobook-s15.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1-asus-vivobook-s15.dtsi b/arch/arm64/boot/dts/qcom/x1-asus-vivobook-s15.dtsi
index 0dc7c1b5a14a0..27fab4db24d5c 100644
--- a/arch/arm64/boot/dts/qcom/x1-asus-vivobook-s15.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-asus-vivobook-s15.dtsi
@@ -1039,6 +1039,7 @@ &smb2360_1_eusb2_repeater {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	edp_reg_en: edp-reg-en-state {
-- 
2.53.0



