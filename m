Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026597;
	b=4zir04ZdZYoyFlEueCR+iZyb3oXWh/QcoENV9eTtO6BDEr6WQQI+nuvAbCsAHLtNfKG5
	 hCAoY/GYlLrJUE8V4C6F9olJcolh/mgEtNd//oar1gGbxXSPrgZY4GP8j4CGfBMXGA6qS
	 A0YCHBTiwpS0o6h4xS3gmmKKMJcnfPNw8KpNgHvJ1VQEEkvWG+FLNI3hAg3Del4Cc/DvF
	 2QXeCmOs1MGIqEw3IYR6Q7fgaRD7MDRFFUB3Fy+9cnDGh09NzRN3LUGBvkg+xgGr4TfL+
	 D3VBg4t11W1VMHuAdwytZmuo4DFtO+kj+qCnC4fnBTHbmncTcq3vHewo+espgMxw+bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RR8Ase3I9bj4ZCPTGGavuqTq7dz+6HsqDvW/xgWL0kI=;
	b=G2zaUGw27PKA+7RC3UU3wyMYEm2ITN1lAetm2HtygHIcwcD7zL1AF9SmIlFEByxRSRi9
	 STBvBM5WS70XQFUcitgKXZnuNQmcZk2axiZao4AbquzFpPlNCCF5etHKhlwUinxS898O7
	 kcpcCUcCgKK0GG6y4tmD3BJevd6yLZoQQiuUl+8bpdxR9RkxEwk+sVGmLmtRRpr0dlRna
	 +uZuId0nrdfbYDdpdhZqCsb+afkXGif52PaP5e2Y4yftsMYRfZpYlohMmStQjwNZwhdio
	 IuAKVFmhFiCAm9O6LoT+vmEe3pHLosOS1Uw1VO948pyd5fvoj1pjaotRAC4ehTBb5nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eg1cliOo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C0B606A31C;
	Wed, 18 Nov 2026 18:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eg1cliOo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BDB1F000C4;
	Wed, 18 Nov 2026 18:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026597;
	bh=RR8Ase3I9bj4ZCPTGGavuqTq7dz+6HsqDvW/xgWL0kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eg1cliOoO5VpUCmZNbR1TLqiiX7ZPIrDzNt6Ryb7hZESeqwZe9w/VHekbbuyXsVhK
	 Kc6+IRq8WjljFG2HX4T5mi5OsarOP6r/fT4LKn5HXSmQ7kC/DR9iENWBnkpZWZAwh2
	 dKKBx2COnB1wbuPn20Gk1GYTLwD6iI9IG+yYNfbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1492/2151] wifi: iwlwifi: mvm: fix the VHT MCS sent to a v1 firmware
Date: Wed, 18 Nov 2026 15:53:47 +0100
Message-ID: <20261118150216.224532983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit a2f60db1c1514c7d083b5c0c8b9510b1adf0cc2c ]

When converting a v3 rate to the v1 format, the MCS index was read
from the mask of the NSS field and written into the mask of the MCS
field. This is obviously wrong, we must not mix the NSS and the MCS.

Fixes: 3592c0083fb2 ("wifi: iwlwifi: mvm: fix beacon template/fixed rate")
Assisted-by: LLM
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20261011140453.dfca0c8b560a.I7a3e1f0e91f0d0c6f4c5f1e6a33dc7c0c5e9ad11@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 2931a8d5ccc96..557c16d4e609d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1372,8 +1372,8 @@ __le32 iwl_mvm_v3_rate_to_fw(u32 rate, u8 rate_ver)
 	case RATE_MCS_MOD_TYPE_VHT:
 		result = RATE_MCS_VHT_MSK_V1;
 		result |= u32_encode_bits(u32_get_bits(rate,
-						       RATE_VHT_MCS_NSS_MSK),
-					  RATE_MCS_CODE_MSK);
+						       RATE_MCS_CODE_MSK),
+					  RATE_VHT_MCS_RATE_CODE_MSK);
 		result |= u32_encode_bits(u32_get_bits(rate, RATE_MCS_NSS_MSK),
 					  RATE_VHT_MCS_NSS_MSK);
 		break;
-- 
2.53.0



