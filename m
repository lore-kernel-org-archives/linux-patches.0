Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525604F7980;
	Tue, 13 Oct 2026 12:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895014; cv=none; b=UkbTV0uczsZ0yzq1UpfBAfrzcatJwbA73HoCeVUE2QnCHmRmT7HamSf4S5lZuoopAItZTK2lIw6veB/38ydICXb1TfFjpmDKlfbihYLoWfOAHAAyyKbuCADKjGEjbMhhA2TPQY7DfjNFs2wG20Y4+aXPudV6irGJiz68Eu4ytJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895014; c=relaxed/simple;
	bh=Vr4cpSs1e72ioVVYxPPnMdwfUngcd4TGKAB3bk79b4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M0f5vJ2+kLDlu0pBKQtctXG1ZV6c7gvbilrDLBubOETlcG2zudsK13Z4ulFF5N8bF1qapbElBL6Ycvz2VsqbSzIWp8PLK506CF2n2Kye3Bf2IsqLYcmNKfGRwv/fSDh1GfOkv7F+OPGDrDcgY+BMZVcCBlOoIn8CQJEP53Hb5sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUjcAl8A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUjcAl8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6868E1F000FF;
	Tue, 13 Oct 2026 12:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895013;
	bh=MViipT/eRPNte7h8yk8Wy0rbbtLoXwuvwLWDcgH+0rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UUjcAl8AkjMNSfkZhC3tO9wSK7EH5ZmhTNY5dr+h6RjS0H/qpeC1/+TfwBBt11xbB
	 ZxP02iA2/PEmPG+7FMesDfE0JKmwTgYjHbGou1vqGTmA/I7f7nNVvomZfrRCJZGQEb
	 LIBO2toSR6Gk3hCGtVzjk4Mj3P4hNycQOZqv4kD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Salmun <salmundani@gmail.com>,
	=?UTF-8?q?Rapha=C3=ABl=20Larocque?= <rlarocque@disroot.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 130/497] Input: synaptics - limit T440p InterTouch quirk to LEN0036
Date: Tue, 13 Oct 2026 13:34:57 +0200
Message-ID: <20261013112910.975677311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


