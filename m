Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475893BBFB3;
	Sat, 17 Oct 2026 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255364; cv=none; b=qLIQ5y0A3y0qdxRCUf7vDdr/t/7Xh7mUeCZtI8Ci1uUSgXnjiCwcJztNa1fRnjQeQwQO0PwF2Gp6qoTqglVH/tfhNWHcTuCTiCPK4e6rYcs5qU1R4eR1OvQQekGMTCw1tterQ4xHF/N/x8wAuyCf0YLdqTzu0KcbLJBwcQxCQGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255364; c=relaxed/simple;
	bh=1coU+2nP0aI1smj2z0FLU5LQD1ZFss3DtN67GOgFzP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LOAjymJZwlC1RDRWN1MQZvactnyzCC5ZyYc/l73g9y3NXca/e7v2f71u2VlHZw2Xj0Cib+twhduuVNKUiD+UOnqFb1aLXPd8+0p3Sqygz97ddGhNAN4y4jh5K8WsfkcocqgeEVL2mZn47fKF4OxKJwtv5+SQi4uu/ODCojZv8ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xShUBUjY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xShUBUjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940751F000C5;
	Sat, 17 Oct 2026 16:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255363;
	bh=Z8VVSwCzoqoipvIW9ur8eOBS8D6rbuhqe2SbJFm50lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xShUBUjYPH5yTKOhrVFMH8jrAuc2ehvDrVAzNl+LfG09hz0P/5DzNJCK1D4yxE6Ab
	 BJ2O0mXAU1gGP/r+BOZWnBjEsZ2uCG+uMYZW9x1n7s8D2KxvaJqsvQQLbRLQT+oPfa
	 2zmVuXTZCyQCrWXRWHw/Zw8aOFIF0vqRONFlB0u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 708/869] platform/x86: dell-wmi-base: Fix handling of ultra performance key
Date: Sat, 17 Oct 2026 17:59:09 +0200
Message-ID: <20261017160055.114996672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit adfd6846bea13667ff28f8aaf00c32fbd69825ab ]

The commit message of commit 5fbd827eb9c2 ("platform/x86: dell-wmi: Recognise or support new switches")
states that the ultra performance key contains additional data
after the type and code fields. The event data passed to
dell_wmi_process_key() is already parsed, so "buffer" already
starts after those two fields.

Use the correct index for accessing the first data field to avoid
a potential buffer overread.

Fixes: 5fbd827eb9c2 ("platform/x86: dell-wmi: Recognise or support new switches")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260612173451.467629-4-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-base.c b/drivers/platform/x86/dell/dell-wmi-base.c
index 713ec2c12a04e..4838992ee5f99 100644
--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -442,7 +442,7 @@ static int dell_wmi_process_key(struct wmi_device *wdev, int type, int code, u16
 				      SW_TABLET_MODE, !buffer[0]);
 		return 1;
 	} else if (type == 0x0012 && code == 0x000d && remaining > 0) {
-		value = (buffer[2] == 2);
+		value = (buffer[0] == 2);
 		used = 1;
 	}
 
-- 
2.53.0



