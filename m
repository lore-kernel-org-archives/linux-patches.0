Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622457;
	b=ZzoxZEK1+NvLwZJdiwJ0q2fKy+6WlPW+ib+et+Mx56Zaaf5VeR1q5nnfWzXlMnfWbKt2
	 3MLN1Rpw4cNyybzl5G9fPiEjrdKQkIf9y3FpNi3m+mjcG57sGBSnMGfNQ2Hgq2bC85xIN
	 GZzHE5ZC03+7yYoENvrudGFZKRlyai4AfpF53yKUMAj5r/sjbfg8LJP/iV9XchUw31kaL
	 r/tOGf316jLxm1PAmrLkwrPtDcrgIOScwAF7RTp8VuoUxpOhVKPTNcGSzp7/IYoThpINX
	 Lj9OmwLKr3sJWqEqhSCi34nmjx79F4npewVNq7u6K4hPGI2kFkqBbfXizzHtGviqSuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SMBsZRtI4GD55yz970Pyx2T/rMiI6QDpDh/sAOObsQ4=;
	b=VX7EPqUFFYdvqz7bU01gIoA5RpWYEnS/HXpM5nFEkaGMQgfa+ma8o/H2/vP7SJsgwbuY
	 NlTWTPySH7/0MTt2RbRG4RrBHir5Kj4TzX6hC+g2QWeR2DtRuzru7Yyw+RYfGJMGyLU9g
	 Y0WS0A56dEAopw5tYP2kxIqq+SMsVdC5pO1XOi+7s4b1gP/CLwDOyzJwAdwS75KRpLoX9
	 E/QhT76Od9nLNt/vahqzemwZTQT1oyEWHfWMzIJk4VaKs4TPgZnjVyMocysDHA0CJXcm2
	 Q8iRZ9tNkilQmYwYOMRqsowyLrQJ5DBCGJHbxFYBj91jWbm3+iWhBqLkEIYk4EZEeWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pSHzky4M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F380606A31E;
	Wed, 25 Nov 2026 16:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pSHzky4M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513311F000D0;
	Wed, 25 Nov 2026 16:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622456;
	bh=SMBsZRtI4GD55yz970Pyx2T/rMiI6QDpDh/sAOObsQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pSHzky4M49JjkdtvN+J9K/8Rfn8O5p0xfJFxbMYSQS4IlQeXuQ66h2jdA5Y7csPnt
	 3hAhF4MfnzpUnBCpfy44MWn8inOlF6zIMuwbFxDr1w7nO8o9KfpKhliPQPj15hxzDq
	 WpHNoDAHZC3KI4oHdyPikOc/o0j9FlDduSoDt7YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 542/990] platform/x86/intel/pmt: complete pcidev to device update
Date: Wed, 25 Nov 2026 15:31:49 +0100
Message-ID: <20261125143834.792516338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Removed the entry->pcidev = pci_dev; line from the single intel_pmt_populate_entry() here, since this tree lacks upstream's pmt_resolve_access_pci() split, and added entry->dev there. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmt/class.c     | 4 ++--
 drivers/platform/x86/intel/pmt/class.h     | 3 +--
 drivers/platform/x86/intel/pmt/discovery.c | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/intel/pmt/class.c b/drivers/platform/x86/intel/pmt/class.c
index 9ec843617e3c9..ebb5071334e5c 100644
--- a/drivers/platform/x86/intel/pmt/class.c
+++ b/drivers/platform/x86/intel/pmt/class.c
@@ -99,7 +99,7 @@ intel_pmt_read(struct file *filp, struct kobject *kobj,
 	if (count > entry->size - off)
 		count = entry->size - off;
 
-	count = pmt_telem_read_mmio(entry->ep->dev, entry->cb, entry->header.guid, buf,
+	count = pmt_telem_read_mmio(entry->dev, entry->cb, entry->header.guid, buf,
 				    entry->base, off, count);
 
 	return count;
@@ -283,10 +283,10 @@ static int intel_pmt_populate_entry(struct intel_pmt_entry *entry,
 		return -EINVAL;
 	}
 
-	entry->pcidev = pci_dev;
 	entry->guid = header->guid;
 	entry->size = header->size;
 	entry->cb = ivdev->priv_data;
+	entry->dev = ivdev->dev;
 
 	return 0;
 }
diff --git a/drivers/platform/x86/intel/pmt/class.h b/drivers/platform/x86/intel/pmt/class.h
index 1ae56a5baad23..1d66681d14722 100644
--- a/drivers/platform/x86/intel/pmt/class.h
+++ b/drivers/platform/x86/intel/pmt/class.h
@@ -20,7 +20,6 @@
 #define GET_ADDRESS(v)		((v) & GENMASK(31, 3))
 
 struct device;
-struct pci_dev;
 extern struct class intel_pmt_class;
 
 struct telem_endpoint {
@@ -41,7 +40,7 @@ struct intel_pmt_header {
 
 struct intel_pmt_entry {
 	struct telem_endpoint	*ep;
-	struct pci_dev		*pcidev;
+	struct device		*dev;
 	struct intel_pmt_header	header;
 	struct bin_attribute	pmt_bin_attr;
 	const struct attribute_group *attr_grp;
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



