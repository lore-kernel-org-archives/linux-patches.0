Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016326;
	b=pyC5AkXouWNIsyeBX5lnxvRAlf6mB/sUX6941p5gh7dVecRQoGupCvBERpSZB3+OlERf
	 Z3i5EZxgN5Q8rojslPIukbOzWQV8OVQRaP9gbplY9CoF9oTZ+Wnpn/YZDhBHPI/xuyJmq
	 uWsW8aU3agcdnBW2vkhCUwyoTtNZsvaAg77liMFpd8C9a3SlWzUaG+5rxMB+xEtnan3ZS
	 hQOPLt0rvvquBYv9IAkP6o6lUgkvUVrnhNjYLgAsS1YF70fZqms106YNsZwqcP4sTt15/
	 cI0CSclr7X0Vn5SZOAtbSmB9GDnSD+sebkkCQ6A47twHtBgEDj3Pe2+MlOrPv5Tz8Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B7MvnLasLrEnqvEM9rBaKVyOBaF+fKIoX8N5Te/vwL4=;
	b=BRovpGOjmaGq7UKt9KmlWUGyvwda8QX7oeMHKCfCT7BAOdQjjErH7OCYR98nrRQZvek/
	 fM8F5NhPLjv0C2cdEOobyg0/kCy3kklAGXWP1699jcdvvdfTCUGdY+XJLostEYoyTIeM5
	 vToVNjPgsDBkST0J8A0rXW6ygFe+7IfLBmahXYoxaK2VeMn6gB9UmSsYjo6kClG/MZsi3
	 wDRbzf4uA1S+GwVr1Zw5CkUdn1n31Wogg+qTwJTOMOfcq3ufZBVSrLFoQUABr13M/7uOl
	 uiOYtLL7JT0Btjx6dA+kJ8zvlL3uUzhbwu949tnvTpGS3giHi7MQwFYRnnRxKHnVguA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLAZot2M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FE2606A33E;
	Wed, 18 Nov 2026 15:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLAZot2M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D711F000C4;
	Wed, 18 Nov 2026 15:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016326;
	bh=B7MvnLasLrEnqvEM9rBaKVyOBaF+fKIoX8N5Te/vwL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLAZot2MmXIYXFLCxvrQsfsE3ca20vhS7liI58mFTBurMVw5bwe2ZYyv1VsuarPbi
	 ArGMnyfQfeHT2KZwk6NRq4NZEtgfs1eGDllYZQXeHg4+9GmIMZHoc6hxKzozKy5TlM
	 773bMPuAv6B8MKijM700DwuM8DldCXYsD+45AeOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitesh Venkatesh <nitesh.venkatesh@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0489/2651] crypto: qat - allow KPT disable when service is not asym
Date: Wed, 18 Nov 2026 15:28:49 +0100
Message-ID: <20261118150305.382779713@linuxfoundation.org>
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

From: Nitesh Venkatesh <nitesh.venkatesh@intel.com>

[ Upstream commit f66452a888e60fec5046c7fbdea1da1fcdaff98b ]

The KPT (Key Protection Technology) enable sysfs attribute rejects any
write when the currently enabled service is not 'asym', including writes
that disable KPT. This blocks a legitimate recovery flow:

  1. Configure the 'asym' service and enable KPT.
  2. Bring the device up, then down.
  3. Reconfigure the service to 'sym' and bring the device up.
  4. KPT is still reported as enabled, but is not active because the
     asymmetric service is no longer configured.
  5. Bring the device back down so the KPT enable attribute becomes
     writable.
  6. Writing '0' to the KPT enable attribute to clear the stale flag
     fails with:
       "KPT can only be enabled when the asymmetric service is enabled"

The asym-service check is only meaningful when enabling KPT; disabling
must always be permitted so a stale enable flag can be cleared after
the service configuration has changed.

Parse the user-supplied boolean before the service check and gate the
check on the enable direction. Disable requests are now accepted
regardless of the currently configured service, provided the device is
in the down state (which the attribute already requires for any write).

Fixes: fb98254a5eb9 ("crypto: qat - add KPT support for GEN6 devices")
Signed-off-by: Nitesh Venkatesh <nitesh.venkatesh@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/qat/qat_common/adf_sysfs_kpt.c      | 24 ++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.c
index 1f733ae80bdfa..a0db98f33f1fe 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.c
@@ -31,6 +31,7 @@ static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
 	struct adf_hw_device_data *hw_data;
 	struct adf_accel_dev *accel_dev;
 	bool enable;
+	int svc;
 	int ret;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
@@ -38,14 +39,25 @@ static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	if (adf_dev_started(accel_dev)) {
-		dev_info(dev, "Device qat_dev%d must be down before enabling KPT\n",
+		dev_info(dev, "Device qat_dev%d must be down before changing KPT state\n",
 			 accel_dev->accel_id);
 		return -EINVAL;
 	}
 
-	if (adf_get_service_enabled(accel_dev) != SVC_ASYM) {
-		dev_info(dev, "KPT can only be enabled when the asymmetric service is enabled\n");
-		return -EINVAL;
+	ret = kstrtobool(buf, &enable);
+	if (ret)
+		return ret;
+
+	if (enable) {
+		svc = adf_get_service_enabled(accel_dev);
+		if (svc < 0)
+			return svc;
+
+		if (svc != SVC_ASYM) {
+			dev_info(dev,
+				 "KPT can only be enabled when the asymmetric crypto service is enabled\n");
+			return -EINVAL;
+		}
 	}
 
 	hw_data = GET_HW_DATA(accel_dev);
@@ -59,10 +71,6 @@ static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
 	if (!hw_data->accel_capabilities_mask)
 		return -EINVAL;
 
-	ret = kstrtobool(buf, &enable);
-	if (ret)
-		return ret;
-
 	user_data = GET_KPT_USER_DATA(accel_dev);
 	user_data->enable = enable;
 
-- 
2.53.0



