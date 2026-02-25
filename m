Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F32C1F03DE;
	Wed, 25 Feb 2026 01:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983020; cv=none; b=r+3+M1ETl9h21CDzi9DHVQYA2ZpJMQ//XRtIh6k68zRFh3hB7/U7/3AC+JB82hp+FpMJFQe1JOW5v+FBv55CsZyeV+S+E3H6TiSoEztutyRk/UP+Jj4vyxICO3/3ENMdnT5vBEF8PCcv6EDf2f7jhcyaZTQ96n3zs9XPleU02T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983020; c=relaxed/simple;
	bh=o+9wAv8DfY4ejroE+7z1pof63lfrvgxs2zJp1Tce7E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cn14I5NBCa2S6qBSPgcOW6WPVWuRAxW1O8z1ZP6n2sThNZEizt1XbOTKMfqF1l8oig/CkJ+PgdAJiebe9jeDXuerr8gmIJdzIOzEtM4BYuWWXgpYw//nTvzc9SiCtY35KMzCD5pXCNc8BO3gLb8wbwU4IRKTMlcjZQ8FFPGIFyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AM+9SkRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AM+9SkRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D958AC116D0;
	Wed, 25 Feb 2026 01:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983020;
	bh=o+9wAv8DfY4ejroE+7z1pof63lfrvgxs2zJp1Tce7E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AM+9SkRP8tHUvkALRZ/+X64TNjCUySXkVnrYLBqfipeb758N99dge3IxFz/04cpBU
	 jda1ugV3wwNVu6yfc7Tb2LHxqYKjpF70gi3Os5+o4/HCxm91oY8b/ncaiyOpP+K+id
	 JnvMDJWcd6FNm3gp+i2LQ9w3St1Dx65KwoHMh3z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 187/781] arm64: dts: qcom: talos: Drop opp-shared from QUP OPP table
Date: Tue, 24 Feb 2026 17:14:56 -0800
Message-ID: <20260225012404.231917022@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit dda4bdd325326dd67ae4401f4f3d35b9cf781e3f ]

QUP devices are currently marked with opp-shared in their OPP table,
causing the kernel to treat them as part of a shared OPP domain. This
leads to the qcom_geni_serial driver failing to probe with error
-EBUSY (-16).

Remove the opp-shared property to ensure the OPP framework treats the
QUP OPP table as device-specific, allowing the serial driver to probe
successfully

Fixes: f6746dc9e379 ("arm64: dts: qcom: qcs615: Add QUPv3 configuration")
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251111170350.525832-1-viken.dadhaniya@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/talos.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/talos.dtsi b/arch/arm64/boot/dts/qcom/talos.dtsi
index 95d26e3136229..3ef21bae31742 100644
--- a/arch/arm64/boot/dts/qcom/talos.dtsi
+++ b/arch/arm64/boot/dts/qcom/talos.dtsi
@@ -537,7 +537,6 @@ cdsp_smp2p_in: slave-kernel {
 
 	qup_opp_table: opp-table-qup {
 		compatible = "operating-points-v2";
-		opp-shared;
 
 		opp-75000000 {
 			opp-hz = /bits/ 64 <75000000>;
-- 
2.51.0



