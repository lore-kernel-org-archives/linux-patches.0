Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713E36FC5;
	Tue, 12 May 2026 18:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609736; cv=none; b=iWbvyTtJvLe4VsF93EQR9l8GQLygRF6qj+Ay6cp2yW0YJw3qZs1sWdrVEhMPoXjI6kqMZLjhr6bmbNw2y26lgUNX++mSIIUwnnuLZBfoDFdkNbSKjFPQM4WXiVcKnYZMxMzQ17mG9kZ9bqxODYhfXVWK+jIDVcWXndan65XG5mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609736; c=relaxed/simple;
	bh=dRcYVSQO4ztj5m+DnCztl9dYGfeoYHhQmvNrw6GVBzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=re3Vaq0CUjY2FR2m/XKbpLED3fUTY9euqzCLIjadT4GHco85LTQnZuu8ZPu/15gFrPBwnBfcO9B8h0SU1GvJ3DcSwJHnw6OV3wegcqP/2PIs2oibyr/D4KSI2EOkf5H6keHTj+LLelrIVmy58jh/N/ravqeVJY38DUMOWTLnL8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REH9SkYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REH9SkYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34B0C2BCC7;
	Tue, 12 May 2026 18:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609736;
	bh=dRcYVSQO4ztj5m+DnCztl9dYGfeoYHhQmvNrw6GVBzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REH9SkYdScyieIRjNSKd9JXBXW7mKGnZ+YY8xRvf0CwYnWN+/Gd3J3EbGAu+Qv/F8
	 l+RiJ0RsSbJ39nonFDmHJvW7yFrJxUUABuSsC1vFw7PkAPrlPG5NU9DyPyPeDjzAfX
	 IB7iEJtKMz6OBdB2hmzKBdGv+0vLmZEwUxQWZuwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 296/307] crypto: qat - fix indentation of macros in qat_hal.c
Date: Tue, 12 May 2026 19:41:31 +0200
Message-ID: <20260512173946.375989839@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>

[ Upstream commit 4963b39e3a3feed07fbf4d5cc2b5df8498888285 ]

The macros in qat_hal.c were using a mixture of tabs and spaces.
Update all macro indentation to use tabs consistently, matching the
predominant style.

This does not introduce any functional change.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: e7dcb722bb75 ("crypto: qat - fix firmware loading failure for GEN6 devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/qat_hal.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/crypto/intel/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_hal.c
@@ -9,17 +9,17 @@
 #include "icp_qat_hal.h"
 #include "icp_qat_uclo.h"
 
-#define BAD_REGADDR	       0xffff
-#define MAX_RETRY_TIMES	   10000
-#define INIT_CTX_ARB_VALUE	0x0
-#define INIT_CTX_ENABLE_VALUE     0x0
-#define INIT_PC_VALUE	     0x0
-#define INIT_WAKEUP_EVENTS_VALUE  0x1
-#define INIT_SIG_EVENTS_VALUE     0x1
-#define INIT_CCENABLE_VALUE       0x2000
-#define RST_CSR_QAT_LSB	   20
-#define RST_CSR_AE_LSB		  0
-#define MC_TIMESTAMP_ENABLE       (0x1 << 7)
+#define BAD_REGADDR			0xffff
+#define MAX_RETRY_TIMES			10000
+#define INIT_CTX_ARB_VALUE		0x0
+#define INIT_CTX_ENABLE_VALUE		0x0
+#define INIT_PC_VALUE			0x0
+#define INIT_WAKEUP_EVENTS_VALUE	0x1
+#define INIT_SIG_EVENTS_VALUE		0x1
+#define INIT_CCENABLE_VALUE		0x2000
+#define RST_CSR_QAT_LSB			20
+#define RST_CSR_AE_LSB			0
+#define MC_TIMESTAMP_ENABLE		(0x1 << 7)
 
 #define IGNORE_W1C_MASK ((~(1 << CE_BREAKPOINT_BITPOS)) & \
 	(~(1 << CE_CNTL_STORE_PARITY_ERROR_BITPOS)) & \


