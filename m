Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028014;
	b=X6MyW9okaZurwUOF4xHDbZQbp0Xe034c+XQOiZ39js6uYafMzEbMJPdxvhVNU3Um43nP
	 XlIKRpYVj5eKcQUQ0/003UwThpUegyG56TmsHIB1fPWIlAXfLljk4SAXeuoV60m2n2mSn
	 d9GjEvWrThDvDAlboU8WUa9SciE0I7klvmCHP2Y523mRCqseTfJ6clxxjCsJ9G2N6BHIr
	 dzWG3cfUVJw6U11Av2oTvjeGhDDvfaq19cv4frUaevwJQWgQdsRS+6xiZThkfyqJpjg10
	 UdbYYnLCj162TH0O2G01odjjdJML+qHgmTnsL/jE8NPFDQuovmfAGz5w7YcPrO219aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KkiIgYCybNleoD7L7kSWL/pHwj7g3gZwgqzYIURcdcs=;
	b=oTX95rkk15dDCQ079Gx+MDfdKFaAyQMn1WWT7INXUQA3Fw8qjgY0Zn2RemtDEsx4Ciry
	 K4a27aFeXqRd09epg8JmRu5SEIZOU82Q4SecleYCAQgqlPZaqX/RURXZDIononkk94W9J
	 1GhYfhKD0Ti1i28LyT+9RF9sJqNsX3E7A9/8Qzd5kZvdvBY7M6wRIXzTBMnEwROrF4wiz
	 kzZIRkeiyJevSfmzgV2OUewW0Vy5YproMPcek9Kz1RBCm+c5rgr1+00lqvBiV9ZzoNcPv
	 uWU3qo3ssb9XD6RUEnqAhfdNADouap+OWu2DYiohVzWXAaS5U0XXwelOEiaFMIGfhVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cRsvdjJA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4190C606A31C;
	Wed, 18 Nov 2026 18:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cRsvdjJA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D2F1F000C4;
	Wed, 18 Nov 2026 18:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028014;
	bh=KkiIgYCybNleoD7L7kSWL/pHwj7g3gZwgqzYIURcdcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cRsvdjJA7+IavJRvz8wFn8gJApxX0L6Fka/pNAQGCWIfRYoTfISZoATtnwfcEej9z
	 nTwq2g0VvYcy9nreCi+hYChaF/RDStlGljB+XxxYfLWbE7Z81D4LniVDkzxy1fxnt4
	 WOMAIB+Xvm6260ONxHhafYA+rkmTzqwz7xEczDEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Laimer <h.laimer@proxmox.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Petr Machata <petrm@nvidia.com>,
	Gabriel Goller <g.goller@proxmox.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1993/2151] vxlan: keep reserved_bits across changelink
Date: Wed, 18 Nov 2026 16:02:08 +0100
Message-ID: <20261118150234.324859900@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Laimer <h.laimer@proxmox.com>

[ Upstream commit e3a629477d52a9f49d50d72903be06a4d1f4aa58 ]

vxlan_nl2conf() derives reserved_bits from the extension attributes
set in the netlink message if IFLA_VXLAN_RESERVED_BITS is absent. A
changelink having it set is rejected, so this means that every
changelink will reset all extension bits and reserve them again.
vxlan_nl2flag() rejects setting a flag on an attribute that is
create-only on changelink. So also setting an extension attribute will
fail before it can un-reserve its fields.

The extension's header bits being reserved again then makes
vxlan_rcv() drop frames that have them set in their header as invalid.
The device still reports the extension as enabled, because only the
reserved_bits are rebuilt and the flags are just copied.

A simple reproducer is

    ip link add vxgbp type vxlan id 1 dstport 4789 local 10.0.0.1 gbp
    ip link set dev vxgbp type vxlan ageing 300

After setting the unrelated ageing, incoming packets with the GBP bit
set in the header start getting dropped.

Keeping the reserved_bits on changelink is safe because anything a
changelink accepts leaves the header bits enabled extensions use
unchanged.

Ran into this when adding support for the GBP flag in ifupdown2, see
link below. The device kept dropping packets after some time, it
turned out it always started after a changelink.

Tested this by changing ageing by hand on a vxlan device that was
created by ifupdown2 with the gbp flag, and checking the reserved bits
using

    ip -d link show vxgbp | grep -o 'reserved_bits 0x[0-9a-f]*'

Without the fix I got 0xf7ffffff000000ff after the changelink, and
with the fix it stayed 0x77000000000000ff. The following patch
contains a selftest that fails without the fix and passes with it.

Fixes: e4f8647767cf ("vxlan: Track reserved bits explicitly as part of the configuration")
Link: https://lore.proxmox.com/pve-devel/20260828134708.692354-1-h.laimer@proxmox.com/
Signed-off-by: Hannes Laimer <h.laimer@proxmox.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/20261023-b4-vxlan-changelink-gbp-v1-1-f0d13951c09b@proxmox.com
Tested-by: Gabriel Goller <g.goller@proxmox.com>
Reviewed-by: Gabriel Goller <g.goller@proxmox.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 090d50b163816..424f57400933c 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -4350,7 +4350,7 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 		}
 
 		conf->reserved_bits = reserved_bits;
-	} else {
+	} else if (!changelink) {
 		/* For backwards compatibility, only allow reserved fields to be
 		 * used by VXLAN extensions if explicitly requested.
 		 */
-- 
2.53.0



