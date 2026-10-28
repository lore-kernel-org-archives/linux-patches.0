Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210922;
	b=mvzR3qO3sBvCWk7tADf+/eyh2yhqeVRAkeF9KR1sAgiDuqo55SHIxQrBoz99JCGlr5wa
	 LRrmItYeQ9izlfmhz9DHjf5mU3w+t+B63bI077lT1e2cIswQyJIzrzn2Gx7s3+k8+hZcJ
	 ZKKayQXfFxq8Tq7cFpgs9yS5ic8fBrkSngXoAI2AIhSfx7MQnxonD4odNgYvOJ9gZnXbN
	 QEfQEular9F1S8KmqEpU/rwfh4u2dF/6u0fqsKshxPvfuR/wTQ0TSJKvV9UDHR2OkOdpR
	 PcHkGrGOofqKJUrVtcQhHRWsS0bJLXpj5O3fZ1LRTnU65f/nkmW6VOz3RRlFOjepuxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EJprPCFR7BrKJHpqilsRxQOuWMHSHbiVtPOICveJ5EE=;
	b=F/1ah+6U0bhpbemEvvMBaCJ/tBY3jNysz0zDALRrfhx8OWo6NnTr4GUCvsO5+qnSG4Hq
	 OBXCSAbnlwJK6+fNLtTbcl1ltgPQl8g51qMIl5MulvLldELdHiOm0wXPDwVpS3t1KRHMz
	 acKbcD9en5pZncqMVAOeVRdtoFHF2DV7p7C/fmCeUIZV0nunv4lwLYcrz/sSwdkimfoM8
	 jC2dhnZrHR8jLCb/54OSe2hYv0gr9TQ+MdzZhPVjXrAUToFrZ77SrK/SK6OlMZ5WmyDcY
	 b5yANxZM6FrmdGREmYlpgp5luJRtgvNimFzYhs2XAdKBO9REEIw81tR0blkmfbSG1eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUiAKwhS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC71606A31D;
	Wed, 28 Oct 2026 18:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUiAKwhS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA451F01825;
	Wed, 28 Oct 2026 18:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210921;
	bh=EJprPCFR7BrKJHpqilsRxQOuWMHSHbiVtPOICveJ5EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUiAKwhSBO4e6ZHj/sXnASim83KPhzWz0RmrWTDjMG5L1+FVEGc+5Us+aFSULSQsT
	 UcB/EzTip5ogp+etj4QVeuYUR8Lj9ZVZQgqINpBkWeo7gyz9kt/o4CkWybfRgH4kdQ
	 zDO35S1SrryBNyhrJGNIl8Pq9VHX7XsySUJ5xoJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Salmun <salmundani@gmail.com>,
	=?UTF-8?q?Rapha=C3=ABl=20Larocque?= <rlarocque@disroot.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 196/571] Input: synaptics - limit T440p InterTouch quirk to LEN0036
Date: Wed, 28 Oct 2026 17:55:43 +0100
Message-ID: <20261028170012.658802463@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphaël Larocque <rlarocque@disroot.org>

commit f0fd8993082ca229faa3f9844f1c9fe182eca20b upstream.

The ThinkPad L440 also uses board id 2722, but does not have the SMBus
initialization problem seen on the T440p. On the L440, the SMBus
companion becomes available shortly after psmouse probes, allowing the
touchpad to use SMBus/RMI4 normally.

The T440p's quirk is currently applied to all Synaptics touchpads with
board id 2722, unnecessarily disabling SMBus InterTouch on the L440,
as reported by Daniel Salmun.

Restrict the quirk to PNP ID LEN0036, which identifies the T440p, so
that other devices sharing board id 2722 retain their normal
SMBus/RMI4 operation.

Reported-by: Daniel Salmun <salmundani@gmail.com>
Link: https://lore.kernel.org/all/20260925230039.236786-1-salmundani@gmail.com/
Fixes: 26eb3d92c7a4 ("Input: synaptics - disable InterTouch on ThinkPad T440p (board id 2722)")
Cc: stable@vger.kernel.org
Signed-off-by: Raphaël Larocque <rlarocque@disroot.org>
Link: https://patch.msgid.link/20260927005810.85971-1-rlarocque@disroot.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1809,8 +1809,10 @@ static int synaptics_setup_intertouch(st
 			return -ENXIO;
 		}
 
-		/* Disable intertouch on known-broken board revisions */
-		if (info->board_id == 2722) {
+		/* Disable intertouch on known-broken T440p board revisions */
+		if (info->board_id == 2722 &&
+		    psmouse_matches_pnp_id(psmouse,
+					   (const char * const []){"LEN0036", NULL})) {
 			psmouse_info(psmouse,
 				     "Disabling intertouch for board id %u\n",
 				     info->board_id);


