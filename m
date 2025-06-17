Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B52C2DFF00;
	Tue, 17 Jun 2025 15:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175435; cv=none; b=a6m8E5npSxP5+ometXp+F7/jLgCvRuavKr4lYWvIc6eRhcZDWEiSY50Il8kef/SqyLuqb129FIOSIfUxGdtE9vIjJQejuoQkQ8GJw7h4sVegpeEhtcJ98qoVpgZ3K8rp+XCYVuYdLEKy/ws6IU2U4A4D+hLRA6K5G+FHlDo0o6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175435; c=relaxed/simple;
	bh=z5UwdA3KARL54bXhPXWVbIT8tXo9UVTN44cdrPMEfGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQuJwaN+IrQrEki4pofhs/L8Cm4gYb9ylArmqm0Q8m8IliU/B/a5yPS7V6ZgQOZJ7tegZRZEx6053nqvI9H0zm9L1BAvJaU1z52/i1ynC+H00D+39kleEEimJtUeSwKPjqicrDL2GzsH/qMDHzRzJkHwtl4d1SK22tVjCFqCLYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQgZbRxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQgZbRxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0BEC4CEF0;
	Tue, 17 Jun 2025 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175435;
	bh=z5UwdA3KARL54bXhPXWVbIT8tXo9UVTN44cdrPMEfGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQgZbRxXdx7xNXhrPdrosl0v+cI1xDf7yvY5tXKAguHamyR+nnwr3cL3oumTAn3R0
	 WNWwJmh8Subbkqcrc3Xqs7I6WsCcC+gyRYbSq6aK1NkTga1nueFNjAZP6sx709PxW6
	 N5/NkK76aIxHGoHY8BdBjstP5oHxfN3ctKPemmeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/356] arm64: dts: qcom: sda660-ifc6560: Fix dt-validate warning
Date: Tue, 17 Jun 2025 17:24:51 +0200
Message-ID: <20250617152345.297291908@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Minnekhanov <alexeymin@postmarketos.org>

[ Upstream commit f5110806b41eaa0eb0ab1bf2787876a580c6246c ]

If you remove clocks property, you should remove clock-names, too.
Fixes warning with dtbs check:

 'clocks' is a dependency of 'clock-names'

Fixes: 34279d6e3f32c ("arm64: dts: qcom: sdm660: Add initial Inforce IFC6560 board support")
Signed-off-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250504115120.1432282-4-alexeymin@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts b/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
index 2ed39d402d3f6..d687cfadee6a1 100644
--- a/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
+++ b/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
@@ -155,6 +155,7 @@
 	 * BAM DMA interconnects support is in place.
 	 */
 	/delete-property/ clocks;
+	/delete-property/ clock-names;
 };
 
 &blsp1_uart2 {
@@ -167,6 +168,7 @@
 	 * BAM DMA interconnects support is in place.
 	 */
 	/delete-property/ clocks;
+	/delete-property/ clock-names;
 };
 
 &blsp2_uart1 {
-- 
2.39.5



