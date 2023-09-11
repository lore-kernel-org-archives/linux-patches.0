Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5FD11715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D1CC433C9;
	Mon, 11 Sep 2023 15:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444867;
	bh=ACQcNbWpflEesWC5DgfH1wCQkb69Vixc9UhpEFQZaH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOPLJhD0FrIvAVQrmvkMICqKHwfBCiuRWqbn+vap3kdL5g5+pkLi6hY/5xQB4pb0E
	 AyzVMSTSshixPEgIji5bHkf1okrsi4cF40w8ZZlB8+mzmrn1bDPAhYig88wGs5cXBP
	 cBhSnHxWax3TSbE0JGpAE4B+3+JXO5/luz/MfNBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/600] crypto: qat - change value of default idle filter
Date: Mon, 11 Sep 2023 15:42:57 +0200
Message-ID: <20230911134637.857663926@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 0f942bdfe9d463be3073301519492f8d53c6b2d5 ]

The power management configuration of 4xxx devices is too aggressive
and in some conditions the device might be prematurely put to a low
power state.
Increase the idle filter value to prevent that.
In future, this will be set by firmware.

Fixes: e5745f34113b ("crypto: qat - enable power management for QAT GEN4")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_gen4_pm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen4_pm.h b/drivers/crypto/qat/qat_common/adf_gen4_pm.h
index f8f8a9ee29e5b..db4326933d1c0 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_pm.h
+++ b/drivers/crypto/qat/qat_common/adf_gen4_pm.h
@@ -35,7 +35,7 @@
 #define ADF_GEN4_PM_MSG_PENDING			BIT(0)
 #define ADF_GEN4_PM_MSG_PAYLOAD_BIT_MASK	GENMASK(28, 1)
 
-#define ADF_GEN4_PM_DEFAULT_IDLE_FILTER		(0x0)
+#define ADF_GEN4_PM_DEFAULT_IDLE_FILTER		(0x6)
 #define ADF_GEN4_PM_MAX_IDLE_FILTER		(0x7)
 
 int adf_gen4_enable_pm(struct adf_accel_dev *accel_dev);
-- 
2.40.1



