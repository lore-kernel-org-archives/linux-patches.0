Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50DE3ED106;
	Tue, 17 Mar 2026 16:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766280; cv=none; b=VYPonLJt9mw9zwBpCNV10BNkQ64e6KqijsUaJqn+1VtIsFNq4EgpvQU3S1PLntveSVhD9nBiFThyVRLVhVdhyitZjsz8An9T7hqJySpfb9EhDkkBD473iBMeZw+YQIf4CmKOxpdNxNIrPoI2gh0SaEqmt3wDay14skBvmiUySRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766280; c=relaxed/simple;
	bh=3tNPiucf9S3DO7rNzEFfjSrxw1aEboGVYBFpLilXDfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+sZZdAVtSOXgkKO2/UiqNelQWbjmKnwEas0OMJCZi0JcrVRwITsgtGzts1I7gTNU+mPyL2xRsPeN1k27oKxiZ6GLPdWn/iq432QL5j/9TqWX2oX7oX+huAxrtdF6d/P6UVuFH2icJipceO//AlYZ1Zy8sSRIUnGlbQ99z/LfgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxTUZ3pc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxTUZ3pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9F4C4CEF7;
	Tue, 17 Mar 2026 16:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766280;
	bh=3tNPiucf9S3DO7rNzEFfjSrxw1aEboGVYBFpLilXDfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxTUZ3pciuAVwmLUsVxrfg2Hl4pYkQY20bT28uW2iObYgWog69fyIGF2lskOcRNP1
	 gFKn7ST0XLy7EyeuBWxSQ24ROoLElQdkg6TrLPZYasMNeOpRhIlfutYPjXxIOAa2Pl
	 TPvKWRPuXsOxSlaooWADxrGW3RBEQrPK7QcO3tUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Arnaud Ferraris <arnaud.ferraris@collabora.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.19 210/378] Revert "tcpm: allow looking for role_sw device in the main node"
Date: Tue, 17 Mar 2026 17:32:47 +0100
Message-ID: <20260317163014.734064121@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 6b275bfaa16be3fb1689fa6794e445ecd127a1b4 upstream.

This reverts commit 1366cd228b0c67b60a2c0c26ef37fe9f7cfedb7f.

The fwnode_usb_role_switch_get() returns NULL only if no connection is
found, returns ERR_PTR(-EPROBE_DEFER) if connection is found but deferred
probe is needed, or a valid pointer of usb_role_switch.

When switching from a NULL check to IS_ERR_OR_NULL(), usb_role_switch_get()
returns NULL and overwrites the ERR_PTR(-EPROBE_DEFER) returned by
fwnode_usb_role_switch_get(). This causes the deferred probe indication to
be lost, preventing the USB role switch from ever being retrieved.

Fixes: 1366cd228b0c ("tcpm: allow looking for role_sw device in the main node")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Tested-by: Arnaud Ferraris <arnaud.ferraris@collabora.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260309074313.2809867-2-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -7890,7 +7890,7 @@ struct tcpm_port *tcpm_register_port(str
 	port->partner_desc.identity = &port->partner_ident;
 
 	port->role_sw = fwnode_usb_role_switch_get(tcpc->fwnode);
-	if (IS_ERR_OR_NULL(port->role_sw))
+	if (!port->role_sw)
 		port->role_sw = usb_role_switch_get(port->dev);
 	if (IS_ERR(port->role_sw)) {
 		err = PTR_ERR(port->role_sw);


