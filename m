Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028951;
	b=LTAscHYYNaSU6Trug5tixXP7zDMF7+130b/daA6W75czpRV7oz8cIV6SuSHdLZSjQ5O0
	 8BD6HCIL9FXjxf3abZ5uzmiV+7arPHwEkegkK3rOKV9NEwNFTAiVnRbdSQaOvQETqudGq
	 dlYrGTaSnIRWcpF9IpMBrbrTR95CnZlJX6I/4b4WcPv0Pu10YKY5TpFKJl7F8u7x8hXsB
	 loopl1CBvhbWm/6kmFCZbQNCHVSVJoRQ1FkGRoh3oeo5LyFAP13XKS15UQzJYlya4h3sz
	 VoMs0ybNcgUnQlASf7LSfIFeZHpsqetp1Oo+b4D0TIK0qTANYj1GwHVbj1wwmjK+upw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jGUdJ8QLHpqF3hhhRX2SDBXwCgfViCI+QemkaEzhZhE=;
	b=O9RKBCPB9Pyd1wZlZSux67AN50mg+guSLaorHYFVFp/B9WTEJfKhL3fV5o5+vfGo6+Oa
	 8iK5fHKXehAIFHjzSW/huFXM49VcAVoJuwI5vbPohZZYUW1wnceM9QIVfBggSHd57gLIT
	 iRpDazZizyo7qbgP8Em6xvUTZ+hBE6CpIK65saRNwUplVrvcwJzAPZRQIUtMJszbl65Z+
	 ZzQx1TcaaNTjpyXyshqZmeIajWFb3FPejqPn/XMt6QXMdWaK/YziRTWUyMZSJdmUp25yL
	 Limt7dUmMIYuyeLyAA6bfvf4Or3TDYFoTgvROT6RxlF1aer70h6wPExQ/m74R/GDeeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPNZF46X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5061D606A335;
	Wed, 18 Nov 2026 19:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPNZF46X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4C81F000C4;
	Wed, 18 Nov 2026 19:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028951;
	bh=jGUdJ8QLHpqF3hhhRX2SDBXwCgfViCI+QemkaEzhZhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPNZF46XN21Ch8+zqlftcHRg9SIOf2o0pYag16RCAdR571o8Yx4tFBMIufFvQPmbV
	 8rK5HhBvoFdjpL8DxKeO2nYXV4C+giioKNUKtCqFVn5m56ANTq+A/Gr6sjdwnd9JzD
	 7aiiBU7/nlYBdXBvEUzZy/vSlx33/rHowJOARmLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shujath Mohd <shujath@outlook.in>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0178/1756] arm64: dts: qcom: sdm845-sony-xperia-tama: Fix Bluetooth UART pinctrl
Date: Wed, 18 Nov 2026 15:38:25 +0100
Message-ID: <20261118150015.531349746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shujath Mohd <shujath@outlook.in>

[ Upstream commit cd0f33393882e2554d46e8e068ab95d00593f385 ]

Use the 4-pin UART6 pinctrl configuration for the WCN3990 Bluetooth
controller on Sony Xperia Tama devices.

This enables the UART hardware flow control required for reliable
Bluetooth communication at higher baud rates.

Fixes: d54331131cde ("arm64: dts: qcom: sdm845-sony-xperia-tama: Add bluetooth")
Fixes: 30a7f99befc6 ("arm64: dts: qcom: Add support for SONY Xperia XZ2 / XZ2C / XZ3 (Tama platform)")

Signed-off-by: Shujath Mohd <shujath@outlook.in>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/PUZPR01MB51413F6FF89A8FA82A9B2755C3A02@PUZPR01MB5141.apcprd01.prod.exchangelabs.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi b/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi
index b02a1dc5fecd6..4c01c43023fdd 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi
@@ -758,6 +758,8 @@ int-pins {
 };
 
 &uart6 {
+	pinctrl-0 = <&qup_uart6_4pin>;
+
 	status = "okay";
 };
 
-- 
2.53.0



