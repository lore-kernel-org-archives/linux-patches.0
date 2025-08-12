Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD09E1C1AAA;
	Tue, 12 Aug 2025 19:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025435; cv=none; b=p2r93Vo7huukcX+J0TS87D6mMP9M924QidoeEXrY3UiUqb4yAPV3H8H9J/Xbohd3Dmsldt2WZYzm0bKrfEO5BNp9eah52TBt866w8cPVQ6vS161KH/77TvzDFdU9iw4lCzb51IDU3m8UuOaGxZ7n0qjMIKt6DNI+KeMXe8If55k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025435; c=relaxed/simple;
	bh=r2gkixSLj3ZEtiLBIzm9rZ2uJZiMRrr6fRZeWGvGJts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBQLiGquwWFiEAtlGv3tiaN4uTNMQrnrvOSJodCP53ZZZJIgga4kukvqiSLxi4vZupfUmzkeVPFWt/oDJ/MIa1T2JO666pdyVxsT7ZqKos7rfcgua0a6czsbc02y0bnSgOwOndCyglkWMXR9one478JxccGlkLyg7HhNAXBAinw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBUqPb0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBUqPb0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C41FC4CEF0;
	Tue, 12 Aug 2025 19:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025435;
	bh=r2gkixSLj3ZEtiLBIzm9rZ2uJZiMRrr6fRZeWGvGJts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBUqPb0rFN9UZfPLFas40MovYxEDqBwUozM2+KCx4+5AswDkFVAb2vItj+k3jFoIH
	 bOMAUuuWtHMi9Ls5FqVfPYUa47VR0npgJ+SW3iFl+IGoQcbIbE/pqW2/Y9ejLI8dUQ
	 PZue9YDyyuJ1IfcnNcjMWe894St6TvSYVVJNImfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 039/480] arm64: dts: qcom: qcs615: disable the CTI device of the camera block
Date: Tue, 12 Aug 2025 19:44:07 +0200
Message-ID: <20250812174359.018742919@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Gan <jie.gan@oss.qualcomm.com>

[ Upstream commit 1b7fc8a281cae9e3176584558a4ac551ce0f777d ]

Disable the CTI device of the camera block to prevent potential NoC errors
during AMBA bus device matching.

The clocks for the Qualcomm Debug Subsystem (QDSS) are managed by aoss_qmp
through a mailbox. However, the camera block resides outside the AP domain,
meaning its QDSS clock cannot be controlled via aoss_qmp.

Fixes: bf469630552a ("arm64: dts: qcom: qcs615: Add coresight nodes")
Signed-off-by: Jie Gan <jie.gan@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250611030003.3801-1-jie.gan@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs615.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qcs615.dtsi b/arch/arm64/boot/dts/qcom/qcs615.dtsi
index e1f510e5485c..3fda88b32a71 100644
--- a/arch/arm64/boot/dts/qcom/qcs615.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs615.dtsi
@@ -2428,6 +2428,9 @@ cti@6c13000 {
 
 			clocks = <&aoss_qmp>;
 			clock-names = "apb_pclk";
+
+			/* Not all required clocks can be enabled from the OS */
+			status = "fail";
 		};
 
 		cti@6c20000 {
-- 
2.39.5



