Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019940;
	b=qs88QYTCZd3dOBME9Zvu4YYct62K74YDHnwogNlNn5cT8yEVH8VPPKZrBs3weGW/qltr
	 tNakgDeTF2SNtkHc1OvsmZmFhgcTu6oQvaYJelfVmox1WpiC65T9BL7/z4NiH9/fD3eMi
	 1BjRrxZELocWR1QfgjlhRyiHLvfnLcuna1gBC7jhS8PxP4ygvgt2i4nJ8yaNScL1xyonm
	 1aXl+Yzuay0CZlkvzheeA+4rKLo2qY7XXMvu+lzyePFAgcXPQTm+tYfzH9kvmmVhjs5th
	 QIQ9uco7i6uXClZaI5+aQDTn6DaXzE+HkVai934nuV0QvEodHS1fYjAgHAPWztgb2RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NptCdp6ALL7kcPLSE3h0Vqailg9YdZPiYC0YYEP/8bQ=;
	b=Dt/OiqgQczq7O7tDaHsglYBm/vVERppzwVcbpc62MeUxCpkivi8rBF76ODgHP28Yq8/Z
	 +0kcHZbmW9Nrl5SUsfHBQZUkioje5N/Rkk0ioiDGxRay1LHkY8fcrBCX9gkZ+PjV3Xhdn
	 QffAGjdSDYZVDDh4YORpxN5gp2tRQL60eC7hMUNQM7shTga1v5CcyAh4QSEwBMapmmBo5
	 Ubaus7T1GbNxd2WuOXu2Za7sqyZ2/fpyNfNX/yQ9NwJmp5oq60+mPzDmQBziTq74DAgsG
	 30osIgVh2/VDSjiFpmYJn4YhueeOmOlkyE/IN1X9JsQXLLTG+WPvHJDhvFCFQhtSVfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lr3O5PdK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E862606A325;
	Wed, 18 Nov 2026 16:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lr3O5PdK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4011F000C4;
	Wed, 18 Nov 2026 16:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019939;
	bh=NptCdp6ALL7kcPLSE3h0Vqailg9YdZPiYC0YYEP/8bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lr3O5PdKV838EfHy5aACSsJRyDnxmvRlMlWlx6nigBI4/8i9uliuxVozAtdyre27Y
	 euhzLIAHEsMGQH4ibvHK9mphmBVl+NOmXbUngcuGlopraWKThW6KZP+Kiw2lPrFjmn
	 C5Vau3kofqFah+CJlBvzhVTqNBiDF1yzYFDfXJ48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1747/2651] clk: qcom: mmcc-msm8996: Fix FD AHB clock register offset
Date: Wed, 18 Nov 2026 15:49:47 +0100
Message-ID: <20261118150350.424009522@linuxfoundation.org>
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

[ Upstream commit 7cb2d65286b817d8d7e26f454a9c374d65e87072 ]

The FD AHB clock branch register is at offset 0x3b74, not 0x3ba74.
The incorrect offset exceeds the regmap maximum of 0xb008, so regmap
rejects accesses to it and the clock cannot be enabled.

Correct both the enable and halt register offsets so the driver can
enable the branch and check its status.

Assisted-by: LLM
Fixes: c252659770db ("clk: qcom: Add MSM8996 Multimedia Clock Controller (MMCC) driver")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-clk-qcom-mmcc-msm8996-fix-fd-ahb-offset-v1-1-a575e1b9112c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-msm8996.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/mmcc-msm8996.c b/drivers/clk/qcom/mmcc-msm8996.c
index 3426e3dde9247..ef7bde361fc38 100644
--- a/drivers/clk/qcom/mmcc-msm8996.c
+++ b/drivers/clk/qcom/mmcc-msm8996.c
@@ -3133,9 +3133,9 @@ static struct clk_branch fd_core_uar_clk = {
 };
 
 static struct clk_branch fd_ahb_clk = {
-	.halt_reg = 0x3ba74,
+	.halt_reg = 0x3b74,
 	.clkr = {
-		.enable_reg = 0x3ba74,
+		.enable_reg = 0x3b74,
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "fd_ahb_clk",
-- 
2.53.0



