Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8467192D83;
	Wed,  5 Feb 2025 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767102; cv=none; b=Gt+zkcHp8WfizH8WZCu/75fXN+NGkXEex6n0Eze+5r53J2wGpRg6PNp6A81KKmXp/ZXwSFKXKs9IiF34Bs1SxKRU32NjQEcFvCu/wosMeAsCv/bah0OqUGLBNse+CuI81+wsfrVjQnIEjT0SJ+nPhKlMnYa7g/lg7F22DWuqLhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767102; c=relaxed/simple;
	bh=fp2ijNwEltgCPoaN3W+4u56lV5JhR0Q4poe/Nx0TlLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1T7d1T9QkSDu0qBGsKADlvVJ9mVS2TwIJ3WwPP73+UR7lPn6hKxVbIEQl6NxHNTqr+mGqMKHZfaPXvJKPAsU0a3Ouoh3anmcMG0aQBQn1xWMc/+lH3LvKzJOnnHDaK8VpXTknSwCzUTypFTN58a92JlejI4zQdO+mnO7hYEAUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnD4QOCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnD4QOCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7B4C4CED1;
	Wed,  5 Feb 2025 14:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767102;
	bh=fp2ijNwEltgCPoaN3W+4u56lV5JhR0Q4poe/Nx0TlLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnD4QOCQ4EHwPhnBlVS0AupfbhNRxNYFuG/BhsXldHurPgaeapFMu4z8DjSXxq15j
	 VSTG5+FcPTjF78xvjQQeu0+lxhjU8hJIoiOIfMCC9SmlhiLMv7erIu9kw08Z9I71zJ
	 DZfyHPOxeK5t4T+jCOmFrI6IEhywF9FyRrb45bFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Stanley <joel@jms.id.au>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 393/590] arm64: dts: qcom: x1e80100-romulus: Update firmware nodes
Date: Wed,  5 Feb 2025 14:42:28 +0100
Message-ID: <20250205134510.302440504@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 983833061d9599a534e44fd6d335080d1a0ba985 ]

Other x1e machines use _dtbs.elf for these firmwares, which matches the
filenames shipped by Windows.

Fixes: 09d77be56093 ("arm64: dts: qcom: Add support for X1-based Surface Laptop 7 devices")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250108124500.44011-1-joel@jms.id.au
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi b/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
index cdb401767c420..89e39d5527857 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
@@ -680,14 +680,14 @@
 
 &remoteproc_adsp {
 	firmware-name = "qcom/x1e80100/microsoft/Romulus/qcadsp8380.mbn",
-			"qcom/x1e80100/microsoft/Romulus/adsp_dtb.mbn";
+			"qcom/x1e80100/microsoft/Romulus/adsp_dtbs.elf";
 
 	status = "okay";
 };
 
 &remoteproc_cdsp {
 	firmware-name = "qcom/x1e80100/microsoft/Romulus/qccdsp8380.mbn",
-			"qcom/x1e80100/microsoft/Romulus/cdsp_dtb.mbn";
+			"qcom/x1e80100/microsoft/Romulus/cdsp_dtbs.elf";
 
 	status = "okay";
 };
-- 
2.39.5



