Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E9F347FE1;
	Tue, 16 Dec 2025 11:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885358; cv=none; b=Oyo3KIXl5Diwin6qWEGN93UnT2oy51dYurELbIggWgXB2wPYPYnTc9O640z/FxomJIB61parQYP0JhuQlyoZtD4QVyuvbchLzOTul6YpCgwRrB9vXTwfi/PU97+hV6b5KW6IDAhi/J6A9MWSKgqQ/98nGvJvgSNG33tQdmnDRTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885358; c=relaxed/simple;
	bh=RAFeLvM2FNMMC5sYh6CDpu7j/UL7S/fjjMrvAz5fK28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7cXciXNL1QAJBCpBPDHzJpLwMI7N7w0YEkzoUNpAlP6sKfY9YDGMHcycGKtJqxHOmipl8tPDkJ/tl7mPGEesqt8QItFxdHN8jA9Mx1FaLXGAW5yCEm42+9t9i+1Er66o8iS7P0gj9Uyc7hzObWOtU3AC46flEL7FdN+12kxhZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19clTIML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19clTIML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A594C4CEF5;
	Tue, 16 Dec 2025 11:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885357;
	bh=RAFeLvM2FNMMC5sYh6CDpu7j/UL7S/fjjMrvAz5fK28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19clTIMLDVrW5lEX7Q+Y3qZ2X3R6RF4o+gv2ZOOz3R5QwOoqFl5s0GdMWuZem962K
	 RXA/HTQPukhP2aFC/FvDW23p9TYd/RhQcE4MIYB/NdeQHIfZzybJ834NIob6Yz8ogj
	 c0jC2rH5UKr+zJNvB7SWvgqA4yrl8qn/w45rZ3U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 098/507] arm64: dts: qcom: qcm6490-fairphone-fp5: Add supplies to simple-fb node
Date: Tue, 16 Dec 2025 12:08:59 +0100
Message-ID: <20251216111349.090730204@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 3d4142cac46b4dde4e60908c509c4cf107067114 ]

Add the OLED power supplies to the simple-framebuffer node, so that
the regulators don't get turned off while the simple-fb is being used.

Fixes: c365a026155c ("arm64: dts: qcom: qcm6490-fairphone-fp5: Enable display")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250930-sc7280-dts-misc-v1-1-5a45923ef705@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts b/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts
index e115b6a52b299..82494b41bd9ac 100644
--- a/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts
+++ b/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts
@@ -47,6 +47,8 @@ framebuffer0: framebuffer@a000000 {
 			stride = <(1224 * 4)>;
 			format = "a8r8g8b8";
 			clocks = <&gcc GCC_DISP_HF_AXI_CLK>;
+			vci-supply = <&vreg_oled_vci>;
+			dvdd-supply = <&vreg_oled_dvdd>;
 		};
 	};
 
-- 
2.51.0



