Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B866D2FFFBE;
	Mon, 13 Apr 2026 16:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097419; cv=none; b=Hw3Sg9nAhVj75Asrb5R3E7YpBz5zxBrSmwlSYgVhz2UIkoUoPdpT6xuvSjKzcV14T8cLEVfVMBkhElBnnWgv7JdBI7d86gzfiG8qRZ8XLke+0xSlSkFquxsE6W++7t6CRV47DJGjHbnPXBs60UbnMIcRck6qrfGrg82vg4holgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097419; c=relaxed/simple;
	bh=yvoAt6MnxIp/14OkgNvLXe02U7dxd7sfgM81Ijj1EGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X244nDz+LadU5qKxZAKuLKZDk+lJ9tgk3gDF1T4hqq1WQA6S4oj0FKy/syloXUDzL2BhflwpKmEuevsdTeAd6LKVYagujPsiXamMDxjmPvLAeH720ECJmob5XmoVOsPEZjf5qYXTD0TTi8gwwSf4qjy9/Lv9gZftlEk3pklaFfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbkLrxMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbkLrxMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED60C2BCB0;
	Mon, 13 Apr 2026 16:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097419;
	bh=yvoAt6MnxIp/14OkgNvLXe02U7dxd7sfgM81Ijj1EGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbkLrxMQQJ71SNEczOkFvkqYcFfbCW7VCuSEmad4nbnPGGHlRURq007veCvdQ7QQh
	 L2h53pj1Hpr7i3ZeWVBurKKcep290PuuXBCxflObNEgkVRW+VTf8GKNUahd3RUQyQg
	 1lp65f8JJN+pCLs+7+hZ+8WoiqnLTuYKeKd9cr7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Mattiolo <marco.mattiolo@hotmail.it>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/570] Revert "arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on"
Date: Mon, 13 Apr 2026 17:54:21 +0200
Message-ID: <20260413155835.313048578@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 018e8512fed90cb3f67851dcd3e4fb0891544871.

The backport applied regulator-boot-on to vreg_l12a_1p8 (ldo12) instead
of vreg_l14a_1p88 (ldo14) due to identical surrounding context lines.

Reported-by: Marco Mattiolo <marco.mattiolo@hotmail.it>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index 948ec59418017..66b86dd292c8a 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -226,7 +226,6 @@ vreg_l12a_1p8: ldo12 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-boot-on;
 		};
 
 		vreg_l14a_1p88: ldo14 {
-- 
2.51.0



