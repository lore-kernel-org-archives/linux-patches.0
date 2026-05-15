Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E58717C220;
	Fri, 15 May 2026 15:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860451; cv=none; b=fgRWiZiEh72nQPs+/UFUKnfK0XrYwtYb63JJTK3z52EXz5jUrS3KLuDr5cFmC6mSfyHeFlXOSEuRQPbRmBTUlb701x9VFBvTTB/PMEFaHjH9vSpoKwb8CfQrsbhnZI/dznbUDGO2F0WYH6LbX7e9lR4K+0iCDe54xHxh7jwx+z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860451; c=relaxed/simple;
	bh=n0rtYuX9pxLJr4a7wUPeGPOr13tAOScFgG86z71ThAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etQRS3pjKGZp6By6kIs7ebZmktTVVE5KRLeUoHLpM74wlrpb0adj5m87j82QodIpfaviVrPcS3PsyUM6Kq+WUGp9HnjCWume3BaxPfgJmgZAhjH+95gvZxmioH+/W6bhcODoVRUvHuZLBiLk0bqTmnCqUQ2Onq44oRugl6Cd/4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=viNxYIkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="viNxYIkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C5BC2BCB3;
	Fri, 15 May 2026 15:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860451;
	bh=n0rtYuX9pxLJr4a7wUPeGPOr13tAOScFgG86z71ThAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=viNxYIkhelScvxd5tAQTHWtxBM9cLCLiKQJepP+FnWjjPlLifAl0DjB25+Xu4fFQJ
	 FdXihmQW/fUTZr/VSuYZt0fNuPbGalz/21XVNbFB5nbrrJO2TTv5R7j9/6324zchwG
	 oxOWTmNmF0fEi7aOujpLHfwfxBOkYQN+HBWW28U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Andrew Davis <afd@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.12 093/144] arm64: dts: ti: k3-am62a7-sk: Fix pin name in comment from M19 to N22
Date: Fri, 15 May 2026 17:48:39 +0200
Message-ID: <20260515154655.667816662@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 6ee0792d83d5c690205c350825a4c30746c0e0a2 upstream.

The pin for GPMC0_CLK.GPIO0_31 at address 0x000F407C is N22 and not M19.
Hence, fix the pin name in the comment to avoid confusion.

Fixes: 8f023012eb4a ("arm64: dts: ti: k3-am62a: Enable UHS mode support for SD cards")
Cc: stable@vger.kernel.org
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Andrew Davis <afd@ti.com>
Reviewed-by: Bryan Brattlof <bb@ti.com>
Link: https://patch.msgid.link/20260309045539.2070793-1-s-vadapalli@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -369,7 +369,7 @@
 
 	vddshv_sdio_pins_default: vddshv-sdio-default-pins {
 		pinctrl-single,pins = <
-			AM62AX_IOPAD(0x07c, PIN_OUTPUT, 7) /* (M19) GPMC0_CLK.GPIO0_31 */
+			AM62AX_IOPAD(0x07c, PIN_OUTPUT, 7) /* (N22) GPMC0_CLK.GPIO0_31 */
 		>;
 	};
 };


