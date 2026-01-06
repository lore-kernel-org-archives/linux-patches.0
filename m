Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20473570AB;
	Tue,  6 Jan 2026 17:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721529; cv=none; b=teGrE4qGj9epfJoX5+KYI8OXW+oCMVHTwj+jFx1rrpgADn0HBzuw0pZQoNryY6kpBnj/8pOkNQ+Fo7M2Amz60mR1DKD/vQqNR/MIlLWFaZuFlW65RUSM53Lulz1qxik5OTfuOIxNN5VjdmzJU3K2upUJzWiPVz6fsHfqzGBsNec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721529; c=relaxed/simple;
	bh=widhpL04nxEoFVhuruKTjjeXOVXu1hBkcjX3zmPM4lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V3Y0ohjPyvvRlLsM33U5Wt1Uu0jFZNk4b69vL0njjantPdgmVdv4ylkNIOZIgRaV9V6WcKmoDJC7Vdvdlq0+ugNvPUqU0mM54wrtE1kJV8AiLh22C8gm51olOt69hkBJBnkWhEEn11MUkVfbS9PEsQ0ZIuMeO5hNtXrSPhw7nrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gh9JtCs8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gh9JtCs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C76C16AAE;
	Tue,  6 Jan 2026 17:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721529;
	bh=widhpL04nxEoFVhuruKTjjeXOVXu1hBkcjX3zmPM4lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gh9JtCs8BEKVubhXqTBK4qqLDQe1vQT0zyaTPbLjUuJcFn9Ms1UQEVcjeIPnB6Piy
	 +kYwOKKU7OwHhNgeimLKkFXV+ELOpps6uTnQqtDZYyinQxpbvoT0reBpwE7sxjGGgx
	 HvSmydyZjX05/SE5kFP5TF5N0DE283AMMUkTsBE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Subject: [PATCH 6.12 531/567] tty: fix tty_port_tty_*hangup() kernel-doc
Date: Tue,  6 Jan 2026 18:05:13 +0100
Message-ID: <20260106170511.039661203@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit 6241b49540a65a6d5274fa938fd3eb4cbfe2e076 upstream.

The commit below added a new helper, but omitted to move (and add) the
corressponding kernel-doc. Do it now.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Fixes: 2b5eac0f8c6e ("tty: introduce and use tty_port_tty_vhangup() helper")
Link: https://lore.kernel.org/all/b23d566c-09dc-7374-cc87-0ad4660e8b2e@linux.intel.com/
Reported-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Link: https://lore.kernel.org/r/20250624080641.509959-6-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/driver-api/tty/tty_port.rst |    5 +++--
 drivers/tty/tty_port.c                    |    5 -----
 include/linux/tty_port.h                  |    9 +++++++++
 3 files changed, 12 insertions(+), 7 deletions(-)

--- a/Documentation/driver-api/tty/tty_port.rst
+++ b/Documentation/driver-api/tty/tty_port.rst
@@ -42,9 +42,10 @@ TTY Refcounting
 TTY Helpers
 -----------
 
+.. kernel-doc::  include/linux/tty_port.h
+   :identifiers: tty_port_tty_hangup tty_port_tty_vhangup
 .. kernel-doc::  drivers/tty/tty_port.c
-   :identifiers: tty_port_tty_hangup tty_port_tty_wakeup
-
+   :identifiers: tty_port_tty_wakeup
 
 Modem Signals
 -------------
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -411,11 +411,6 @@ void tty_port_hangup(struct tty_port *po
 }
 EXPORT_SYMBOL(tty_port_hangup);
 
-/**
- * tty_port_tty_hangup - helper to hang up a tty
- * @port: tty port
- * @check_clocal: hang only ttys with %CLOCAL unset?
- */
 void __tty_port_tty_hangup(struct tty_port *port, bool check_clocal, bool async)
 {
 	struct tty_struct *tty = tty_port_tty_get(port);
--- a/include/linux/tty_port.h
+++ b/include/linux/tty_port.h
@@ -254,11 +254,20 @@ static inline int tty_port_users(struct
 	return port->count + port->blocked_open;
 }
 
+/**
+ * tty_port_tty_hangup - helper to hang up a tty asynchronously
+ * @port: tty port
+ * @check_clocal: hang only ttys with %CLOCAL unset?
+ */
 static inline void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
 {
 	__tty_port_tty_hangup(port, check_clocal, true);
 }
 
+/**
+ * tty_port_tty_vhangup - helper to hang up a tty synchronously
+ * @port: tty port
+ */
 static inline void tty_port_tty_vhangup(struct tty_port *port)
 {
 	__tty_port_tty_hangup(port, false, false);


