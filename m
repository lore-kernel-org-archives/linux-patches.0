Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021897;
	b=gVaWJczsB0V5QwFaa12xry0e6DVSda5v9QFH6SVypogUztxvM+C1ZPAToiLr/WaahIao
	 B80nOWK0Ngk1LaPtEngyUZWhKi/5131pU7HSGUN2ji0at/Soft41OsTwwpH1AXelQ1+3s
	 ypag33oGac5Mv3npvyGePQO4fuCpms7COWaJORJeS3h97mgXW3RQSmYee6atTJPvnUXfZ
	 duoGAQLWtaqFtm/etx5O+gZUgjuFFSG+Y7wyIe3bJsjUCCV4oMs5Q006HMcCuceE2r77r
	 QeZBeFt5jwMX/PzgJeefQhS3ccGyi3XTH/3jqnHONOAhXhubOA5ONaDgwYqFzSRL/ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nuuWt8pxMq+JQc4fBYh5+ju9rDAdyOPB4a6uH+lucgI=;
	b=If8tKc8Y2uSeoLbeOW8hv5kSrBHiHMRoQkQiI1SzFjo46+vmNoNA03Mb+ZkN7Dypci8b
	 /54Lp0w6PKe1C/joIFKgCsdMfgi6IdK4gN7Bv5BJdcoTomcHMgEt+YK/+HuM3SJW/0ZEi
	 5iM8+IyUclXf+WgERqojEanlZa34oWLJrBPG0nGaBZsbqryRzrYQf9cMA39rsrOQiWXKy
	 l1HWnPXXtZSdFZR1aF0Kfooc2lXxzlcVdhyfTQdw6mU32poYIjk1XQu60YPE2mpdbg6oH
	 an8xRCCDBEHqRXMSyjzlfZdxVtyZdlYj4MkaoFm8br3j3ViuOBgQtUIVS2rCmKizIKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k1uAhrHO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA9F606A32C;
	Wed, 18 Nov 2026 17:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k1uAhrHO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D9E1F000C4;
	Wed, 18 Nov 2026 17:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021897;
	bh=nuuWt8pxMq+JQc4fBYh5+ju9rDAdyOPB4a6uH+lucgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1uAhrHO970b2o79Hgi6WQJd8XKMt4jkkSMtmqiyP1++ty0vnwKBGcMyWsBfAb0Hx
	 7n6rwUbV9tsHtoRKoX/qUCf9W6LHyPYwVGNn91ozUPH4jzyiL5VWz97ST2Ab3vE8IQ
	 XtvmBIhlCseinaJZ0ANNRoQNnPIo0AP28f5gRrao=
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
Subject: [PATCH 7.3 2470/2651] vxlan: keep reserved_bits across changelink
Date: Wed, 18 Nov 2026 16:01:50 +0100
Message-ID: <20261118150413.916551840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 7ecd73a5a3745..66fdca6cad1c3 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -4358,7 +4358,7 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 		}
 
 		conf->reserved_bits = reserved_bits;
-	} else {
+	} else if (!changelink) {
 		/* For backwards compatibility, only allow reserved fields to be
 		 * used by VXLAN extensions if explicitly requested.
 		 */
-- 
2.53.0



