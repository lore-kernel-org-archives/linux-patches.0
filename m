Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE7947DD54;
	Thu, 20 Aug 2026 16:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244420; cv=none; b=CUWvMJ3nwVxEdctyLaYN4NWzcmlpls7kLNfVnJqMAT/yEP1vN0GogFhf05D2tN68Bt8U+BCntT+szdsBrU8pDUpRGynjODD0skBwDLRrUYvCwEN1krOwZrFjnp23w+6ZXj4tEA7CL+3fIl1a6aQmYm12s/yO5ytU8ySDQJSP4qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244420; c=relaxed/simple;
	bh=+OT5sq4uFJTS3gnvOWn6s805z0Eq0aoJ5QE0ahp5Qt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzIeAVIV8RtkJnD3mIvmtcKF4eS8Y1IdaauCyFmq+dEbnI/MwDs8EIUu2GIp6K9yY0LpCeJOkkfYsd+4KRQUGiWq59/Day+WFsS/sjRUqV6pFC2kcz+Qy7xUFFKcRPFnY4mKoKSiGPSGUjvwEvSiipef/z9u8txMceBbXKlbIB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RC2LZEsr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RC2LZEsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429CF1F000E9;
	Thu, 20 Aug 2026 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244418;
	bh=iyfSRfiB4XH/InScS0Bp95I+gVTYlKkwAzzvfd+wet0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RC2LZEsr+WoSt1IMtCzL4ENVFJtRBaaxuCefbAvKAgRhoztBbLEI13BJAvZZHgwy9
	 8DFxlTs/Xr7pzw8DGvsocjnViySzZw+yrzN318C7pgDPCpRjVb1FgdQU/U1jMEfegR
	 W6G6ogV2orQBDuAUzUnB4yj/tx4DCucBoA97huZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 162/235] media: imx219: Fix maximum frame length in lines
Date: Thu, 20 Aug 2026 16:56:38 +0200
Message-ID: <20260820145221.398905012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 2c4f1ba7354312ad2d6e34e70a518a51a9344715 ]

The driver used the maximum frame length in lines value of 0xffff, but the
maximum appears to be 0xfffe instead. Fix it.

Fixes: 1283b3b8f82b ("media: i2c: Add driver for Sony IMX219 sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -73,7 +73,7 @@
 
 /* V_TIMING internal */
 #define IMX219_REG_FRM_LENGTH_A		0x0160
-#define IMX219_FLL_MAX			0xffff
+#define IMX219_FLL_MAX			0xfffe
 #define IMX219_VBLANK_MIN		32
 
 #define IMX219_REG_ORIENTATION		0x0172


