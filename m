Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E3440963F;
	Thu, 30 Jul 2026 14:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422094; cv=none; b=RErNWO0ynadwRoyas0VTrf6zby5LU9zZYzuOwYlg9W1AT9K0+2Ykyqyea32D0RGQz2QtHQoq+1w7ajVxF5a9TNzoDlEVa6u3vQSDPxehaEsj83ioZK9GdsRo7h1LilrTz8xOS0WrVqdeAFxbNZY+Rc3WUg6Ix1dMO07k4ezU3P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422094; c=relaxed/simple;
	bh=LUyhWZTCTsvCIKyQN8OOpbeJMTndf0voGKl+caP1XkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cUA9aB4CVLJhgWOd9lsJ9X5DhUGZZ+j5BWmCfe1qrOtHYMEmzRnZu9oUlPsnGZ+9mTNZvHz/ca0Qje8YfkSx5mnuBHm0yQU0YWDKivKKfoUuJJxpVfSbxkBTUre+jZRwRnm4kiZovsu2JJZ1HifrnkW3GbnSecr+kx7pxtO/Q24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKXBWK48; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKXBWK48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF361F000E9;
	Thu, 30 Jul 2026 14:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422093;
	bh=ZQQVEN14oGDWgUQvNZ69+jJGp+WiqmZrd6zssGfo88w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKXBWK480Mpru674OEHymJ5t+tpkTVBj9vIxcHV31GVCgCyioSCNffN2qwMQTDhDC
	 J/ZOnc12xmAKJG7FVYRMPMykR23j+2K/hMMrcejxKXOKrcNtnIgrwSWu2M2W4/Cxep
	 gtBpfrXvbS3eIlvPyq6S7kdEXPNoxaEZQcR35+xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 315/744] drm/xe/i2c: Allow per domain unique id
Date: Thu, 30 Jul 2026 16:09:48 +0200
Message-ID: <20260730141450.980815621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit 5d8ed6b64220ad629aade5f174e3f690c37435f9 ]

PCI bus, device and function can be same for devices existing across
different domains. Allow per domain unique identifier while registering
platform device to prevent name conflict.

Fixes: f0e53aadd702 ("drm/xe: Support for I2C attached MCUs")
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260721113438.651100-1-raag.jadav@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit a79f6abc8b516b5bd906e2eca8121e3549ee163f)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_i2c.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_i2c.c b/drivers/gpu/drm/xe/xe_i2c.c
index 706783863d07d6..f05f23221c1b7b 100644
--- a/drivers/gpu/drm/xe/xe_i2c.c
+++ b/drivers/gpu/drm/xe/xe_i2c.c
@@ -95,18 +95,21 @@ static int xe_i2c_register_adapter(struct xe_i2c *i2c)
 	struct platform_device *pdev;
 	struct fwnode_handle *fwnode;
 	int ret;
+	u32 id;
 
 	fwnode = fwnode_create_software_node(xe_i2c_adapter_properties, NULL);
 	if (IS_ERR(fwnode))
 		return PTR_ERR(fwnode);
 
+	id = (pci_domain_nr(pci->bus) << 16) | pci_dev_id(pci);
+
 	/*
 	 * Not using platform_device_register_full() here because we don't have
 	 * a handle to the platform_device before it returns. xe_i2c_notifier()
 	 * uses that handle, but it may be called before
 	 * platform_device_register_full() is done.
 	 */
-	pdev = platform_device_alloc(adapter_name, pci_dev_id(pci));
+	pdev = platform_device_alloc(adapter_name, id);
 	if (!pdev) {
 		ret = -ENOMEM;
 		goto err_fwnode_remove;
-- 
2.53.0



