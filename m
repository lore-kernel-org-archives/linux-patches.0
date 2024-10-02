Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AE01D0433;
	Wed,  2 Oct 2024 13:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875303; cv=none; b=mo8wQYhy2zYTptG9Dm17BbxyRgwgvehaiTownhngkOwFOWTYDD5YoXI/NTY0h/faoDqbosgbn+6hAa8o3JkRyuBlSUVUDIau7vqv/91Sx+gBUa40doSpAGrrSs2M+9n0sM+ync6sId5lvpMuXNlFr3QumOqhDpPCqHBJGddAgRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875303; c=relaxed/simple;
	bh=d/lTFQPFTnBaLHpfYevSwPzUjwKVAU6KxvCld86iaZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOmYyolDouu5h8zJGKIdQDo0N2RH3n8gZTQpgnMamgmg/H3MTrEitOyjPJtlNvLzDudClIyx2b0EATIuWHT7IMYhk4ck5uhasb918HV0+tIkakIQo9RbQqV1Y62mT2d2lvO422RMM5i4ObZR7+H+H8VqwzEM2337sACFfemlswk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjhvOz6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjhvOz6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59720C4CECD;
	Wed,  2 Oct 2024 13:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875303;
	bh=d/lTFQPFTnBaLHpfYevSwPzUjwKVAU6KxvCld86iaZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjhvOz6btzIrj08Nov8cI4A52fAI+dRSRZqo1wr+iEMKuOW8kH6rPXXHorEyRsG44
	 cagdibfuRv6noJz9r1xBSCryLjHNFCDTnEntpw1DhLHKk1KPd/QwADx7/LEZaQhLMM
	 6+YEaZkZa5LhQO5jEm5rzRW2gizn6wEmdiFVONws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 049/695] wifi: iwlwifi: mvm: increase the time between ranging measurements
Date: Wed,  2 Oct 2024 14:50:47 +0200
Message-ID: <20241002125824.446091020@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 3a7ee94559dfd640604d0265739e86dec73b64e8 ]

The algo running in fw may take a little longer than 5 milliseconds,
(e.g. measurement on 80MHz while associated). Increase the minimum
time between measurements to 7 milliseconds.

Fixes: 830aa3e7d1ca ("iwlwifi: mvm: add support for range request command version 13")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240729201718.d3f3c26e00d9.I09e951290e8a3d73f147b88166fd9a678d1d69ed@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index c4c1e67b9ac76..8f63cbe9e50da 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -109,7 +109,7 @@
 #define IWL_MVM_FTM_INITIATOR_SECURE_LTF	false
 #define IWL_MVM_FTM_RESP_NDP_SUPPORT		true
 #define IWL_MVM_FTM_RESP_LMR_FEEDBACK_SUPPORT	true
-#define IWL_MVM_FTM_NON_TB_MIN_TIME_BETWEEN_MSR	5
+#define IWL_MVM_FTM_NON_TB_MIN_TIME_BETWEEN_MSR	7
 #define IWL_MVM_FTM_NON_TB_MAX_TIME_BETWEEN_MSR	1000
 #define IWL_MVM_D3_DEBUG			false
 #define IWL_MVM_USE_TWT				true
-- 
2.43.0



