Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2902430CE3;
	Tue, 21 Jul 2026 22:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674701; cv=none; b=Nbhi8x0087AG+absY2fkmOrJ7CHqPqBvaKQbofefvDtd/cKw/XkEiZjyBJgR/iX24Tgq6ZF6QwlZiHOestSi99U88i/Ym0hLZ3BOlgV3WbsA2gk9CZ4swuPz87enAj6QKLEhQsqUDJCmylUNcjEaeiV+MhkaP2cz/u1zdDeUM/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674701; c=relaxed/simple;
	bh=ym1QjK6rd+Zba5Cig7TTDPYQXpsuD5GX+QyK/2jCzXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HvdNf26ToDQXuyf3FzNsnGVFJt8fgH3XQmyQ6nej6C17oOyAwXO+gp+uuIupVqAa/XSOeSZBOCrXPWvVLMWVXFsQ8d1a4aZeoTklfQShEH0kYVC97XzqqHUyRzzVZ1ILuBcpZBZcGcBmIIqSFp/rY7NZ4Q5GQ5abIoZzkkMLb0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOucskC5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOucskC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4382A1F000E9;
	Tue, 21 Jul 2026 22:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674700;
	bh=FoG6VDNI/ACFKl5NjVWe6KDXZsmM592AN81bkdqZ0Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iOucskC5cKhH79FX9VFzlZmiFOTeOS6QdnwA07qCXwC854iXeL8i7rMyrnVLwhRUo
	 +YlPGE6/8papgtpnB8W0itVgQnp/IOtKThO4DXJOY4tXbtoQO4wdEZ6wmCg1s51JJA
	 5yqfWj40zQAuZA9sVPXlIHxV0vcLCR2ZQyHBba2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 5.10 633/699] PCI: Add kerneldoc for pci_resize_resource()
Date: Tue, 21 Jul 2026 17:26:32 +0200
Message-ID: <20260721152410.027353425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit d787018e2dfdc4c1331538e7a8717690d1b7c9b3 ]

As pci_resize_resource() is meant to be used also outside of PCI core,
document the interface with kerneldoc.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Alex Bennée <alex.bennee@linaro.org> # AVA, AMD GPU
Link: https://patch.msgid.link/20251113162628.5946-8-ilpo.jarvinen@linux.intel.com
Stable-dep-of: ee7471fe968d ("PCI: Skip Resizable BAR restore on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-res.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -422,6 +422,26 @@ void pci_release_resource(struct pci_dev
 }
 EXPORT_SYMBOL(pci_release_resource);
 
+/**
+ * pci_resize_resource - reconfigure a Resizable BAR and resources
+ * @dev: the PCI device
+ * @resno: index of the BAR to be resized
+ * @size: new size as defined in the spec (0=1MB, 31=128TB)
+ * @exclude_bars: a mask of BARs that should not be released
+ *
+ * Reconfigure @resno to @size and re-run resource assignment algorithm
+ * with the new size.
+ *
+ * Prior to resize, release @dev resources that share a bridge window with
+ * @resno.  This unpins the bridge window resource to allow changing it.
+ *
+ * The caller may prevent releasing a particular BAR by providing
+ * @exclude_bars mask, but this may result in the resize operation failing
+ * due to insufficient space.
+ *
+ * Return: 0 on success, or negative on error. In case of an error, the
+ *         resources are restored to their original places.
+ */
 int pci_resize_resource(struct pci_dev *dev, int resno, int size,
 			int exclude_bars)
 {


