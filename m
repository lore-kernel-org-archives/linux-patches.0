Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA54C3164A1;
	Sun,  7 Jun 2026 11:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830177; cv=none; b=lK/FBFXz4Xc+1247vD1Y9I6viLA/6SomTZeE6oskRBe3a0Fz1o003xHL0iIz0eOitomWqV1+Boby4BaNKCPUU6p6o8DsfwhdBj+hkPWwy6pVsVHFO7YdKLEY9Ls9fzGRrXuomtM5mND8YACdgCP8vlw16oBVviRT5W3F6vOxa7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830177; c=relaxed/simple;
	bh=kCub6j5+Q5/4sUkaP0VqDoKUrM9t86T+gSKkHQwmsEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aeh2IQ0go8WekjdWa/N0+6M0dd09kRCKB1LJMB3Ob3fMXNv6lV3I62oQa3VvZE4xPPsxQauA3OnkaZEFxcDGSmsiR8gz7oTxTgcTobvOhHPkxW6c/p2KzwC/cG+VUMcOnvpcXYV4KdTDxTUgN47REqpVeHNM541Irv80go3Zs/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gm+22GhC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gm+22GhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A6A1F00893;
	Sun,  7 Jun 2026 11:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830176;
	bh=5QdrlGK2Du2Iwe5EIncLd+FfwlJh6hR+HQ6MFjcDyRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gm+22GhCAaHIcYa4LkjPzIUe6J+JAsIflhFWnqqUbO48UdgIUgPs2zUBP9y25HzHv
	 PyfIFxpvHa5IpDIQvvtQPgu8Bf9JxcTwGa/1/DSqx6Tr/R7aYpaH7+BnRW5Oj5+bpv
	 T7bW7ImcvvAg2DoFSixGLECVafMleO/JQOz2APVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Sasha Levin <sashal@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 6.12 299/307] usb: typec: ucsi: Dont update power_supply on power role change if not connected
Date: Sun,  7 Jun 2026 12:01:36 +0200
Message-ID: <20260607095738.729109254@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>

[ Upstream commit d98d413ca65d0790a8f3695d0a5845538958ab84 ]

We only need to update the power_supply on power role change if the port
is connected, because otherwise the online status should be the same for
both cases.

Cc: stable <stable@kernel.org>
Fixes: 7616f006db07 ("usb: typec: ucsi: Update power_supply on power role change")
Signed-off-by: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
Reported-and-tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://patch.msgid.link/20260519-ucsi-fix-2-v1-2-6f1239535187@qtmlabs.xyz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ This is documentation for an already-completed backport. The change is described clearly.

"translated upstream `UCSI_CONSTAT(con, CONNECTED)` accessor macro to in-tree idiom `con->status.flags & UCSI_CONSTAT_CONNECTED`" ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1233,7 +1233,12 @@ static void ucsi_handle_connector_change
 
 	if ((con->status.change & UCSI_CONSTAT_POWER_DIR_CHANGE) && role != prev_role) {
 		typec_set_pwr_role(con->port, role);
-		ucsi_port_psy_changed(con);
+
+		/* Some power_supply properties vary depending on the power direction when
+		 * connected
+		 */
+		if (con->status.flags & UCSI_CONSTAT_CONNECTED)
+			ucsi_port_psy_changed(con);
 
 		/* Complete pending power role swap */
 		if (!completion_done(&con->complete))


