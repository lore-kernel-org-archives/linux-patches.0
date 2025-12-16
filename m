Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669E531A7F5;
	Tue, 16 Dec 2025 12:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887093; cv=none; b=Qy2qM6+cTADePGUFWhRMh5TOZbY3w7UToLsbb65fyyEOFDcDRUGIhsX2e4KnHJnLWqlzbYDzJemqp+ao3aUUcE56Oz+1VdUWYVxzZr/rZ52KA7TSDqaOSTM9ImhOL83F1DRHhCNhJ4WXL8oALx/RSeZNt34yEdwtCHDqsT53kdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887093; c=relaxed/simple;
	bh=v5bQwEmjareuChpXY5RDKE3CreGWIhTGomk/RPr5T8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqXJBrvzw7o6HoexOhIMaKN7icESrqC6du9Ypv7fqWuCKxl5ujGOBP1+mOZ2UxseP7NyO0fCXSnqP/qxRhkUGXy9iOK7N9LFJKlT6BCCzC1E7+cz9O7Y9f750SppJBLd4tCKEuT1UTozFn0h4N9xM9jAkFIUNAD6BC71Ex6FFUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17o71qJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17o71qJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B74C4CEF1;
	Tue, 16 Dec 2025 12:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887093;
	bh=v5bQwEmjareuChpXY5RDKE3CreGWIhTGomk/RPr5T8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17o71qJRiGsOj8pj0QtKYki5SmCDP2wgOcwo7D3bf5XWjQQXtys74bftJ2NF+QP+Y
	 YznwdGfxamhWcYVwp5kQazCuwihhwu/mdIe3fAHushldMQxo1jvX1mTOGCWeV7M2o0
	 WHAoX5v9aToqEb957IpSvhv4mjME4gl1mRlZQD0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/614] arm64: dts: qcom: sdm845-starqltechn: Fix i2c-gpio node name
Date: Tue, 16 Dec 2025 12:08:11 +0100
Message-ID: <20251216111405.829049113@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 6030fa06360b8b8d898b66ac156adaaf990b83cb ]

Fix the following DT checker warning:

$nodename:0: 'i2c21' does not match '^i2c(@.+|-[a-z0-9]+)?$'

Fixes: 3a4600448bef ("arm64: dts: qcom: sdm845-starqltechn: add display PMIC")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251015-topic-starltechn_i2c_gpio-v1-1-6d303184ee87@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index 215e1491f3e9a..493c69e991746 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -158,7 +158,7 @@ rmtfs_mem: rmtfs-mem@fde00000 {
 		};
 	};
 
-	i2c21 {
+	i2c-21 {
 		compatible = "i2c-gpio";
 		sda-gpios = <&tlmm 127 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 		scl-gpios = <&tlmm 128 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
-- 
2.51.0



