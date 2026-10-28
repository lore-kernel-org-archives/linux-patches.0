Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212809;
	b=bmHNHndEAzKbY0eorbbL88S1s4nUM9FWukk5RXm4h5/DfYzA8rL7vzYhsG8q0EeLL7iy
	 RPoyqoOwAdqIVsB/aEGgEQSyjNq2/Y5YQKX0DKyyxYzCNTVdz+Z2+etkl/ZdumP1YLF5h
	 HRkpImdtEWZ1jz9oSJnb6s35v/rQJDUQ+bByM4y1Xvjqdhs8p8QlqG0CRmpE9wCkvi5BX
	 9pl0jugUGxSABFUiWsOQzbuS1BzRfEEhUZ3BkvKRrhySxLkaax3O3moBKLgGyA97z5MVy
	 dTXW69Y4Tx57fyyZWZB0mte3AA0zyS5WA29a07fQqHQbxZkvYz+fLj6oiI526W129AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ngmm8K9ntSQv9/zHVdCq47Qbp2rLQao5Hd+RZJETpE=;
	b=2vF5WmXVN9imyshl9bBu3ipj4chBfyjoX7RYA2Q5g5YfgZbo1kfN3eUV0L92LP7/+Ztu
	 0Yx0HfqjzitvrajYISj3YcbEZx6MTd8JbVBiD39V4sUCBmdHFIStPQ/DvtgSZbp986z6Y
	 qT6KAU6hhAt7Vl1anSXYtL71LlmGKCaha/nnMtttxNOBZf74fjfTsJGr5/yWbo5ZfwJJu
	 CIXyjV3nOU0B0/YzSleezVa3+lNtz2aiqTzr1+A6i/v6vCdO1Fr9XC/pV9mh0Vd1dDf9k
	 yVmz6mC3PVNYLPwAgd5rFQlPLdmnL81JUbhVhiPjkwtXHgmn5cbbgrqGUcsgxRGD2hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p3tTrtKw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA87606A31A;
	Wed, 28 Oct 2026 18:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p3tTrtKw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEC11F01825;
	Wed, 28 Oct 2026 18:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212809;
	bh=7ngmm8K9ntSQv9/zHVdCq47Qbp2rLQao5Hd+RZJETpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3tTrtKwvOTx4+0Pj3XLKiP4s6Kcfvemx3thila8sZgZRMkciWNVzyzF4og7IHcy/
	 Ib7uGT/wr+wCpHuuYTMevM9B/X862AtOGHXze6JnTPGT/HF+YwRWYjpR1Q1IPdya+m
	 IhrpC/7HdWN5xep8NeECXCFPCDTXkbSi6UhGJqa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 0283/1887] usb: typec: tcpm: recover after failure to start the frs ams
Date: Wed, 28 Oct 2026 17:39:39 +0100
Message-ID: <20261028170505.668974615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Sunil Dhamne <amitsd@google.com>

commit 90156585765b29304f07b0e4a1c56a969876fcfc upstream.

Reset the port if the tcpm fails to start the FAST_ROLE_SWAP AMS by
initiating error recovery on it.

This helps in cases where some cables (incorrectly) signal an FRS to
an FRS capable port during disconnection. The TCPC autonomously starts
sourcing VBUS on detecting the FRS signal. However, the VBUS sourcing is
left on when the FAST_ROLE_SWAP AMS fails to start (as tcpm_sink_tx_ok
is 0 as CC is open due to the cable disconnect). This is because the
code sets the state to INVALID_STATE without resetting the port state.

Log snippet before changes:
[  101.401960] AMS FAST_ROLE_SWAP start
[  101.401971] Sink TX No Go
[  101.401982] sourcing vbus
[  101.401987] VBUS on
[  101.402159] VBUS on
[  109.257809] CC1: 0 -> 0, CC2: 5 -> 0 [state SNK_READY, polarity 1, disconnected]
[  111.267442] VBUS on

After changes:
[   70.541211] AMS FAST_ROLE_SWAP start
[   70.541220] Sink TX No Go
[   70.541228] state change SNK_READY -> ERROR_RECOVERY [rev3 NONE_AMS]
[   70.541362] VBUS on
[   70.541365] sourcing vbus
[   70.541367] VBUS on
[   70.541374] state change ERROR_RECOVERY -> PORT_RESET [rev3 NONE_AMS]
[   70.541410] disable vbus discharge ret:0
[   70.543028] Setting usb_comm capable false
[   70.544009] Setting voltage/current limit 0 mV 0 mA
[   70.544034] polarity 0
[   70.544239] Requesting mux state 0, usb-role 0, orientation 0
[   70.555550] cc:=0
[   70.555595] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100 ms [rev3 NONE_AMS]
[   70.555697] VBUS off
[   70.555702] VBUS VSAFE0V
[   70.555762] CC1: 5 -> 0, CC2: 0 -> 0 [state PORT_RESET, polarity 0, disconnected]
[   70.587794] VBUS off
[   70.587799] VBUS VSAFE0V
[   70.655672] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 ms]
[   70.655682] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev3 NONE_AMS]
[   70.655686] Start toggling
[   70.656274] CC1: 0 -> 0, CC2: 0 -> 0 [state TOGGLING, polarity 0, disconnected]

Fixes: 0908c5aca31e ("usb: typec: tcpm: AMS and Collision Avoidance")
Cc: stable <stable@kernel.org>
Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260903-frs-error-handling-v1-1-ad0fee541847@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5540,7 +5540,7 @@ static void tcpm_pd_event_handler(struct
 				port->upcoming_state = FR_SWAP_SEND;
 				ret = tcpm_ams_start(port, FAST_ROLE_SWAP);
 				if (ret == -EAGAIN)
-					port->upcoming_state = INVALID_STATE;
+					tcpm_set_state(port, ERROR_RECOVERY, 0);
 			} else {
 				tcpm_log(port, "Discarding FRS_SIGNAL! Not in sink ready");
 			}


