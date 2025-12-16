Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5CC34D3BA;
	Tue, 16 Dec 2025 11:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885325; cv=none; b=Yd4lGvi6AyZwjryyCKQ3JA5BumJ8UIqyfq3W5QBUk+5r4hBcjU/0vplo+nbSd1D9Y00JuiX83Lhl5AWLQ9hktZq20jgdVvtwSg9X4Sqon6K0FtL6cMFjLbiSFgjGr2nWryWIZj56Fj+qpNfXbGGv3+8MEMJ8pkkpgHa3heimVPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885325; c=relaxed/simple;
	bh=o8HvTvAQLHI8JH29givA4HbpScuBBQ8iLzuaCVgPUbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMjiIdQnHfaQzbjRuYXBMmeGptk52NVDNAzXSOcQc5Dx5z97jHXjDOla1JSkxmInxSixFxnaqwr4AJu/MpQRjF8WFm6Z5Qj/QkmAg6DK6/HdjsM8hz6vBuopV273tafbGp6PiB4+HP1DGhiYhpHkbZErKEQNvQEx0vQDWNjMOY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBFa5EaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBFa5EaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AB5C4CEF1;
	Tue, 16 Dec 2025 11:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885325;
	bh=o8HvTvAQLHI8JH29givA4HbpScuBBQ8iLzuaCVgPUbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBFa5EaMINqfMFlETdavC5GaclmPACBATuYDG5+IgKiI90ZGq4DsXDI+YdDUnvDwd
	 BDdO+FJH3I7K1+3X7aDgkcX/hFUfk0WV2rXFhOeEuJa8Rr3V1/17eRiEcBatS//6TG
	 vZAGIiMm5bJ+4hU/E7yKEhhDEl4foyH/DG3KW698=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 106/507] arm64: dts: qcom: qcm2290: Fix camss register prop ordering
Date: Tue, 16 Dec 2025 12:09:07 +0100
Message-ID: <20251216111349.377506569@linuxfoundation.org>
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

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 67445dc8a8060309eeb7aebbc41fa0e58302fc09 ]

The qcm2290 CAMSS node has been applied from the V4 series, but a later
version changed the order of the register property, fix it to prevent
dtb check error.

Fixes: 2b3aef30dd9d ("arm64: dts: qcom: qcm2290: Add CAMSS node")
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250918155456.1158691-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm2290.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcm2290.dtsi b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
index 4613713124f77..7705ef6ebea12 100644
--- a/arch/arm64/boot/dts/qcom/qcm2290.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
@@ -1679,25 +1679,25 @@ cci_i2c1: i2c-bus@1 {
 			};
 		};
 
-		camss: camss@5c6e000 {
+		camss: camss@5c11000 {
 			compatible = "qcom,qcm2290-camss";
 
-			reg = <0x0 0x5c6e000 0x0 0x1000>,
+			reg = <0x0 0x5c11000 0x0 0x1000>,
+			      <0x0 0x5c6e000 0x0 0x1000>,
 			      <0x0 0x5c75000 0x0 0x1000>,
 			      <0x0 0x5c52000 0x0 0x1000>,
 			      <0x0 0x5c53000 0x0 0x1000>,
 			      <0x0 0x5c66000 0x0 0x400>,
 			      <0x0 0x5c68000 0x0 0x400>,
-			      <0x0 0x5c11000 0x0 0x1000>,
 			      <0x0 0x5c6f000 0x0 0x4000>,
 			      <0x0 0x5c76000 0x0 0x4000>;
-			reg-names = "csid0",
+			reg-names = "top",
+				    "csid0",
 				    "csid1",
 				    "csiphy0",
 				    "csiphy1",
 				    "csitpg0",
 				    "csitpg1",
-				    "top",
 				    "vfe0",
 				    "vfe1";
 
-- 
2.51.0



