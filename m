Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6822BDC0E;
	Sat, 12 Sep 2026 07:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197654; cv=none; b=E/8Cmm+CLaacdlHYSsuMGNpt8qOmU8vS+KYTTmuD8EoWlVvvvQgM/wK82k/OpcUlfDS84Jk1EDwtCpsIpXcBBbs5vL8DtTNR2SGqEWRN4dRTXR2R+pw3ubYQsPX2e1KKRRtOYLWE2WbAVYibLG/6Un7FJiVvT4Zcq8xUOTNOxXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197654; c=relaxed/simple;
	bh=a2WzBS9Js/5lL3IWrm5ukK82xmaXmmVwPkrJY1qkR2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9JJEg7kQ4pPxvsuz8XB36Jx90fgNAObAzc9iisPuNyCG0MbTHqtvVoIffVOXwYvurN9DJwe2gFmpMwtb8Gfq4sEcpGCbp7CiaoLpQtxi/1K98JUAFEVmWGaUnMSter9h9ZHM1ioGvtj8LtT33HYN39KWfTuaoK8Ll+yP9+FujQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UD2mGM82; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UD2mGM82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CFA1F000FF;
	Sat, 12 Sep 2026 07:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197653;
	bh=txO5s/zRYd7Z0+tjxO+V6JKwkoMJBmqtYEFjtmUPl58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UD2mGM82S0zh1df/U0QSIm85wMj2orxFVYb+t4aZhJjYbgj+izEzr5awLJ0yNdKxX
	 SxmPHnXUr3juZRvPRgFDY00hq49ozyvSfuEJ05c+xpcWficvs9/S7lGx+fnpquvacz
	 3iXNfaR6BrrDudY7H9Jnxo0eG5oZBoFf2cbhrM0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0218/1815] arm64: dts: qcom: glymur: Fix unit-address mismatch for spmi_bus2
Date: Sat, 12 Sep 2026 08:32:48 +0200
Message-ID: <20260912065654.111603332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>

[ Upstream commit 82a766b68cd4d323b302a28082fbb7924f1146e6 ]

The spmi_bus2 node was named spmi@c48000, but its reg property
specifies the base address as 0x0c448000. Fix the node name to
spmi@c448000 to match the actual register base address.

Fixes: 41b6e8db400c ("arm64: dts: qcom: Introduce Glymur base dtsi")
Signed-off-by: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260518-glymur-fix-spmi-bus2-unit-addr-v1-1-27d6edca51e8@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 129be417ac424..5997078575206 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -5029,7 +5029,7 @@ spmi_bus1: spmi@c437000 {
 				#size-cells = <0>;
 			};
 
-			spmi_bus2: spmi@c48000 {
+			spmi_bus2: spmi@c448000 {
 				reg = <0x0 0x0c448000 0x0 0x4000>,
 				      <0x0 0x0c8e0000 0x0 0x10000>,
 				      <0x0 0x0c44c000 0x0 0x8000>;
-- 
2.53.0



