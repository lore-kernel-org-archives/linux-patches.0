Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211169;
	b=OyR8IGyQzFDsJ5zGNsLLTrAFQa0pjHIzS3skKb5roCmyg3+C0f/rhfrtfFINGkigt1yI
	 ZE9UKyrnEYPZffspqNS8J4h4/cUPvyiSi/gI4tSQUlA0bk8H3PuDkGmcIExTeL3UA5RUa
	 utNCxTNY+KRVY1B61tbNT+xw7NlMThw7pd1s6wraTiIKphqZ/3CVQdYx78NNORIVxuK+v
	 7I2rmw91cokD2yrehMWzXRVi0O7IYVRm1dwUi0wIWMmUeLkvLF9Bnk9emBIB11udUZJnY
	 1DX1ZrSnpktH7zpEhrP2MZU43uVxQJpE6dkL8q5tFjBwE9OVAEfnbe/9ryR6STvV2Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H/Orgqdjl6LfaOaADetSY1irEJztHZxqAlw5sMEabjI=;
	b=hD8O2WkBYWqiix1esIJL8p3DZS19zEuhxsMd0RQW05xzAtfqUJ8tmSm5vL3HNeVG2bPG
	 1rhJgS4sH70o36mWvSfD5xNubHaVWjZdNxNcJPNtSp1lngWBaxFR+4aRF4/vBlOW3ZBY+
	 3T2kfTNAnjb/kTt52iE9tGgnKQwEyxVwAhpD4D7dtTpCPeyxUpN1PVTEtTRxOUXZj9yMX
	 ZVzQIaAx2ZGu00oEK3EFnyd1YldW+ppy4hhsqAn1wDs6DLcKRskcgMCLB6pTqD0iWihwu
	 UQ12198mwYi1V9pCV+/7m5+2CBSJHBjHxIIah04HZI35YKrjzKiRCKqYAE7iOwL9xRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZSCRFGvW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4C9606BF58;
	Wed, 28 Oct 2026 18:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZSCRFGvW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477151F031E2;
	Wed, 28 Oct 2026 18:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211168;
	bh=H/Orgqdjl6LfaOaADetSY1irEJztHZxqAlw5sMEabjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZSCRFGvWNoKdvFR0JE+eRw5/2yoRxNTOVN/oqCVBj/KGk42Uj6BnBJtg14q+hxAzF
	 HkWjrMdMTkAjBiZX3wHlBpMuPPcRc0YuTjRe4xr3MZ8bprfnib5P+qhifj1nRk7ogY
	 I4JzO33hVacM3u9SWaW4MVeDCmfORSH2oiu6m4QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/571] usb: typec: tcpm: fix debug accessory mode detection for sink ports
Date: Wed, 28 Oct 2026 17:57:11 +0100
Message-ID: <20261028170014.740660566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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

[Backport to 6.12: This tree lacks 8db73e6a42b6 and the associated
sink debug-accessory state-machine support. Retain only the source-debug
macro extraction and source-side call-site updates. Keep
tcpm_port_is_debug() source-only and omit the sink-debug macro and all
sink/audio attachment transitions introduced by the upstream dependency.
This preserves existing detection and state transitions while providing
tcpm_port_is_debug_source() for cd3b9cea675b ("usb: typec: tcpm: constrain
TCPM_SOURCING_VBUS event handling"). No functions are added.]

Stable-dep-of: cd3b9cea675b ("usb: typec: tcpm: constrain TCPM_SOURCING_VBUS event handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -514,9 +514,12 @@ static const char * const pd_rev[] = {
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
 
@@ -3951,7 +3954,7 @@ static void run_state_machine(struct tcp
 			tcpm_set_state(port, SNK_UNATTACHED, PD_T_DRP_SNK);
 		break;
 	case SRC_ATTACH_WAIT:
-		if (tcpm_port_is_debug(port))
+		if (tcpm_port_is_debug_source(port))
 			tcpm_set_state(port, DEBUG_ACC_ATTACHED,
 				       PD_T_CC_DEBOUNCE);
 		else if (tcpm_port_is_audio(port))
@@ -4954,7 +4957,7 @@ static void _tcpm_cc_change(struct tcpm_
 
 	switch (port->state) {
 	case TOGGLING:
-		if (tcpm_port_is_debug(port) || tcpm_port_is_audio(port) ||
+		if (tcpm_port_is_debug_source(port) || tcpm_port_is_audio(port) ||
 		    tcpm_port_is_source(port))
 			tcpm_set_state(port, SRC_ATTACH_WAIT, 0);
 		else if (tcpm_port_is_sink(port))
@@ -4962,7 +4965,7 @@ static void _tcpm_cc_change(struct tcpm_
 		break;
 	case SRC_UNATTACHED:
 	case ACC_UNATTACHED:
-		if (tcpm_port_is_debug(port) || tcpm_port_is_audio(port) ||
+		if (tcpm_port_is_debug_source(port) || tcpm_port_is_audio(port) ||
 		    tcpm_port_is_source(port))
 			tcpm_set_state(port, SRC_ATTACH_WAIT, 0);
 		break;


