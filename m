Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC8A2F83C3;
	Mon, 10 Nov 2025 20:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762808144; cv=none; b=UDQmuaFbA7apWx+R6MQUgfsC4t7pVAAgnlCRTkn88WxL1zodWIvetCoh5udvhbzRFYX9eIWeV3A1J/9EP8CNdO6LsXVbVXpuetofUKGuJOMFU+MDskooOZ75YxBNOUZ+Zw6rIT4icss2u5v85FxvAGfrYyBjWRbBhi2ftpWreME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762808144; c=relaxed/simple;
	bh=YGwndXDVfw313ofFvJKijTm0xMqmknLKipL/FYTW6Uk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=L+cbwiyoy+PVHYLp+iU8Nty8MTBQ30hnqUhP/3vHZRZ3CtIzv9alncXkCBkCM9bvv/JnGkXYV6HWbEoBogy1qfSuQ6GaGdqYV9teNaljogyqnCQxzNDCpxweHIA5VObuqkTCkUUYHuXFoOhyEcZo9k6f1OwW0fN2+VZoM61au6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QcOtzwgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QcOtzwgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAE7C113D0;
	Mon, 10 Nov 2025 20:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762808143;
	bh=YGwndXDVfw313ofFvJKijTm0xMqmknLKipL/FYTW6Uk=;
	h=From:Date:Subject:To:Cc:From;
	b=QcOtzwgxX0m2Cd2j4GyjQOrKbGRga4McuYApdEnHSkrjQPaS+XaiBc46Jw/GOUCxC
	 Vhd02uLuw8WatRi8PCRpJEPnMx8QYaZ+7cFGctTtyGaKYAVkn3Erzz0HG4sSfxtzXr
	 jXVb5LvUzggiQTIuFTtY+WBIPn5O3y2t6+v4+UtOAqMnGTVkShVv+RJ5bjS/8aydQh
	 BMDQLg5nNHKmwPIcJf2k5lAa8kVGIsUhGjc8egH4FywiO+pXnkKRXOkMB/gJV3mp1N
	 0mENLdf0P2PuSBDuYgF2Q6Ct50c0E3sikZPZxZ1zK24fD2sBdfBE3eLwBmXx3/0IyC
	 6ZlmtmKi3HJtg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 10 Nov 2025 13:55:34 -0700
Subject: [PATCH net-next v2] net: netcp: ethss: Fix type of first parameter
 in hwtstamp stubs
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251110-netcp_ethss-fix-cpts-stubs-clang-wifpts-v2-1-aa6204ec1f43@kernel.org>
X-B4-Tracking: v=1; b=H4sIAEVREmkC/5WOUQ6CMBBEr0L22zVtxYB+eQ9DTClbaCRAuhUxh
 Lu7cgM/Z2b3zazAFAMxXLMVIs2BwziIMIcMXGeHljA0osEoc9ZaFThQctODUseMPizopsTI6VU
 zul4e8B38z2p8UXqvm9wWNQhtiiTne9MdBCKgJUElSRc4jfGzT5j1nv/dNmvUaEtlT8rl5mLL2
 5PiQP1xjC1U27Z9ASzjNY3pAAAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3570; i=nathan@kernel.org;
 h=from:subject:message-id; bh=YGwndXDVfw313ofFvJKijTm0xMqmknLKipL/FYTW6Uk=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJlCgT4iKSma9h+d9s8ISJx4bmW/5pfE1m9FS77Y/db5F
 TJ/c++2jlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjARwW5Ghv9qmf3PVl9Ol5ws
 ZJU5Q+7pnNot/bvlrt99kvBNsnvZ/r0M/4w+S4ddT/1eWua7waP9wYYlyTwXcxaopps4m/ZoHX2
 4kAMA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building without CONFIG_TI_CPTS, there are a series of errors from
-Wincompatible-pointer-types:

  drivers/net/ethernet/ti/netcp_ethss.c:3831:27: error: initialization of 'int (*)(void *, struct kernel_hwtstamp_config *)' from incompatible pointer type 'int (*)(struct gbe_intf *, struct kernel_hwtstamp_config *)' [-Wincompatible-pointer-types]
   3831 |         .hwtstamp_get   = gbe_hwtstamp_get,
        |                           ^~~~~~~~~~~~~~~~
  drivers/net/ethernet/ti/netcp_ethss.c:3831:27: note: (near initialization for 'gbe_module.hwtstamp_get')
  drivers/net/ethernet/ti/netcp_ethss.c:2758:19: note: 'gbe_hwtstamp_get' declared here
   2758 | static inline int gbe_hwtstamp_get(struct gbe_intf *gbe_intf,
        |                   ^~~~~~~~~~~~~~~~
  drivers/net/ethernet/ti/netcp_ethss.c:3832:27: error: initialization of 'int (*)(void *, struct kernel_hwtstamp_config *, struct netlink_ext_ack *)' from incompatible pointer type 'int (*)(struct gbe_intf *, struct kernel_hwtstamp_config *, struct netlink_ext_ack *)' [-Wincompatible-pointer-types]
   3832 |         .hwtstamp_set   = gbe_hwtstamp_set,
        |                           ^~~~~~~~~~~~~~~~
  drivers/net/ethernet/ti/netcp_ethss.c:3832:27: note: (near initialization for 'gbe_module.hwtstamp_set')
  drivers/net/ethernet/ti/netcp_ethss.c:2764:19: note: 'gbe_hwtstamp_set' declared here
   2764 | static inline int gbe_hwtstamp_set(struct gbe_intf *gbe_intf,
        |                   ^~~~~~~~~~~~~~~~

In a recent conversion to ndo_hwtstamp, the type of the first parameter
was updated for the CONFIG_TI_CPTS=y implementations of
gbe_hwtstamp_get() and gbe_hwtstamp_set() but not the CONFIG_TI_CPTS=n
ones.

Update the type of the first parameter in the CONFIG_TI_CPTS=n stubs to
resolve the errors.

Fixes: 3f02b8272557 ("ti: netcp: convert to ndo_hwtstamp callbacks")
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Changes in v2:
- Rewrite commit message, as this issue is visible with just
  -Wincompatible-pointer-types with both clang and GCC. I have an out of
  tree patch to build with -Wincompatible-function-pointer-types-strict
  locally applied, which actually changes the type of warning emitted in
  this case... https://godbolt.org/z/WGb1cYqod
- Carry forward Vadim's reviewed-by, as the code fix is unchanged.
- Link to v1: https://patch.msgid.link/20251107-netcp_ethss-fix-cpts-stubs-clang-wifpts-v1-1-a80a30c429a8@kernel.org
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

