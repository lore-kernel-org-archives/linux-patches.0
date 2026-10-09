Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34383BB112;
	Fri,  9 Oct 2026 14:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556557; cv=none; b=iUOrcAVH10n1yVf18C50RSaVvcHH+eg0BRW80O+5evDZytGl9bpO8vnrsJ1aH11UWGw7DThgME9wPv/E0TBDnnJA/MV8BtFstLcscqWeb7ljxKTTWPlE8WQATjg8UcTB0g10RS7D6KwJ5PBao8IVCDNgNIRIee2vMgqyyC9qZnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556557; c=relaxed/simple;
	bh=W03Tbf2YRmCMDMIf1NzZGthOGJB/3kJQPvT6wYY9CJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BJrxsnBAFIKMPDpwEhsc6I5chtvK96FjIUp8nLPHRb1hC5QL/GWb/ZlgGuPA+Bbj0lQHnIjOubPj2J7MO8IPeILEqORySbNAEzxWi7zcCuJejVOTsNdRXQAHhahc9smhCs4zMWzmXgJkHFR/eeHYe0QxIpPnNVau+vJkOB1SWD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOmF8Fc9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOmF8Fc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7621F000FF;
	Fri,  9 Oct 2026 14:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556555;
	bh=KHZNWwZH21gFB7T+CnXQI+kozXo/90ZCW4UWrFshM9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DOmF8Fc9nwa6d2pfZV4jYc314DVk9xebDJWvb+ZU3n5InCc+q22BHXFJ4Q2pirAt6
	 /10S+ynXQoyD9pgfoPf6mVUgeUjaQbzEerMuZkXiJ/sKL9ejYWk1x/o3k6o5RwtkNC
	 72uBk8U9AyD4SYxmzIHwfkAjKybcTq8tNhcUqPeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Salmun <salmundani@gmail.com>,
	=?UTF-8?q?Rapha=C3=ABl=20Larocque?= <rlarocque@disroot.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 200/428] Input: synaptics - limit T440p InterTouch quirk to LEN0036
Date: Fri,  9 Oct 2026 16:08:57 +0200
Message-ID: <20261009140950.528559852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1839,8 +1839,10 @@ static int synaptics_setup_intertouch(st
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


