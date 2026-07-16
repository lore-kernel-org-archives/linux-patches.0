Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96F942A7A4;
	Thu, 16 Jul 2026 13:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209741; cv=none; b=uAPwb0R/c2sfiZXDMrQq7yhLR7f3OegbhSfjQaeNrYvcaeemj91mbvbqtEEiSj8cQCMv1fjbBt2kG5REuiFzHEWrMqRLrFZWlENiB3JcqbVbZXZqMShTwWiGCISE6bjgkGYIpDChDPGO8T6BoDrs93dGrIe6IMAshFksswwq7s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209741; c=relaxed/simple;
	bh=nlr1YB8YCz84FieOFzF/o6EouMQdN7aADsTlXhDOXdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RccCmvfN1unHv6GkhwDnTcmopb14HY3jhQaaG+4EWcPBOzl2NworWDJ1jBU73ajMlkBF5+d7Vr18AuYY6a9Yzg8cPeovEF97DBXGRZrohKdcUJM6rrkv1EKyvInK22S2lpEvshe0bj2Yfk3NXhzZ0TeaKoSrb8j7DSUCuENJ4OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=he1cTQ01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="he1cTQ01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABE21F000E9;
	Thu, 16 Jul 2026 13:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209736;
	bh=tNP2+/mAJeTBvaa4LgLYX7OPDOi6GYu2pLa1j1MUsBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=he1cTQ01zpJs+EoLbcvRUJQimGV7Oq8jEcrliapUMV/zXa0i6N7u0MNePVAAoZTyn
	 4KtgX5u0IqEJ7lTaC6cjpzdYF8YEzpwTJLqjM7MGLMypjl1ppMHY1w21FGaLidBX+s
	 aZhnWxHX2ZRtY4q31sv8xbzrceZCvCr/BaqNga00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.1 297/518] Revert "usb: typec: mux: avoid duplicated mux switches"
Date: Thu, 16 Jul 2026 15:29:25 +0200
Message-ID: <20260716133054.316518098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Glathe <jens.glathe@oldschoolsolutions.biz>

commit f576c75f95a52c71b30167d7efb6d47148f9c279 upstream.

This reverts commit b145c3f29d62f71cc9d2d714e2d4ae4c8d3f863d.

The deduplication logic appears to cause issues with separate
SBU muxes. The mode-switch call on these (like gpio-sbu-mux)
never appeared, so no successful mode-switch happened. The more
high-end Parade PS883X redrivers are not affected due to being
retimer-switch. The revert fixes dp altmode mode-switch for both.

Tested on:
  Lenovo Thinkbook 16 G7 QOY
  Lenovo Ideapad 5 2in1 14Q8X9
  Microsoft Windows Dev Kit 2023 (Blackrock)
  Lenovo Thinkpad T14s G6

Fixes: b145c3f29d62 ("usb: typec: mux: avoid duplicated mux switches")
Cc: stable <stable@kernel.org>
Signed-off-by: Jens Glathe <jens.glathe@oldschoolsolutions.biz>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260530-typc-mux-modeset-v1-1-64b0281e2cd6@oldschoolsolutions.biz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/usb/typec/mux.c b/drivers/usb/typec/mux.c
index db5e4a4c0a99..9b908c46bd7d 100644
--- a/drivers/usb/typec/mux.c
+++ b/drivers/usb/typec/mux.c
@@ -275,9 +275,7 @@ static int mux_fwnode_match(struct device *dev, const void *fwnode)
 static void *typec_mux_match(const struct fwnode_handle *fwnode,
 			     const char *id, void *data)
 {
-	struct typec_mux_dev **mux_devs = data;
 	struct device *dev;
-	int i;
 
 	/*
 	 * Device graph (OF graph) does not give any means to identify the
@@ -293,14 +291,6 @@ static void *typec_mux_match(const struct fwnode_handle *fwnode,
 	dev = class_find_device(&typec_mux_class, NULL, fwnode,
 				mux_fwnode_match);
 
-	/* Skip duplicates */
-	for (i = 0; i < TYPEC_MUX_MAX_DEVS; i++)
-		if (to_typec_mux_dev(dev) == mux_devs[i]) {
-			put_device(dev);
-			return NULL;
-		}
-
-
 	return dev ? to_typec_mux_dev(dev) : ERR_PTR(-EPROBE_DEFER);
 }
 
@@ -326,8 +316,7 @@ struct typec_mux *fwnode_typec_mux_get(struct fwnode_handle *fwnode)
 		return ERR_PTR(-ENOMEM);
 
 	count = fwnode_connection_find_matches(fwnode, "mode-switch",
-					       (void **)mux_devs,
-					       typec_mux_match,
+					       NULL, typec_mux_match,
 					       (void **)mux_devs,
 					       ARRAY_SIZE(mux_devs));
 	if (count <= 0) {
-- 
2.55.0



