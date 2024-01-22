Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4033850258;
	Tue, 23 Jan 2024 01:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974652; cv=none; b=J5CPLOCEOoBiD04b+xzXtGLZ/ZyDt3OuOzpX48sHTdpyDGWFy4wUZfOqnH7074nIOXi/E9k6c9R/y/PonTC0aJkf+7xHuZqVqdaFUO/a9MS0E3X6YfZkRPSYZClRhkwRSeWCI3CM1UQ0yQm7Bl89i6RLEFvHIm9o2lca1IHvBf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974652; c=relaxed/simple;
	bh=oSoBrT4VOdlvNdOTGiWsfIaOmWQ7SuvfFEObIGspN+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGkRQPXum6HGH8zGT5dUcgbm8jXzUPJ16jTDn/aos1RXNwhDPisevx5WHa/5F/qkmVqXa7FS2MTsqWLzUoAdZClxgBqXu6bZlPEa+cf5O6nlDexWo8CgTAwRhOknAgnfrs0oyG9njcw62W8jz9TByQkGFI/O57fj7jAxPx1TzN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6M/EeUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6M/EeUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F578C43394;
	Tue, 23 Jan 2024 01:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974651;
	bh=oSoBrT4VOdlvNdOTGiWsfIaOmWQ7SuvfFEObIGspN+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6M/EeUb/f4goFojwcgoeQgZEvOi+meaun9O1GeSEeplnBoMlTgB4gYatqoNsMx0a
	 67R6sQHaaSr9T0I+YB9xxv5AzTdaqerx3iw3S9G+G7BFCLQk91Iy+QAoFxAmpK6KZK
	 16KmjWoFM4KH6fJ6ihUSdIQbZuW8zXt2GlhvB4b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/583] arm64: dts: qcom: sc8180x-primus: Fix HALL_INT polarity
Date: Mon, 22 Jan 2024 15:52:38 -0800
Message-ID: <20240122235815.438180993@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit 1aaa08e8de365cce59203541cafadb5053b1ec1a ]

The hall sensor interrupt on the Primus is active low, which means that
with the current configuration the device attempts to suspend when the
LID is open.

Fix the polarity of the HALL_INT GPIO to avoid this.

Fixes: 2ce38cc1e8fe ("arm64: dts: qcom: sc8180x: Introduce Primus")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231130-sc8180x-primus-lid-polarity-v1-1-da917b59604b@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x-primus.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x-primus.dts b/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
index 834e6f9fb7c8..ae008c3b0aed 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
+++ b/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
@@ -42,7 +42,7 @@ gpio-keys {
 		pinctrl-0 = <&hall_int_active_state>;
 
 		lid-switch {
-			gpios = <&tlmm 121 GPIO_ACTIVE_HIGH>;
+			gpios = <&tlmm 121 GPIO_ACTIVE_LOW>;
 			linux,input-type = <EV_SW>;
 			linux,code = <SW_LID>;
 			wakeup-source;
-- 
2.43.0



