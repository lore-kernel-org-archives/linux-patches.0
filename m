Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DD56AAC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC48C433C7;
	Sun, 17 Sep 2023 20:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982075;
	bh=xpKGV79LMQjIvPdw+UVYlas2kTLW9qMnILBDGHD4vlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJWGdWGHO/1HuheLn5So+3iwzPNzeg4QABa981w5ZS4Us0og73XUKGTE17Euv2qeR
	 QfKxzqNjCHQfI1yt5g8cejzaX7AsKPcWk+QvWOWuK+NVKKd1SBFuwSTYntaLSEejx+
	 SPAOB2ODvif8382lwVhE18rlXFjbDEiBjBwEc9C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/511] arm64: dts: qcom: pmi8994: Remove hardcoded linear WLED enabled-strings
Date: Sun, 17 Sep 2023 21:09:34 +0200
Message-ID: <20230917191117.405001279@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 9b729b0932d0e6097d9f103e9dd149ef10881f43 ]

The driver now sets an appropriate default for WLED4 (and WLED5) just
like WLED3 making this linear array from 0-3 redundant.  In addition the
driver is now able to parse arrays of variable length solving the "all
four strings *have to* be defined" comment.

Besides the driver will now warn when both properties are specified to
prevent ambiguity: the length of the array is enough to imply a set
number of strings.

Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-By: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211007213400.258371-12-marijn.suijten@somainline.org
Stable-dep-of: 8db944326903 ("arm64: dts: qcom: pmi8994: Add missing OVP interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pmi8994.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/pmi8994.dtsi b/arch/arm64/boot/dts/qcom/pmi8994.dtsi
index 7b41c1ed464ac..166467b637527 100644
--- a/arch/arm64/boot/dts/qcom/pmi8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmi8994.dtsi
@@ -39,8 +39,6 @@ pmi8994_wled: wled@d800 {
 			interrupts = <3 0xd8 0x02 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names = "short";
 			qcom,num-strings = <3>;
-			/* Yes, all four strings *have to* be defined or things won't work. */
-			qcom,enabled-strings = <0 1 2 3>;
 			qcom,cabc;
 			qcom,external-pfet;
 			status = "disabled";
-- 
2.40.1



