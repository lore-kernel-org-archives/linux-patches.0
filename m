Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04148477984;
	Wed,  9 Sep 2026 13:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961777; cv=none; b=UhqygJjjSW818YJIYyYTYs+n4c7ubCU80y2KwrwSj5eQNXPNPNO7pZUjLrxGaru0XeTv5xSu/SwtK6K6ZBUieb5UPdNfaixe5/CZgDAL5Q2VoT+4iGtZTpEUr0iG3e8gF7cnzxB9cSl18TyW6J1yttn/vZp5o9VFX2IJSZm+uT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961777; c=relaxed/simple;
	bh=CyypMdQh5uMIpzBpYUR0ly+Q9wT1zNEjnQ9PhWBul6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xixsg/0+B1sdI/K1+7eTKZh3K1kUjHeV6DbzjM98AgRbQojDHk+2Oa0Q+B0AKBL0lYXwQo04W+DGZ7fSNV5kGDyymkETH9Tb/zx2GOcDXY4uLhuULL2/m26icO0oA8q/Yn5lbjFnb8ZZjyrLWZMhnGRRu1yfNjG6xD6+/w2l9sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeC7WDjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeC7WDjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF521F00A3A;
	Wed,  9 Sep 2026 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961775;
	bh=UwiwyNhybn9mYciYaPsi0IRNvqZI0PWlJywwA9grdCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BeC7WDjlOStfpWqp59tBYKS09Cou+bQ3nCZQJUFBj9GSB1yEMjjUwVPUA+Bi8b5Fx
	 vr6HpBBi0K4hRIpdO2EulKigDbosnMNWA1cce8qqnAwTtH+dzmyerzotB/iYR1reIz
	 C8o8vBVqFwxv+k04bq51IoaT8r3/SVqxQ0UBYoAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Marek Vasut <marex@nabladev.com>,
	Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.2 036/556] usb: typec: mux: avoid duplicated mux switches
Date: Wed,  9 Sep 2026 15:35:16 +0200
Message-ID: <20260909134231.768984221@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

commit d50b6442bef66abbe4694f918f8ad013f81d75cf upstream.

Some devices use combo PHYs (i.e. USB3 + DisplayPort), which also
handle the lane muxing. These PHYs are referenced twice from
the USB-C connector (USB super-speed lines and SBU/AUX lines)
resulting in the mux being configured twice. Avoid this by
dropping duplicates.

This is a re-application of b145c3f29d62 ("usb: typec: mux: avoid
duplicated mux switches"), with fix derived from usb: typec: mux:
Fix typec_switch_match() .

Fixes: f576c75f95a5 ("Revert "usb: typec: mux: avoid duplicated mux switches"")
Cc: stable <stable@kernel.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Co-developed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Marek Vasut <marex@nabladev.com>
Tested-by: Jens Glathe <jens.glathe@oldschoolsolutions.biz>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260822072556.490594-1-marex@nabladev.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/mux.c
+++ b/drivers/usb/typec/mux.c
@@ -275,7 +275,9 @@ static int mux_fwnode_match(struct devic
 static void *typec_mux_match(const struct fwnode_handle *fwnode,
 			     const char *id, void *data)
 {
+	struct typec_mux_dev **mux_devs = data;
 	struct device *dev;
+	int i;
 
 	/*
 	 * Device graph (OF graph) does not give any means to identify the
@@ -290,8 +292,18 @@ static void *typec_mux_match(const struc
 
 	dev = class_find_device(&typec_mux_class, NULL, fwnode,
 				mux_fwnode_match);
+	if (!dev)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	/* Skip duplicates */
+	for (i = 0; i < TYPEC_MUX_MAX_DEVS; i++)
+		if (to_typec_mux_dev(dev) == mux_devs[i]) {
+			put_device(dev);
+			return NULL;
+		}
 
-	return dev ? to_typec_mux_dev(dev) : ERR_PTR(-EPROBE_DEFER);
+
+	return to_typec_mux_dev(dev);
 }
 
 /**
@@ -316,7 +328,8 @@ struct typec_mux *fwnode_typec_mux_get(s
 		return ERR_PTR(-ENOMEM);
 
 	count = fwnode_connection_find_matches(fwnode, "mode-switch",
-					       NULL, typec_mux_match,
+					       (void **)mux_devs,
+					       typec_mux_match,
 					       (void **)mux_devs,
 					       ARRAY_SIZE(mux_devs));
 	if (count <= 0) {


