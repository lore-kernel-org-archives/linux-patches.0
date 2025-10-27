Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBC3320CCE;
	Mon, 27 Oct 2025 19:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592722; cv=none; b=YfmZ15KQW1CyZT1KHwdg2gMK0SVrRYW6cnRM6+ClhkPqoWR74JecQv1cb4o4Cl2anDzY5mNjuvg3kPo8XeVEUYi8RHJy8wGj4Na1SoNpNZ9D/y7/On+LlMSMjlwGO4+K7bKg0uKO60MiJYvXuU1pSbR2xymN82Elghmp11d5f28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592722; c=relaxed/simple;
	bh=dVWcG8WqzEyYiFKm42aGbkX9ybqnMo9icZ0NdINcRLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNn2/6a/R6jSpRTG0zWcGhlc5J4TrypE53PmUvHPidVfa2vYNMreou6DhXZ8HVKgpt7Ik9DiB3iQcTOSUx4pYSfF4aTY848c/CueSdImpSKOgCSeIxeJyUTESnHuGzufxfo7uShBZtd99nHnxKkqNNWyxwQIKU7EtWSSXUzTGXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0D1W6+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0D1W6+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336BAC4CEF1;
	Mon, 27 Oct 2025 19:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592722;
	bh=dVWcG8WqzEyYiFKm42aGbkX9ybqnMo9icZ0NdINcRLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0D1W6+Oaqr4Jlzrqyf5V2TxDIj+JX8nrXDdASP3HgxvKyxMZvF0X6qCJB2JvQ4Tq
	 YoHCiTg0C0gvwOefzuSqa4hg1WAHgwuczi8+W5dp7WejQJMqV+cozVSDbRR85aLHbb
	 teoa0Ce7JdcAfw1fEKSQB46QwSfcAMWBvdqTa+9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.6 72/84] tcpm: switch check for role_sw device with fw_node
Date: Mon, 27 Oct 2025 19:37:01 +0100
Message-ID: <20251027183440.727617528@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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
@@ -6636,9 +6636,9 @@ struct tcpm_port *tcpm_register_port(str
 	port->partner_desc.identity = &port->partner_ident;
 	port->port_type = port->typec_caps.type;
 
-	port->role_sw = usb_role_switch_get(port->dev);
+	port->role_sw = fwnode_usb_role_switch_get(tcpc->fwnode);
 	if (!port->role_sw)
-		port->role_sw = fwnode_usb_role_switch_get(tcpc->fwnode);
+		port->role_sw = usb_role_switch_get(port->dev);
 	if (IS_ERR(port->role_sw)) {
 		err = PTR_ERR(port->role_sw);
 		goto out_destroy_wq;


