Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46B12C15A9;
	Mon, 27 Oct 2025 19:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593534; cv=none; b=SuL6VQCcNhXZqUcnPNh/hVK3O13gGLzlROeHBUNg2a4XSkEvmGU0hgINu/Aq6SHoJfFQieINucoD5sJLjhWxWx0bbA+qVpPiPnVsrRWVtzLCZdNZ+cQT5aDAlaH3bH9wcdas1wZdhVMoaICdCW48Y85RbZjJfsNe7Xc9lSGwyoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593534; c=relaxed/simple;
	bh=spqi//Odd5iJgmmu6UuMNjBFHiZKVTcSz43C+7gGrVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+OY1ibYWitMINO1MR19LLFXErQD7N9Rck3ulb0UzptmClzuo/r9QDPOiWGa3FweJybOK4+ylfnW0+JPkODftujT8yEbJKq4zGtyfDjvlB51P6nIh8N7OZp6tuSkaSg+SuZsu+5p17p04R23iqqplurcpaXFsKxq8bNI4XU2HJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYCRUWcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYCRUWcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3695DC4CEF1;
	Mon, 27 Oct 2025 19:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593534;
	bh=spqi//Odd5iJgmmu6UuMNjBFHiZKVTcSz43C+7gGrVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYCRUWcF8sMO+H2NiWcXe2/aZWM6pu7B5/xTth4cDtd9u6QQnFKKTvo9/jx9I33Oq
	 U9WkJUKA7Yc/gQLok3is/o3jj6QGttkCFsSYO/PoTvmgT1bAWy1ddFrESSqTaNj7ts
	 2sAqJopiPT1uofOWkuj/stt8tQDjSEF/6MlvdFXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.17 165/184] tcpm: switch check for role_sw device with fw_node
Date: Mon, 27 Oct 2025 19:37:27 +0100
Message-ID: <20251027183519.368660398@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 2d8713f807a49b8a67c221670e50ae04967e915d upstream.

When there is no port entry in the tcpci entry itself, the driver will
trigger an error message "OF: graph: no port node found in /...../typec" .

It is documented that the dts node should contain an connector entry
with ports and several port pointing to devices with usb-role-switch
property set. Only when those connector entry is missing, it should
check for port entries in the main node.

We switch the search order for looking after ports, which will avoid the
failure message while there are explicit connector entries.

Fixes: d56de8c9a17d ("usb: typec: tcpm: try to get role switch from tcpc fwnode")
Cc: stable <stable@kernel.org>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://patch.msgid.link/20251013-b4-ml-topic-tcpm-v2-1-63c9b2ab8a0b@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -7876,9 +7876,9 @@ struct tcpm_port *tcpm_register_port(str
 
 	port->partner_desc.identity = &port->partner_ident;
 
-	port->role_sw = usb_role_switch_get(port->dev);
+	port->role_sw = fwnode_usb_role_switch_get(tcpc->fwnode);
 	if (!port->role_sw)
-		port->role_sw = fwnode_usb_role_switch_get(tcpc->fwnode);
+		port->role_sw = usb_role_switch_get(port->dev);
 	if (IS_ERR(port->role_sw)) {
 		err = PTR_ERR(port->role_sw);
 		goto out_destroy_wq;


