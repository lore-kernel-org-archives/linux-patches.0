Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620381;
	b=C5DKA/KtkDnBZwga8/Jqd7MtGRVmOfO0pM83QMrXKcH3rqgCa7Q9djnzq+DoadQjdgB0
	 suJLON13LLGiKCUXOagMRNW8Qt2YiIzlLmbN7JArkNY1S3JN7eZxLR7fyO/8H6gLmZd/O
	 ngS49j8cWnbq4EO6DVXlMTObsfNgtykp/BSrfXOooaPNGhI4ncQV/5q5DNJlMTVoyLDhU
	 e7P86wKReoCTYc77nabNwRKyQUp2wvqD5TDaVCrEELgHPbOKVmdoT9NJpCDpiJp6/oI0T
	 PJsQQDtIT4AJ+iNJ7se8qyB5bUjdU+Idtz6HRAS3xA/tndv/LnKpwzjb/2J6sroEaJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fg9geOFW5EqatdKLEPcGl0ZCQOtm8shtS4jRTcCpnGA=;
	b=F6ee4CrocHWHSpL22N9CHQM5RxdVE0yif/ZFh5V/+6X2h9TS09SSbrFVpkeNh7FHrMY7
	 cfskeuucXbzRTiTU9QMkJoM7B/5mTgD6HoiwKYFVpaUHhuiItuqfKQRygVXt2mR7x82jQ
	 LibAqqfuagpVUJWtQq/mUjdJB3XrOMuU9AkfPdN8B/vuJYy+ko2hq01bfn+0Igenu6Wdm
	 cKyJDfSHPKHQ3+IlAystwtrIP8iyMwLxYP2t809Gpfzypg26UgkivhRXldbGofewv7TjN
	 9p6WZAYCRWb0TLFqplF4X4aejqEwQ6CZjehjNt7C0OZyFGmhDZj/qUfYBCjGNdIKMMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkdneQNF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC8C606A31E;
	Wed, 25 Nov 2026 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkdneQNF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E80C1F000C6;
	Wed, 25 Nov 2026 15:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620381;
	bh=fg9geOFW5EqatdKLEPcGl0ZCQOtm8shtS4jRTcCpnGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkdneQNFmM/ta/jQV3DpKR8KPPKmnoy/eWj5K2N+lQhP6iw0EjfHwUd9TjJ/amE6Z
	 zihAQstOVyoS9TZP/x9WqxH+kblKxcbisxGDi6EJIfEgVJlbSH/pBOEOwx3dTTfREO
	 Zvk9QxOH/N0gEDAIa7YhKaBuJgWFccapT51QHWPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?Antonio=20V=C3=A1zquez=20Blanco?= <antoniovazquezblanco@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 7.3 0899/1005] mei: me: add ice lake point LP iTouch DID
Date: Wed, 25 Nov 2026 15:37:17 +0100
Message-ID: <20261125143842.752648203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Vázquez Blanco <antoniovazquezblanco@gmail.com>

commit 73383d06da9a1ded4c85845407cb4029aeecca39 upstream.

Add the device ID for the Intel Precise Touch & Stylus (iTouch) function
on Ice Lake Point LP. It appears as PCI device 8086:34e4, next to the
regular MEI function at 8086:34e0, on Microsoft Surface Pro 7 and
Surface Laptop 3.

Without this entry mei_me does not bind, the touch controller is
unreachable, and neither the touchscreen nor the pen work. Users
currently work around this by binding the device by hand at boot:

  echo "8086 34e4 ffffffff ffffffff 0 0 9" > \
          /sys/bus/pci/drivers/mei_me/new_id

where the trailing 9 is the mei_me_cfgs[] index of MEI_ME_PCH12_CFG.
That is fragile by construction, since the index is positional and any
reordering of the config array silently changes which config the device
gets.

This ID was first reported in June 2020, together with Sunrise Point's
0x9d3e, in "mei: me: Add itouch device IDs for SPT / ICP" [1]. That
submission was declined over the server platform ID conflict, and the
Sunrise Point half was subsequently added in commit 372a829862e5 ("mei:
me: add MEI device for SPT with ITPS capability"). Ice Lake Point was
never added.

Use MEI_ME_PCH12_SPS_ITOUCH_CFG, so that the device is reported with the
correct kind and the SPS firmware exclusion applies. Note this is not the
config the manual new_id workaround above selects: it reports kind
"itouch" rather than "mei", and it does not set up a DMA ring.

Link: https://lore.kernel.org/all/20200601155954.764558-1-dorian.stoll@tmsp.io/ [1]
Cc: stable <stable@kernel.org>
Signed-off-by: Antonio Vázquez Blanco <antoniovazquezblanco@gmail.com>
Acked-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20261029084859.4537-1-antoniovazquezblanco@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -94,6 +94,7 @@
 #define PCI_DEVICE_ID_INTEL_MEI_CDF        0x18D3  /* Cedar Fork */
 
 #define PCI_DEVICE_ID_INTEL_MEI_ICP_LP     0x34E0  /* Ice Lake Point LP */
+#define PCI_DEVICE_ID_INTEL_MEI_ICP_LP_3   0x34E4  /* Ice Lake Point LP 3 (iTouch) */
 #define PCI_DEVICE_ID_INTEL_MEI_ICP_N      0x38E0  /* Ice Lake Point N */
 
 #define PCI_DEVICE_ID_INTEL_MEI_JSP_N      0x4DE0  /* Jasper Lake Point N */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -98,6 +98,7 @@ static const struct pci_device_id mei_me
 	{ PCI_DEVICE_DATA(INTEL, MEI_CMP_H_3, MEI_ME_PCH8_ITOUCH_CFG) },
 
 	{ PCI_DEVICE_DATA(INTEL, MEI_ICP_LP, MEI_ME_PCH12_CFG) },
+	{ PCI_DEVICE_DATA(INTEL, MEI_ICP_LP_3, MEI_ME_PCH12_SPS_ITOUCH_CFG) },
 	{ PCI_DEVICE_DATA(INTEL, MEI_ICP_N, MEI_ME_PCH12_CFG) },
 
 	{ PCI_DEVICE_DATA(INTEL, MEI_TGP_LP, MEI_ME_PCH15_CFG) },


