Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339981DD0C7;
	Mon, 23 Jun 2025 21:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715443; cv=none; b=OnltKU1CduoFa9G0lEdVRCRmeTMjLxTXvFB37ZEVPuiEmABupsBsC1swtzhIKjrZjYyeF2uJBt4mosnV2GLBanFSXZ3HZEiyetMwZn22Fp2fCk+b1wdWKF0uasKl2oAkXToihlMfx14MDiApCHXYQv32fn7G+CIe/zQm1S1pHYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715443; c=relaxed/simple;
	bh=z905HTBBL1w+zHtyyciTn4QgcN3oQtq9t3cndga6S3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUgqoYyZ2iqLLvBRx+eaDiBlekrc4Vz+YB355ZQBRb6YTcq444QG2xJJSmc1AtRy0ddobWWMZP6hd5f29lPLOIgQ+AynfU3Bzz13M+5y8YfXnbtM56cSmjEB07++8UXtPb6b6DcqCXVA0PJqxIOVL8A4sGqsSF8iheh1x4rY5WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxJ+RbgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxJ+RbgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF5CC4CEEA;
	Mon, 23 Jun 2025 21:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715443;
	bh=z905HTBBL1w+zHtyyciTn4QgcN3oQtq9t3cndga6S3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxJ+RbgEQIBs8XklGYMJkaQkyEAS+M5qRytNylzeV5P5Acv/Fnd3cbWLYXznP1kFm
	 1e2WA3TJF11bcCm+utNeFNG4WxLBQXisGysYyBk98nwkDhRoz4jCoieGAZsxHfEEks
	 +xA39s0uUuqqkSVXYCKlkZZjqrzabOxkPmdrtD0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurentiu Tudor <laurentiu.tudor@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 275/355] bus: fsl-mc: increase MC_CMD_COMPLETION_TIMEOUT_MS value
Date: Mon, 23 Jun 2025 15:07:56 +0200
Message-ID: <20250623130635.040981733@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

[ Upstream commit 23d060136841c58c2f9ee8c08ad945d1879ead4b ]

In case the MC firmware runs in debug mode with extensive prints pushed
to the console, the current timeout of 500ms is not enough.
Increase the timeout value so that we don't have any chance of wrongly
assuming that the firmware is not responding when it's just taking more
time.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20250408105814.2837951-7-ioana.ciornei@nxp.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/mc-sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/fsl-mc/mc-sys.c b/drivers/bus/fsl-mc/mc-sys.c
index 85a0225db522a..14d77dc618cc1 100644
--- a/drivers/bus/fsl-mc/mc-sys.c
+++ b/drivers/bus/fsl-mc/mc-sys.c
@@ -19,7 +19,7 @@
 /**
  * Timeout in milliseconds to wait for the completion of an MC command
  */
-#define MC_CMD_COMPLETION_TIMEOUT_MS	500
+#define MC_CMD_COMPLETION_TIMEOUT_MS	15000
 
 /*
  * usleep_range() min and max values used to throttle down polling
-- 
2.39.5



