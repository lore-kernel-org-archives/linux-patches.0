Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0FD3BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVBY6P9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E98C433C7;
	Wed, 15 Nov 2023 19:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076183;
	bh=iEVRlnKVm2e3tqHeRl7OVftXfOW0RqloIKzQ+ffkow8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVBY6P9pxm7+njwpwGpwlzxE5AirFllmTi7FPOkcP7lWcxEJNNUVqpqcaqKWnWYNA
	 JWfMxjHUpDUJDIqCD6pzHCxxushnHr7hh35ohux6ZRsWSjHAl+7UmB85TwX9hE1N0H
	 HsknvX4dlT+KC8COD4+aXk0c1W74cn7vlVvb9dFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rotem Saado <rotem.saado@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 128/550] wifi: iwlwifi: yoyo: swap cdb and jacket bits values
Date: Wed, 15 Nov 2023 14:11:52 -0500
Message-ID: <20231115191609.561122048@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

From: Rotem Saado <rotem.saado@intel.com>

[ Upstream commit 65008777b9dcd2002414ddb2c2158293a6e2fd6f ]

The bits are wrong, the jacket bit should be 5 and cdb bit 4.
Fix it.

Fixes: 1f171f4f1437 ("iwlwifi: Add support for getting rf id with blank otp")
Signed-off-by: Rotem Saado <rotem.saado@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20231004123422.356d8dacda2f.I349ab888b43a11baa2453a1d6978a6a703e422f0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 6dd381ff0f9e7..2a63968b0e55b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -348,8 +348,8 @@
 #define RFIC_REG_RD			0xAD0470
 #define WFPM_CTRL_REG			0xA03030
 #define WFPM_OTP_CFG1_ADDR		0x00a03098
-#define WFPM_OTP_CFG1_IS_JACKET_BIT	BIT(4)
-#define WFPM_OTP_CFG1_IS_CDB_BIT	BIT(5)
+#define WFPM_OTP_CFG1_IS_JACKET_BIT	BIT(5)
+#define WFPM_OTP_CFG1_IS_CDB_BIT	BIT(4)
 #define WFPM_OTP_BZ_BNJ_JACKET_BIT	5
 #define WFPM_OTP_BZ_BNJ_CDB_BIT		4
 #define WFPM_OTP_CFG1_IS_JACKET(_val)   (((_val) & 0x00000020) >> WFPM_OTP_BZ_BNJ_JACKET_BIT)
-- 
2.42.0



