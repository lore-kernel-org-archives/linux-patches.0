Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCC841A574;
	Fri,  4 Sep 2026 05:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499460; cv=none; b=ip54EPR+PkAzMfEwmu9j3B4RXg2QTY8oJHWMItMkWBWw+xOH7G15rNLT/L4mwUE6yH9x6e41AYsl1H/EBS9BhoY/W40t59vPVYfa0ZL+bWulBiUb63T+eNZIE9NO0XH2uYKUol1kSGiiMT69YO6vIGryY5YWcUL9olRKk1WCKsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499460; c=relaxed/simple;
	bh=HE5oSTqeAPOIUsAU59P2II/5Ow9kcLxwllUOAvaA1bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bM+8MTqRORSa51Cmm98/728laKsbNfsNpMWQdA6l9S5k3LFme84B9leSdRtiyw+APT/GCge9GIM6NQF+yO0BwE7aokRBSxyK6RCET2Ra/yFYm4yx20Ihs+ArBKDE8YoHeJisAH0+IalIs6VldQ7c4l4wMui3kvT0vNyS+yI18XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfbMlqml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfbMlqml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5C91F00ADE;
	Fri,  4 Sep 2026 05:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499457;
	bh=le1NXjROAlMVXqYoZ9G/N82U77TZY3eDH0oxpj9qe1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nfbMlqmlvWhlB3b+vQjVL6EV5PID3utfJsj/B/QBtebzMzjajsW9ZeFT4UJpo+hNI
	 gyhj0qaN8QhcPb7/wgX/qQ4lxeZYzROd4SHXgftKzTLQ37/tZ2FyhQNdsfjVtBfN5X
	 pmlqYVmu6MdFqDtXykCLOZn36AVXPIdHMR862ooI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 7.2 424/713] arm64: dts: qcom: sm6115-pro1x: Correct touchscreen GPIO flags
Date: Fri,  4 Sep 2026 06:56:32 +0200
Message-ID: <20260904045813.332524915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

commit 8e73ae5c34e4fbbd25a8324e3c0eb1e845d7f01e upstream.

IRQ_TYPE_xxx flags are not correct in the context of GPIO flags.
These are simple defines so they could be used in DTS but they will not
have the same meaning: IRQ_TYPE_LEVEL_LOW = 8 = GPIO_TRANSITORY.

Correct the touchscreen irq-gpios to use proper flags, assuming the
author of the code wanted similar logical behavior:

  IRQ_TYPE_LEVEL_LOW => GPIO_ACTIVE_LOW

Fixes: e46b455e67f8 ("arm64: dts: qcom: sm6115-pro1x: Add Goodix Touchscreen")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260413090527.53000-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6115-fxtec-pro1x.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm6115-fxtec-pro1x.dts
+++ b/arch/arm64/boot/dts/qcom/sm6115-fxtec-pro1x.dts
@@ -151,7 +151,7 @@
 
 		interrupts-extended = <&tlmm 80 IRQ_TYPE_LEVEL_LOW>;
 
-		irq-gpios = <&tlmm 80 IRQ_TYPE_LEVEL_LOW>;
+		irq-gpios = <&tlmm 80 GPIO_ACTIVE_LOW>;
 		reset-gpios = <&tlmm 71 GPIO_ACTIVE_HIGH>;
 		AVDD28-supply = <&ts_vdd_supply>;
 		VDDIO-supply = <&ts_vddio_supply>;


