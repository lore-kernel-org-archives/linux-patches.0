Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1399A2ECE86;
	Sat, 12 Sep 2026 16:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229146; cv=none; b=oKJf2SHvf0CqOwqqwH9GgSftIGdI4S8QGGRNwNf1xZZsHtmElG0X4mHUYdwbIT9iRNz1JG/IYIEXRVv+giBJ1kQqIdQSHpd2o7n01HNpl90a6vYszpO5SM2ZcxTNLo45K6JA5ZmiLYhdqBeMoK3Z3SqUa/BNcxVoAs/ZHef64Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229146; c=relaxed/simple;
	bh=52ds49nlhrYGrDL3MGy7I81BEwFwEa+UU6puyY89WBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0eG2zOMkvCc/6abp3QRa/zZFp4S9cIOzv17r0vx9Twq1tP72CTBODHVYw/qancviyKBADQ4/qdbvhkonao+pIU8R7vfiw9URBlbzYL9pYImI/fIiBWsbjOyOUbVXU3SlWr31uSu8l00U5MviqsQIIvg2rLgLplucmKOoXWWE7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGCXecI2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGCXecI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C01C1F000FF;
	Sat, 12 Sep 2026 16:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229145;
	bh=Qh43FewergH0VSEjhGDiD+d9TaM1xmr6dgBF8p4ocZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGCXecI2ZkxxIx1nzlBKyy8EYt1iae6l293cw+myphuBsHkFCXc6uoGbp18u6z4IE
	 vY2sPbXjPkizzf/tt3RYadJmlVcsxdI7oEzVgpZKgenCivd5BgNocdzvtDAuO9MfTZ
	 iUtu94vjiK+oy+SMtTEi/sNlEvVCr+XcLCp9JlvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0530/1191] arm64: dts: qcom: sm7225-fairphone-fp4: Fix address in fb node name
Date: Sat, 12 Sep 2026 08:54:18 +0200
Message-ID: <20260912065600.151983015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit f6e65005fe55c3d09287851523de06367cbf0bc2 ]

'reg' is 0xa0000000 so the node name is missing a zero. Add it, so that
the reg and address in the node name matches.

No functional impact.

Fixes: 4cbea668767d ("arm64: dts: qcom: sm7225: Add device tree for Fairphone 4")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260505-sm6350-misc-v1-3-0b9efc22690c@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index be47e34da9906..13b1d484bdeb7 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -34,7 +34,7 @@ chosen {
 
 		stdout-path = "serial0:115200n8";
 
-		framebuffer0: framebuffer@a000000 {
+		framebuffer0: framebuffer@a0000000 {
 			compatible = "simple-framebuffer";
 			reg = <0 0xa0000000 0 (2340 * 1080 * 4)>;
 			width = <1080>;
-- 
2.53.0



