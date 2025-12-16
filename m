Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47F733F378;
	Tue, 16 Dec 2025 11:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884037; cv=none; b=au6Y33RmSeE6mdN/k8pEDf0RDqLzbQ7micEyENu0/hGUY3zMTYmWcAEnmMJ6hDGfR0r+TBJDYtgqrSkjgZIuv+6Bi+YPid40wNinzeLxZL0ov1u2kNCF3IQZe2xYMu0+Z9iTO81+H54d9cFPlwjGt/TvwqsHVg1d7qI9iQFkJ8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884037; c=relaxed/simple;
	bh=stSdIohe07yS0CGdx9HahDRvrE5eZsZKj4wpLGiaO9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAbpwMs2yFVk9cR5yOjeZoMbdt107xM8SEeH3b1MQCS2QEbRkHnUS6e4BC+c3LnNEPCh0r5/MxOCml9PT6wLe5ysFaHcE9hW3tvbDdNao6HmBeo63SNqWsSCGswdRg113oJVMYuDtV/F7XVFc2kuXvpMYamjhTu8Edh4gnDE9EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDff1ygq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDff1ygq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CBDC4CEF1;
	Tue, 16 Dec 2025 11:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884036;
	bh=stSdIohe07yS0CGdx9HahDRvrE5eZsZKj4wpLGiaO9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDff1ygqbJWOUGAUAix1ii0CCkf9/AvB7CLHEn83E59OcfmgDZnRJpV6+qZ7UZU09
	 2jiDbaJujRY8QdShdrwrM2g9+zg0oDknaSOcj/y1GsAle/MEpZXfQKLTPenDy6vJUS
	 k4qHUiDfvqt1S+ikAcugN9RTg9qJMAFzRYltvDoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/354] arm64: dts: qcom: sdm845-oneplus: Correct gpio used for slider
Date: Tue, 16 Dec 2025 12:10:41 +0100
Message-ID: <20251216111323.605377484@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit d7ec7d34237498fab7a6afed8da4b7139b0e387c ]

The previous GPIO numbers were wrong. Update them to the correct
ones and fix the label.

Fixes: 288ef8a42612 ("arm64: dts: sdm845: add oneplus6/6t devices")
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250927-slider-correct-v1-1-fb8cc7fdcedf@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index 46e25c53829ad..d0cbf9106a792 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -803,8 +803,8 @@ hall_sensor_default: hall-sensor-default-state {
 		bias-disable;
 	};
 
-	tri_state_key_default: tri-state-key-default-state {
-		pins = "gpio40", "gpio42", "gpio26";
+	alert_slider_default: alert-slider-default-state {
+		pins = "gpio126", "gpio52", "gpio24";
 		function = "gpio";
 		drive-strength = <2>;
 		bias-disable;
-- 
2.51.0



