Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017380;
	b=WITPTqw4Ms1jtYC9V64J6rNi9yzcdpL4kGx/LrK3cPGCSXWYMWVWJ+01cNqtHzzW/a6X
	 LntSNm92COVj3K6TlBLbuL0cZAfNiRNGMHdEtaz9CcYp/+6gfKtSLws31v43BoeWhGXsq
	 hKtHFssFH45t6Neyf0vXfuP2tiCOHA9JlOMnUoXGWElLTSXFsWReUq1O4N7NE7IJxxb+C
	 otYHcefbMna55h5SQSEn3fAgGcb+/MIlJQUbmx0yieZFpedcVrR7IqLuKyye6bJKg3jU4
	 phXg4wuvHL2xgAhvGvdAa0RdO/1i2ifbwpASnl5bpi1KNRdJJ4Wli5iEzb7ufKvQBRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wJkMAghAXrNnrqyNqcVmR8NhrBfPcs4W3Bclv91VPUQ=;
	b=JgZxrAVjeL2VfQBXi+K1xxKaNaJZ+sCOkIPJCxDJqXmHcroTy3UpavtNVzuNEXmgCsO9
	 IGR1ulYIN+lR0+K3uNqxNDX7wD89meEWCgaK0evL+3nFqIht+GA9d1nhdAtS1mLUusy7t
	 Z4SHFo8TwM4i/WIpwWzQY4lN0fYDxu8D09UO0QGKYPlnGqyw6FW6bCvMFzkdrWjhOSoo8
	 9i1NBl2s7881wH73u69UrBMjfK0E/ppOYDkfPJAf/tQYZV2eiRlFiO2g5rUkQUbntxNGm
	 Skb0J6q5a22Wz/u6c6aoh89KgItXRnAG/lLNDWKx6TFz+i+QByW5ZUyEcnUoHlOOsqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2YZAD+zA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F904606A32A;
	Wed, 18 Nov 2026 15:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2YZAD+zA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30EB1F000CB;
	Wed, 18 Nov 2026 15:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017380;
	bh=wJkMAghAXrNnrqyNqcVmR8NhrBfPcs4W3Bclv91VPUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2YZAD+zAxpmIGXXG6yW3JmHc9ek2giYWUdcMXBg38eeHJ84rhd9erJT1H6HZ5sG4M
	 ub5KmZDG125gUeP45OD6saxdyzExk5Jd18Axybkd2zYrTWHa62th7Xf+i9jqDESoXk
	 JC2hwA1H1uK7Q3LW/K7Z1kgpuiuDjKCDZmu1RjG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0827/2651] platform/x86/intel/pmt: complete pcidev to device update
Date: Wed, 18 Nov 2026 15:34:27 +0100
Message-ID: <20261118150317.661402017@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

[ Upstream commit b86e5062cb881f6e5c1ddb8913c1357a9508f6db ]

The update that moved struct pci_dev usage to struct device is
incomplete. Only telemetry endpoints are covered.

Other PMT features (crashlog) are now blocked from using the callback
mechanism.

Change struct intel_pmt_entry pci_dev member to device.

Update callback usage to use the intel_pmt_entry rather than the
telemetry endpoint.

Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Fixes: 353042d54d82 ("platform/x86/intel/vsec: Switch exported helpers from pci_dev to device")
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://patch.msgid.link/20260923181115.2514193-23-michael.j.ruhl@intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmt/class.c     | 5 ++---
 drivers/platform/x86/intel/pmt/class.h     | 3 +--
 drivers/platform/x86/intel/pmt/discovery.c | 2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/intel/pmt/class.c b/drivers/platform/x86/intel/pmt/class.c
index c25892a511804..c4f73e4e126a2 100644
--- a/drivers/platform/x86/intel/pmt/class.c
+++ b/drivers/platform/x86/intel/pmt/class.c
@@ -100,7 +100,7 @@ intel_pmt_read(struct file *filp, struct kobject *kobj,
 	if (count > entry->size - off)
 		count = entry->size - off;
 
-	count = pmt_telem_read_mmio(entry->ep->dev, entry->cb, entry->header.guid, buf,
+	count = pmt_telem_read_mmio(entry->dev, entry->cb, entry->header.guid, buf,
 				    entry->base, off, count);
 
 	return count;
@@ -286,8 +286,6 @@ static int pmt_resolve_access_pci(struct intel_pmt_entry *entry,
 		return -EINVAL;
 	}
 
-	entry->pcidev = pci_dev;
-
 	return 0;
 }
 
@@ -365,6 +363,7 @@ static int intel_pmt_populate_entry(struct intel_pmt_entry *entry,
 	entry->guid = header->guid;
 	entry->size = header->size;
 	entry->cb = ivdev->priv_data;
+	entry->dev = ivdev->dev;
 
 	return 0;
 }
diff --git a/drivers/platform/x86/intel/pmt/class.h b/drivers/platform/x86/intel/pmt/class.h
index a0ece4fc3837d..258cb460e61c2 100644
--- a/drivers/platform/x86/intel/pmt/class.h
+++ b/drivers/platform/x86/intel/pmt/class.h
@@ -20,7 +20,6 @@
 #define GET_ADDRESS(v)		((v) & GENMASK(31, 3))
 
 struct device;
-struct pci_dev;
 extern struct class intel_pmt_class;
 
 struct telem_endpoint {
@@ -42,7 +41,7 @@ struct intel_pmt_header {
 
 struct intel_pmt_entry {
 	struct telem_endpoint	*ep;
-	struct pci_dev		*pcidev;
+	struct device		*dev;
 	struct intel_pmt_header	header;
 	u32			disc_header[PMT_DISC_DWORDS];
 	struct bin_attribute	pmt_bin_attr;
diff --git a/drivers/platform/x86/intel/pmt/discovery.c b/drivers/platform/x86/intel/pmt/discovery.c
index c482368bfaaef..f4203d240f542 100644
--- a/drivers/platform/x86/intel/pmt/discovery.c
+++ b/drivers/platform/x86/intel/pmt/discovery.c
@@ -609,7 +609,7 @@ void intel_pmt_get_features(struct intel_pmt_entry *entry)
 
 	mutex_lock(&feature_list_lock);
 	list_for_each_entry(feature, &pmt_feature_list, list) {
-		if (feature->priv->parent != entry->ep->dev)
+		if (feature->priv->parent != entry->dev)
 			continue;
 
 		pmt_get_features(entry, feature);
-- 
2.53.0



