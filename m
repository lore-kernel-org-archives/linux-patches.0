Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020155;
	b=DKFbrnkIBedoe1mKu/Q5uwnJZ8paT9NIx5lAFgd4LOAZipWLRH5QrNkSIxGdCJYTAk20
	 3gZ/KXGr9b6JdK8pldgHaRgcrYdlueNts/Tw9lDzt5HAWxHfEZGJvlGUSj9Dg22IyjYQh
	 rktKZthkX7dLX66LzOyY7yNpwolwX1um+ieRShYLgX4ZSvcuv7agROBZwac+Wt0klA3f0
	 kgGkGcVd5wYkbhsi+mQjqjzGtww/K2rZWT1kN9WkFPJqZCLzGTceftB9ztuna7gG24Nfz
	 xjq/uAr8EzTJghtuv18sAoftt4HjHsLyfokWm45HFgq7N4eSI1yB59nJU/btkuqL/aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MWqh3L2xOWQerdZFMTxDU1lDI0CHCvIONuqbqGxul/E=;
	b=rixoqA0aEoRuwEH2+oIga+eqAM0kO0eDKwKzorCJ2NhcIL6V8/zcm+Qf7V78qM6+ivih
	 N3CCf1pO+FUjmjyFq2lsPCCsp8UIzzE1WJ6AgeySSn3oxQKenfrvXnHJjok1CI9hVCwk7
	 Rfa9+dyVvqMKe/fdH+IJSdiVsK3uiURRY5Ich+f9xPbrlDL0t/+fKwgIOb14rpRzq1lJK
	 Ri+Sq0vpZht/8T0+DPfM/IbrQp4qhkWhsI6WC/bbS1nQrzuIvEWsi4QwARyG6Cnmdzpxx
	 MustdjVb78Q3t6RKsEpX0rwuzuGGVl7aSOzqsjWonh+qhjZDrz2VE/wUebYe2Cee6Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0vhMT+D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCA5606A333;
	Wed, 18 Nov 2026 16:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0vhMT+D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4392C1F000C7;
	Wed, 18 Nov 2026 16:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020154;
	bh=MWqh3L2xOWQerdZFMTxDU1lDI0CHCvIONuqbqGxul/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0vhMT+DKUf1fAIiHAq+g1L+Att3Bq7qZ4CPkASEW8VDetzpRNk6XAy2f7yohCaz9
	 IXbz5fKHRAL9mh7A0rdZivQ0nxdDYj82d/K8Zq2syjbMv+T/BovFo9JD6JULS1QNFW
	 UI3sqDEwa/3TNlFsC6Y2zn8mfGg4uiKk4kyLoJ58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1834/2651] wifi: iwlwifi: mvm: fix the VHT MCS sent to a v1 firmware
Date: Wed, 18 Nov 2026 15:51:14 +0100
Message-ID: <20261118150353.141486368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 2fd4a99611450..42432682fdc18 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1356,8 +1356,8 @@ __le32 iwl_mvm_v3_rate_to_fw(u32 rate, u8 rate_ver)
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



