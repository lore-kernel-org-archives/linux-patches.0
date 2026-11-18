Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015309;
	b=FTgK7eNdozLVKuj4+wfNgWIcwYegTqf5j6DBbFCNZ25XFaxclashpj5h6MMPL6fV9Rcd
	 jlFB+t6K4B8VCnMucNi48etz2ptevKibllfsY92IaiNejPUTaZJ3hPfcp/Zu1QHI6lOVa
	 rvwW11vTgKbrwg6hD8b3fCZJGRgR+pgSBXBDJL12cAt2gTRJDWuO6nTqyBzRWm8cq0kT6
	 E1XnYf5fi/tRftVTyuShK/8IvYpG+Sgp6y8yvLZkJPb9jjdlt3chfdb6ccTDngnPHnlgz
	 QgKR3CMiyBIHGsdJ+8Mo1we6MkhbyyP8MDORaUC9oDlfreeaqUidLGgGoL7dZQBkNQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WRfoc9hcqU7IRt+jHjQ8K6GuFAES3ziuvo7/TlRyEsU=;
	b=I+CDiLzxC4L+ZOZ5xz65DcR0/EHYAnD7RcNyqxOGvY1+ulfuA+j4TG42Y3W45l8Aik5O
	 ur3b58V39JE+UFrTfoR1gFEeveInBnQWNPto7YfKrWl7piEdAB3nP30axlmWsJCI3d5M4
	 6/Zw/ruYdTaYYx09pB5abxTi6LIvJUhIYE4GTs/DMZgDj+2nZLS23w7MFY9g2A101Yuug
	 2lkpd5UNN2A+TOwD34y6AlMpcsdAbIO05WFF/KuMmcK0XfKFuYjXJGTnZcBKQps7eJAiR
	 Jpuu19G4+iTDVlXbjnSOGUtKSdywC32zU3Wx8Cc8E3UY07YCH+4c5aiWsRagkdypFww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="y3G6ZI/Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445F5606A335;
	Wed, 18 Nov 2026 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3G6ZI/Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B3B1F000C6;
	Wed, 18 Nov 2026 15:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015308;
	bh=WRfoc9hcqU7IRt+jHjQ8K6GuFAES3ziuvo7/TlRyEsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y3G6ZI/ZpdhtgnqvPnI4I2M0rOfIuk1bRyWhMWxCFjDEUG2PsTA4iCXZ1vjsFVAZI
	 kSMQYn/CXIroVgfLvVIifdpqYDGe0mrc6fyfIIkuqh5PHtPWHniGyRH/ki055/OlkJ
	 gNDnermJY6EeipiyPRX1icGUxiqch/6FGW7F2MGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shujath Mohd <shujath@outlook.in>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0128/2651] arm64: dts: qcom: sdm845-sony-xperia-tama: Fix Bluetooth UART pinctrl
Date: Wed, 18 Nov 2026 15:22:48 +0100
Message-ID: <20261118150252.468725575@linuxfoundation.org>
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
index 4c63286d8b041..05e5a3674e5fa 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi
@@ -754,6 +754,8 @@ int-pins {
 };
 
 &uart6 {
+	pinctrl-0 = <&qup_uart6_4pin>;
+
 	status = "okay";
 
 	bluetooth {
-- 
2.53.0



