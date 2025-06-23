Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DF770838;
	Mon, 23 Jun 2025 21:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713049; cv=none; b=HrlpqKb5eLA+qJTQ7cQRc3mcf3EcG26Co9OmHIs7H4BF0MR0TYY2Z3GsxdErMdQF6CVmHRgyePpMIaWB0BzthyMiXLZYfx6BQBeFhidknAn0+CVwRn1fq77PoD/bK7D9lUrC+lnzO/eyluxvYxIeCtsJVhc3FYAtwHSDQOsCpZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713049; c=relaxed/simple;
	bh=q3ns3jUbXdK0A4C7HhxqsultUQi4PBOxRBRuShKu4dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dege6J54Pb+IrcMIBs048Y757OzGK06M2hvw774+m5/SyI9lmaq1paqXrlNAi/P9ce6o6lSR8v6liN0YS2LBziAIk5LnWzymxrptB+VPnAZ77fzGKiLV+Dtq/WnrK18VBq4PbutDqC37NrGaqn1Us38DXB8CHtZsicda6jOlHs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNqEXCVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNqEXCVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00992C4CEEA;
	Mon, 23 Jun 2025 21:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713049;
	bh=q3ns3jUbXdK0A4C7HhxqsultUQi4PBOxRBRuShKu4dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNqEXCVV7H99korVsC7yYQD36HVuZvt76E7YEmiX/nSssDsmc1rygFF9BCUiu/ZTk
	 EJ4zoQHYtEDOcF7O5I78ISth6A+4ZD+2A5dkBpvIYzYgWe0mA7yvfSzRmNeIC8SsOa
	 C4i31TpY14wQyscyUQlhG+yYq63D/JGtDxKi0z6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 043/414] media: imx335: Use correct register width for HNUM
Date: Mon, 23 Jun 2025 15:03:00 +0200
Message-ID: <20250623130643.113703518@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umang Jain <umang.jain@ideasonboard.com>

commit b122c9cfcb39c8ef520d50eddfbe15f3e6551a50 upstream.

CCI_REG_HNUM should be using CCI_REG16_LE() instead of CCI_REG8()
as HNUM spans from 0x302e[0:7] to 0x302f[0:3].

Signed-off-by: Umang Jain <umang.jain@ideasonboard.com>
Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Fixes: 8f0926dba799 ("media: imx335: Use V4L2 CCI for accessing sensor registers")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx335.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx335.c b/drivers/media/i2c/imx335.c
index 0beb80b8c458..d400a019f6b3 100644
--- a/drivers/media/i2c/imx335.c
+++ b/drivers/media/i2c/imx335.c
@@ -31,7 +31,7 @@
 #define IMX335_REG_CPWAIT_TIME		CCI_REG8(0x300d)
 #define IMX335_REG_WINMODE		CCI_REG8(0x3018)
 #define IMX335_REG_HTRIMMING_START	CCI_REG16_LE(0x302c)
-#define IMX335_REG_HNUM			CCI_REG8(0x302e)
+#define IMX335_REG_HNUM			CCI_REG16_LE(0x302e)
 
 /* Lines per frame */
 #define IMX335_REG_VMAX			CCI_REG24_LE(0x3030)
-- 
2.50.0



