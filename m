Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065165;
	b=P24T1lRgqzrp4oih1ibk0UN3fRpt0YuCxi0afFbWGanIByXf7V4LsZwNA2s7WTb2aCa3
	 dycIADwx+rZdH6F71jvtrKqq6a2lFEeb29ZfEgK5+CudRfq5X2UJMxi5XIEiLWUBTENEQ
	 tuEUnD9h7kYDtptL9WQGJriqFi33ePByTmX8HoG6FCk9om+O8AmXA4BgymGx+VO++mEPu
	 u0LGBQAcOQ8QLz0Dy3DA4Um1L7XXmqsjQUiMB7lEnum349l/VNh5XL1EGpVQtB93bI9KY
	 PCtKTPD70pGafhn8Ml94o8REd/a3YAX+TiuOiXYZ+momSEeQxbAD2P3MG4jzzNEG/Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GtpbhzghIX0As2PIaOxBJTq4H2SxGqfNXOyBgFl4+N0=;
	b=f33JgyEql5tKIQYmAedR6Y0T3iBJ8CCnQf/MpTaI5FABRXU9D5vO+OSmx8sUfKHNP1c5
	 i73C41FOP8txjeQHzyFPjsrp3dOzHpaPXLBNYKw3IqH0OfZOb+kjEgveegLyE1tcGnbcu
	 5N0SC4ebSyhH/HFimGOhQPA+Bd9NoRK97pqlDTVeeDhf+NjsoHhgnrvejas7lvNi3AiXY
	 jPKnSpSCWWhQ9WgoiBrrNohPs6btlzGwiBtX7M8uNIPBdVhUyN++/jStG35s1iXwd4OTY
	 D7inI7a+UQHSHwvzse2AAZdKe4mh24Z2kJQJjXWcu5QkQ6l6Fcuk/O/0ttyYrlhqnbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m7UUHqMw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80A4606A32E;
	Sat,  7 Nov 2026 15:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m7UUHqMw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B021F0089F;
	Sat,  7 Nov 2026 15:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065164;
	bh=GtpbhzghIX0As2PIaOxBJTq4H2SxGqfNXOyBgFl4+N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m7UUHqMwElQmE2xgFzhOoHSwsOTPJ2nTAqecy9i/sehUMGWU7q130Rhs8d+HjjoQz
	 kFGUhTWjzd8wCEtYfO2AXD08CJT2bLQWCoMtsb7sSBG8Bzb48SoElUWlE/jy0CTNaR
	 V0lj+JySM7nhjpMOkrN97dUppCKlJOiEnIIR16+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeswanth Krishna Tellakula <yeswanth@linux.ibm.com>,
	Kees Cook <kees@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0970/1257] netdev: Hide the netdev_priv() origin from GCC in netdev_from_priv()
Date: Sat,  7 Nov 2026 08:54:26 -0500
Message-ID: <20261107135006.147347785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 56f8d919739b588e2ad8cb9fb9eff704f32afaab ]

GCC 15.1 and later can compute an object size of 0 for a pointer that
container_of() derives from a pointer into a __counted_by flexible array
member[1]; Clang gets it right. netdev_from_priv() does this with struct
net_device's "priv" array, so when GCC can see that its argument came
from netdev_priv(), FORTIFY_SOURCE sees a zero-sized net_device. Since
commit 9027497a25e3c ("team: use netdev_from_priv()"), adding a port of
another type to a team device can then fail the memcpy() to
"dev->broadcast" in team_setup_by_port(), which GCC sees through after
inlining team_port_add() into team_add_slave():

  memcpy: detected buffer overflow: 4 byte write of buffer size 0
  ...
  kernel BUG at lib/string_helpers.c:1044!
  ...
  Call Trace:
   <TASK>
   team_add_slave.cold+0x88/0x201
   do_set_master+0x11c/0x180
   do_setlink.isra.0+0x3a4/0x1410

Whether GCC inlines that far depends on the architecture and the
configuration. It does on ppc64le, where this was reported, and on
x86_64 with defconfig plus hardening.config or with Debian's
configuration, but not with allmodconfig.

Hide where "priv" came from with OPTIMIZER_HIDE_VAR(), so GCC sees a
net_device of unknown size whose members have their declared sizes. (An
"unknown" size is considered uncheckable by FORTIFY.)  FORTIFY still
bounds writes to members; only the whole-object size becomes unknown,
as it already is for any net_device pointer GCC can't trace to its
allocation. In an extracted PoC, the __builtin_dynamic_object_size()
of "dev->broadcast" for the two types FORTIFY sees, before and after
this patch:

                                   GCC 16.2.0      Clang 22 and 24
                                 before   after
  plain pointer, whole object   unknown  unknown        44
  container_of(), whole object        0  unknown        44
  container_of(), member              0       32        32

In addition to getting the bogus "0" fixed in GCC, I'll be following up
to solve the whole-object visiblity disparity as well.

Build tested with GCC 16.2.0: ARCH=x86_64 defconfig with hardening.config,
CONFIG_NET_TEAM=y, and CONFIG_NET_IPGRE=y; ARCH=arm64 defconfig with
hardening.config, CONFIG_NET_TEAM=y, CONFIG_PPP=y, and CONFIG_NET_AIROHA=m;
and drivers/net/team/, drivers/net/ppp/, and drivers/net/ethernet/airoha/
in ARCH=x86_64 allmodconfig. Under QEMU, the x86_64 kernel hits the BUG
above when adding the GRE fallback device "gre0" as a port of a new team
device without this patch, and adds it with the patch.

Reported-by: Yeswanth Krishna Tellakula <yeswanth@linux.ibm.com>
Closes: https://lore.kernel.org/all/3ad19e86-234c-408f-896e-0d6c774fea49@linux.ibm.com/
Fixes: 9027497a25e3c ("team: use netdev_from_priv()")
Cc: stable@vger.kernel.org
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=127875 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
Link: https://patch.msgid.link/20261015165959.i.798-kees@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3cff2174dc03a..3e64af0b932d7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2841,6 +2841,13 @@ static inline void *netdev_priv(const struct net_device *dev)
  */
 static inline struct net_device *netdev_from_priv(const void *priv)
 {
+	/*
+	 * When GCC can see that @priv came from netdev_priv(), it can
+	 * compute an object size of 0 for the net_device and its members,
+	 * which makes FORTIFY_SOURCE fail valid accesses through the result:
+	 * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=127875
+	 */
+	OPTIMIZER_HIDE_VAR(priv);
 	return container_of(priv, struct net_device, priv);
 }
 
-- 
2.53.0



