Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCE5345CC0;
	Wed, 21 Jan 2026 18:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020359; cv=none; b=cPGmGXBpiDW1A62wzYuhs3LW0NwfHY9MzYhh778HiRhrwxZGu6OPaDoEazgNcQ2BFq324YOAuQeoEIkWoiwn0Fv6oZ1hu9lrh5lH5Xfb9Ana/2keMjs2PvSuhfLXbtqMriXBv1XhSPNpDuo/+T2zTR5ZAzMrDULHEpX3z5GW7L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020359; c=relaxed/simple;
	bh=CpGHXSoDivuSmAz0hR1Z5wBM/zwS6t+hd0bq4o07foo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWnVIdxBnzOFAwYplqAlhc6DcvXU5QyvQcmo4sTmZ7RIHh2JK3ESFCorarv/wMCIbOLGgEwZUVyT1zPeigu5VXlCPONsZ32eTpYzmskDfGJ2H1B7W6W1Ac5Lxp6dyQgojbPMZjt5KOH/VBfWztDaNV4bVDVBm2zEp8KyyPpwba8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9/zrKVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9/zrKVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E2EC4CEF1;
	Wed, 21 Jan 2026 18:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020359;
	bh=CpGHXSoDivuSmAz0hR1Z5wBM/zwS6t+hd0bq4o07foo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9/zrKVkxd4OxhnZ30A56bQw5RuKZuqbI3cZuAjrjSGT4sp1TeE5ae4a9e9Gq8FkH
	 GKk/4zpH5+9uJnBh9YTaOW6Q7MMbfEXrfXAW/hrSUcFuJfTLmO3/PDsHT8WV31oKfe
	 USKT+lC6sdvri6MAHZvLtwkwfv7tiMbGQudhO4Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Arnaud Ferraris <arnaud.ferraris@collabora.com>
Subject: [PATCH 6.18 133/198] tcpm: allow looking for role_sw device in the main node
Date: Wed, 21 Jan 2026 19:16:01 +0100
Message-ID: <20260121181423.334014516@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Ferraris <arnaud.ferraris@collabora.com>

commit 1366cd228b0c67b60a2c0c26ef37fe9f7cfedb7f upstream.

If ports are defined in the tcpc main node, fwnode_usb_role_switch_get()
returns an error, meaning usb_role_switch_get() (which would succeed)
never gets a chance to run as port->role_sw isn't NULL, causing a
regression on devices where this is the case.

Fix this by turning the NULL check into IS_ERR_OR_NULL(), so
usb_role_switch_get() can actually run and the device get properly probed.

Fixes: 2d8713f807a4 ("tcpm: switch check for role_sw device with fw_node")
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Arnaud Ferraris <arnaud.ferraris@collabora.com>
Link: https://patch.msgid.link/20260105-fix-ppp-power-v2-1-6924f5a41224@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -7877,7 +7877,7 @@ struct tcpm_port *tcpm_register_port(str
 	port->partner_desc.identity = &port->partner_ident;
 
 	port->role_sw = fwnode_usb_role_switch_get(tcpc->fwnode);
-	if (!port->role_sw)
+	if (IS_ERR_OR_NULL(port->role_sw))
 		port->role_sw = usb_role_switch_get(port->dev);
 	if (IS_ERR(port->role_sw)) {
 		err = PTR_ERR(port->role_sw);


