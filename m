Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CA413C90B;
	Tue, 25 Jun 2024 10:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309730; cv=none; b=Y79HC9b4Utc381sStakkWvupGRbO4nVBKD8MbIN7AHQdKpMbhUkEoeFBsKl9IhM2Nzsd+TM5YXjCOmVJYkJSm7FT+q8Y1B8/utGEnaFpHQC8wpb1ksy4I0Kp6uzomArJ4ldFBqF25+Ms8iTeX/FdqytoJcqSgjRyHrT0fdDqh6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309730; c=relaxed/simple;
	bh=QJXChfeTSsSEPSCnRjdpi79SqKOUoGDpc6Syqtg0RO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVpybPdYMZ6L/AVMiFw1FPaK3ektpKaDhwWDeqgMOCmpeoBtTFUdUJCctfF1ncuSCHR3OaHkQM5/Q5/bNXFfWRwD6iyw3zo7ukZJeaIjt9OnbsUPKXT86b/Zrl1Sdr3V8B9DxycTf+0bEhQMPZESl3Z12PuTNWdPhqDyKeuqe84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfs/4Vfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfs/4Vfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE832C32781;
	Tue, 25 Jun 2024 10:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309730;
	bh=QJXChfeTSsSEPSCnRjdpi79SqKOUoGDpc6Syqtg0RO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfs/4Vfd051KMFMGriX+oAVUjdntQRBZuFM/ieRyYkn6bhbJZouJHxg/9/8zXGIKu
	 JmK26PlERyTv6/z1UljgXNVojbp2ZvD5WcIg2owmF4RVi22CM3Amy22cW+4b0yaZ1b
	 FqS4B7WU5qd8Aiggq8QlqMvk5jmr4OEPa9zh6fcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.1 115/131] arm64: dts: imx8qm-mek: fix gpio number for reg_usdhc2_vmmc
Date: Tue, 25 Jun 2024 11:34:30 +0200
Message-ID: <20240625085530.307528720@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit dfd239a039b3581ca25f932e66b6e2c2bf77c798 upstream.

The gpio in "reg_usdhc2_vmmc" should be 7 instead of 19.

Cc: stable@vger.kernel.org
Fixes: 307fd14d4b14 ("arm64: dts: imx: add imx8qm mek support")
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -32,7 +32,7 @@
 		regulator-name = "SD1_SPWR";
 		regulator-min-microvolt = <3000000>;
 		regulator-max-microvolt = <3000000>;
-		gpio = <&lsio_gpio4 19 GPIO_ACTIVE_HIGH>;
+		gpio = <&lsio_gpio4 7 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 	};
 };


