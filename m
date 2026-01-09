Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD3E33C511;
	Fri,  9 Jan 2026 11:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959632; cv=none; b=iXiSvn8d4Sl7cL8u0HAnUYTwgjZQp5Gqxvp7VmMrpa5ApTrqXXHTnRW8xrPkPTDfy6z1pSvJdX0JxeP6q9/EKxQUtsnqynC+JBiPaWcd1MGLZm2ajUQppsa4xrwQd5M3H/mOj3H0gRhlwskhyg9tYe6rPLPelKSPJVTTf3AkWs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959632; c=relaxed/simple;
	bh=sCCzCLaXrtWiz9T7gxyp2bDk1ElPiC3xdDU4385GryU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibYaAi8vxaVgIqzGk2kbTu7vl/b28lwfqIT/r54Q/sDUEDIUiQhOtpr3MFeoxU8l+Sm2zqGTwuQpmJyJYep/hlRMfFc7Ve/+AX0XRS/SgNYSSOWUMfo7edNsMyIAZ+jSYo6XWwDMVtYba7NLZQLe0P9CDcGdrwllrJpPDa5Htrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dz59T1FD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dz59T1FD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63262C4CEF1;
	Fri,  9 Jan 2026 11:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959632;
	bh=sCCzCLaXrtWiz9T7gxyp2bDk1ElPiC3xdDU4385GryU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dz59T1FDSIHiPX0U2ZgwNItZGIykH+TwojkieDR57s1lrirPkpwD6RA/+0HdlyHGg
	 1w8KSH3mKImMe8mcorS7updeYYiEBkzJhWOWNTmeRCE9ojE+h/kMtykJBqCYZeTpAl
	 H8CMNgLZ0FfNMzuuetjpOaameKcHN1zwLhxVnp6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/737] ARM: dts: omap3: beagle-xm: Correct obsolete TWL4030 power compatible
Date: Fri,  9 Jan 2026 12:34:20 +0100
Message-ID: <20260109112138.556149007@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit f7f3bc18300a230e0f1bfb17fc8889435c1e47f5 ]

The "ti,twl4030-power-beagleboard-xm" compatible string is obsolete and
is not supported by any in-kernel driver. Currently, the kernel falls
back to the second entry, "ti,twl4030-power-idle-osc-off", to bind a
driver to this node.

Make this fallback explicit by removing the obsolete board-specific
compatible. This preserves the existing functionality while making the
DTS compliant with the new, stricter 'ti,twl.yaml' binding.

Fixes: 9188883fd66e9 ("ARM: dts: Enable twl4030 off-idle configuration for selected omaps")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Link: https://lore.kernel.org/r/20250914192516.164629-3-jihed.chaibi.dev@gmail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/omap3-beagle-xm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ti/omap/omap3-beagle-xm.dts b/arch/arm/boot/dts/ti/omap/omap3-beagle-xm.dts
index 08ee0f8ea68fd..71b39a923d37c 100644
--- a/arch/arm/boot/dts/ti/omap/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/ti/omap/omap3-beagle-xm.dts
@@ -291,7 +291,7 @@ codec {
 		};
 
 		twl_power: power {
-			compatible = "ti,twl4030-power-beagleboard-xm", "ti,twl4030-power-idle-osc-off";
+			compatible = "ti,twl4030-power-idle-osc-off";
 			ti,use_poweroff;
 		};
 	};
-- 
2.51.0



