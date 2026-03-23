Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555EF284B36;
	Mon, 23 Mar 2026 15:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278291; cv=none; b=RG+BgK7sfRtvA8ykNkDv2krRY0490mJOHfTh6P5EMwHRWXfD4obCbAs9FZnlg+V+Cmp8P/IApbY7IBmxpMC1LKq3uZ8hz44vRtXzWuZsGfC2eyLZATN2ZwBmaAV5P7VMG2hRCv9Bf9oAkP+LkZD9M2sFHLsmAW9T6bwRgO6aMyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278291; c=relaxed/simple;
	bh=smfqsRiSosoEKMfrbtVbMlSpJrdUayn7bobQNUP5osk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUVcoEJa7kTuOcaZZobLTB7kNjrc4wUHSPz6WaJyrnUELXp1a9Z3jjCDPQMs3kbBUa4kyog+M2UOWLlgCoqEnd0LukGoVqHV9rxk+ZHFLBT/VC/gO7xHflXTd53aC/IkUZ0H/+GmdYiVvXAgdNYt9oqwRAVRWP75iYYbsOx/mBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6zqnZNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6zqnZNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F173C4CEF7;
	Mon, 23 Mar 2026 15:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278291;
	bh=smfqsRiSosoEKMfrbtVbMlSpJrdUayn7bobQNUP5osk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6zqnZNfjuZoDUlHY3WFuw+aE6J+UVdUw9O62DHm4S/h5ph2kTsp4IDdAZov+xCur
	 ZCgcLRv6BqWjqQCuYouPVohpjgLJU4WbYjz75nAGPrdiNIGjiaFwAfKlF1FgmApiFZ
	 BSIATLa6fZykDDM3keQ+Y+SKlfh1MU3CRmuNZH3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Mattiolo <marco.mattiolo@hotmail.it>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 260/567] Revert "arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on"
Date: Mon, 23 Mar 2026 14:43:00 +0100
Message-ID: <20260323134540.264219680@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit dc62cf0814fa62177bb4ba944c72d9f122568cdc.

The backport applied regulator-boot-on to vreg_l12a_1p8 (ldo12) instead
of vreg_l14a_1p88 (ldo14) due to identical surrounding context lines.

Reported-by: Marco Mattiolo <marco.mattiolo@hotmail.it>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index e028b58a30f31..c50d335e0761f 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -245,7 +245,6 @@ vreg_l12a_1p8: ldo12 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-boot-on;
 		};
 
 		vreg_l14a_1p88: ldo14 {
-- 
2.51.0



