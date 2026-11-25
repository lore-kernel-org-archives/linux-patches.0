Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622479;
	b=RuOVhJz1JXgxQyi2lrDilFnl01ZbZyCqzaeop1+DLPmLTCU9Y9q9ZKHz/Jd0SFoulTi3
	 t9XW5J/X3lsuxdg5lHmYc7XBYzIGmO+c3A4BkrS74ibLUte/Z8ap6iqDY3+LaSeraatca
	 RqTuCoDXVTmh6wakMMubeYz0+Ybn/T2TzOMqUJyQmhQcPYZsabca++vXHxlcoGdx2l35F
	 2mcvnUlm6sxtb166gJqrl5sZbRk6jiWQ4Dc4P66Der2u0Q6yk5uge1AjYCjj4T6EpZEYb
	 fSuStWjAfwhts2pw+z9YI2EmG5t5PqQnFNYHcMwczCPMuHQMVfJxHtQsZMawdQnEYsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FJxGguNNvyFITfzv8vy3ARBxwSF90i8U9CXmZJGZ6sY=;
	b=iswRGm+EFg69pXk2T6lT9MkieQYmToBSKGTDg7f+3U2FKMGEAUFDTLPSUsWre+8RWpi0
	 KsCGisG8jQr7NAxL5/b6LhsG1ZG0J/gKyWz/WC3zucizAne4G6LSL2SACoz9QpTgteIbM
	 tyJNvPQ4jipQ64cvKsuZTv4ulvW+nsLOodwbhft6Qjmo3vEJ69lFhy5ZwB5Y56Y2EKSGg
	 RU8sqgE7TRHCxz5TJVDbQ3TG4jWbZM2qAN2J5L14xl5vO1eWIFqUsxmxreSXk9LeW3XxJ
	 Uiqk76OtX+ebkPL0a7nm2BGMujvhZ/DaHVEaxWF4NgKR4bGVe34c28KcnnC18kdv8ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VCT2s4ic;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F15E606A326;
	Wed, 25 Nov 2026 16:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VCT2s4ic
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230C81F000C0;
	Wed, 25 Nov 2026 16:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622478;
	bh=FJxGguNNvyFITfzv8vy3ARBxwSF90i8U9CXmZJGZ6sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VCT2s4icu7XTT7FuNpvkvz7p8bCeXGJXVsSO5Y504y6Lz2ha/9Erk87kYl+MvLLIq
	 hEA+Bj95CIJj1V9AmJ6yFMYDfuR2WcmiS/nDSCUEFi6rvJjJDS73IDUEDoQ4qGuInS
	 jwmmhPcUx+JNkf+xEZk2mTUUazGBApGlUeXERvVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 544/990] arm64: dts: qcom: x1-asus-vivobook-s15: Mark the EC reset gpio as reserved
Date: Wed, 25 Nov 2026 15:31:51 +0100
Message-ID: <20261125143834.841644810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Applied the one-line GPIO 65 reservation to the single-file Vivobook S 15 devicetree, since the upstream shared .dtsi file does not exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts b/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
index f2960953e608f..7abd519f38a4e 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
@@ -742,6 +742,7 @@ &smb2360_1_eusb2_repeater {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	edp_reg_en: edp-reg-en-state {
-- 
2.53.0



