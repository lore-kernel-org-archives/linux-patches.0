Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA917537EA;
	Mon,  8 Jan 2024 15:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKrxMAVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168DDC433C8;
	Mon,  8 Jan 2024 15:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728432;
	bh=ttQ6ACPSaHXVB3bbfo+rDIZ38dcx41KiP5/tUSPkwT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKrxMAVkfRnwd5VT4IwAZctN5w6vAmyAPmLONj5+RMGgzP8Lc1/dzkDTUr9gQMkF2
	 0PTt7jSGM1r+QTXcYwUpJrMR6TCqGKmafpb1sd1DpaBd1Nukc693zwd/VVmdPyd3bs
	 zxsGOSZwktJTALtM0uHfGug1I3PTRFMffTakDDr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rotem Saado <rotem.saado@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/150] wifi: iwlwifi: yoyo: swap cdb and jacket bits values
Date: Mon,  8 Jan 2024 16:35:25 +0100
Message-ID: <20240108153514.619342893@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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
index 157d1f31c4871..c5a306b01fe20 100644
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
 
 #define WFPM_GP2			0xA030B4
 
-- 
2.43.0



