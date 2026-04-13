Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE852BDC2F;
	Mon, 13 Apr 2026 16:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096493; cv=none; b=VOnzA0D/eP7J+nlUWzUZBEwThnio1tjBWw7i7ElaPaEIjw37Zef1x4U+IcV/m9apobxcdWCCIsv2M3QYknX+pjlHll7dIuQ5tuMXgiY85zlODFmJkiZtuVisvNqAoV/eFNKnl8vt+4ci3cDSOiGILO7CjyIl7KRp4IBiWWfsxQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096493; c=relaxed/simple;
	bh=2g9zzKiU8cxKuea3E8KqtReZT1VEMHBwcUe+O74lhtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iZeqVtxAqydwWqff3zNl/e9rWM910VM0DjaBhBmIyeyGO2D6VSYhSdfD6cMSy4ZVi7UZTlCIIEgqGubt6PsrV0UUaCSpvrNly1TlYs8oeo7e6vgCluXcRyTasAL/N+sUB6BF2QNIDAa0i3Qi7Xc2i8pYpCOE1FsKs53FMHr0awQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvthxEXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvthxEXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FD5C2BCAF;
	Mon, 13 Apr 2026 16:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096493;
	bh=2g9zzKiU8cxKuea3E8KqtReZT1VEMHBwcUe+O74lhtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvthxEXPt+nIeelcx12qf469XqO77y+HK8S6nTiUkSUAPgIRq8HIQ42/3jLh418vX
	 4vG0wkeiegirwQmbStYZylMIxFBBHOcnZLZM+ym3muuXqsSZrkMhNT5qKGgjl9WsbZ
	 fYrQGFirX1MuJ5361RTVa6u1/Sw46vu27MuR1Z0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.18 32/83] arm64: dts: imx8mq-librem5: Bump BUCK1 suspend voltage up to 0.85V
Date: Mon, 13 Apr 2026 18:00:00 +0200
Message-ID: <20260413155732.221669224@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -846,7 +846,7 @@
 				regulator-ramp-delay = <1250>;
 				rohm,dvs-run-voltage = <900000>;
 				rohm,dvs-idle-voltage = <850000>;
-				rohm,dvs-suspend-voltage = <810000>;
+				rohm,dvs-suspend-voltage = <850000>;
 				regulator-always-on;
 			};
 


