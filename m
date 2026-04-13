Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2002B26CE32;
	Mon, 13 Apr 2026 16:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096875; cv=none; b=AyYX5CSTyMg9S1a6JegLrZuS6GgwwByZZBrWaPrRYPvQYcoZte1T0wVCR+NRDAtxcvlLOpai6zbGem3u981l1eGUz4eqNYV+GdqKjWknDX2nOZ/suTDvKgAPoP5KDua7TfogvVJW+byoHPYwcX9WjxU3bEDU1Yg96y9KOWy7F00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096875; c=relaxed/simple;
	bh=YBIJhLcV8ztcSR8xbulhg4w5HY3kwhYra/UyWGPsnvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dO0Qn2SuOy81wkTB9GQy7l2swohz6iqtenIJCeoH4z850u3EJoACXIWYeFrXp+ahZiVM4mMv71nLSxMoUmanPkoDjCYcXUiDEk1n/VjBjp9XFvc1JXwUOj0fhe+zVzYak95O10u6dhiWDIENOyyZtWbZV/8ZjzG4t9RThkd8pFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+6gjqxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+6gjqxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A367EC2BCAF;
	Mon, 13 Apr 2026 16:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096875;
	bh=YBIJhLcV8ztcSR8xbulhg4w5HY3kwhYra/UyWGPsnvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+6gjqxZYbB9iZVsDdbbwTJraCAygk4Q3zW2Drup7+kMkIkpMqJ44yz5BCqPSGP4P
	 NoHCgeHEesmiiXXGLP3zFM6WDwEvwOIjG8f79yECzIqGjv3zwvB0CbrT3CthnEWi0Z
	 VVHdSnnfFy6DLOLr4jUntkSrQ3cQLxOE9eh6cr30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.6 25/50] arm64: dts: imx8mq-librem5: Bump BUCK1 suspend voltage up to 0.85V
Date: Mon, 13 Apr 2026 18:00:52 +0200
Message-ID: <20260413155725.453378229@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

commit 511f76bf1dce5acf8907b65a7d1bc8f7e7c0d637 upstream.

The minimal voltage of VDD_SOC sourced from BUCK1 is 0.81V, which
is the currently set value. However, BD71837 only guarantees accuracy
of ±0.01V, and this still doesn't factor other reasons for actual
voltage to slightly drop in, resulting in the possibility of running
out of the operational range.

Bump the voltage up to 0.85V, which should give enough headroom.

Cc: stable@vger.kernel.org
Fixes: 8f0216b006e5 ("arm64: dts: Add a device tree for the Librem 5 phone")
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
@@ -849,7 +849,7 @@
 				regulator-ramp-delay = <1250>;
 				rohm,dvs-run-voltage = <900000>;
 				rohm,dvs-idle-voltage = <850000>;
-				rohm,dvs-suspend-voltage = <810000>;
+				rohm,dvs-suspend-voltage = <850000>;
 				regulator-always-on;
 			};
 


