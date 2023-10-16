Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAD0262AC
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRRWsqqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EEAC433C8;
	Mon, 16 Oct 2023 14:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468254;
	bh=eDD+9em70tHi18ff63gGf3Jr8E7jfn0aAfgNEjunhq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRRWsqqf2O4hMIeg+r2E3heNsq+8QyNcLUoByMzjrhN+nzLqs1KJ+7W23io1OLWWq
	 LSZb/GQl7kmLC8ELoeSVQHvG7wkXugMmnTKdcmPnpI7+2PJOdiA85iwpznvkDBrUD2
	 dzpyIx1IBN6nLe8L1473p2Z6dXAYABSiGbaLLlUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.5 173/191] usb: typec: ucsi: Fix missing link removal
Date: Mon, 16 Oct 2023 10:42:38 +0200
Message-ID: <20231016084019.413828292@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit dddb91cde52b4a57fa06a332b230fca3b11b885f upstream.

The link between the partner device and its USB Power
Delivery instance was never removed which prevented the
device from being released. Removing the link always when
the partner is unregistered.

Fixes: b04e1747fbcc ("usb: typec: ucsi: Register USB Power Delivery Capabilities")
Cc: stable <stable@kernel.org>
Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Closes: https://lore.kernel.org/linux-usb/ZSUMXdw9nanHtnw2@kuha.fi.intel.com/
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20231010141749.3912016-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 509c67c94a70..61b64558f96c 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -787,6 +787,7 @@ static void ucsi_unregister_partner(struct ucsi_connector *con)
 
 	typec_set_mode(con->port, TYPEC_STATE_SAFE);
 
+	typec_partner_set_usb_power_delivery(con->partner, NULL);
 	ucsi_unregister_partner_pdos(con);
 	ucsi_unregister_altmodes(con, UCSI_RECIPIENT_SOP);
 	typec_unregister_partner(con->partner);
-- 
2.42.0



