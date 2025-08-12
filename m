Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07682F291B;
	Tue, 12 Aug 2025 18:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024272; cv=none; b=knLgYI5QyZvqfu3sbVX4Wmfo5BVK5d2GhXyLDIJ3yBvi0X/79ub+00grqVq/ptV7sQdezZ1Tqx20A+KNP3yMxt0I0Qwnhqd9DpxT+0QLbUAAqo0zYMUXh91wY9VEwn3q1m7XLsmnHumRIB7L7ijCrvKHXT0qpXRSUJyFygo6Hg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024272; c=relaxed/simple;
	bh=J+248NYXJceAyF5YHImgxbr2Q+WvC7wccB+Io6ZPKsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDX6cBKz7KwoMURkxQ0J6zW7+b9VRv8zodZh6ExmiQ7IVaNw0xHoOzfnn2vs2mFYdU1hq+fpDe9jmUWvvfB4RB5NOAgJqxSgClWmrmgRtX8tSFg44nmxNgusKV9Afsk0sBWnLUNfLqAYCCT21bv5M54577ZanS8Eeuo0I1B6cJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8pHuiFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8pHuiFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B60C4CEF0;
	Tue, 12 Aug 2025 18:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024272;
	bh=J+248NYXJceAyF5YHImgxbr2Q+WvC7wccB+Io6ZPKsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8pHuiFqaXoUmP6LDcGwGtouUPh8MGcwLgIpYoTHxjR8YoittqLOAVazuot5txtZC
	 dlzD8hX1hB7El3xiiExNSqFn2zoL9eASfAS1xqN2WoWfj/W82JPwz02ug3W3DN1cmr
	 hbm89sucvE9hHqHA2rLMKosaU04uE/ohdCZXPNGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 325/627] crypto: qat - restore ASYM service support for GEN6 devices
Date: Tue, 12 Aug 2025 19:30:20 +0200
Message-ID: <20250812173431.658753749@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>

[ Upstream commit 4e55a929ff4d973206879a997a47a188353b3cd6 ]

Support for asymmetric crypto services was not included in the qat_6xxx
by explicitly setting the asymmetric capabilities to 0 to allow for
additional testing.

Enable asymmetric crypto services on QAT GEN6 devices by setting the
appropriate capability flags.

Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index 359a6447ccb8..185a7ab92b7b 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -627,7 +627,15 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
 	}
 
-	capabilities_asym = 0;
+	capabilities_asym = ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
+			    ICP_ACCEL_CAPABILITIES_SM2 |
+			    ICP_ACCEL_CAPABILITIES_ECEDMONT;
+
+	if (fusectl1 & ICP_ACCEL_GEN6_MASK_PKE_SLICE) {
+		capabilities_asym &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
+		capabilities_asym &= ~ICP_ACCEL_CAPABILITIES_SM2;
+		capabilities_asym &= ~ICP_ACCEL_CAPABILITIES_ECEDMONT;
+	}
 
 	capabilities_dc = ICP_ACCEL_CAPABILITIES_COMPRESSION |
 			  ICP_ACCEL_CAPABILITIES_LZ4_COMPRESSION |
-- 
2.39.5



