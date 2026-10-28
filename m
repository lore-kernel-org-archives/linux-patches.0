Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208631;
	b=Fam1QeQwI2LfTaZWia4bxTQ2Nb6GOJ15TzKXm8cggZLkRsS0iJxvlN4O+EfdN7uYBO1m
	 1AvAhjTx+MsqZMB90eZmI+mTT0FGrN7j659Yt7AE7RoVowV6k8U2XON5wCZ07xSr+yKFw
	 C111ZOmbQdkHeAsY8+eT0Ze4mjyKnBZ+yhTWfSb57D45VOZoSxDl6ApTY39rdMP5kf3o8
	 tNSWcwdooc+t8WfVQz2mYrioHnhC2MgVxd9sJl/pHj2XYspCMpJOEtLOWyWzAtpCXCA3p
	 7miuYatxBocVZ48Ibfr2U2cBogZYjSePWeZj+Fjy76aG67r1x3Qgq5kmThluygOnRhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vw+9zy8SF2rddUeffamwVx76TjX0nY4mybiwoAETYPg=;
	b=3o+ZdN5/cDyxy7dFwdlKjHikEwwcF6W2Vbw5NpkOyjTmbcr1UNba9+bs5QWpFw14upiv
	 koVYrHroPxYbt/RlotbDbWIVqDz8VQE4LopTeyI+9rC92xAKLYgkuWGQQiR/AQhwHEi4U
	 E/ekC6yCaxom3XKd9xvV33JrY8/4f+Nq2yRPWT13iA7feWMq4YAt+UwgLrJvZYvyHbJI2
	 7oxcwiNx/35QGMapWKYufqXfZ9T8WhF0eMH+O1bmoqc3E2K7pqIlyy4WIOU9DvXDud2EC
	 LFrc9kU9+XjTga95YH7WjRNJ/IqXTgcmLYBzpzx9/zO6ybcBoJ8QvJTvT2iLz7vDuJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruzXLvjR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC97D606A31A;
	Wed, 28 Oct 2026 17:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruzXLvjR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079D41F01825;
	Wed, 28 Oct 2026 17:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208630;
	bh=vw+9zy8SF2rddUeffamwVx76TjX0nY4mybiwoAETYPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ruzXLvjRAwz9Mfxz0LTKGfAgxxBOFDkVCvQ+CMVaRfMQrkrMPE81iRkiNwCt2Yrzl
	 aXw4PbsDq3HvWMtBxhOv3NlCgJIyqpVicGW4ptdHXRPcDLGIrExIRDRQLlvZB2uZ2E
	 YClMWh6RhEy75Lbc35hgR41q4Sa6ERwj50DjjN68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Salmun <salmundani@gmail.com>,
	=?UTF-8?q?Rapha=C3=ABl=20Larocque?= <rlarocque@disroot.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 185/516] Input: synaptics - limit T440p InterTouch quirk to LEN0036
Date: Wed, 28 Oct 2026 17:55:37 +0100
Message-ID: <20261028170007.886588680@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1806,8 +1806,10 @@ static int synaptics_setup_intertouch(st
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


