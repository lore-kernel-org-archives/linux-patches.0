Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216805;
	b=MP3etSSjkBtL5q8tP9CRrs3ctd+/qolXbWY7RedFh3rUGChbA0be6HVK6HgcZf9HXtu0
	 eNJrp/EzXQDnQYDrqMJXa6UISaQ9kHU+MMnwQ9qx8o5mOB2Lp27hijKnI6TBit7OPTZ8c
	 xZE/rLIXXShXOAayrR0DWDPvE7mX0/dZpx5erHRrfaOum3NOVehas/SZdpYyc1PjWMczw
	 V7ixOQUmK4LXhChgfd4z1qE62uqMmDv9OYxjdYAXjJooz2HCrQUoH1RoIyA8RhEgfkUS2
	 EoxG/LoYX+Rj8jz5lipUIwC75rWDixZ2zgeaIyHT7/m5i9sufwoWrF6dWBpYZGWny2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uf3R8LgnvmKgupGlMSOecSMM42UbI9wONphSG/dA0yI=;
	b=wliWytttGNwtEyDkG5DoFcoXj7FZUCxkHAb7V2bBehAY2I6Ux+ffdyDZBSr7B3pkvLNI
	 TJRRD0FiTJ1L6s2nyl6WqMSZXxrvC++CSVLZWRU3ry9RaEh19k8j1+uYdJQDpawn5jAm5
	 y80eH+ao1S2U+G/CACGUKDx4ZQ94eO/a9hXA1u42ke3gsAhFLsBl6u/aisACm1KmkvNQI
	 c+GehbenB/2H6BE2nwsAPAFrkBI9goPvWgs+y+9hSv917SMx221BrOS6YJijLRY2nIH4d
	 clNCiXL5bPFDdRcoEp2hN2oaJL8CGRLkmhCMvr0byI3Pyyukrgy/vjYP4rphC2MC6sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztjhe03l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE1D606A31A;
	Wed, 28 Oct 2026 19:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztjhe03l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3ED1F01825;
	Wed, 28 Oct 2026 19:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216805;
	bh=uf3R8LgnvmKgupGlMSOecSMM42UbI9wONphSG/dA0yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztjhe03lugfrCjHbH0IY7fMfNyKQ+l/OQ5avDhmhCD+gBpRFtaAUG7CbBZ1F6UHbs
	 XeQf9p3+exwHtUvKTlgS6Sg72+8LCHm1OSBMu1hpEjnhHE+rl4iotiJwPivqg38xGn
	 hDcL8Cynj9g8iUc6eXz/8WOppD92f7fnKcuhRRm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1683/1887] PCI/sysfs: Add CAP_SYS_ADMIN check to __resource_resize_store()
Date: Wed, 28 Oct 2026 18:02:59 +0100
Message-ID: <20261028170537.756174552@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit 25ec7f57deceec633f27bc93b615f951e2ade814 ]

Currently, the __resource_resize_store() allows writing to the
resourceN_resize sysfs attribute to change a BAR's size without checking
for capabilities, currently relying only on the file access check.

Resizing a BAR modifies PCI device configuration and can disrupt active
drivers.  After the upcoming conversion to static attributes, it will also
trigger resource file updates via sysfs_update_groups().

Add a CAP_SYS_ADMIN check to prevent unprivileged users from performing BAR
resize operations.

Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260508043543.217179-6-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index f6bf0b99ce63c..528b4efc95d75 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1456,6 +1456,9 @@ static ssize_t __resource_resize_store(struct device *dev, int n,
 	int ret;
 	u16 cmd;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (kstrtoul(buf, 0, &size) < 0)
 		return -EINVAL;
 
-- 
2.53.0



