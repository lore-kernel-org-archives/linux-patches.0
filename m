Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AB4226529;
	Thu, 12 Dec 2024 16:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020529; cv=none; b=E/yua1hRrCuBMicXZJvQ+/Bh/BMrP0VLw9n9I2UQESCOwLA08y54ceqWQB4PtsOrftSmm+SxGXDeKqwiziM0Pd61S0pAWZH8APVE1kIwjXgS30s5NvDdvxKeTxS+EgudfRowxn5PbSFj5MxEm+OmIYGv+3Tx2LoKDeLWMLDUjqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020529; c=relaxed/simple;
	bh=MUvijHd+/CF0kifBpgfUeFTz8rIfmCLJS455+RSV7jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJ/+wMPRmo49r7qL6eIJk8rEbfbrMXstr00ECzNGkOs3GYKbch/whTf6iqXT8lzqCGHbKWApGqqIlrgCLkcbPhWlp/b9rKKYjJs+kZm6polfWn7UHO8J59QGDR05NdcK7EnCS5sKNbv4/lZBi9Ax/78nx7cYycpey1AjiMBQgOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVurO18d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVurO18d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5894EC4CECE;
	Thu, 12 Dec 2024 16:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020528;
	bh=MUvijHd+/CF0kifBpgfUeFTz8rIfmCLJS455+RSV7jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVurO18dGVtUyBX0gWifndsH7QuqDXgXzNe/5KbdJk3MTjRaGrZpIn4nmmxMyLets
	 ncLNd0PWwonB039wKCtUN7F80srv9zWoA7fHJuB1mzPRL89fpNV04qQfqJsDPACJmp
	 92FGe4px0yyU0yCqBHMaa6Qc464z2+RQtGnH+K48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.1 460/772] arm64: dts: freescale: imx8mp-verdin: Fix SD regulator startup delay
Date: Thu, 12 Dec 2024 15:56:45 +0100
Message-ID: <20241212144408.935165146@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 6c5789c9d2c06968532243daa235f6ff809ad71e upstream.

The power switch used to power the SD card interface might have
more than 2ms turn-on time, increase the startup delay to 20ms to
prevent failures.

Fixes: a39ed23bdf6e ("arm64: dts: freescale: add initial support for verdin imx8m plus")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
@@ -133,7 +133,7 @@
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
 		regulator-name = "+V3.3_SD";
-		startup-delay-us = <2000>;
+		startup-delay-us = <20000>;
 	};
 
 	reserved-memory {


