Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D11316078C;
	Mon, 27 May 2024 19:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836475; cv=none; b=rnymohDyzTWhogi+9NElyAQBH0baV5v4BoJv0hnPQxMFdfjyCo/7PVYg111GyAWsGh4/5GiDkSn/BkYXGQg+cAZnEg7AuMQEFxoZzIm+/HAkNX/EOouDhOFeSUWg5+BbrEQ3FVginlcRWbYFPglQ1hiVqZPOjKBZKDdMv/6FpZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836475; c=relaxed/simple;
	bh=nNDCDn9V0MDe4CdsWBMxPKbmleB/dlM0k4+aGdrNToE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PS01idfQ2y4N9jbNZGe0THHn8p4TT157a+jUnj54Sgv1dsRJITln+ioDjZDmWuN774ortvPHJAqnZVi3EpJFk1P3pqUv2fa8ruyH4ZoHUw9ILjbgOQG3QclZbtUBYrcmQWJagIC02HULGA9xoXRe8QxfFnQcoGNE36K/Lo0EabY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBFQVVX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBFQVVX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6254C2BBFC;
	Mon, 27 May 2024 19:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836475;
	bh=nNDCDn9V0MDe4CdsWBMxPKbmleB/dlM0k4+aGdrNToE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBFQVVX21ri7g6ZRv0Tc4GDEGA7qyt4Gh45ChSTgjx1Smh4ouYevkBiVWT02gfpWd
	 pJBBGsaKM0RUnK3D4O9NGM/ocwqCb8RBuRiN8PAJW0F/WKC1Dya/BoZ5LFGELKZ8ia
	 gjfAYLDfkov7CIHC7E+SjvvENGDpgRBe6xJmETyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 068/427] crypto: qat - improve error message in adf_get_arbiter_mapping()
Date: Mon, 27 May 2024 20:51:55 +0200
Message-ID: <20240527185608.168404880@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 1102c47f8293d..1d0ef47a9f250 100644
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
index 927506cf271d0..fb34fd7f03952 100644
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



