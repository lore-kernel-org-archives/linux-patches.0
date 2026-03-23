Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622ED381B03;
	Mon, 23 Mar 2026 14:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275409; cv=none; b=s7ODDJGAcKiBVyjl9pRADvakIk3prFnD3/ykw3Vz4EAZ8gLWDsW6TJcekTSstr6UYKrPCLgrfLoAhQtHs1ZkuqOjldC4QZ2wcWE3Xxi0aLejGiCP52FjJ31ZgaDfa5hqv4t+d8dksGbhDK8Mqeotw+RgzXrBVa+3tFTjGUCSQa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275409; c=relaxed/simple;
	bh=JLQ9dxzxak4whxfDwZ14XVqqS0ibn+q4MP2m2jnPY/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNBkBtRk9I1Vi17DXQ3i5tKPG/Lt0dCYkjZqRMNaTCZv2I+ljI/Kc9R6ibYxSpi0jTVnrQMRkVfN/Cfx4LRc7pnvfHar4sxvaGmpinJMj8Kp/WOht7uQINO13jpwjM3B4KTyGSv+1PUc2ZSeQqIMmMbifXdf5ckbGRcPzZri+Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K33dkP23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K33dkP23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A45C4CEF7;
	Mon, 23 Mar 2026 14:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275409;
	bh=JLQ9dxzxak4whxfDwZ14XVqqS0ibn+q4MP2m2jnPY/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K33dkP233XYYo0Oa9ako54wKi4lX6Z4F7oJNq52s/6wvT331OVrEvQPnCxiwDmHjZ
	 JkFNHXnmk+EpqwfVf/oTTcFhq/bJkUkTVGwQf5Hd/JldQFrqMtSLTJ+sd2O3YXpoHf
	 P63pMqihPdgIDwSLI+TWhjzDhv9yNz9iCwviFI0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Mattiolo <marco.mattiolo@hotmail.it>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/460] Revert "arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on"
Date: Mon, 23 Mar 2026 14:41:24 +0100
Message-ID: <20260323134528.832668439@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit a7037c3eb0130a6167138e69178895b22758d7f3.

The backport applied regulator-boot-on to vreg_l12a_1p8 (ldo12) instead
of vreg_l14a_1p88 (ldo14) due to identical surrounding context lines.

Reported-by: Marco Mattiolo <marco.mattiolo@hotmail.it>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index 934bf9cfc5ac7..56840b6ed6449 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -246,7 +246,6 @@ vreg_l12a_1p8: ldo12 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-boot-on;
 		};
 
 		vreg_l14a_1p88: ldo14 {
-- 
2.51.0



