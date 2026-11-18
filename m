Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041455;
	b=l/ELbHaSbuTIGGMxekFX7qVQj24o8pcFP6ZVzdYZPUGFza+WxTC+xUXlJ3uKll8+7mhx
	 eaz8ubaH5d6nOhdwMlTGNqml7VJcT63Nn9X6NPwBHfvWeimpU/kBmI1TRGIttp3g/vDvJ
	 8GUJOE1yoc7I7uuZlK67Vi/jojCYuknSBWlCRRqx07jPx4RBP+LdFu+7NBz1RcMtrqVKy
	 lHoYOzxr8PGm0SSXRHmTbUJdRE/Ffb0dUXn1OByzmAaNR8GTIoWZgY+TdzQc6xcqcoGpM
	 JJJfFocZxvipIBDB2duavadd5ds68mANQTOqrl0sSJtYuzXCpC+J7PZ03gx43Bda7RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=esR0x9dCLjywOL+v1TmBfWCXJWOJlFYHbjiIMI/Y5Ng=;
	b=BHSpzxVG55ZW5QtbZYJUrvBIS+0x7EnoeMzPMyRFzxDN1aF9CCAj64/BhLkL4hijZKm/
	 aAhYo/vsTMAAu5DpnY64tQHsFna3umYU7zxkOTvuiLb/QeY0HcaUIr3ZnoLTEKx3fPvVr
	 Ry2pQ2TM335TeR9FxxpAxq1nlSCSKKoI3HsOnHDHsXw298xnoOyA5dk6FLX2Q5SGFygKi
	 fXNCp/asTucl8OweQ/TGE5vd5mQmP0/lnpYqUeh4E5CTnoB50Jc5isbUiwUq5+iPAbXWJ
	 czNDiwSqeeKBQnRywXsCoH0wsLwsSbBOppqMKeT+Bs5+VTljPyuWj+pIdFoth12R/nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kw17wt1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD480606A32C;
	Wed, 18 Nov 2026 22:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kw17wt1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F88D1F000C4;
	Wed, 18 Nov 2026 22:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041455;
	bh=esR0x9dCLjywOL+v1TmBfWCXJWOJlFYHbjiIMI/Y5Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kw17wt1g3cXtxz740MxwUs1doQwKMbtQS0npycknKw4rCj+0a5wvFRnhqX7oznFXR
	 k/cWHQoQoFcAuqPMjMzYEximWqRpXue2+mJX5zKDvEj9jmymeZQ1//b4HZym1EbXJO
	 ObFTkEYu4UI5ntOzbymShwWDu9WQnTavL6rT5V/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2803/3318] clk: qcom: mmcc-msm8996: Fix FD AHB clock register offset
Date: Wed, 18 Nov 2026 15:57:05 +0100
Message-ID: <20261118150444.761971567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d3f2dc798567d..dd578ae557b2a 100644
--- a/drivers/clk/qcom/mmcc-msm8996.c
+++ b/drivers/clk/qcom/mmcc-msm8996.c
@@ -3136,9 +3136,9 @@ static struct clk_branch fd_core_uar_clk = {
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



