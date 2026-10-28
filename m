Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215210;
	b=s5VaE/B+onYQMfwhyF4FBYjy0wznmnYzBdHyVlDrc4b90h0GTjV945cJB99PgzJJSzQ4
	 GpemYJKfifWbe8yT2538o5Bx5OpBpWA7cQJf8ApF3qEBUn+YiKVT329nsmPLQFhzDcgOZ
	 3qfUTz8VTstbWoOhEYwY/bwHQ0FEmUAjUAGdlgeJ8jpZMOLYLfwmEW/rqW5DetjhtAaQN
	 dRiHXz1ttxPP4nzKRkGfCxKkL9mAJ2jhYetbrsWvnX6Njqq8M9c7BR1d7OF8LB5N9y5Vk
	 BYHQ0qLAILRroyyv/RwsFhSSpwCAW4vlnuCPzi3zSxLZtABGfcnYqe4pSspjl2vDDgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1s7ncQv28TACMDmuH6yQojrODS/uxQMmH4wUu0NHe2E=;
	b=YhenOVgT36cuZyjmiVAzqIp15n8w/a4Di9pm7Ke4LSfTSKekxMJgGPfPYojnQMVWQ3gj
	 h3nEJYWaFxpetXFqRGDjBg4GrqBkxqqP1IKtNUZyCGsEDjQ7YLwPPjOSaVmdBRgzAs/FF
	 HDPpmGGVRBSNx7wtQcU3zoraXZeDjaFIdGO400VmZzinL6NvHvkI1N6Lknz2Fd4AY7TEN
	 JS2vFrHJaoqu/c1mehcPicwt4jqGxufuvDEcqNDNKgUgD1TnypKIsCVeVLpm5MfnWReUQ
	 O0lwMlhTrgipovU4RmJ7s8Yo7HdwJL443urBhr/pEpkGbstLa72qafomQi7AG4CTFpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPz3pS+V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1B2606A31C;
	Wed, 28 Oct 2026 19:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPz3pS+V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299281F01825;
	Wed, 28 Oct 2026 19:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215209;
	bh=1s7ncQv28TACMDmuH6yQojrODS/uxQMmH4wUu0NHe2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPz3pS+VMkChf3vhXTP8NuhyjvxcI0Hg7y/WY0xNkRxrWqVCcG7OYVsbcU41YuXI7
	 jBQ5GEdW5tY82x8EdoCRleiYtlgnrRTXllJuX0x/Ukt6ZKJJDc9USaqIVRthqNMyV4
	 hropcXtb0ESFGz4ZHpNwX0UI72XCYmb+TkqtWD5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1129/1887] usb: typec: tcpm: validate VDO count in Discover Identity ACK handlers
Date: Wed, 28 Oct 2026 17:53:45 +0100
Message-ID: <20261028170525.093530405@linuxfoundation.org>
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

[ Upstream commit 8fbc349e8383125dd2d8de1c1e926279d398ab17 ]

Properly validate the count passed from a device when calling
svdm_consume_identity() or svdm_consume_identity_sop_prime() as the
device-controlled value could index off of the static arrays, which
could leak data.

Assisted-by: gkh_clanker_t1000
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://patch.msgid.link/2026051350-plated-salute-0efe@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 685a08a659d73..b7f81db5f371a 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1476,6 +1476,9 @@ static void svdm_consume_identity(struct tcpm_port *port, const u32 *p, int cnt)
 	u32 vdo = p[VDO_INDEX_IDH];
 	u32 product = p[VDO_INDEX_PRODUCT];
 
+	if (cnt <= VDO_INDEX_PRODUCT)
+		return;
+
 	memset(&port->mode_data, 0, sizeof(port->mode_data));
 
 	port->partner_ident.id_header = vdo;
-- 
2.53.0



