Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215772;
	b=ngRJ6XISpilSnwp72hOL8X+GQUQusmaXcSR41YCZWVYhhdiAfVnha/RqTVnO6gsmawX7
	 xoZyayGrsKWfy6GBRrs00BdbYOHqCT0+TejrcG3xtB5URQDsnSncbrSfEQJhlNbQ98+F7
	 XexTiPjQOG26ycJNXn2BYL2NjHXaGNM5WhzCpodWrs2yYetmDY1iuIjwZsJUfU+pu1m8H
	 RVPW8fCbo/6yoUWE9AU7END4yfCdxrDm71lmte3gx/EgqDje+69ubhaMNTIV5RWCrQpPw
	 FLEG1l7o+LVGxI+lbgmHYZyTAFMc+beW+sg1pwtLBYrNyWbhJu7SyDCrW/jJ8AAs/TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PqJRuVQWsmcB7QE4qVBUzkQnFGEDeRbIORBcbIPAV6c=;
	b=VDyNxK0JWRbD9z0QrSB94zDXqEvQv1Nxs8RgIh30fh0JSKon3Kne5zJDXHDOogcz7q2S
	 PkWE7tX5PUOF+NBQo+cjsoDSiT5kuKjMtBXhQV1vj2zrRQ2yh7yd0Os3ehSzeyKzECcDI
	 zu9nBsHMt0GJYjCd6aljRlmVqHFKQ3UgLCo+/lFwe0Kgzdkvj0Ph6OmcEuSIBYFK+Zc+X
	 MVL0XzSKyYUlTMdPDDZ6l/wJD2PG8k7zdiX1v+vrmJn0k71URABn78TOuKcy+SKAuYqq3
	 gz7Tx4Oxw2ue8osLg7WAxuvm3MG3OCFco1rMpXjYR0MEhJH3vScr493UdaaGvdS8O5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ONUtJsG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2E5606A323;
	Wed, 28 Oct 2026 19:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ONUtJsG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FA61F01825;
	Wed, 28 Oct 2026 19:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215771;
	bh=PqJRuVQWsmcB7QE4qVBUzkQnFGEDeRbIORBcbIPAV6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ONUtJsGVsaVKNxBjGiv+EspVlqWAc1jXUmekGxXzxRlufz7EUWPM2Q4mBskTmk0t
	 EUFhLPklnC2G8r/YbNuQDBUCXbL5cNi1rmiCJfHO/KWHUBqbqdxL27C0u6soDrjTIh
	 3uX263di5JGpEJT8DG8gs+665adPNcWqwFa/RMcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1328/1887] EDAC/igen6: Fix call trace due to missing release()
Date: Wed, 28 Oct 2026 17:57:04 +0100
Message-ID: <20261028170529.650448533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit ab1f9d466c7d83ab0d2a529e07984e53b5960dcd ]

When unloading the igen6_edac driver, there is a call trace:

  Device '(null)' does not have a release() function, it is broken and must be fixed.
  See Documentation/core-api/kobject.rst.
  WARNING: drivers/base/core.c:2567 at device_release+0x84/0x90, CPU#5: rmmod/127209
  ...
  RIP: 0010:device_release+0x84/0x90
  Call Trace:
   <TASK>
   kobject_put+0x8c/0x220
   put_device+0x17/0x30
   igen6_unregister_mcis+0xa2/0xe0 [igen6_edac]
   igen6_remove+0x82/0xb0 [igen6_edac]
   ...

Fix the call trace by providing empty release() functions for the
memory controller devices.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260403054029.3950383-2-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 97468fbf17b74..98c56254d79b5 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1007,6 +1007,11 @@ static int igen6_pci_setup(struct pci_dev *pdev, u64 *mchbar)
 	return -ENODEV;
 }
 
+static void imc_release(struct device *dev)
+{
+	/* Nothing to do, the 'imc' owns the 'dev' and will also release it. */
+}
+
 static int igen6_register_mci(int mc, u64 mchbar, struct pci_dev *pdev)
 {
 	struct edac_mc_layer layers[2];
@@ -1051,6 +1056,7 @@ static int igen6_register_mci(int mc, u64 mchbar, struct pci_dev *pdev)
 	mci->pvt_info = &igen6_pvt->imc[mc];
 
 	imc = mci->pvt_info;
+	imc->dev.release = imc_release;
 	device_initialize(&imc->dev);
 	/*
 	 * EDAC core uses mci->pdev(pointer of structure device) as
-- 
2.53.0



