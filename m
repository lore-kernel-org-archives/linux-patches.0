Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9AF1FC7C5;
	Sat,  8 Nov 2025 03:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762571987; cv=none; b=X+g/apHNZX3B/1dHS6pknAKOkLz7+SH+76z8QEooPTdIY6OhDVgaFOBny9uuzQN8Zi1xOr0WaakNWobFze9tHsZj2I1Tjt6uIMRSd35JKzLjJrXGSnQP0GtdgZ0aLKPAcuiJmajmWOzeD7C6IZf8RGmdkwI9NnNqvfLe9o/GDE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762571987; c=relaxed/simple;
	bh=J+39KRxdHMJXiKENT50y17IkveIzch0K1Z4oKkpXH5A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=fNOC5AslSuPr4FZd8+xkCRYg/TD7PV5N1nMGRFXfzjAH0cw6mvCW8sBZXx5WP7kKK/3CMoIxgNqbmdczmR7cMwVJcUNnKoZEn831vZDf2sMkpnrhOpzuww8Bg0i+2kx686BO2Yx0wxhWP2SEowI1/AQklPxKeS7m8Aq0640W3Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDrVNcuq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDrVNcuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBAFC19421;
	Sat,  8 Nov 2025 03:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762571986;
	bh=J+39KRxdHMJXiKENT50y17IkveIzch0K1Z4oKkpXH5A=;
	h=From:Date:Subject:To:Cc:From;
	b=mDrVNcuqsTYohvmlFBSZB5HdIj0bmjjexaKeZ04SwIDerEPqgb80aKBcp2pkybPFy
	 q1TQxk5lHmD/aoJgRciOOWeyDGf1+4xcU0o5Y76za+RTP1IBVHPb/1AN7XKnxYctLQ
	 byoqOAYVCq+JvTpaQkxvJXXoIlb1CUPPb9hahWZK4W7owjAs0sxmHHPTedCpkz4XVw
	 hP88kPo0TaFBg5/l99FXCwgNH8io2tRv0Aq64ME9HiRzP3Wl5nK/BuJ6rXR711e86U
	 pFMx2YzF7M20HXNynDugRlBKPV/mxkwrU6oB5CfcLHxAPe12d0o0E0yZ3oXYIgxPdU
	 5YShb66MqcSgw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 07 Nov 2025 20:19:37 -0700
Subject: [PATCH net-next] net: netcp: ethss: Fix type of first parameter in
 hwtstamp stubs
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251107-netcp_ethss-fix-cpts-stubs-clang-wifpts-v1-1-a80a30c429a8@kernel.org>
X-B4-Tracking: v=1; b=H4sIAMi2DmkC/x2NUQrCQAxEr1LybaBblBWvIiLtbmIDsi6bVAuld
 zf6+YaZNxsoNSGFS7dBo7eovIpDOHSQ5rE8CCU7w9APpxD6iIUs1TvZrIosK6ZqimrLpJiePsC
 P8C/KHM/MIR/HOIHbaiOv/5+u4BIXrQa3ff8CfCOBWoMAAAA=
X-Change-ID: 20251107-netcp_ethss-fix-cpts-stubs-clang-wifpts-df78ff1d4a7b
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
 Kory Maincent <kory.maincent@bootlin.com>, netdev@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3551; i=nathan@kernel.org;
 h=from:subject:message-id; bh=J+39KRxdHMJXiKENT50y17IkveIzch0K1Z4oKkpXH5A=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJl8284XVK1IsXtwSX3bhMkfzEX7zUocVod+OyTnceTpU
 udAx71tHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAim5cz/GYRWflt46xtd+f4
 lR/fuPPcP4/zDe1XlX9rvj1+ZlFIas5VRoZuz/+3PrPXMLzf1xrHNalpTjJ30vWt578rtEXtDi1
 8coYBAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with -Wincompatible-function-pointer-types-strict, a
warning designed to catch control flow integrity violations at compile
time, there are several instances in netcp_ethss.c when CONFIG_TI_CPTS
is not set:

  drivers/net/ethernet/ti/netcp_ethss.c:3831:18: warning: incompatible function pointer types initializing 'int (*)(void *, struct kernel_hwtstamp_config *)' with an expression of type 'int (struct gbe_intf *, struct kernel_hwtstamp_config *)' [-Wincompatible-function-pointer-types-strict]
   3831 |         .hwtstamp_get   = gbe_hwtstamp_get,
        |                           ^~~~~~~~~~~~~~~~
  drivers/net/ethernet/ti/netcp_ethss.c:3832:18: warning: incompatible function pointer types initializing 'int (*)(void *, struct kernel_hwtstamp_config *, struct netlink_ext_ack *)' with an expression of type 'int (struct gbe_intf *, struct kernel_hwtstamp_config *, struct netlink_ext_ack *)' [-Wincompatible-function-pointer-types-strict]
   3832 |         .hwtstamp_set   = gbe_hwtstamp_set,
        |                           ^~~~~~~~~~~~~~~~
  drivers/net/ethernet/ti/netcp_ethss.c:3850:18: warning: incompatible function pointer types initializing 'int (*)(void *, struct kernel_hwtstamp_config *)' with an expression of type 'int (struct gbe_intf *, struct kernel_hwtstamp_config *)' [-Wincompatible-function-pointer-types-strict]
   3850 |         .hwtstamp_get   = gbe_hwtstamp_get,
        |                           ^~~~~~~~~~~~~~~~
  drivers/net/ethernet/ti/netcp_ethss.c:3851:18: warning: incompatible function pointer types initializing 'int (*)(void *, struct kernel_hwtstamp_config *, struct netlink_ext_ack *)' with an expression of type 'int (struct gbe_intf *, struct kernel_hwtstamp_config *, struct netlink_ext_ack *)' [-Wincompatible-function-pointer-types-strict]
   3851 |         .hwtstamp_set   = gbe_hwtstamp_set,
        |                           ^~~~~~~~~~~~~~~~

While 'void *' and 'struct gbe_intf *' are ABI compatible, hence no
regular warning from -Wincompatible-function-pointer-types, the mismatch
will trigger a kCFI violation when gbe_hwtstamp_get() or
gbe_hwtstamp_set() are called indirectly. The types were updated for the
CONFIG_TI_CPTS=y implementations but not the CONFIG_TI_CPTS=n ones.

Update the type of the first parameter in the CONFIG_TI_CPTS=n stubs to
resolve the warning/CFI violation.

Fixes: 3f02b8272557 ("ti: netcp: convert to ndo_hwtstamp callbacks")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/ethernet/ti/netcp_ethss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index 0ae44112812c..4f6cc6cd1f03 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -2755,13 +2755,13 @@ static inline void gbe_unregister_cpts(struct gbe_priv *gbe_dev)
 {
 }
 
-static inline int gbe_hwtstamp_get(struct gbe_intf *gbe_intf,
+static inline int gbe_hwtstamp_get(void *intf_priv,
 				   struct kernel_hwtstamp_config *cfg)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int gbe_hwtstamp_set(struct gbe_intf *gbe_intf,
+static inline int gbe_hwtstamp_set(void *intf_priv,
 				   struct kernel_hwtstamp_config *cfg,
 				   struct netlink_ext_ack *extack)
 {

---
base-commit: 01c87d7f48b4f9b8be0950ed4de5d345632bd564
change-id: 20251107-netcp_ethss-fix-cpts-stubs-clang-wifpts-df78ff1d4a7b

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

