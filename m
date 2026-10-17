Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8BC3B531D;
	Sat, 17 Oct 2026 17:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256506; cv=none; b=Nvgre3qvxv55HsDKgfox1uEVJP7lIwKM5knSOkEdKTiKrAJylCeFMP904ChkXxCcUJBH8Eri2MkMryKb+oRSKWFBjg5WTdcrn5CWC29iZe+EaJRQVXr7PQcS9F1WeMm860O+Ou9Lns44iEyb/2Yx2+ExHKlIWlkkkckNfYVfSoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256506; c=relaxed/simple;
	bh=h+hWit3qD9H48x9B6A6TgPKllnIVi8QWL+vhnVM21l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F21z7odvFIvELFlh+TUASJLoVeObSkurH22h4FTQd8u/Kv7RJKpITPBSxFkjJpiQMA/PTqqHWiMIPHjd8rMM7IzXyY7yfL9fQDspAVDNe6/zqnHqIfCz7Wwjfeqrby8Ttc+/xJrqblyWQCrBj/sqcjswfLiinQVtPoXVoL/w6EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbdWXJJb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbdWXJJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F2D1F000C4;
	Sat, 17 Oct 2026 17:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256505;
	bh=24h0YGn3KNr2+PddOoQJ1FyDB4ivVR5xl/+pJHge//E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AbdWXJJbFZ68sPPeQCLI3l3aL9fyPEeq1kn318gXGmcmg1WFFtR5zPE33f1THCwNp
	 Ly6kxSGgWoMAbGrykH1/PgO7KA7XW99GSlJ/gpi1RenE4knJG13ZD1wo07pe6z85Hw
	 P38i9srRmAIveGB47jELuEpU6R3xFazlaHQ5j78w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Rosencutter <rosencutter@gmail.com>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0251/1674] Input: synaptics - add LEN205b entry to smbus_pnp_ids for ThinkPad T490
Date: Sat, 17 Oct 2026 17:42:03 +0200
Message-ID: <20261017160437.569519001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>

commit a961417c5ae77bbb728a23d9577ecd8f4d8a4b5a upstream.

Lenovo ThinkPad T490 has a Synaptics Touchpad that supports SMBus/RMI4
mode, but is not listed in smbus_pnp_ids table.

Add LEN205b to smbus_pnp_ids[] passlist.

Reported-by: John Rosencutter <rosencutter@gmail.com>
Closes: https://lore.kernel.org/all/CAOGuaRh025eKcBf9P8UrvtXNp68vQ0HVF2EbNMp-kpdaC1HNpA@mail.gmail.com/
Signed-off-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Link: https://patch.msgid.link/20260920200730.1836756-1-lovekeshsolanki00@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -190,6 +190,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"LEN2058", /* E490 */
+	"LEN205b", /* T490 */
 	"LEN2068", /* T14 Gen 1 */
 	"SYN1221", /* TUXEDO InfinityBook Pro 14 v5 */
 	"SYN3003", /* HP EliteBook 850 G1 */


