Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5C13A960E;
	Mon, 23 Mar 2026 16:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282542; cv=none; b=LGFGXGh1cKmLY9CNde0Vjmq6QrMeokluSRzzv0Ij4LPpUfWoHfgrACyffX201I6tQvqmCeHK8Wr2JvktjTrnvn/tMX3ODARaAm04CnBM7cQsGNRDPRMBnM76QFrqeOPett5h8PCdts+dhlfXf9Z+llCe3xUGracJcraRI/z9NIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282542; c=relaxed/simple;
	bh=k6U/gvew15wB99F5AcUy4jzhOkbO+48mQFGKWaxJeqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rlf7/5wciuPwQXB1fRrwYsmCZJj6uc7NjpOlOxHaHk03WeqXWqmkMf4VYl7IHUEFKkyRCffA+Pob7SOSMZQJO80qIgbaxWRYq+pKRwR1HDwMCu3VdcdbcYqCIENVO8lf6hJ05AUBOvM/6fXWAIr+nz5CXf6oGWBnwrDbynYZlFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFPA/KL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFPA/KL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D86C4CEF7;
	Mon, 23 Mar 2026 16:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282541;
	bh=k6U/gvew15wB99F5AcUy4jzhOkbO+48mQFGKWaxJeqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFPA/KL33SYe62dvTabu40diMegtIcXGTwk7qc7k9LuMn0C/js0i+6C3VY8RAFETE
	 oMS/GSJxkLwG9NSBJxIhcz5vrYAbC+zKxzW5TxpX0sdZsIDER/mYDN0VIxkA5vrEIj
	 CkF7S/V9MRDx85aesg2tRfQ5n/IAzXGt3gJIE1mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Mattiolo <marco.mattiolo@hotmail.it>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/481] Revert "arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on"
Date: Mon, 23 Mar 2026 14:42:58 +0100
Message-ID: <20260323134529.963975953@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit d2a3230c1f655e5d1560ec005805f800b9873292.

The backport applied regulator-boot-on to vreg_l12a_1p8 (ldo12) instead
of vreg_l14a_1p88 (ldo14) due to identical surrounding context lines.

Reported-by: Marco Mattiolo <marco.mattiolo@hotmail.it>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index ab2a9d1ff8865..281e1178a2f46 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -224,7 +224,6 @@ vreg_l12a_1p8: ldo12 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-boot-on;
 		};
 
 		vreg_l14a_1p88: ldo14 {
-- 
2.51.0



