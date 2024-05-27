Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BCA15FD1E;
	Mon, 27 May 2024 19:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837773; cv=none; b=hmS1nTt9zkh5C1dh603GX62GChAW7I6vHpoy9C81kA0MrBcIAZKzGwKtCBk/NBPTMHlq7+dX91483KgfrkSlAJtI1bcn+M/71aJja+jNZAXiKTmkyTqMJP1JgQr8L5K1kC+KnhjSCiFrBYLo00ncbPckmFZ5+7vf23yYqyUg+Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837773; c=relaxed/simple;
	bh=/douf4t1b800uu3W8FVFT0l8/R5z/EljsYQcZ42gac8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdqsv+nzsR298ryJrSVRVbvFuaYSZr4bcDv9eheIuh6qpXyh+JpQuTMC4D7vUMPhravQMWErfPv16JovixGwA8iNBo3DyaXr2OkmP+JAI21KEdVCrLld8x93BKHGPBfsOi/2Qn4YSS6EP5AUsb2+QIDD+YEe6JF4n2cBlJDX+Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7codmhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7codmhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E15AC2BBFC;
	Mon, 27 May 2024 19:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837772;
	bh=/douf4t1b800uu3W8FVFT0l8/R5z/EljsYQcZ42gac8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7codmhZKHjljZfsllGnHsSIaEZZFyMuzfmwA3DLpTKOXN2I/C4MiCsLOoGQReTg4
	 zGenIAt77CURQFKSnPq0+H1BzcThOX0y8Ge9Pi6iF54aiAvitM2BT3W3r2I21GDnvv
	 JyojLRfVmycSumw5eQc218cXmrMJ13qWDa/A+/E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 140/493] crypto: qat - improve error message in adf_get_arbiter_mapping()
Date: Mon, 27 May 2024 20:52:22 +0200
Message-ID: <20240527185635.038570788@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Guerin <adam.guerin@intel.com>

[ Upstream commit 4a4fc6c0c7fe29f2538013a57ebd7813ec6c12a8 ]

Improve error message to be more readable.

Fixes: 5da6a2d5353e ("crypto: qat - generate dynamically arbiter mappings")
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 2 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 7909b51e97c30..7b8abfb797fff 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -296,7 +296,7 @@ static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
 {
 	if (adf_gen4_init_thd2arb_map(accel_dev))
 		dev_warn(&GET_DEV(accel_dev),
-			 "Generate of the thread to arbiter map failed");
+			 "Failed to generate thread to arbiter mapping");
 
 	return GET_HW_DATA(accel_dev)->thd_to_arb_map;
 }
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index e171cddf6f025..7a5c5f9711c8b 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -208,7 +208,7 @@ static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
 {
 	if (adf_gen4_init_thd2arb_map(accel_dev))
 		dev_warn(&GET_DEV(accel_dev),
-			 "Generate of the thread to arbiter map failed");
+			 "Failed to generate thread to arbiter mapping");
 
 	return GET_HW_DATA(accel_dev)->thd_to_arb_map;
 }
-- 
2.43.0



