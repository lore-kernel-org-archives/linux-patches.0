Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2164369A;
	Wed, 25 Feb 2026 01:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982986; cv=none; b=ZB4w7qgNdsG2gkeKBiIradkKDaL7DHZqjqPeXCgeWiZpS//e/LPFS2Om4ayoR8UIOIq4VybcYBWoJqlX6NZw9TwnxbJpTZpzWenTRRdMJwRNl3Fg9Ro/Kd70kOOjxiu9mCV77Xl6ShEk1eFO6vo2JfvzUhZndnT+sQPm4l/u52c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982986; c=relaxed/simple;
	bh=q+xFtZZduV1OQ1r4DO3LSwI6qgzfRr/qZO19mYxbcJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYSe1NwpSALaUGk80CDS9T1RjywtJchpNH19NWpev9iFvaHliEWijBVR9plzGranEs7d8uA7QW3xNEPhy+sd81XOhFUeqibTRuQWv8cwyGfdgMvoxTaKh8TutGVXvfjHdU0EEzXUlyOUfKe5vFQtMlBad5rXoPZFZxWWdS6CT00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3/AUmZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3/AUmZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9B2C116D0;
	Wed, 25 Feb 2026 01:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982986;
	bh=q+xFtZZduV1OQ1r4DO3LSwI6qgzfRr/qZO19mYxbcJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3/AUmZKlcXMXe95UEnPkmrVlXeWpYYapWWhTqqJrMbqfOdFmdro/kJ+XyW8p3c7z
	 eFs3FD+DgfwWSJHaluqWI2yfxHrWF35Ud1CDWUCG5DIPOPdsHZsQDwyGRCySj3jLQn
	 CKlI6t9tZ3iyRLWtkAJNMrKqjxg/z8gg36TBuUA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 156/781] arm64: dts: qcom: sdm845-oneplus: Dont keep panel regulator always on
Date: Tue, 24 Feb 2026 17:14:25 -0800
Message-ID: <20260225012403.484368733@linuxfoundation.org>
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

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit 45d1f42d3e84b5880cf9fab1eb24a7818320eeb7 ]

The panel regulator doesn't need to be always on, so remove this
property.

Fixes: 288ef8a42612 ("arm64: dts: sdm845: add oneplus6/6t devices")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251118-dts-oneplus-regulators-v2-2-3e67cea1e4e7@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index ee62adfa6af0b..5845bc3bb80b2 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -272,7 +272,6 @@ vreg_l14a_1p88: ldo14 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-always-on;
 		};
 
 		vreg_l17a_1p3: ldo17 {
-- 
2.51.0



