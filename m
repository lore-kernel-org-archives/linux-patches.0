Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F8E1A3A80;
	Mon,  2 Jun 2025 13:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872159; cv=none; b=J9+JF9YdJbedQSK/YBTVpoxFnSrqaNZtKtxRW33m/K2dHQAr4EshaV41cQ8vcortlAHbh6LgokvydLUAKqoijkJ4znUgSOTTs7j12GPVXcNZyGo2WEGAcIE1USM67BOJO0z8cUQgqvpVoLUO6DOw2LLXzCo/2YPEaP7Eqa9grmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872159; c=relaxed/simple;
	bh=rffd3203g1cFgfDD2WpLeV19H7Unz5lOXHJBEkle9a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7xfHFeXPkvPWFNakT2EyfAxDGUrXNgJDxUKO3o98QLpbLFW+TDI0KS0x+ilEcTJp53/ozA4MuRFTuF95J4JZe86X7nrvRNyntOiqFFJ30tPp0qL35UI5ZeKZg13qMm85MdAFfurTJUTiGGR5aV12CLmLuTLJ8EFz8G9XC50TkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ph4bFK23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ph4bFK23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A931CC4CEEE;
	Mon,  2 Jun 2025 13:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872159;
	bh=rffd3203g1cFgfDD2WpLeV19H7Unz5lOXHJBEkle9a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ph4bFK23f5h2/34oTHF39roQdjy83G0EgmtdzYZm/HGAlOq9f8Sy0BDmGsa1OdVEl
	 YFu28FmPoNVncCs4AJ4a7+JDg9CyEbHmIVaPC8kCW3Q6lrG90a0SErMDwxpUdr4Jyx
	 zpW1xI/5iXRo9CP18dRF9qKNnGkNSi1D4fNoekz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 08/49] arm64: dts: qcom: sm8350: Fix typo in pil_camera_mem node
Date: Mon,  2 Jun 2025 15:47:00 +0200
Message-ID: <20250602134238.269363133@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

commit 295217420a44403a33c30f99d8337fe7b07eb02b upstream.

There is a typo in sm8350.dts where the node label
mmeory@85200000 should be memory@85200000.
This patch corrects the typo for clarity and consistency.

Fixes: b7e8f433a673 ("arm64: dts: qcom: Add basic devicetree support for SM8350 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://lore.kernel.org/r/20250514114656.2307828-1-alok.a.tiwari@oracle.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -455,7 +455,7 @@
 			no-map;
 		};
 
-		pil_camera_mem: mmeory@85200000 {
+		pil_camera_mem: memory@85200000 {
 			reg = <0x0 0x85200000 0x0 0x500000>;
 			no-map;
 		};


