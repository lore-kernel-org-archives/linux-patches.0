Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23D9149E0E;
	Fri,  6 Dec 2024 14:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496000; cv=none; b=QZVhFcnz94pgWKNJpdOuSFyjvooXK7dpsxLH7TqXb8k6EGXDD4zRPg7foiyz2rVsA4bsYBZ5jpOTaSI0kPpkMTJMara4gYKyLx/+fjFqE34CWh1spcqyWehkrMv6ZP3yOsaMfG9TeFO7kdlYy4XBB4bddhcKMwlQ63MDjUtO8HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496000; c=relaxed/simple;
	bh=RIxu0lIE+dRAtv14Gkz/qEd0c6UCKp5+HIBZQVg6jX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvQIBeYjyyiwqVBqIFgNlg6xN/nrMsO7jLWMAldbJlzi7/C3ejQg+ViK55XdDZr1+D0iB46oU+ysLPmX1gQwiyyL7RNq733XEvlY1l33/ZINWqUAw7LGCw5gdRTclN+oNfoWVlWsenD56D+Tz9VowlUG3QyMIdwDDgSJk7ebSJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X38jmwES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X38jmwES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3EBC4CEDE;
	Fri,  6 Dec 2024 14:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496000;
	bh=RIxu0lIE+dRAtv14Gkz/qEd0c6UCKp5+HIBZQVg6jX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X38jmwESwjbRSJKxJ5cdYxW9mmFMKTxf86patvnrSev+8AkIETXqN8a7yQc6oGiUB
	 ElwYK0d/OXm2uk8XuvUVE9wC5RVzDwOCjakaVf6f2V9f8eEjE8C7UM48Dpzm3GPGfT
	 dEOlusOEbE+zfebggQA2XdXXvkrprGCIyb5Pil0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 024/146] arm64: dts: freescale: imx8mp-verdin: Fix SD regulator startup delay
Date: Fri,  6 Dec 2024 15:35:55 +0100
Message-ID: <20241206143528.598397708@linuxfoundation.org>
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
@@ -175,7 +175,7 @@
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
 		regulator-name = "+V3.3_SD";
-		startup-delay-us = <2000>;
+		startup-delay-us = <20000>;
 	};
 
 	reserved-memory {


