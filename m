Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029821;
	b=GXAHuK0NLWZNtSBcw6sBfXUWuMvl0sW7OVd17Z7jGAsRG7Nn21xkbO5r7uoRYL5yXvkr
	 Oq0fxMMP5sxcfB0tvVt5hVBEV6lqxnnYzDMgzJrx6ID4EGtFV8sAtBkQtD6wsPFCvthVW
	 heXQKok7QGw0+LYZiPj1TRvrK4h14mvTlOhqIW4nYuhW4S9iDt+MTc3aBetWoIfaBt2Js
	 Gae1N15ug4nKKTAxwh7oBUpzejuwvx5+xA6hkX9mpSYAywKN5lnPL5HypuCi9u2yPXK8h
	 Qo6v/nXkmGi3cj5G4e6UkMVfpejZg0zaECjltEMk0PjcCjffuOVBIIRp1B/oVG7P2AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TleWBH2iO9pcSFBPkX5aRKfTxNN9cpS0qvL3OSrXNgA=;
	b=W3Ji1uoMHzm+VDWz3AGzaajPk3phxlE/7tef5C1TG3dDgxLSv/0J3s82XwUJhuU5w0I4
	 9ZbUz9usrcY0aHLsEGdtCITJoXxGnAz8x1ibJM6cGsri+Dw2ps3Ip9Z7GuqVAdOZFdE/Y
	 vqHBRV0e5NEDHrf0wqCMqUJDRoy0Xp7zSBk6ai03Id/oTHkmHOEEOqAudjN427vGmWYEp
	 IgJ6AR79mWueaoVBDmTX5NF0D8bUA5SNdPobr9tq3X04Ks+8MMTrZVHVRiVGl+KJICNtU
	 fTDMzB3ytuzHTZQfUw47Sfqe9KdCuHDZsXOOnUDRMAbrhXhQOWR2pZWNSyDXiEk5aUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPUA+fPj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3D9606A320;
	Wed, 18 Nov 2026 19:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPUA+fPj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140341F000C4;
	Wed, 18 Nov 2026 19:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029821;
	bh=TleWBH2iO9pcSFBPkX5aRKfTxNN9cpS0qvL3OSrXNgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPUA+fPj6+FUl0C8H+FDD6+22Qwt3XG22JPwXf3ousMbrReP+cUBKTigt4XLpPlHI
	 iWNkBM8RZCDL+fr8qr7MSZr2oBTsa1qyB4NXfRf55S2N65kVpbx90OzGncmtgwdoQA
	 lamJf4v7Jnn5o4iFDfvlo3b2Y8GvI3SqbMqwgnjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0486/1756] pstore: reject persistent RAM zones too small for the buffer header
Date: Wed, 18 Nov 2026 15:43:33 +0100
Message-ID: <20261118150028.356983005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 1b30df8662ac85a6759be4332f3bec7e3cb28efc ]

persistent_ram_buffer_map() computes

	prz->buffer_size = size - sizeof(struct persistent_ram_buffer);

without checking that size is large enough to hold the header.  A
ramoops zone configured with a tiny size (e.g. ramoops.pmsg_size=1)
underflows buffer_size to a huge value, which defeats every bounds
check in persistent_ram_write() and persistent_ram_write_user(); a
write to /dev/pmsg0 then copies user data far past the end of the zone
and corrupts kernel memory.

Reject zones that are not larger than the buffer header.

Fixes: 404a6043385de ("staging: android: persistent_ram: handle reserving and mapping memory")
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20260921202317.70595-3-parri.andrea@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 95675d4bab141..4d07280768975 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -507,6 +507,12 @@ static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
 	prz->paddr = start;
 	prz->size = size;
 
+	if (size <= sizeof(struct persistent_ram_buffer)) {
+		pr_err("%s: persistent ram zone too small (%#llx bytes)\n",
+		       prz->label, (unsigned long long)size);
+		return -EINVAL;
+	}
+
 	if (pfn_valid(start >> PAGE_SHIFT))
 		prz->vaddr = persistent_ram_vmap(start, size, memtype);
 	else
-- 
2.53.0



