Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83CC1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A935C433C8;
	Mon, 11 Sep 2023 13:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440472;
	bh=2vb7hXwqowa+4oVtQqEF1oRYOP7FuNmF/cHyg3I0WYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRuI0SYqr8jaPiUjtp/c6qxfKMcO3YjoX02nZOlmu5qRnYu2GuJE5TLz+D+ZkYbjZ
	 lT2Qeq+MkAtZYWrVNv1Zg0f8SidOdChjlePJRywBMq+HP9A9V/nxECfbGmkV5/ARYc
	 R/S9UYFaNIZMqBNTsfaEwW8uXRiJHsyFLQo6MAnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 073/739] crypto: qat - change value of default idle filter
Date: Mon, 11 Sep 2023 15:37:52 +0200
Message-ID: <20230911134653.158117127@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index dd112923e006d..c2768762cca3b 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h
@@ -35,7 +35,7 @@
 #define ADF_GEN4_PM_MSG_PENDING			BIT(0)
 #define ADF_GEN4_PM_MSG_PAYLOAD_BIT_MASK	GENMASK(28, 1)
 
-#define ADF_GEN4_PM_DEFAULT_IDLE_FILTER		(0x0)
+#define ADF_GEN4_PM_DEFAULT_IDLE_FILTER		(0x6)
 #define ADF_GEN4_PM_MAX_IDLE_FILTER		(0x7)
 #define ADF_GEN4_PM_DEFAULT_IDLE_SUPPORT	(0x1)
 
-- 
2.40.1



