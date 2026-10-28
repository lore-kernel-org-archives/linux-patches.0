Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208716;
	b=a4gOTYWVkps10Bg01rWqSgZGz+bIyTiepr/Gql6HmT/CjC3+StrXTn0sQTXmfSnc9aQ0
	 PRWndlVlYeQqZVgWNBcWsmvAP81cl2DtjtOP5sb5EHWOubY6SL6JDnMF5cQxGTbqS9Uf0
	 n4DHHiDNWlJMh5rLrOhC0b55vOYRlJvoP61U4KlaLHfibZPUw40siSX/9HAwbKwo3DdXk
	 N/f2Ox/B74OZfjgM8ct9TrljeljMxf/pTYvPmrhRhTIBaAhqn6cHWD3LQlFXZHbbCexiC
	 moJOaAjCnudBUj/F4fbEKbI7jSskoMcxmaaTU4ycqrCWfN+vRstFSlpSbDXFS7iITKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kTfWKQ5Lo6dBLBJ1rd6smLj/m4tMtVPma5aUKmLr/lw=;
	b=v2t36NDf5MAqpgYVUrbmoxPeMtjsMUQ3XVBjttrW3X0ZLX1GmT6lB/6Imj+1CtRBkxdt
	 ZLMRBRVn5cwNQ9/UK1l7SkLRTlkJMOx1yuN+gO+ZuymAkOGEJxdSVxNrFJ502PN+F8l7i
	 pluXcP4hzSq34VPSEe+9PdNUg9L9w77bDdAc7IescDGPjtPor63ovVonTar/n+Lb4VUI0
	 3TokOnJXQZSBughHyFMYekooS8Mvvfwri7w7Gtx0ppZ7cCdWRPSfxqT8UIXnz2AwVk1Pc
	 AadoMhiIQYdzdRsLPiO659587Wtl68oYzHFRCnsBqd45K1GA6RVK3IqcOykwKqoFvnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gkTEgegA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BB6606A31A;
	Wed, 28 Oct 2026 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gkTEgegA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7947D1F01825;
	Wed, 28 Oct 2026 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208716;
	bh=kTfWKQ5Lo6dBLBJ1rd6smLj/m4tMtVPma5aUKmLr/lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gkTEgegA1Xx/C+/S/hpgO2k2BA5Yy5o805pCO+gywwOIan3i8RuPM0vFPuAY8A8lv
	 mKT2QLmCD2T3oq1F1nD3y2coD+0Q8VyZN3frQh9ishuMe26EWR0+GN/f3aH/Q02xYr
	 ATiEvz+ASi6yuYGJijeCP3HDDnGH6+eiy8O3S7vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Fluhr <mathieu.fluhr@gmail.com>,
	stable <stable@kernel.org>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 190/516] usb: hub: use shorter 120ms post resume hold for SS root hubs
Date: Wed, 28 Oct 2026 17:55:42 +0100
Message-ID: <20261028170008.003788432@linuxfoundation.org>
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

From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>

commit 29480b05e6e226594dc11ccf2a036fbd5cdd0e42 upstream.

Holding a USB3 hub PM runtime reference for 200ms at hub resume triggers
an AMD platform issue.  Users running Android adb report crashes after
adb has been polling and waking up the USB subsystem once a second for
some time.  Vendors are working on a solution.  Disabling USB runtime PM
is one way to prevent this issue, but it is also proven that reducing the
hold time to 120ms in resume also mitigates it.  See Link for more
details.

Reducing the hold time to 120ms for the USB3 roothub is in itself a valid
change and optimization, as the current 200ms is excessive: a root hub
has no upstream suspended hub whose wake propagation needs to be
accounted for, but still need some time for USB3 link training to
complete.

Keep the 200ms hold for external hubs that commit 8f5b7e2bec1c
("usb: hub: fix detection of high tier USB3 devices behind suspended
hubs") is intended for.

Reported-by: Mathieu Fluhr <mathieu.fluhr@gmail.com>
Link: https://lore.kernel.org/all/CAPyJwA_D9qw0T72f8zwM1yKjP+To=maVANbcdsWM7yRmbBxYvw@mail.gmail.com/
Cc: stable <stable@kernel.org>
Fixes: 8f5b7e2bec1c ("usb: hub: fix detection of high tier USB3 devices behind suspended hubs")
Signed-off-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260903112903.542719-1-lovekeshsolanki00@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -56,8 +56,11 @@
 /*
  * Give SS hubs 200ms time after wake to train downstream links before
  * assuming no port activity and allowing hub to runtime suspend back.
+ * Root hubs have no upstream hub whose wake propagation needs to be
+ * accounted for, so they need less time, use 120ms for them.
  */
 #define USB_SS_PORT_U0_WAKE_TIME	200  /* ms */
+#define USB_SS_RH_PORT_U0_WAKE_TIME     120 /* ms */
 
 /* Protect struct usb_device->state and ->children members
  * Note: Both are also protected by ->dev.sem, except that ->state can
@@ -1319,7 +1322,9 @@ static void hub_activate(struct usb_hub
 
 		queue_delayed_work(system_power_efficient_wq,
 				   &hub->post_resume_work,
-				   msecs_to_jiffies(USB_SS_PORT_U0_WAKE_TIME));
+				   msecs_to_jiffies(hdev->parent ?
+				USB_SS_PORT_U0_WAKE_TIME :
+				USB_SS_RH_PORT_U0_WAKE_TIME));
 		return;
 	}
 


