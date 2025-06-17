Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951AB2ED876;
	Tue, 17 Jun 2025 16:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176570; cv=none; b=CwazrwdHsA5cvJYRAGG8RnWb7jYVJhwxnazlnrfpI8yv/bhDu7yds0svdv7PSLwoXOlW8105ftDlD3SwzuAKWoXztcWH9zJT9IpqpCvNp6CPnZcDBnn9exIdofsOJVnsy13jZ1xipRkBZtu5J51QdQdY4ipVUE+SyWa2UgbNjYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176570; c=relaxed/simple;
	bh=pKGIpzbM8hliXCnOUagkCwxIHZ1vLv/qrZbHjcIA33c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQy2HE5Ja4/QU1LEqTz1j/tYJeM4j6EyGUk6IEQhsMYd21SmDZmEypWmRXE7tsAG1Lwto5JYqON/eyPZNXmIXYtog2SjuKAu9ua94/jLgu/hSZ9lWzCXKrbScoJPWydiPpcFMlU+jmhMH+gd3ej2yaZqNhlDvGtWWZ84upX9WiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuImbXUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuImbXUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F9FC4CEE3;
	Tue, 17 Jun 2025 16:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176570;
	bh=pKGIpzbM8hliXCnOUagkCwxIHZ1vLv/qrZbHjcIA33c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FuImbXUUnMfK9Gn2uS7Fpsr/kurStbhxOGuM35PeM4kmENRwiJU4gniVoYVBADer8
	 pIdKAhQ0NOa/N1SIAGMR6vLpUFDntx6iv487kUC4MCPC0AbhIjrhv0/FE7ZHp8d2hl
	 Bs8/5odJUCmDOeUG/xpmh3Mrm0MJl72ExPVql0m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 243/512] arm64: dts: qcom: sdm660-lavender: Add missing USB phy supply
Date: Tue, 17 Jun 2025 17:23:29 +0200
Message-ID: <20250617152429.461126464@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Minnekhanov <alexeymin@postmarketos.org>

[ Upstream commit dbf62a117a1b7f605a98dd1fd1fd6c85ec324ea0 ]

Fixes the following dtbs check error:

 phy@c012000: 'vdda-pll-supply' is a required property

Fixes: e5d3e752b050e ("arm64: dts: qcom: sdm660-xiaomi-lavender: Add USB")
Signed-off-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250504115120.1432282-3-alexeymin@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
index 0b4d71c14a772..a9926ad6c6f9f 100644
--- a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
+++ b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
@@ -107,6 +107,7 @@
 	status = "okay";
 
 	vdd-supply = <&vreg_l1b_0p925>;
+	vdda-pll-supply = <&vreg_l10a_1p8>;
 	vdda-phy-dpdm-supply = <&vreg_l7b_3p125>;
 };
 
-- 
2.39.5



