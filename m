Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DE3313E09;
	Mon, 13 Oct 2025 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369207; cv=none; b=tmxYxvrUEnFJ0u3y2/9khl1JIgdgJrCxBVj+JiN42moxKm5N6/HmDAPcwAtn8+6LRHsPHBui+VvfWN+AFayaxEzHtFYNE5AoGuXCinxoHg9erYiIkKZJPjg8YnTT8adTPyMs4GCtio6X0ywtIR+D21RB8H+pzhvCHyiuvieJ3a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369207; c=relaxed/simple;
	bh=Fp+y8LWQpWRStvyCnTuxWEXRULIUV9OjeGPAmjV7oNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdwvR/c4HCuX+cc8XmWQI5wTFVJ8AjBLu/bMYwFO8PLy2xkB3ZKs1CU9oDOQVKF9iWOPY+A3souq7VgxYtMM3WDzeQ8tnmYHLM31pPW+XSskyZ1yT3XT5nfBFFUBWMOw8Vx0S8bklHBAEylVLmJQ8E+p1jqnObsm3CkK+Eyl/ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvKgrRL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvKgrRL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0E9C4CEFE;
	Mon, 13 Oct 2025 15:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369207;
	bh=Fp+y8LWQpWRStvyCnTuxWEXRULIUV9OjeGPAmjV7oNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvKgrRL7DnUzfFUBHrc1vjn7mGLdi2ojwiwZ7nPxXCzi/PTB59B8n23XDzdDoRKrG
	 mbb5E/Ogu1GnxKk/xfugDbBZ9UMs3LlViaWWJtLvZN7r5SomryzyFqlKrWHPpO9fqM
	 aoCSSuW4fbaaX1nMDX+sO8Kp6UCSsREmg5li7+pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 132/563] arm64: dts: allwinner: a527: cubie-a5e: Add ethernet PHY reset setting
Date: Mon, 13 Oct 2025 16:39:53 +0200
Message-ID: <20251013144416.075202173@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit a15f095b590bcc1968fbf2ced8fe87fbd8d012e0 ]

The external Ethernet PHY has a reset pin that is connected to the SoC.
It is missing from the original submission.

Add it to complete the description.

Fixes: acca163f3f51 ("arm64: dts: allwinner: a527: add EMAC0 to Radxa A5E board")
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20250908181059.1785605-7-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts b/arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts
index 553ad774ed13d..43251042d1bd5 100644
--- a/arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts
+++ b/arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts
@@ -75,6 +75,9 @@ &mdio0 {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		reset-gpios = <&pio 7 8 GPIO_ACTIVE_LOW>; /* PH8 */
+		reset-assert-us = <10000>;
+		reset-deassert-us = <150000>;
 	};
 };
 
-- 
2.51.0



