Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B741DFD81;
	Tue,  8 Oct 2024 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394193; cv=none; b=B96mTtS0qfLTROR5IoR7tzLSekzIwmicHNeHkoPyd5H9Tc0C/z8Dgln4013GMHeoaok7LuODruyd6F8Nk49aBK+EtrxLKui0HW3uiDa3yeVtreL8ts1Acj2+F98daONeCEKu/YgGw9YI5i2Xwp9iGQB2nzhmlMjTbIJtBlaGEzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394193; c=relaxed/simple;
	bh=S/QWtSGfdLOXt6y9fmPsonwVEGYD5bIbZsi5ZG59V20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lzUCEvi7a4/W+LL1TaBBneZvTdLBpvvG0JbU14ZcwQIpoRG0ahw7Z/gpH0izlRNq5+qfKpcgI/DSJZAAisGXDsNUN0Qhb1TYgxffOWTmS9Do5+35t1qwWREsWgxjKipzbATIdIeOAqr9AsPLrpKr2lux9Vc/G915RnbcrkzSwuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1T0tU+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1T0tU+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5045DC4CECE;
	Tue,  8 Oct 2024 13:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394192;
	bh=S/QWtSGfdLOXt6y9fmPsonwVEGYD5bIbZsi5ZG59V20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1T0tU+jvNIT+S+oombewHoB+2cp0SGj0HrN5xgEC87R0trkhRaMtOS1svyOGMRMc
	 owSlPw+upq8rNZp2Erxm0ia//aqZmtLAeeDVURN8ILfmV6KuGLrU74xzwfpfukzyfe
	 BV8jQCNEDEtHppIltTS0OVKvoLl2R1gMJQWiARUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH 6.6 375/386] platform/x86: think-lmi: Fix password opcode ordering for workstations
Date: Tue,  8 Oct 2024 14:10:20 +0200
Message-ID: <20241008115644.146726966@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 6f7d0f5fd8e440c3446560100ac4ff9a55eec340 ]

The Lenovo workstations require the password opcode to be run before
the attribute value is changed (if Admin password is enabled).

Tested on some Thinkpads to confirm they are OK with this order too.

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Fixes: 640a5fa50a42 ("platform/x86: think-lmi: Opcode support")
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240209152359.528919-1-mpearson-lenovo@squebb.ca
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
(cherry picked from commit 6f7d0f5fd8e440c3446560100ac4ff9a55eec340)
[Harshit: CVE-2024-26836; Resolve conflicts due to missing commit:
 318d97849fc2 ("platform/x86: think-lmi: Add bulk save feature") which is
 not in 6.6.y]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/think-lmi.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -1021,7 +1021,16 @@ static ssize_t current_value_store(struc
 		 * Note - this sets the variable and then the password as separate
 		 * WMI calls. Function tlmi_save_bios_settings will error if the
 		 * password is incorrect.
+		 * Workstation's require the opcode to be set before changing the
+		 * attribute.
 		 */
+		if (tlmi_priv.pwd_admin->valid && tlmi_priv.pwd_admin->password[0]) {
+			ret = tlmi_opcode_setting("WmiOpcodePasswordAdmin",
+						  tlmi_priv.pwd_admin->password);
+			if (ret)
+				goto out;
+		}
+
 		set_str = kasprintf(GFP_KERNEL, "%s,%s;", setting->display_name,
 				    new_setting);
 		if (!set_str) {
@@ -1033,13 +1042,6 @@ static ssize_t current_value_store(struc
 		if (ret)
 			goto out;
 
-		if (tlmi_priv.pwd_admin->valid && tlmi_priv.pwd_admin->password[0]) {
-			ret = tlmi_opcode_setting("WmiOpcodePasswordAdmin",
-						  tlmi_priv.pwd_admin->password);
-			if (ret)
-				goto out;
-		}
-
 		ret = tlmi_save_bios_settings("");
 	} else { /* old non-opcode based authentication method (deprecated) */
 		if (tlmi_priv.pwd_admin->valid && tlmi_priv.pwd_admin->password[0]) {


