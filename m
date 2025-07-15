Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5523114C5B0;
	Tue, 15 Jul 2025 20:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752611624; cv=none; b=hPWN2AyK7SHVYpmsT/2m5oVtvywP/aKlO9oUV37liw8kzkRUgYhmdp6bMGiOxYLs0juGmi5bnrgaSmy7hyY40AZxfscRrHISy+AkmtSjCtZ2Abc45mzasvBgnaIvtXQMyb1t47jlVwZwjOR5yQ+2mASRGIv2M+dj8Ju0FmRx8Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752611624; c=relaxed/simple;
	bh=8tpCzL5oiRbCf6TONC2mLp87lm68V7p5K+gVlHvUvkM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=TGLH9Zb/GKDLh+QHf6gFIQ+ZehOW4Dwf1ym1wWk0RfCTO6uVZHhop62ifBtZWeVENDa22sQAUsL/+O0/9M0eKYm8TdvGREW1C0HVXQayTymfsYzqXbC5aFErciV0Jr2mIw5EqyM+/FlSbjFAY0hVPfgoTrT/cbznw9JUJCDEI+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehR5ztTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehR5ztTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DC3C4CEE3;
	Tue, 15 Jul 2025 20:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752611624;
	bh=8tpCzL5oiRbCf6TONC2mLp87lm68V7p5K+gVlHvUvkM=;
	h=From:Date:Subject:To:Cc:From;
	b=ehR5ztTixlsFC5diEwVDfGinQWEE3lyc6dIcxqojIv7lIw040XUbp9JAyJra+tvvH
	 uU4/0/QtEOVIWuJY9xXmCkwVBd5i6PA+F60ukfhRlxdwJSnjigGtLJrZZbyjKC8L3S
	 jk1sYu45Cis2RIu2DfXEq1o/p3ucCnz3CJApRkwL649DUyuAmeI3NU1jyIO41nEXQb
	 f+XaSur0i9RazSTw0MSlTMzxM378xnUaFqCYTXn4QrMudphMYVgEetJa+OZ58kpqwK
	 t+B+BpyQYwGNcHEY/WO34pg2vn0N0hXL37ILyK7Ddf5+6DyhTwYZu2+TkjWxWoPZ7i
	 AGcZLcwdQIMng==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 15 Jul 2025 13:33:32 -0700
Subject: [PATCH] usb: atm: cxacru: Zero initialize bp in
 cxacru_heavy_init()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250715-usb-cxacru-fix-clang-21-uninit-warning-v1-1-de6c652c3079@kernel.org>
X-B4-Tracking: v=1; b=H4sIABu7dmgC/x2N3QqDMAxGX0VyvUDb+YN7leFFjZkGRjdS6wTx3
 Q27+w4czndAZhXO8KgOUN4kyycZ+FsFtMQ0M8pkDMGFxnW+wZJHpD2SFnzJjvQ2CYPHkiTJir+
 oNmbs67ub+pbakTxY7Kts+v/oOZznBd+Fk8h4AAAA
X-Change-ID: 20250715-usb-cxacru-fix-clang-21-uninit-warning-9430d96c6bc1
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: accessrunner-general@lists.sourceforge.net, linux-usb@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2691; i=nathan@kernel.org;
 h=from:subject:message-id; bh=8tpCzL5oiRbCf6TONC2mLp87lm68V7p5K+gVlHvUvkM=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBllu9WkmsoXez8L+tZhH3J/bc001YSsOxuM9Hd3yBuX5
 qd9vTm/o5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEzk/hmGP1yrVimelbSXt0r7
 L1w7O9w+WuTd89C4dWt9jrMzTpBe3sbI8KDImfsbZ8T9EFdvu8zU+Oi1Ox9J9S1dJxqcn/jfzvA
 YDwA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After a recent change in clang to expose uninitialized warnings from
const variables [1], there is a warning in cxacru_heavy_init():

  drivers/usb/atm/cxacru.c:1104:6: error: variable 'bp' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
   1104 |         if (instance->modem_type->boot_rom_patch) {
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/usb/atm/cxacru.c:1113:39: note: uninitialized use occurs here
   1113 |         cxacru_upload_firmware(instance, fw, bp);
        |                                              ^~
  drivers/usb/atm/cxacru.c:1104:2: note: remove the 'if' if its condition is always true
   1104 |         if (instance->modem_type->boot_rom_patch) {
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/usb/atm/cxacru.c:1095:32: note: initialize the variable 'bp' to silence this warning
   1095 |         const struct firmware *fw, *bp;
        |                                       ^
        |                                        = NULL

This warning occurs in clang's frontend before inlining occurs, so it
cannot notice that bp is only used within cxacru_upload_firmware() under
the same condition that initializes it in cxacru_heavy_init(). Just
initialize bp to NULL to silence the warning without functionally
changing the code, which is what happens with modern compilers when they
support '-ftrivial-auto-var-init=zero' (CONFIG_INIT_STACK_ALL_ZERO=y).

Cc: stable@vger.kernel.org
Fixes: 1b0e61465234 ("[PATCH] USB ATM: driver for the Conexant AccessRunner chipset cxacru")
Closes: https://github.com/ClangBuiltLinux/linux/issues/2102
Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/usb/atm/cxacru.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index a12ab90b3db7..b7c3b224a759 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -1092,7 +1092,7 @@ static int cxacru_find_firmware(struct cxacru_data *instance,
 static int cxacru_heavy_init(struct usbatm_data *usbatm_instance,
 			     struct usb_interface *usb_intf)
 {
-	const struct firmware *fw, *bp;
+	const struct firmware *fw, *bp = NULL;
 	struct cxacru_data *instance = usbatm_instance->driver_data;
 	int ret = cxacru_find_firmware(instance, "fw", &fw);
 

---
base-commit: fdfa018c6962c86d2faa183187669569be4d513f
change-id: 20250715-usb-cxacru-fix-clang-21-uninit-warning-9430d96c6bc1

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

