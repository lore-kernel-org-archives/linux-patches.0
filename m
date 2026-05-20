Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3986933BBAF;
	Wed, 20 May 2026 16:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294486; cv=none; b=rfUN599zvYUsw4IkMsf2m+xkf9mNgKirYbjTlTgjYnGi1FalyCkqmkGFRgzQEvZkFV2eGHvA+60aKiDnU8lMMQNAIQBMSd9WGI1AV4iMxsUs/xzVR0rhf9fTnVPW4fFeY3CCoAUVCA64a1izBiTEBN4PZQLYM2kGYS71GYOdR/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294486; c=relaxed/simple;
	bh=zgmeBU3aW7YWnM5yAQZhVT6/OgkBlpFKgI6bq9LkhCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lJHCnS5PKa4FFKScLfzvtz90MB0i7+dmVoxnWkuDNl7T0TzCRKROTcW3nWr8ReIexXv1nHY0cuLcTiGo1hgXBnecB1uv3JtuEmznJCen+6WfOOo69JU1oISsj9C3h7cuiyPW9HI5L4il04/cCqxy5ocQjkr+FAL9QXf//pV0wh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlwBVEOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlwBVEOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8441F000E9;
	Wed, 20 May 2026 16:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294484;
	bh=19PmePU3AI7AT4U2PAldwVDa6mlmeRHeIekHZTS3F50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wlwBVEOr5UzG4UxLS6rOhJY21OAYenLYadVwChnRYiQUNwSqFOfxQw70V20Ui9EC7
	 Uf6aCzi2ITKjXD8mcYwPu/vIULH3oFzimlrDINSlukE8Kz4MzRs8dGzvgNJFIzqZG3
	 ndNZyscbA+0teVLmrJkgbRFOYPNv90XiChXAl9Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh=20 ?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0057/1146] scripts/gdb: timerlist: Adapt to move of tk_core
Date: Wed, 20 May 2026 18:05:07 +0200
Message-ID: <20260520162149.663594347@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



