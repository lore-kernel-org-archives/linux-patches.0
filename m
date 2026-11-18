Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057220;
	b=13BtXxItS+w3iA8zlhdnBn7uhSy33fCv95JpOKxiftp7msLk97+1uBSE/+OP2B/dDcpY
	 MS/FZ5FaGgkHDEGrJNooilxwqW/0WmJXX6VjPhh+D5xwOn4cowCvoAKwqB4RMbnKCNLPd
	 WPSEtIgbYMAFzardtikrNcPqkreYGOo6+z/g+bzPUi+tQuC+h8yBN/CcYdyntaIgxXjCQ
	 tAW4CMn+/6GRdcZ3cx8NCgfQ7JED+CiNNfBhjFetELRbq8xEQlhvmPevGQR39rT75G+y1
	 s4pa3hdXBe5dZHERm7EuPM3lEnzYODn18C/CdNwOZa7B0EVKbzXXsOHY0641mQX/8bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0d6KaEncywbkWhoO2FZEY1i0fFwMouPW5fmdDsC5AYE=;
	b=uSaR6KXbRyztGlZ6a6JBlgHzmTp/teuJLiZtH49ROmcgfS9cJ62ncZhzuHaNpDT+hMKd
	 TdJAR+vQ2rP3+Cd2lI5WLq+qqF9zLjNhvvdOwCJKPP99g01jZrFgNeuBNZLRdvNEvdnAr
	 t0KreY2JM1Oky14WPMScHLnGVU6vZwiXJe+qh0ldnqpUlUxId7lnO78TckUb3HjFq3SGb
	 ApwW1e+D8eT3prAkMCrZfulA8VIB8hqI3ElNgzJTWlmiCRfApbinGQcTZvR8DWPY8jGIL
	 JCvmDTtjePvGzisS8+UwPB9IA7hsgeLzrkFcNVx3gYaFkUD2LO7a0IVldvzUwSTL+2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXNTVvx+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DDC60A2600;
	Thu, 19 Nov 2026 03:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXNTVvx+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72211F000CE;
	Thu, 19 Nov 2026 03:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057220;
	bh=0d6KaEncywbkWhoO2FZEY1i0fFwMouPW5fmdDsC5AYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXNTVvx+mkAcVznuGtULrnEFLBcUWrU4lP574lkvz3Tdrvx9JcxINqtZ+EeTkiqMo
	 OXRG1/UR2+FQDzYJjvSgdRBKjYyh8OmKfR0O/sD7sZqZg8WwQEgp7553ftGrq2tMyz
	 gs7avPMtsOdgB1jTpvSxCtE6FbhI1DZ2hvJRgCCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>,
	Denis Arefev <arefev@swemel.ru>
Subject: [PATCH 5.10 0011/1848] usb: typec: tcpm: bound altmode_desc[] per iteration in svdm_consume_modes()
Date: Wed, 18 Nov 2026 15:34:09 +0100
Message-ID: <20261118145911.661400290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 3389c149c68c3fea61910ad5d34f7bf3bff44e32 upstream.

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
[Denis Arefev: adapted for 5.10/6.1: tcpm has no SOP' support here,
svdm_consume_modes() takes no rx_sop_type argument and has a single
pre-loop bound check instead of the two in the SOP/SOP' switch;
drop that one check and add the per-iteration bound check]
Signed-off-by: Denis Arefev <arefev@swemel.ru>                                    
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1155,17 +1155,16 @@ static void svdm_consume_modes(struct tc
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
 


