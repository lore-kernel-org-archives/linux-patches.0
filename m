Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5317482;
	Mon, 23 Jun 2025 21:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713633; cv=none; b=uFUyGVldRy6Qdiyk9dEwiTM97PiaS1vVUXT05uQiZ583t/Tqbtep/vJ7QXlYqEh33gshjZH7wPucYO7qYcXXkr4w0iAgzcMppoxxgmCx2B5D6BFe0Rx/DNUg+QZ6u0nLqTqY9CvNmD949fiEHtwW9avY87FATSNFMvOUaehvZfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713633; c=relaxed/simple;
	bh=nJDRUVXh2oElUL0G41pmbZBgPW4V92Zd6L4uI+cvxy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBBxcy9uNwnWVEHz/lRoJISsAcFTzXJic8dDT5XvfYojvjIgu7GpY37Em/2PqwDPeMGSlWRj0pgEpXJxXwXaTx3WFlPr9cmdDhHurPVurZAy/JU8g9NKB4i8opX54yGpdLkDFglxNrDwRnUa1rLkuqTveY5vY0sGxDgAIs41wmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTh5h8B8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTh5h8B8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53798C4CEEA;
	Mon, 23 Jun 2025 21:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713633;
	bh=nJDRUVXh2oElUL0G41pmbZBgPW4V92Zd6L4uI+cvxy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTh5h8B87xTJfJLoapCn3+Q/144pFqdwY0jhE1DIu1hi7aQG4j2bd+GnfD3lKqZsB
	 lMCL4DkZI330Jvro72jmvBCFjrptab4z8N8jpga0Hh6ssfrleWIud2u1VYgjaemW+K
	 yvVOr0rxf8CwTDwaRa/tSBEZQ3tGRN8KS09lGOlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/508] arm64: dts: qcom: sdm660-lavender: Add missing USB phy supply
Date: Mon, 23 Jun 2025 15:02:39 +0200
Message-ID: <20250623130648.100902379@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Minnekhanov <alexeymin@postmarketos.org>

[ Upstream commit dbf62a117a1b7f605a98dd1fd1fd6c85ec324ea0 ]

Fixes the following dtbs check error:

 phy@c012000: 'vdda-pll-supply' is a required property

Fixes: e5d3e752b050e ("arm64: dts: qcom: sdm660-xiaomi-lavender: Add USB")
Signed-off-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250504115120.1432282-3-alexeymin@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
index 9612671dc5afa..6166099aa0c32 100644
--- a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
+++ b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
@@ -107,6 +107,7 @@
 	status = "okay";
 
 	vdd-supply = <&vreg_l1b_0p925>;
+	vdda-pll-supply = <&vreg_l10a_1p8>;
 	vdda-phy-dpdm-supply = <&vreg_l7b_3p125>;
 };
 
-- 
2.39.5



