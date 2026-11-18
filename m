Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017416;
	b=Ss0XspArjCeZd6/FdiGd0HgNY4S8oP8JpV8aXdB+GDe8zKYp2yBUHDKTXdvEJPZ6LRg+
	 zOB4xb2k8EZGn0pkAJJnSJgNgfVHvwCyMmNEa+7wS8hEV0PVrBH/3mGNExq5BbACMLFx7
	 /9HI7vCuGH1dP9sUMwIeB0twxlTtozsFJ9uJoJ7HLvUAwY4vS6yayJNyfHYTqb5flOM3B
	 hrk1eRS5CfA5bYMALeh8c4WTbSaDDeqqcxGUjBJM7kQ2NkvtFtubU7wypAR4pYhJLFyss
	 2w9VszAjPFOapWB7dR36zMJtR9RNj9eHHeIyGt+eYJtTf16ei7FyLBRt056hWfsjfBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W06VGN6Ol7tHRrKjWGcaMx+YRsLbIO3LB62/eobkC/g=;
	b=JXAFZru0KzK5oMeI00zOY+li60euvWPu0+2lIanAfF//qBZ5q6EE4UMkr4iD23v90LzY
	 1UnntT5vQu71NPcdww+BahT2/oAiWOMVnxY94bZQdHqZlMZTSq/1YerogeZit5MyV3Sjx
	 +/uX69HJALCj1fhTYv0ERFFaKLUxAKVVVm8eVnQy/8ZoHiEDLu5GM3Q1L3FomRgAq9pAp
	 YreW6GC0yRMD6mg5Zw4KfaORCFlpqI/ZoCwBE/SBZpSr3nO8xGBqIxQ7T6B9TIcbn30Ph
	 /vhCnpBWIDP/ZnaOMrSMxp93A7GiesJLPiTKgG6c+8igxsw7nDxY2g+Wk8r2diZVvQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GXdDGTTh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB64606A325;
	Wed, 18 Nov 2026 15:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GXdDGTTh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13DA1F000C4;
	Wed, 18 Nov 2026 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017416;
	bh=W06VGN6Ol7tHRrKjWGcaMx+YRsLbIO3LB62/eobkC/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GXdDGTThTcMf3WoOMTEaWRmRLY6usOnNEydw+Krt6COVXGUla02nEWUa4GJ2hEqug
	 Sdh3O3Awo95BFwOoKCJEH9GRLU7r+Q1UIzF/L+2lUZvO9eA4H07q2KICjMEULkkKAm
	 PuTZa2F7GpRwePB/39fdFJlwCjf0z4RCuI980TT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0878/2651] arm64: dts: qcom: qcs8300-ride: fix SerDes PHY regulator supplies
Date: Wed, 18 Nov 2026 15:35:18 +0100
Message-ID: <20261118150319.464181264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>

[ Upstream commit e55080f068f3f6b733235fd7618c12e61744244b ]

The SerDes PHY node was configured with 'phy-supply = <&vreg_l5a>',
which only covered the 1.2V rail. The 0.9V rail (vreg_l4a) was missing
entirely.

Replace phy-supply with the two named properties vdda-0p9-supply
(vreg_l4a) and vdda-1p2-supply (vreg_l5a).

Fixes: 787cb3b4c434 ("arm64: dts: qcom: qcs8300-ride: enable ethernet0")
Signed-off-by: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260804-b4-sgmiieth_serdes_regulator-v2-6-c4bc688177dd@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs8300-ride.dts | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs8300-ride.dts b/arch/arm64/boot/dts/qcom/qcs8300-ride.dts
index 1ff39530ea3de..76c34215dbdf0 100644
--- a/arch/arm64/boot/dts/qcom/qcs8300-ride.dts
+++ b/arch/arm64/boot/dts/qcom/qcs8300-ride.dts
@@ -702,7 +702,9 @@ &remoteproc_gpdsp {
 };
 
 &serdes0 {
-	phy-supply = <&vreg_l5a>;
+	vdda-0p9-supply = <&vreg_l4a>;
+	vdda-1p2-supply = <&vreg_l5a>;
+
 	status = "okay";
 };
 
-- 
2.53.0



