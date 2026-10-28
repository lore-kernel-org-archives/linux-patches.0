Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213107;
	b=vc494heAZBNz1U9o2SLqmIswMumJvsWF/Tfq/EwAkhZSnuRp++OnilP5AFXe9mM0qWHK
	 OGTzgzSsnE9K3vOHusoGoqH+jB6Nc3ibOuulPVV0M9RdLYmejCEs+1m2X34dgcMQaMKnl
	 dMmhPPHmHHM4usWEj37pXid82hyxyP9QmIbF0ZmUlBcNFdYieKw5GbLZySJsONFxkwYBc
	 0eQ6ZKRpmMN32wsIio4dhiUOGNzZxNpQNwxmkQbxurUz0aiWvnBj/+bU5rJ2LO2lSiAtK
	 RLNqpx63VH3SWp238MI22DlTeO16C2cNQ9ySDfX1mH9kCLdHCFQ0+VRiAbffUmRK8jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cYXNmpfs2Xp9fRTwzOTHyXJHDa9iWIHDWmoaWxcGvo4=;
	b=0Irik5xiEBY6NAlHY4BAoIyGmnxx0rgU5vUqFAqFOAZUMP8jhs3eA+4YIRYpyLsB0nG8
	 Zm64m0lsxKlpS93NasD2SQCmtw7L6XO9biBl5RJ6JNHA/mVX7SEWL1kfi6b4Coy5y+rNx
	 fDN8NMgBTjlca7o6VDI0bQN3+J/OHw3RfyhFzmJ3VTSiFQlA+GyW36WYaEqK7JzMXV6hT
	 uljwL/C60pxiBtGsDRVKjhEDlBAmgxIGVpYAocOXR6QMkRp7LHz0BrGZ99RUVlVYHNvz4
	 lISZV15Cgv/4rBD6Ixa8SJ/LNLmL1ot+wL/T3hxphI5viHmRhFRHGbhnXXxYJC0u2ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z64vCX+E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D42606A31E;
	Wed, 28 Oct 2026 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z64vCX+E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E4E1F01825;
	Wed, 28 Oct 2026 18:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213106;
	bh=cYXNmpfs2Xp9fRTwzOTHyXJHDa9iWIHDWmoaWxcGvo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z64vCX+EdyR2e/UYN9vvkCj45ityrGal22UdZCaAaeIYxaOiPVjcFqUMq5E4zvWed
	 ZP+sW1eIkG2ltn3Sdol0318S1RJt4OqlteNciIWYInQjoylcxYE1px24wmaFcDSE8n
	 aqhGo675NcMKcS5KQKb9mNlbjhO+29L7Ur3+Yc8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0387/1887] USB: dwc2: shut down wakeup timer before freeing HCD state
Date: Wed, 28 Oct 2026 17:41:23 +0100
Message-ID: <20261028170508.042053510@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit fd772af9512cdecb83de34a461801533828e77fd ]

dwc2_wakeup_detected() accesses the DWC2 host state and can rearm the
wakeup timer.  dwc2_hcd_free() currently deletes the timer only after
freeing host-owned state, and timer_delete() does not synchronize a
callback or prevent it from being queued again.

Stop and shut down the timer in dwc2_hcd_release(), before the HCD
resources are freed.  This covers both the HCD initialization error path
and normal HCD removal.

Fixes: 7359d482eb4d ("staging: HCD files for the DWC2 driver")
Cc: stable <stable@kernel.org>
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260904065323.4047026-1-runyu.xiao@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: adapted timer_delete() removal to the existing del_timer() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/hcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index e0f84726f4b1d..5e71094a22b2f 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5082,14 +5082,13 @@ static void dwc2_hcd_free(struct dwc2_hsotg *hsotg)
 	}
 
 	cancel_work_sync(&hsotg->phy_reset_work);
-
-	del_timer(&hsotg->wkp_timer);
 }
 
 static void dwc2_hcd_release(struct dwc2_hsotg *hsotg)
 {
 	/* Turn off all host-specific interrupts */
 	dwc2_disable_host_interrupts(hsotg);
+	timer_shutdown_sync(&hsotg->wkp_timer);
 
 	dwc2_hcd_free(hsotg);
 }
-- 
2.53.0



