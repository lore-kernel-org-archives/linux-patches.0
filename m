Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2843734C13D;
	Tue, 16 Dec 2025 12:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887087; cv=none; b=bhX4v5+xTA9j4z/11ipT6nEHUVxPTOa0rHdTKf72HDBZKZGc30r0AQS7ZzdthE2TWjCjBHzCHimssWK1oC8fcZP76Lq5nyvR5TpfeOHFT95OeR+Qtb2TvTpY327Npp3HGPtYuvLt7kTbg5GbhgjKdCTbM0JFe0XNTT9GqSbXDO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887087; c=relaxed/simple;
	bh=xeh3o3HL5iVkBL0FPXBOvNBoLh4Mx8PSZ4Antlgrwog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2mNydTtRPwNWQPX2Qn0fL9/vfeHlTPLVg1dpZ9qW3fxjkkug/ns/Oj3YlU2OOtCvBYG0tudue8okTCTPZ4i1Jmvg2MXxXzPQ0bf8JeW3w25jimOPdjtLqUeYcjHoWkMC7gQkaeMbCAlBlBfGHK+3ltSvMxb62jpH53AoaC0um0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PllEeBtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PllEeBtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDB4C4CEF1;
	Tue, 16 Dec 2025 12:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887087;
	bh=xeh3o3HL5iVkBL0FPXBOvNBoLh4Mx8PSZ4Antlgrwog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PllEeBtVMUmhl6QymIzRjXT6LdPbC3SDVN10QlhZZ+0DYlljHXBGGsWLC2xilUezM
	 8sDICGdhD9AEIH+QGb9SPcyiDhNrx6Uf9E+24sfltxhNIKimVjIp5qeY3cazTbyP4J
	 D7p7CgYq2qKuM1O8cQ4svDveW6EqKYIyT52ltsFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Val Packett <val@packett.cool>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 122/614] arm64: dts: qcom: x1-dell-thena: remove dp data-lanes
Date: Tue, 16 Dec 2025 12:08:09 +0100
Message-ID: <20251216111405.755688403@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

[ Upstream commit 147d5eefab8f0e17e9951fb5e0c4c77bada34558 ]

The commit 458de584248a ("arm64: dts: qcom: x1e80100: move dp0/1/2
data-lanes to SoC dtsi") has landed before this file was added, so
the data-lanes lines here remained.

Remove them to enable 4-lane DP on the X1E Dell Inspiron/Latitude.

Fixes: e7733b42111c ("arm64: dts: qcom: Add support for Dell Inspiron 7441 / Latitude 7455")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251012224909.14988-1-val@packett.cool
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi b/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
index 9df66295660c3..847b678f040c0 100644
--- a/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
@@ -1023,7 +1023,6 @@ &mdss_dp0 {
 };
 
 &mdss_dp0_out {
-	data-lanes = <0 1>;
 	link-frequencies = /bits/ 64 <1620000000 2700000000 5400000000 8100000000>;
 };
 
@@ -1032,7 +1031,6 @@ &mdss_dp1 {
 };
 
 &mdss_dp1_out {
-	data-lanes = <0 1>;
 	link-frequencies = /bits/ 64 <1620000000 2700000000 5400000000 8100000000>;
 };
 
-- 
2.51.0



