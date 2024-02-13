Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059ACA93C;
	Tue, 13 Feb 2024 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846019; cv=none; b=UFC7Y+HK7/0Y5YfwF9Urr18ozfN9iB4BFcZJPwGJ7376JGhQAd3NSXLz9gF/Jj5nd4Lc19Oc8rmt39iapQ6aczqj1J7yPh+NO4uARpvCCo0rxuDt2qJoTtFgXOKQYSi4Z1cKle9yMN80MW1NrbDCPKyWYvLyCExQRy8CZWd1+1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846019; c=relaxed/simple;
	bh=VyxA4Sd63Y8o85xPszcYAlQxwmVyLJ5gQzxnSvSMjSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KL2EKF7UhcYOLOBTA6ySwD4Ip+N3kkpIZ8I3KIIGb8unzMsQkChHrQtD9FAAVUiPrTTbgwOIwtdDfc13enpqX7U+zi49XaoyYhg6t3MT8MwksIB5vYAbIMvIoftmOB055XVQEsM4bZwty0FFgh8X7PTHzuvcQHCNSJvCMNFTLyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEfPjfAb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEfPjfAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4B5C433C7;
	Tue, 13 Feb 2024 17:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707846018;
	bh=VyxA4Sd63Y8o85xPszcYAlQxwmVyLJ5gQzxnSvSMjSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEfPjfAbF3SYYhufQlkkqhaNfjPRkBWM6w6ulIXkDe4lyo4CqWe1v5I8Br2XqV/BM
	 Me4kWW5gUUaYfnibL4adjbgfg64cunMKsCk5akWTZhmJ0BVJj4qmcTn+/Sylxy0TS1
	 eTXioqUYMqPHjGdm98lgi3KGyE8+JAOEBQCZ75Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wang <frank.wang@rock-chips.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.7 093/124] Revert "usb: typec: tcpm: fix cc role at port reset"
Date: Tue, 13 Feb 2024 18:21:55 +0100
Message-ID: <20240213171856.446249309@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Badhri Jagan Sridharan <badhri@google.com>

commit b717dfbf73e842d15174699fe2c6ee4fdde8aa1f upstream.

This reverts commit 1e35f074399dece73d5df11847d4a0d7a6f49434.

Given that ERROR_RECOVERY calls into PORT_RESET for Hi-Zing
the CC pins, setting CC pins to default state during PORT_RESET
breaks error recovery.

4.5.2.2.2.1 ErrorRecovery State Requirements
The port shall not drive VBUS or VCONN, and shall present a
high-impedance to ground (above zOPEN) on its CC1 and CC2 pins.

Hi-Zing the CC pins is the inteded behavior for PORT_RESET.
CC pins are set to default state after tErrorRecovery in
PORT_RESET_WAIT_OFF.

4.5.2.2.2.2 Exiting From ErrorRecovery State
A Sink shall transition to Unattached.SNK after tErrorRecovery.
A Source shall transition to Unattached.SRC after tErrorRecovery.

Cc: stable@vger.kernel.org
Cc: Frank Wang <frank.wang@rock-chips.com>
Fixes: 1e35f074399d ("usb: typec: tcpm: fix cc role at port reset")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240117114742.2587779-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4862,8 +4862,7 @@ static void run_state_machine(struct tcp
 		break;
 	case PORT_RESET:
 		tcpm_reset_port(port);
-		tcpm_set_cc(port, tcpm_default_state(port) == SNK_UNATTACHED ?
-			    TYPEC_CC_RD : tcpm_rp_cc(port));
+		tcpm_set_cc(port, TYPEC_CC_OPEN);
 		tcpm_set_state(port, PORT_RESET_WAIT_OFF,
 			       PD_T_ERROR_RECOVERY);
 		break;


