Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045193;
	b=3qK6f8fEvLFdvVVw/etBuTEGcD/oiOAHxcqq1SQY6F+UFhRqSntRbjQSFSJR9ob7fVCs
	 bhpDlyd6f2ZIhp4rImn+d8qn7xEHaGUqsdoCGaoDzDAb7CsfdeN45mqDpqvwvGT9xPEwc
	 UURgy2PfX/XAll7CtcmKWpXaJ2IoxHCVb4RC4BcSTxxQlpjEhHVsIV4fW6JqAjuB3cJSe
	 I40A82PcfiDNatUh7LOGPP7aIJexdMGFpNyWPy/SDL13a5UaK14+nf9kLnWBnXtdx8iMv
	 8VV2ClWdg9qaBvJ3erRqOMSKladDIiaCrGQeGyowfGoIHX35Jfl/pG61W1gNLhZnYdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tm721GycH/v3VZZhMrGxpDvTGD21BdRCFGSK/8YSxFs=;
	b=czx5IpgG+96rUIY7uFmL6sVlJdaViBrrAEVAqAUoNnE3wdGcGHjHDdokfuih5Wll54Ak
	 2ksthUVmv2i3uIPD0KkIjfB8rhBX92+8L6NYMktibJLGyVOvdVMa4ru/rPgDoto2zyFeU
	 gVCqVQbFNfMWW+cBikAApLa6M5+VAIg7mulREh6bzGLZ7uKzyOqkSBtAXWRhoVNh66PsY
	 +G6mg/Q1kksX4WzVmOH69/XTOHMgH3Cl/v6NudgeIPLAZTvSLEMcOSSYPdhfhz3HVyDLx
	 5/Ip23S27tSFQq300nx2xqPyOzINBVisTcldoxYrsvg/Q+PkBSzj71ZRXXJWM8k2d+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tuAII/r5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C652F606A31C;
	Wed, 18 Nov 2026 23:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tuAII/r5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2782D1F000C4;
	Wed, 18 Nov 2026 23:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045193;
	bh=tm721GycH/v3VZZhMrGxpDvTGD21BdRCFGSK/8YSxFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tuAII/r5DBtzODaXlhTS2dWgpmGb2+PptPEtiYH5ujvT8i7UyAznkNjilHSTXB8/Y
	 wkKuGR/7x/gZlxqZDDRRG2gVbkY+xhP30VXZX7w/CnSlHM8pm6/Ycllld2g/BAxuCU
	 xGuYf0Dj+TJDLBm8UbC/Yr+5CG8/yAof/9z6U+pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0833/2857] arm64: dts: qcom: sdm845-xiaomi-beryllium: Extend the xbl_mem region
Date: Wed, 18 Nov 2026 15:31:07 +0100
Message-ID: <20261118150231.565516813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 511c4fea32708a065e03503c0e4d44f48990c530 ]

Xiaomi's Oreo-era tree still had the CAF 1 MiB region, the 2 MiB version
arrived with the Pie import. This isn't a board-layout quirk, it tracks
the firmware. The later XBL wants one extra MiB below the old region.

Cc: stable@vger.kernel.org
Fixes: 77809cf74a8c ("arm64: dts: qcom: Add support for Xiaomi Poco F1 (Beryllium)")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-sdm845-xbl-mem-v1-1-6e3c88507997@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
index 261364dc3faaf..63d11753d70b4 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
@@ -24,6 +24,7 @@
 /delete-node/ &slpi_mem;
 /delete-node/ &spss_mem;
 /delete-node/ &rmtfs_mem;
+/delete-node/ &xbl_mem;
 
 / {
 	model = "Xiaomi Pocophone F1";
@@ -54,6 +55,11 @@ key-vol-up {
 
 	/* Reserved memory changes from downstream */
 	reserved-memory {
+		xbl-mem@85d00000 {
+			reg = <0 0x85d00000 0 0x200000>;
+			no-map;
+		};
+
 		tz_mem: memory@86200000 {
 			reg = <0 0x86200000 0 0x4900000>;
 			no-map;
-- 
2.53.0



