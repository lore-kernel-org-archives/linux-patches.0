Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208852;
	b=WVYNGrz8Jzp2zmvayXlblGXwQq2Pjw/9WlyHLSQHpB9auOsxxiJ9IIAt10Olxi97PyXB
	 DvS+hNZ3xyAtvgjeoEBnslYPsVHm8Ghcs/2VzSxr5FgOZmsh5qG1xIgU/sBw3je4cn25Q
	 qBWU1BPwH27kxmJ6kiUibBRX5IyTTgamUndYfLjeDZ/gjLmPTfgwtTAXHgkSbhuxLeSw8
	 u64FY8xJRxG4skpCYCN9qesG6ku7lvZaxchtlO7g+E8EAhDqzNWXzZW/nVjesTisquNV0
	 bA6LFHGuI8GqSkQhbFc8s5+NsTWn3QaA65/Mfp0ifzgPru5TY9Fl8PV6zlnAUJztxOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aWZ9wFpYDaXVQR4oST6y9wZoaAzR1m+P7zGD4mLnBks=;
	b=zscjUzXBvFG88ldY6NfYdgltV+/8YdXc5dFOc7EEm/vKv0cGno7mhgjxKQEVNnaeEqYp
	 GTIPRpmo8MD2OqFnY7zgi4d4+kPF7kOf1LvX8IQxCRbXIzw8Wzt5ebx4Z04HWRhz2DDrY
	 kwwfrR83b1dvEAllfQrPOGgLbckniX2J9NUTd87Bu1NVlRZ5MhqXIOPtOT8esg4IH0AWu
	 PK0wCZqEdYezmbpcwE9WnSwgkFZLsK4NSOUQaT103C5U6Uvn3qDVJNJkTG/FyhuporaEd
	 lo2oSVcmjI9KbzLFmo/Fyr8inFz0AcvpdV02z/gLqgSePesu3DGrX0Pra3seSiPQKJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FKGQytQ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F12606A31C;
	Wed, 28 Oct 2026 17:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FKGQytQ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CA61F01825;
	Wed, 28 Oct 2026 17:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208852;
	bh=aWZ9wFpYDaXVQR4oST6y9wZoaAzR1m+P7zGD4mLnBks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKGQytQ3n3MdKp4r89Z2HVQOftJchwAL8WYHyKY737ZhkN8u2FnYelGzEFugcXuLs
	 F4/i36imK2BBdLX5wopQaYzpLaEcxZIfX/YQRk6/TT4PP7KVDZjJBd3oCPjG7Qr+np
	 XANYHRMT5CR0mehzLfJMntZmQIrVtc5DTa2c9oZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 264/516] usb: typec: tcpm: fix debug accessory mode detection for sink ports
Date: Wed, 28 Oct 2026 17:56:56 +0100
Message-ID: <20261028170009.744912491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit f6ec9bb4acc7182b25a793ad094a764e1cb819a7 ]

The port in debug accessory mode can be either a source or sink. The
previous tcpm_port_is_debug() function only checked for source port.

Commit 8db73e6a42b6 ("usb: typec: tcpm: allow sink (ufp) to toggle into
accessory mode debug") changed the detection logic to support both roles,
but left some logic in _tcpm_cc_change() unchanged, This causes the state
machine to transition to an incorrect state when operating as a sink in
debug accessory mode. Log as below:

[  978.637541] CC1: 0 -> 5, CC2: 0 -> 5 [state TOGGLING, polarity 0, connected]
[  978.637567] state change TOGGLING -> SRC_ATTACH_WAIT [rev1 NONE_AMS]
[  978.637596] pending state change SRC_ATTACH_WAIT -> DEBUG_ACC_ATTACHED @ 180 ms [rev1 NONE_AMS]
[  978.647098] CC1: 5 -> 0, CC2: 5 -> 5 [state SRC_ATTACH_WAIT, polarity 0, connected]
[  978.647115] state change SRC_ATTACH_WAIT -> SRC_ATTACH_WAIT [rev1 NONE_AMS]

It should go to SNK_ATTACH_WAIT instead of SRC_ATTACH_WAIT state.

To fix this, add tcpm_port_is_debug_source() and tcpm_port_is_debug_sink()
helper to explicitly identify the power mode in debug accessory mode.
Update the state transition logic in _tcpm_cc_change() to ensure the state
machine transitions comply with Type-C specification. Also update the logic
in run_state_machine() to keep consistency.

Fixes: 8db73e6a42b6 ("usb: typec: tcpm: allow sink (ufp) to toggle into accessory mode debug")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Amit Sunil Dhamne <amitsd@google.com>
Link: https://patch.msgid.link/20260424074009.2979266-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[5.10 dependency adaptation: This tree does not contain 8db73e6a42b6
or sink debug accessory support. Retain the source debug predicate and
its source-path callers, and keep tcpm_port_is_debug() source-only.
Drop the sink predicate and sink accessory state transitions, which
require the missing feature. This supplies tcpm_port_is_debug_source()
for cd3b9cea675b without changing 5.10 accessory behavior or adding
functions. The target applies with a three-way merge; its references
to AMS_START and upcoming_state still require a separate 5.10 adaptation
because AMS and Collision Avoidance was not backported.]

Stable-dep-of: cd3b9cea675b ("usb: typec: tcpm: constrain TCPM_SOURCING_VBUS event handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -420,9 +420,12 @@ struct pd_rx_event {
 	 (tcpm_cc_is_source((port)->cc2) && \
 	  !tcpm_cc_is_source((port)->cc1)))
 
-#define tcpm_port_is_debug(port) \
+#define tcpm_port_is_debug_source(port) \
 	(tcpm_cc_is_source((port)->cc1) && tcpm_cc_is_source((port)->cc2))
 
+#define tcpm_port_is_debug(port) \
+	tcpm_port_is_debug_source(port)
+
 #define tcpm_port_is_audio(port) \
 	(tcpm_cc_is_audio((port)->cc1) && tcpm_cc_is_audio((port)->cc2))
 
@@ -3095,7 +3098,7 @@ static void run_state_machine(struct tcp
 			tcpm_set_state(port, SNK_UNATTACHED, PD_T_DRP_SNK);
 		break;
 	case SRC_ATTACH_WAIT:
-		if (tcpm_port_is_debug(port))
+		if (tcpm_port_is_debug_source(port))
 			tcpm_set_state(port, DEBUG_ACC_ATTACHED,
 				       PD_T_CC_DEBOUNCE);
 		else if (tcpm_port_is_audio(port))
@@ -3918,7 +3921,7 @@ static void _tcpm_cc_change(struct tcpm_
 
 	switch (port->state) {
 	case TOGGLING:
-		if (tcpm_port_is_debug(port) || tcpm_port_is_audio(port) ||
+		if (tcpm_port_is_debug_source(port) || tcpm_port_is_audio(port) ||
 		    tcpm_port_is_source(port))
 			tcpm_set_state(port, SRC_ATTACH_WAIT, 0);
 		else if (tcpm_port_is_sink(port))
@@ -3926,7 +3929,7 @@ static void _tcpm_cc_change(struct tcpm_
 		break;
 	case SRC_UNATTACHED:
 	case ACC_UNATTACHED:
-		if (tcpm_port_is_debug(port) || tcpm_port_is_audio(port) ||
+		if (tcpm_port_is_debug_source(port) || tcpm_port_is_audio(port) ||
 		    tcpm_port_is_source(port))
 			tcpm_set_state(port, SRC_ATTACH_WAIT, 0);
 		break;


