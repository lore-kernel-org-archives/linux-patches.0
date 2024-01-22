Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4436214A4FA;
	Tue, 23 Jan 2024 00:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969236; cv=none; b=RmJMgOlYokr7/7879WCRX/1VmQP9RuCxFekcfBJmWU4bCbqxo1pUD//dQF1HIo6YM04qoynPD3VHrxDSjSPOc4X0dyidg/OyaDAktfvsy3qoRFO9Ipl1CvXeoMvrOPm9lzQBore1QzdCi1g74++nifnDyj9eKhtcaN/0utWyQvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969236; c=relaxed/simple;
	bh=3AkFxzG5A1L+AyLN0EXYxwdSycWF4yYUSqpbTVgmUH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnNkar5kUUWP3mk72zKYkjSLOdG6NWGxzRVxtUj8GfE7zi+QxwCP7pnMD/ZqKz9d4MMRSMi1FrzCdYxzdLOL56pJCNUXlsTKjmKZknvXP6IXEg4KAbY4wI3KSroH4LuVoXxtG/5o/AVFzl+k6NJ8M2Gyq0iw0ALVqGCIvcP1J1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/WeRWTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/WeRWTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071B2C43399;
	Tue, 23 Jan 2024 00:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969236;
	bh=3AkFxzG5A1L+AyLN0EXYxwdSycWF4yYUSqpbTVgmUH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/WeRWTGltSnSySg+ANtzauKbXF+pvbF16zZdSZpllhD1f3llM/Qez2xIVBHMkgQN
	 7btCq0/Ww6+lAEh3NxqyVyCwdxY2aQrwjK1Mz5IeUz5l59hThkhuQ/EY08I7H7cs4Q
	 NtTgxqlalhWGKlryIwW0D0gos6cekP2ibyAs8UmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 118/641] ARM: dts: qcom: sdx65: correct SPMI node name
Date: Mon, 22 Jan 2024 15:50:22 -0800
Message-ID: <20240122235821.741359733@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit a900ad783f507cb396e402827052e70c0c565ae9 ]

Node names should not have vendor prefixes:

  qcom-sdx65-mtp.dtb: qcom,spmi@c440000: $nodename:0: 'qcom,spmi@c440000' does not match '^spmi@.*

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230924183103.49487-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-sdx65.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom/qcom-sdx65.dtsi b/arch/arm/boot/dts/qcom/qcom-sdx65.dtsi
index 648899b5220f..27b7f50a1832 100644
--- a/arch/arm/boot/dts/qcom/qcom-sdx65.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-sdx65.dtsi
@@ -530,7 +530,7 @@ restart@c264000 {
 			reg = <0x0c264000 0x1000>;
 		};
 
-		spmi_bus: qcom,spmi@c440000 {
+		spmi_bus: spmi@c440000 {
 			compatible = "qcom,spmi-pmic-arb";
 			reg = <0xc440000 0xd00>,
 				<0xc600000 0x2000000>,
-- 
2.43.0



