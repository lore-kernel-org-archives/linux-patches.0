Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B2634A3C4;
	Sat, 30 May 2026 17:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162528; cv=none; b=pgA7nPQbm4xPmhYbML/FvZnhWQEk1I/FGsEKmVCG8HcRZmcSGeNNTrwA/pnc4DU8bnX37zlJdg0Xthoq9bFpjQQ8WYmP5vy9Jscb1yvmilVq/hv5JWgrnOp+HSYxfr5D4wgkUVKJusdsumG7ygVvVdjH6WB6zeEI1Wl1ZcWLluc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162528; c=relaxed/simple;
	bh=fxYJAOq/M7e03xEKs5FFywYjRK/uysNv/Sj6UpNC/8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrPLYrAlqI7BWLq44hxX/Kt9RaUxkxnNz7kg3TtwIdQ1Dxda0kBq9CIXeitae4fq2bLBjr1vnuX+7TVgoFWqaIquPu5tip9wP5CtnfxBO7y7zMIlKc1F0jQa2p5dcruBf7YfKVdkpy3RlVQAdzbfaWS95j5FP12253FDb4gLIdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qwvtxigk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qwvtxigk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473A61F00893;
	Sat, 30 May 2026 17:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162526;
	bh=hMCiMJ+JPmr9jrOR8doMDrZvVuAMfo79HqreKT8vARo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QwvtxigkuVbOz/56N1E0iF0Wq/AUdDhN8Q7IhpASl5WzxBCLQSnGkjY1Vxcqsz9Fr
	 P4/ZWUIo2VoCV/7i8eEeL+VLs3SLf2w4gbbkdTJO83MmNkFwMc9WFGzj+lf46hxrEI
	 gYbSfJOa/PZbrKkHO4EhKeYxkE98mC5JA58bctxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Navya Malempati <navya.malempati@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 904/969] pinctrl: qcom: Fix wakeirq map by removing disconnected irqs for sm8150
Date: Sat, 30 May 2026 18:07:08 +0200
Message-ID: <20260530160325.675236280@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maulik Shah <maulik.shah@oss.qualcomm.com>

[ Upstream commit 52ac35b8a151446481496404af3a8e5e889b3c5a ]

PDC interrupts 122-125 were meant for ibi_i3c wakeup but sm8150 do not
support i3c. GPIOs 39,51,88 and 144 are also connected to different PDC
pin and already reflected in the wake irq map.

Remove the unsupported wakeup interrupts from the map.

Fixes: 90337380c809 ("pinctrl: qcom: sm8150: Specify PDC map")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Maulik Shah <maulik.shah@oss.qualcomm.com>
Signed-off-by: Navya Malempati <navya.malempati@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sm8150.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sm8150.c b/drivers/pinctrl/qcom/pinctrl-sm8150.c
index 1cc622694553d..2bda8c1c89583 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8150.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8150.c
@@ -1504,18 +1504,18 @@ static const struct msm_gpio_wakeirq_map sm8150_pdc_map[] = {
 	{ 3, 31 }, { 5, 32 }, { 8, 33 }, { 9, 34 }, { 10, 100 },
 	{ 12, 104 }, { 24, 37 }, { 26, 38 }, { 27, 41 }, { 28, 42 },
 	{ 30, 39 }, { 36, 43 }, { 37, 44 }, { 38, 30 }, { 39, 118 },
-	{ 39, 125 }, { 41, 47 }, { 42, 48 }, { 46, 50 }, { 47, 49 },
-	{ 48, 51 }, { 49, 53 }, { 50, 52 }, { 51, 116 }, { 51, 123 },
+	{ 41, 47 }, { 42, 48 }, { 46, 50 }, { 47, 49 },
+	{ 48, 51 }, { 49, 53 }, { 50, 52 }, { 51, 116 },
 	{ 53, 54 }, { 54, 55 }, { 55, 56 }, { 56, 57 }, { 58, 58 },
 	{ 60, 60 }, { 61, 61 }, { 68, 62 }, { 70, 63 }, { 76, 71 },
 	{ 77, 66 }, { 81, 64 }, { 83, 65 }, { 86, 67 }, { 87, 84 },
-	{ 88, 117 }, { 88, 124 }, { 90, 69 }, { 91, 70 }, { 93, 75 },
+	{ 88, 117 }, { 90, 69 }, { 91, 70 }, { 93, 75 },
 	{ 95, 72 }, { 96, 73 }, { 97, 74 }, { 101, 40 }, { 103, 77 },
 	{ 104, 78 }, { 108, 79 }, { 112, 80 }, { 113, 81 }, { 114, 82 },
 	{ 117, 85 }, { 118, 101 }, { 119, 87 }, { 120, 88 }, { 121, 89 },
 	{ 122, 90 }, { 123, 91 }, { 124, 92 }, { 125, 93 }, { 129, 94 },
 	{ 132, 105 }, { 133, 83 }, { 134, 36 }, { 136, 97 }, { 142, 103 },
-	{ 144, 115 }, { 144, 122 }, { 147, 102 }, { 150, 107 },
+	{ 144, 115 }, { 147, 102 }, { 150, 107 },
 	{ 152, 108 }, { 153, 109 }
 };
 
-- 
2.53.0



