Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2AD442FCF;
	Thu, 30 Jul 2026 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424111; cv=none; b=oWulta0cHBzfLYaualyIWp90yH5EDgIyV/s7whuGdVLwV30eDAYKWtZQ6ijJUyG7dpXIpce1WfW5ED5xGBdXJfQJqCI3/OXdpR1qKSj3uw5gw6aKLb51MVn0DmHcQohDhGh7r3JU4J2ceVEG+6RRakXk4h3OlMDHbqvt6DJapWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424111; c=relaxed/simple;
	bh=TfwbQ9+o9etoi3hqwh2TF1AUxWHRASjNHZbZoFPG5B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j/l/OcBdDLbhx/kb4m4yhmT0WpQirzznsFoI2ZSrEK/wLiyxqA7YUjtJp+NztCkFymMd74Nerwnqp0ynT2ADQTE7MTpuFa0Vj/a4hPtDAbtXdXqu5Pr/WIs6r2Gtn95GaBCEq7rel2G3qxnciAhhbGlX1Mkad+l4vwu4SllLoQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/eLznIx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/eLznIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2811F000E9;
	Thu, 30 Jul 2026 15:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424110;
	bh=zyvM13+snjFwV229JyZyB/m1Tju3G5S+3qj//EJ3T0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/eLznIxMz+goNC1sW5fq7bcCOE7rwl3SFbajSqGWOd67NvdzRLYWaIOZfjl20r/3
	 ZIW0ftk4UoMD1pfrxO6ymZhNIxu7tHLII46n0weH/CwTdW3srr6xA8FHbm1zMnzFq9
	 FqUQmjJuewXWBjmYfn8wiNqvNzJ5IRZhaTE9Wd0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 280/675] drm/xe/i2c: Allow per domain unique id
Date: Thu, 30 Jul 2026 16:10:10 +0200
Message-ID: <20260730141451.077151022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 48dfcb41fa08c1..2788dc6510d6ac 100644
--- a/drivers/gpu/drm/xe/xe_i2c.c
+++ b/drivers/gpu/drm/xe/xe_i2c.c
@@ -94,18 +94,21 @@ static int xe_i2c_register_adapter(struct xe_i2c *i2c)
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



