Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54B533F59D;
	Wed, 20 May 2026 17:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297580; cv=none; b=VQglFBGNMmzhsTi8nLg/4i5RuCrCKzrCFlFpf6kH5t2np+4zM2lF9Zk1nTPr/nHc9CFuZ8dVwz6eNuiumstyxvmpsls0FF+lztyvIxkSdySgU08+N1zjpeM4ALZghik8tVCADpZfVdWvcvVlHFPDrk1tGTm+C40E24/PpHC+mB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297580; c=relaxed/simple;
	bh=7/Bv/Zqx+kloyBZx8kbzGSMNhxRdjJtj3KS4hrZ/cms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OcN0VABvO0foS2S7p+/iCG1gHkI7XRQqRrmrM0Un15NeJ0RYULlogrEcLOPnvPNuf/HKZcfvE45woQ7ItEqsS5lz9Prf0bOBHlx6zPG+i6REGvC7PAwrbRvaPoaTKalItkzrz2ZijaiteCNoWs+CdG8Oto1vnqoT9CEoE5baMao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvXPSx+Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvXPSx+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E941F000E9;
	Wed, 20 May 2026 17:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297579;
	bh=uGQ70LmcxSkX8bOnSM4QiLIWrU/pd99vZ+Cl+EPmwIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvXPSx+QbIeVSP2O/ghbX7m6Lwqf/wNeY4rik74Vy1HZKR4lctMnWe8n9Q2Pzkemc
	 lCnOn6iiom0b4YMVBzLX1/g+6Da77wBLFQ00Sgs6gxGOE0oQMxddWcChQiOPB+mxbm
	 I0nw4rT6pFZCR5IjsVEb1C7DGdHZXUW6PW6Em3n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh=20 ?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/957] scripts/gdb: timerlist: Adapt to move of tk_core
Date: Wed, 20 May 2026 18:08:46 +0200
Message-ID: <20260520162135.492813189@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>

[ Upstream commit 5aa9383813aca45b914d4a7481ca417ef13114df ]

tk_core is a macro today which cannot be resolved by gdb.

Use the correct symbol expression to reference tk_core.

Fixes: 22c62b9a84b8 ("timekeeping: Introduce auxiliary timekeepers")
Signed-off-by: Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260311-hrtimer-cleanups-v1-1-095357392669@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/timerlist.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/timerlist.py b/scripts/gdb/linux/timerlist.py
index ccc24d30de806..9fb3436a217cc 100644
--- a/scripts/gdb/linux/timerlist.py
+++ b/scripts/gdb/linux/timerlist.py
@@ -20,7 +20,7 @@ def ktime_get():
     We can't read the hardware timer itself to add any nanoseconds
     that need to be added since we last stored the time in the
     timekeeper. But this is probably good enough for debug purposes."""
-    tk_core = gdb.parse_and_eval("&tk_core")
+    tk_core = gdb.parse_and_eval("&timekeeper_data[TIMEKEEPER_CORE]")
 
     return tk_core['timekeeper']['tkr_mono']['base']
 
-- 
2.53.0



