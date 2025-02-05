Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA878634E;
	Wed,  5 Feb 2025 14:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765171; cv=none; b=d35vlcl0Lz5Hvb4Psewrj3co3wc89Ej7T8SQZ0D3vqAkoCWO4Qkb0wMUKS4aeqgQof5z9wPpBKj3ZvzSQvv5gVYBQgMNb1YCJIOedv3ayHtiq3XD7Bww/W41Y8in5L41To6b9+hh5EL8JSqdxpwfhRbI9Huhmj+xvmB52qPhtpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765171; c=relaxed/simple;
	bh=bazaHg1Q0CTh7f3PksMNltQeGiSxmS+ftdpmQnd9qEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQvXvmA6EjzqSySdnukrV9oS1GTrk7iHA+Yz99SFVPuPe+sPYhXmt+H2gp1zI+tf8tYhTHIQuCtodSyPmXsBbVyMe/ubgeqVtcQLFoM+aCA7/b9axCCkBj6yRdP/iQY3Qaakm2MhOjGZHmgSLdFvE/kqH/Q5TBTqg5HO7ZfXVv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XMOCP1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XMOCP1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DE4C4CED6;
	Wed,  5 Feb 2025 14:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765170;
	bh=bazaHg1Q0CTh7f3PksMNltQeGiSxmS+ftdpmQnd9qEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0XMOCP1t8Y6Cj+7mF+KwbkgDVB2n8PpAv032oTpZrcP6HG/q3Agwsl+ZC5UhU+6Q2
	 2yBeq45apcfLUjVZikenJkGagiQu4ixiQ4Spk4ioOuqgs+VIm556yYqZ3w6jGWz/o3
	 XjGYMIuylkvjJwsv9hpp99oG7FCxEy9jAwu3g/2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 240/393] arm64: dts: qcom: qrb4210-rb2: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:39 +0100
Message-ID: <20250205134429.488235801@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 298192f365a343d84e9d2755e47bebebf0cfb82e ]

Qualcomm RB2 board uses PM6125 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 8d58a8c0d930 ("arm64: dts: qcom: Add base qrb4210-rb2 board dts")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-6-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
index 5def8c1154ceb..331b6a76560db 100644
--- a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
+++ b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
@@ -492,7 +492,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &tlmm {
-- 
2.39.5



