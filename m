Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB51345EB9;
	Sat, 12 Sep 2026 15:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227635; cv=none; b=Be7eR0C5ivpSlCaXyO8J2Q2OGTXQZFaq1wlWDmGyPlTTE6g/O9eUCQGxpHKhkdPuMbTKBEbiQ7CsLZAo6G26Lw8PVKS0WHlON9cFMuIsTzyVJ9qHSXFLk6vehu9VkzLnNkI9XmZgwRZMyj1Fm3xk4kUT05pRCBXxD4HRzfuZJ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227635; c=relaxed/simple;
	bh=lXkeb+lSxhGgXvPDVv8ejwZxT0QACB6Fkkx53IIF8iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qu+NTV/rcDrJR/ByzgODymZA59LkL+JlQJj+wRrKXy3Vdl8CWNqJpHRvD0tS1IFp94CLqMeY3CZghE0AhvGYU25P6LBuG3r82Ct0V+GJ8fy5gh6tsmuCh0Gn/Op3SKPSbhdu95PkB4va+v7B1DCqyrr+80nWkpngdZq8Z+q2XJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlNTbSLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlNTbSLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EFD1F000FF;
	Sat, 12 Sep 2026 15:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227633;
	bh=CFEDx/OA9AuHflWRuA7InlBQ5mYr/AeVEeokz1eyZdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zlNTbSLj72Dnhc0EQ8Di3onMiqYjgTepAs4dYXSsadvE3WaC+kXI8TmoK433FqJab
	 kEn/qgDPrBstJYCAZ2238uNQ/s/Zq19PO3khMIRQbYYMTGDUiSrsRFMNHWyVzEw1Jk
	 lGojCkxtQiip7p3hdu693khme7RCi8bpqlPiVXhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.1 0194/1191] platform/x86: dell-wmi-sysman: Dont hex dump attribute security buffer
Date: Sat, 12 Sep 2026 08:48:42 +0200
Message-ID: <20260912065552.571319509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit 83c80495e45eddf64c6525fb582d8db68f256b71 upstream.

set_attribute() populates the security area of the BIOS attribute request
buffer with the current admin password via populate_security_buffer(), then
dumps the whole request buffer with print_hex_dump_bytes(). This can expose
the plaintext admin password in the kernel log.

The same issue was fixed for the password attribute path by
commit d1a196e0a6dc ("platform/x86: dell-wmi-sysman: Don't hex dump
plaintext password data"). Remove the remaining dump from the BIOS
attribute path.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260614045353.143500-1-sammiee5311@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-wmi-sysman/biosattr-interface.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/platform/x86/dell/dell-wmi-sysman/biosattr-interface.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/biosattr-interface.c
@@ -84,7 +84,6 @@ int set_attribute(const char *a_name, co
 	if (ret < 0)
 		goto out;
 
-	print_hex_dump_bytes("set attribute data: ", DUMP_PREFIX_NONE, buffer, buffer_size);
 	ret = call_biosattributes_interface(wmi_priv.bios_attr_wdev,
 					    buffer, buffer_size,
 					    SETATTRIBUTE_METHOD_ID);


