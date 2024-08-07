Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6876B374CC;
	Wed,  7 Aug 2024 15:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043666; cv=none; b=PgxZL8QDAZVG7UPpMwAkbpo/QS4PamierBwgjuOoWD5lvWdCYCnP59J3zUYsZ+xu9Bme48XXfh9xjl2WHe6ECZzktk3i1Gqrsb4BkANrHB561C2ECdhGp4ZadyA/Feze9U+CxlnRULgqadm759uY/jhCUurXlhVjkjvnnkv/1gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043666; c=relaxed/simple;
	bh=PW5wO4VGH2iIjnaBdEIpNBk6mJ1z+vajlFevrWCrAvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jp8G16BWLasy0W4nKCaZ31xwg7mBfabq32iPP637XMJYpUTvTlP1k7Kt4TGSLM63L4WOVwacPSVrXm2EhAtmHig1nCO/16wFdwMXhFYpRv3UuBIelZX+ngxJx9bxOIThb7L+7WCRgZRzmMo8/ac63NUZ0qKFXg4emUM713zskrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwSM3TVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwSM3TVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FEFC4AF0E;
	Wed,  7 Aug 2024 15:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043666;
	bh=PW5wO4VGH2iIjnaBdEIpNBk6mJ1z+vajlFevrWCrAvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwSM3TVtVUjhDlAlD2BAkscwYIs1mi9UdeSUekCSQr23+dHweXTQQw13/BFcKkHXW
	 KFW/qCuURrnwL0Mm8PNPvwo7XEsZY2rn6Szhe6x5LBpdtWJ9ZFSGJGnZf7eMnIzlwW
	 8IZZDpP6hyrLDNK2WNsQp6diJG32LrT3rgfnzK5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 27/86] drm/udl: Rename struct udl_drm_connector to struct udl_connector
Date: Wed,  7 Aug 2024 17:00:06 +0200
Message-ID: <20240807150040.133835254@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 59a811faa74f4326fe2d48d2b334c0ee95922628 ]

Remove the _drm_ infix from struct udl_drm_connector and introduce a
macro for upcasting from struct drm_connector. No functional changes.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221006095355.23579-2-tzimmermann@suse.de
Stable-dep-of: 5aed213c7c6c ("drm/udl: Remove DRM_CONNECTOR_POLL_HPD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/udl/udl_connector.c | 19 +++++--------------
 drivers/gpu/drm/udl/udl_connector.h | 10 ++++++++--
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/udl/udl_connector.c b/drivers/gpu/drm/udl/udl_connector.c
index fade4c7adbf78..3c80686263848 100644
--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -46,10 +46,7 @@ static int udl_get_edid_block(void *data, u8 *buf, unsigned int block,
 
 static int udl_get_modes(struct drm_connector *connector)
 {
-	struct udl_drm_connector *udl_connector =
-					container_of(connector,
-					struct udl_drm_connector,
-					connector);
+	struct udl_connector *udl_connector = to_udl_connector(connector);
 
 	drm_connector_update_edid_property(connector, udl_connector->edid);
 	if (udl_connector->edid)
@@ -74,10 +71,7 @@ static enum drm_connector_status
 udl_detect(struct drm_connector *connector, bool force)
 {
 	struct udl_device *udl = to_udl(connector->dev);
-	struct udl_drm_connector *udl_connector =
-					container_of(connector,
-					struct udl_drm_connector,
-					connector);
+	struct udl_connector *udl_connector = to_udl_connector(connector);
 
 	/* cleanup previous edid */
 	if (udl_connector->edid != NULL) {
@@ -94,10 +88,7 @@ udl_detect(struct drm_connector *connector, bool force)
 
 static void udl_connector_destroy(struct drm_connector *connector)
 {
-	struct udl_drm_connector *udl_connector =
-					container_of(connector,
-					struct udl_drm_connector,
-					connector);
+	struct udl_connector *udl_connector = to_udl_connector(connector);
 
 	drm_connector_cleanup(connector);
 	kfree(udl_connector->edid);
@@ -120,10 +111,10 @@ static const struct drm_connector_funcs udl_connector_funcs = {
 
 struct drm_connector *udl_connector_init(struct drm_device *dev)
 {
-	struct udl_drm_connector *udl_connector;
+	struct udl_connector *udl_connector;
 	struct drm_connector *connector;
 
-	udl_connector = kzalloc(sizeof(struct udl_drm_connector), GFP_KERNEL);
+	udl_connector = kzalloc(sizeof(*udl_connector), GFP_KERNEL);
 	if (!udl_connector)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/gpu/drm/udl/udl_connector.h b/drivers/gpu/drm/udl/udl_connector.h
index 7f2d392df1737..74ad68fd3cc9f 100644
--- a/drivers/gpu/drm/udl/udl_connector.h
+++ b/drivers/gpu/drm/udl/udl_connector.h
@@ -1,15 +1,21 @@
 #ifndef __UDL_CONNECTOR_H__
 #define __UDL_CONNECTOR_H__
 
-#include <drm/drm_crtc.h>
+#include <linux/container_of.h>
+
+#include <drm/drm_connector.h>
 
 struct edid;
 
-struct udl_drm_connector {
+struct udl_connector {
 	struct drm_connector connector;
 	/* last udl_detect edid */
 	struct edid *edid;
 };
 
+static inline struct udl_connector *to_udl_connector(struct drm_connector *connector)
+{
+	return container_of(connector, struct udl_connector, connector);
+}
 
 #endif //__UDL_CONNECTOR_H__
-- 
2.43.0



