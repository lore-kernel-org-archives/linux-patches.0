Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C713A1DFD89;
	Wed,  6 Nov 2024 12:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896465; cv=none; b=k5g/70PKLryhXlhWoNQTIrsyCvulhMC9qXE9dpGX0567zR/nHdrOtWrbdbiLEqbdFaELUcPmkAMIVLbWffTC2TXtb1xVPtvLWgEViUYUnpbHg0oBb9600sp+KQTQB/5i34IpoAzzZAnRhy82LoSzYffiB0jBlkRlGO5IGJuR9gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896465; c=relaxed/simple;
	bh=Z/lXqYXPcVZbr+lC5/huI+yFKfSuTny5sRiwzB1CZKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keYonJyOf78cZ7X6XqI3IqnO6/RG0GfyN13GmtTKzI1yebuZmQnK6jw605ZmX9plKYFsu6aGPoPkN1q80sCNJ9WIWOyTT+Kcp/sqxUGOHntxe8jPYzMMYMcmOiHNvveStI/eP7bJWNbC0TsqfiP3j23gN4U+5jD7N3Qp/3m94W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N37pb4Bx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N37pb4Bx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496BCC4CECD;
	Wed,  6 Nov 2024 12:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896465;
	bh=Z/lXqYXPcVZbr+lC5/huI+yFKfSuTny5sRiwzB1CZKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N37pb4BxWyr57Pmn1ojfrx42iwVAbnVSl2rinDrDbSbKQ5iGVUzLViW2E8fTH7Bef
	 Unz82D971/7dKPypj15U7Ap5SAYN+vB199BNhB80Sfi8BkvzWKcZUA/vg7730SQus7
	 1/EdOlq4in1xFA0VJNL99P4p7JedOglXDOH9vgEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 212/245] arm64: dts: qcom: x1e80100-yoga-slim7x: fix nvme regulator boot glitch
Date: Wed,  6 Nov 2024 13:04:25 +0100
Message-ID: <20241106120324.473454900@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 1badd07e4c0e1ecfb187dcba05357c0f3e70e797 upstream.

The NVMe regulator has been left enabled by the boot firmware. Mark it
as such to avoid disabling the regulator temporarily during boot.

Fixes: 45247fe17db2 ("arm64: dts: qcom: x1e80100: add Lenovo Thinkpad Yoga slim 7x devicetree")
Cc: stable@vger.kernel.org	# 6.11
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241016145112.24785-5-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
@@ -206,6 +206,8 @@
 
 		pinctrl-0 = <&nvme_reg_en>;
 		pinctrl-names = "default";
+
+		regulator-boot-on;
 	};
 };
 


