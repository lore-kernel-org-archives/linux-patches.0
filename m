Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEC141D208;
	Fri,  4 Sep 2026 06:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502571; cv=none; b=b60G/+339olILhZK2teWHD3aT1Y6XPsjMRVmbGJ52iGiA/4hKK5dUt25rJeMRMZcz0c3la++0/0AifKYGkfSMcaVXemqiQ8sCjfgJ6PKk5biDVj4iLPjDjlqnjRjTw6auIin8rePXAYIEy8ts5C94kcazENj9CMPF3PeRXrn4GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502571; c=relaxed/simple;
	bh=qWYjWFRUTFvVOb2rWzJGRi/6yWtyBUjGJY1sdbhLBE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqAqJKohzuup8bvguYgqU/rIjH1qODiopjzBFfZmg291ox826Op3SUj25QOXosFnmv8M8H21h95JOjsCl2bnes6lBgQ5AlKyMEEeOIWH6yEZnACk3lHGyR0ydea3/+oBwTSLi2vtx1VDI3HFoPgZS8G/WUeBD8mrZAEGiK5Erx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqVfnqso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqVfnqso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5521F00A3D;
	Fri,  4 Sep 2026 06:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502570;
	bh=Jjp/JyqbadJqgVH9F/aE3f7zOyzQa0GKGRfbuURpTaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qqVfnqsoRKeX+9GTVuWrMhLE84BuGxd8Xr3ea1IDy602znQaQFnt7l3aBVJ4LW47q
	 spgAWO0O6DjbVi0rmu9TLOk/OiswDuUzU9V8BXL9gpJWJq9dW8llG+Boj5lDiD0jER
	 Q7JZsY7YZqMw4BuoQxTyFUoi3r0GdlDkZLU1QycQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 227/403] arm64: dts: qcom: sm6115-pro1x: Correct touchscreen GPIO flags
Date: Fri,  4 Sep 2026 07:00:30 +0200
Message-ID: <20260904045740.024072123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/boot/dts/qcom/sm6115-fxtec-pro1x.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6115-fxtec-pro1x.dts b/arch/arm64/boot/dts/qcom/sm6115-fxtec-pro1x.dts
index 0f23eaef01f2..b290f0f4c0e1 100644
--- a/arch/arm64/boot/dts/qcom/sm6115-fxtec-pro1x.dts
+++ b/arch/arm64/boot/dts/qcom/sm6115-fxtec-pro1x.dts
@@ -151,7 +151,7 @@ touchscreen@14 {
 
 		interrupts-extended = <&tlmm 80 IRQ_TYPE_LEVEL_LOW>;
 
-		irq-gpios = <&tlmm 80 IRQ_TYPE_LEVEL_LOW>;
+		irq-gpios = <&tlmm 80 GPIO_ACTIVE_LOW>;
 		reset-gpios = <&tlmm 71 GPIO_ACTIVE_HIGH>;
 		AVDD28-supply = <&ts_vdd_supply>;
 		VDDIO-supply = <&ts_vddio_supply>;
-- 
2.55.0



