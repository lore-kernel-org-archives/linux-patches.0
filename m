Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD79728B4FA;
	Sat, 12 Sep 2026 08:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202886; cv=none; b=IkPpEbHguOb1vzPt6DAOF4VWmTqOAVMP7rhDpHCww+A+8EV0FD5MPm6ZCfiTbw3GfyYfijenS0IrlrIUgC1fATQ6icOwccA3WOYMdgX8y8lUul7qoHtKfRVLwRB+kvSSVAa5l0JytM4lZ7MZw0GLjkVQPEaAqbeuaoZDY11UXO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202886; c=relaxed/simple;
	bh=I8uJgFyKvTZTMXcnJQMI7s63SGYUr2apU+V7EwPE7gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFmM3p1vSC1tv1N5Q9uQZ83knegxse4HUO8yVl3BI9M9ibeOq2SLpmLJ8SMPmeD3MJ0ayO4e0nql7aD9PO1oV/8PBYSdmhD9qKztmqVQQAwx4POJz1oDFL6Vjc2rBTg+XX76vMfMGJ4McRraUQBaRNfL+zlzU4d32Yln/zo3MkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2260c82; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2260c82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08061F00893;
	Sat, 12 Sep 2026 08:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202883;
	bh=We9kkpYcqqBtWpuG+aTcxseR8kMuF3jH5SZO5eDgU2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2260c82mDo29JWDNNK5aYe0P6goSy2M75QgMPZZjpVxRfXR3y1pRXIaq4z0eCVK6
	 OBb5wLNH3xlynrPwJFTW5h3FZ9sjLzgSfU3Zj6jghj1uPyDDyLY+fT8NmDchouRYQR
	 EudqG1fLPUnqpxSnDwIxK2zDL9Z/iKu2C+n75q1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1296/1815] crypto: qat - remove dead ADF_HEX code
Date: Sat, 12 Sep 2026 08:50:46 +0200
Message-ID: <20260912065719.441197026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit 61135c1597af56eb454d53c9d7cda90d5e5dc566 ]

The ADF_HEX value type is defined in the adf_cfg_val_type enum and
handled in adf_cfg_add_key_value_param(), but no caller in the tree
uses it.

Remove the unused ADF_HEX enum value and its dead handling code.

Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_cfg.c        | 3 ---
 drivers/crypto/intel/qat/qat_common/adf_cfg_common.h | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index d97ee10000452..b88febf53a19d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -292,9 +292,6 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 			 "%ld", (*((long *)val)));
 	} else if (type == ADF_STR) {
 		strscpy(key_val->val, (char *)val);
-	} else if (type == ADF_HEX) {
-		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
-			 "0x%lx", (unsigned long)val);
 	} else {
 		dev_err(&GET_DEV(accel_dev), "Unknown type given.\n");
 		kfree(key_val);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h
index d63f4dcccbb5d..5922d018f5b98 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h
@@ -28,7 +28,6 @@ enum adf_cfg_service_type {
 
 enum adf_cfg_val_type {
 	ADF_DEC,
-	ADF_HEX,
 	ADF_STR
 };
 
-- 
2.53.0



