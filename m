Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954CB8472
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A1DC433C7;
	Mon, 11 Sep 2023 14:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442871;
	bh=LQzq85J6k7U7JDduhFkEQHb3A+46YwmCyC5m60Tis5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vex2SjTIkO9sIbrBq9TcFaYBFy5NpFasBGr4STFtR7B3CfNuOelHa8KYIjnX+X0P6
	 DaH1R7AoD2FsnrJr3nOp/YcFDJ+QhVO9rhxbIyl+86c1j0CUhlHQ1mMRTOkNeR8RnR
	 TKJFW2fob4WoTk6Rv9560d3RqYB735s/MQLk5Nu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 150/737] crypto: qat - change value of default idle filter
Date: Mon, 11 Sep 2023 15:40:09 +0200
Message-ID: <20230911134654.676639303@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h
index f8f8a9ee29e5b..db4326933d1c0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h
@@ -35,7 +35,7 @@
 #define ADF_GEN4_PM_MSG_PENDING			BIT(0)
 #define ADF_GEN4_PM_MSG_PAYLOAD_BIT_MASK	GENMASK(28, 1)
 
-#define ADF_GEN4_PM_DEFAULT_IDLE_FILTER		(0x0)
+#define ADF_GEN4_PM_DEFAULT_IDLE_FILTER		(0x6)
 #define ADF_GEN4_PM_MAX_IDLE_FILTER		(0x7)
 
 int adf_gen4_enable_pm(struct adf_accel_dev *accel_dev);
-- 
2.40.1



