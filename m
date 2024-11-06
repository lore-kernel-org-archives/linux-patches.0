Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B8B1DF974;
	Wed,  6 Nov 2024 12:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896471; cv=none; b=f2CG7ZBW5RVCmCU8zBwDAQWgpFrEZKnqYAP5RtaWr1ju4hwxN32j/9tFc+C0NB61T82OjxV7QLPQ4LS7yNzp5z95stSGi11Elvx9nhdCbYXNl/gy+X6rCtze0dBW+xZU1dEuHluzLFymWTO0v7L/pBq5VP2/aMIixl01Zu3TN0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896471; c=relaxed/simple;
	bh=hdg5UsZ1XJ+IoYuyaBU5J4jwDzLvoHJT9SKlcRydBuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPsMZVo/B1WmAADVLNHZyYRWZNfJ+K5FW1xah8UjkuRFXKMPyObmR3BWBKyxG7rVaS5V9fuFlKvlLHfyJohcTAmSWA+yAG3krZWonSoRFypIj98cRDrWEWa7GzaSV00mTe1ebEqmYjlIoG7oCIvF7R8aLKvERl0TK5txdzL4560=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOKNQpXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOKNQpXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E38C4CED4;
	Wed,  6 Nov 2024 12:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896471;
	bh=hdg5UsZ1XJ+IoYuyaBU5J4jwDzLvoHJT9SKlcRydBuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOKNQpXhJonfKQ3Zf6cc391652NHkpWIXbcWQynVqQGnOw5vLnrh4Ai1fgjmLNB/Z
	 txiNDlZfAIhG7JJXZ8JD7nl7Tts8JcvolSMeD88n60ER57s5j4udSBZ6MnqR6T9y4+
	 /gyQuWwuY7O1cmXUDfFoyXBss/0zYzUWJp8ZnCXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xilin Wu <wuxilin123@gmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 214/245] arm64: dts: qcom: x1e80100-vivobook-s15: fix nvme regulator boot glitch
Date: Wed,  6 Nov 2024 13:04:27 +0100
Message-ID: <20241106120324.521426644@linuxfoundation.org>
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

commit c6d151f61b6703124e14bc0eae98d05206e36e02 upstream.

The NVMe regulator has been left enabled by the boot firmware. Mark it
as such to avoid disabling the regulator temporarily during boot.

Fixes: d0e2f8f62dff ("arm64: dts: qcom: Add device tree for ASUS Vivobook S 15")
Cc: stable@vger.kernel.org	# 6.11
Cc: Xilin Wu <wuxilin123@gmail.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241016145112.24785-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts b/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
index 20616bd4aa6c..fb4a48a1e2a8 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
@@ -134,6 +134,8 @@ vreg_nvme: regulator-nvme {
 
 		pinctrl-0 = <&nvme_reg_en>;
 		pinctrl-names = "default";
+
+		regulator-boot-on;
 	};
 };
 
-- 
2.47.0



