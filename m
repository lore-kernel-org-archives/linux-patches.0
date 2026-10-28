Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215207;
	b=w0pwwazNSbK68lHk3t0UgYoSGyusalmdwvkb08mAc9dlDSpSoZdlIhUlIsHvMFS7Ki3z
	 yqnFFs7FA9em/Ty2/CHm7ISqBAhZIhF9LRDaAaFhWK/qJakgX17fbcwyNO6Qcym4nINdW
	 olYCZvYJvxb5HfrZt05iOIAFffH4Odpl+6IPMtnN8wNYZ1DgCKdxemoBuXxD3oxcQfQp8
	 xSsuhHjFm5YMGZQl5UvgH4r4tqYFpg/3RiY/rxx1nP5KUSamdO6FGvnGWYa3YHsihVRxB
	 AJI1JIk1zwNVdFVzdOF9p+rEBGy44bkz+rCIRdruuZVALpMwVRHsCW0Uxbyvva7m14w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lpDf7IKgXcCpc/OdqXP0gb7/nRe/CW9IEhGWFEJC6jQ=;
	b=LHB1x4lDw2ZLHzfnL0C+EiqUrzXHqyV1Oi2GLNEIskVWbcicmhWgTabKEqJ6n5Tfh8O4
	 goUYOiM2B/1l2zsSs8ncMH9gIVP4fJRbNGbEuD02ykItx6nSpyYYDU+IDCCHWNZXnR/9V
	 6lh3nFIwtPgNWOvzwFM2GmALJPm1YDS1W3p6ivpMcpIkMOZVzdHyVUrjnaNxXWjNQr3nu
	 QLL5yjxmGepEBHJPevLDB5bPKISzFeEv8wPX9VDTgIMEu4ad2Lb8RZHa5qwiQkZcgNe81
	 s6fg710eY9G2XM1P9yh2Z02Vys4GVk3WEJiEG6TCSF4HdAkK9v+1FOWFgPbcvoxQpdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNlCOd0j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072CC606A31A;
	Wed, 28 Oct 2026 19:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNlCOd0j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571991F01828;
	Wed, 28 Oct 2026 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215206;
	bh=lpDf7IKgXcCpc/OdqXP0gb7/nRe/CW9IEhGWFEJC6jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNlCOd0jtusTZE3zuc4kQbdHEbGhADUZuJdKuU8W0NCFJy+Cmm7Zoky53Ui/XvbnE
	 FGYmpHFOJKBwlCtMb9qQV1R3xhicgM8rJpOG//N35GUA/5EKIINcUm9Q3bMjncWf8J
	 webtrYDbFvBYLVdPyncsyZu4XewH0//blIxW8hs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1128/1887] usb: typec: tcpm: bound altmode_desc[] per iteration in svdm_consume_modes()
Date: Wed, 28 Oct 2026 17:53:44 +0100
Message-ID: <20261028170525.071718336@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 3389c149c68c3fea61910ad5d34f7bf3bff44e32 ]

svdm_consume_modes() checks pmdata->altmodes against the array size once
before the loop over the count, but forgot to check the bound at every
point in the loop.

In the well-behaved SVDM discovery flow this is harmless because each of
at most SVID_DISCOVERY_MAX SVIDs contributes at most MODE_DISCOVERY_MAX
modes, exactly filling altmode_desc[ALTMODE_DISCOVERY_MAX].  But the
CMDT_RSP_ACK handler in tcpm_pd_svdm() does not correlate an incoming
ACK with any request the port actually sent.  Once port->partner is set,
an unsolicited Discover Modes ACK is consumed unconditionally.  A broken
or malicious port partner can therefore drive altmodes to
ALTMODE_DISCOVERY_MAX - 1 via the normal flow, and then send one extra
Discover Modes ACK with seven VDOs.  Because the pre-loop check passes,
the loop could then writes up to five entries past altmode_desc[].  For
mode_data_prime the next field in struct tcpm_port is the
partner_altmode[] pointer array, which then receives partner-chosen
SVID/VDO bytes.

Move the bound check inside the loop so the array can never be indexed
past ALTMODE_DISCOVERY_MAX regardless of how many VDOs the partner
supplies or how the function was reached.

Assisted-by: gkh_clanker_t1000
Cc: Badhri Jagan Sridharan <badhri@google.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/2026051351-reshuffle-skillful-90af@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index e18c59ae778e9..685a08a659d73 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1544,17 +1544,16 @@ static void svdm_consume_modes(struct tcpm_port *port, const u32 *p, int cnt)
 	struct typec_altmode_desc *paltmode;
 	int i;
 
-	if (pmdata->altmodes >= ARRAY_SIZE(port->partner_altmode)) {
-		/* Already logged in svdm_consume_svids() */
-		return;
-	}
-
 	if (pmdata->svid_index < 0 || pmdata->svid_index >= pmdata->nsvids) {
 		tcpm_log(port, "Invalid SVID index %d", pmdata->svid_index);
 		return;
 	}
 
 	for (i = 1; i < cnt; i++) {
+		if (pmdata->altmodes >= ALTMODE_DISCOVERY_MAX) {
+			/* Already logged in svdm_consume_svids() */
+			return;
+		}
 		paltmode = &pmdata->altmode_desc[pmdata->altmodes];
 		memset(paltmode, 0, sizeof(*paltmode));
 
-- 
2.53.0



