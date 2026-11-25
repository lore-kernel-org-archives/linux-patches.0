Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625173;
	b=zaF7eR4WEykS8f2KiFGdqN3tYTWDg+mZz3JlrdzOEbHCZ+yxCxYY+BZ/vjUasbn68iNv
	 4MkZin6ySAWXy/viM6vDjs9T5VclCDqbeKQIYCkxo4iffMr4gP1NAVGXgoZhUjW7ue5hS
	 KwzpcQV6+m8PoO2UhqaVQ5T91eY9MZSl3f5Mckv20MHMU7YVKMrs6Sy5npg9tgqLSvPpg
	 L1FsM/N3NRjotlLG/cGk9ZkoxsG1nP86U/qbmJZEjUCx9WKYMB0aOQuVfng8RRvCpheQp
	 5oi9hNd+9c1RHSq1GjE03relCcIIufHnVtpwYvojLEAKtnZhY/Si1gEqi7C82IaoLHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n+oTL7ENqzFI/CPFcC6aYA+U7TMSFYi2SzOO0wbkglw=;
	b=2j8QH4Jfk2UCeDxYWUT/8vXATL82ruSZDdxKHcmT4Ox+Jot6Lu112Xw64I/ckBCSOKQA
	 7+vBeNl4Q1qLMOZZKa/Q4drykNyr2vd94hr8tn1pRlHNB4VCMrDB1ZoOClnJAsgkdIisX
	 4UFm8BV7A4PvZjXQjj7SYcxXJvIAv0YdxGsjWL6anuQj9UfC0t2t+4yUO4UXv5bqXeeoc
	 GWR1hcKEydP8CrnKDw3Vqdqj7PFMwydvBzvxLUbnAHokxVtp1QWJxbmzJ4nfLq0IRIIFe
	 fmlQI9xIXP3uhO62yrfjReYdAci9gprggxhpFIvMU27DfxXm9LASIu8dMkhrQUOJUhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gCU7vcQ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9783606A321;
	Wed, 25 Nov 2026 16:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gCU7vcQ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEB21F000C0;
	Wed, 25 Nov 2026 16:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625173;
	bh=n+oTL7ENqzFI/CPFcC6aYA+U7TMSFYi2SzOO0wbkglw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCU7vcQ2tro1JwWqTXxF3jcEv6GoHPq/YeKs9JgwEDmbcbT5xiLrMV1MEvpCM+z/N
	 0gSw/uwaEuU8dd5v9RBZYnXVuCyqUZlcFmXz0MMc8OKKkeBqi7+YFUAz8Wc9K5eqY5
	 hx34bf8Tn5QB3kI8B39Dk8KPkB6K1f4/8AZH5WP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 431/816] arm64: dts: qcom: x1-crd: Mark the EC reset gpio as reserved
Date: Wed, 25 Nov 2026 15:32:59 +0100
Message-ID: <20261125143859.169666291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 099cd579fa73c142fde2f7e3ea473f334792a249 ]

GPIO 65 from TLMM is connected to the embedded controller's active-high
reset line. Asserting it causes the fans to run at full speed during
reset and leaves the keyboard non-functional afterwards.

Reserve it to prevent Linux from requesting or reconfiguring it.

Fixes: bd50b1f5b6f3 ("arm64: dts: qcom: x1e80100: Add Compute Reference Device")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-1-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
[ sashal: Applied the one-line gpio-reserved-ranges addition to the CRD board file, since the shared include file the original patch edits doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
index e5d0d7d898c38..e44ea4d686822 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -1000,6 +1000,7 @@ right_tweeter: speaker@0,1 {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	edp_reg_en: edp-reg-en-state {
-- 
2.53.0



