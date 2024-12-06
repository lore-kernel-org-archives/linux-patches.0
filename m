Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0E61494D9;
	Fri,  6 Dec 2024 14:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496088; cv=none; b=TMfC9XHPwOEQgBJ3gWQrSsG3F8mqaDhsmUSgM3hZp5kBn86axQdB29T1EQ0rI1AF9apEH0NUjzrZ36zcMNLcSDqQLjYWdQhAntWxZ3e62gzAG4nDLckOipCMe9fZ8p/XU4IbEzwTnLJWW63qDPhXOvXUrYs2npZf0GkJsIDKxcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496088; c=relaxed/simple;
	bh=O7xKYLrJ7X4WSnWtaDm7d/eYg13G4DJn8B/tXPi5bQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kee910TrtT4OR6znCXUm6Ma+/OIZSnrU4VZguqLGivs8z2IdB+kQ9TqMMH/lp2fs7BM04PJmJNv3JVvLn0L3MdK8gkI1VfJUyrfkMl/AFbjlnmN1ODz8u+TUopf9jTdyO/aMAwysTig+ToWwQY3+zNbfGMlhLjzDL3gkTgvnCkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJ3Ck+Vz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJ3Ck+Vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FA3C4CED1;
	Fri,  6 Dec 2024 14:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496087;
	bh=O7xKYLrJ7X4WSnWtaDm7d/eYg13G4DJn8B/tXPi5bQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJ3Ck+VzAAgtvB+l6NQtnUHC6PQCrADMi9wxTwEPrGmbBI0qfTzMtOeruFOBw8yE5
	 rLlhP/1rdQ35sMrHoBkU00/ewFQH40S5fmFOkSElP7cbgg2hzSlUaxMudod1/pSZL0
	 YZ0dPrssEd1mPNK5SAKT6HVbDGpleycOF6tNUeVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 016/146] arm64: dts: freescale: imx8mm-verdin: Fix SD regulator startup delay
Date: Fri,  6 Dec 2024 15:35:47 +0100
Message-ID: <20241206143528.293698544@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 0ca7699c376743b633b6419a42888dba386d5351 upstream.

The power switch used to power the SD card interface might have
more than 2ms turn-on time, increase the startup delay to 20ms to
prevent failures.

Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -162,7 +162,7 @@
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
 		regulator-name = "+V3.3_SD";
-		startup-delay-us = <2000>;
+		startup-delay-us = <20000>;
 	};
 
 	reserved-memory {


