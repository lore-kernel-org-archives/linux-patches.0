Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31313B19DE;
	Fri, 15 May 2026 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862377; cv=none; b=Y4rNk59t91H0YogtloN2to0NieZvi8HlqedRyh+RSSCf2CXKMC4dMKqKFNunC+ym9/XcogynKRIHGnZgCQlS7RbK8tpV13qDRp7E2c8d2lrR3D1/6rdC+JEJNO6E0dz4Qn9lzCXVdV/IX+bgU12zZEc9QJ+VreFTmfxFsHE6QFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862377; c=relaxed/simple;
	bh=G1NXNE54um8S9m4IxmjpiOp7QNQciI4wOKBQauXNzDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/3+QlU2L9RlhB+9KoT2YY0ozjHMglDLwEYftn/+AoJ4qVcooZ8LtiBXbtyJbLOv6SRqy8B0MAOtS54b5yZcapyvBv/+kesIpZSotZFE3npff12nvX0JStKR8qIpxGR/AAwEIQ/cVEvvlWjU09U0RkTCDte9uxnLrxx6dZ25ye0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pe8+8S/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pe8+8S/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679FEC2BCB3;
	Fri, 15 May 2026 16:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862377;
	bh=G1NXNE54um8S9m4IxmjpiOp7QNQciI4wOKBQauXNzDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pe8+8S/jpkv3Wht1zu53ve/JUnsmURrjy/mdal5+6S3cegBy/qES2bemRfNfuGd4z
	 Eb2LlONhNFY8wZb+dK8j7sJ5Je1Rwsc5vIGDHzrTOV38g4PwrfBJf4zW4qLJ7NbaD/
	 Q/qJQcfC1qI6nSk+FwR994E8dF2T2Fxu3ozF2TD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH 7.0 025/201] arm64: dts: freescale: imx95-toradex-smarc: fix PMIC_SD2_VSEL label position
Date: Fri, 15 May 2026 17:47:23 +0200
Message-ID: <20260515154659.079009185@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

commit 0c9d379d436e119285ef39a4f96b012f576ed74c upstream.

Fix the PMIC_SD2_VSEL gpio-line-name position. It should be on line 19
of gpio3, not line 20.

Fixes: 90bbe88e0ea6 ("arm64: dts: freescale: add Toradex SMARC iMX95")
Cc: stable@vger.kernel.org
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi b/arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi
index 5932ba238a8a..f64c05dc50f8 100644
--- a/arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi
@@ -262,7 +262,6 @@ &gpio3 {
 			  "",
 			  "",
 			  "",
-			  "",
 			  "PMIC_SD2_VSEL";
 	status = "okay";
 };
-- 
2.54.0



