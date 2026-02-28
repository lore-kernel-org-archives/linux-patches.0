Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F45137224F;
	Sat, 28 Feb 2026 17:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301491; cv=none; b=NDt6d9LXaRPdKJH0mkNrwwYMpIog3hHdzMycngYAksiQA0iKR5zWRmwatqdZ7rCxhndAjFCEm0s+HdwrapMSHXwLLoOn1SLTzQ9aynxVQXKyLRG7pBboDPKMxZjjpiaiz8qYxIlie90K4B0A5adryFmRkxX853iMjG50DbiFAj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301491; c=relaxed/simple;
	bh=F/1/VNcsCrnYdwGp3WAGQXy98Un5OdYgzPHEUVOVs2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThsSGYwk4Z9Cib7jpxucdiFJBJX8ydJbfJQ16WzgG36kk6TmEhOQCO62aDlin1YM2H608r8SjuO2Gi36gGyfhDqCPACDTumtz2A1UF4iXSh8+rqi82j4KBjLAc0RGpM0mhID+5oyZTk0rbADVQwhivhsRdDNQ1PA/l0dS6CMCnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s4f6jHc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s4f6jHc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC16EC19425;
	Sat, 28 Feb 2026 17:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301491;
	bh=F/1/VNcsCrnYdwGp3WAGQXy98Un5OdYgzPHEUVOVs2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4f6jHc3IvkvHpy0oO1UQmopAOKlZ7oyISs5MT4Q3L8vOnQilS+B/AxRogdIdPdeJ
	 Y3M8xqFJPy3DScWjRXcy3dpIDueaDAsI4kUIdc1G/0dR+CKlwziQHTfBr1BG92Hyy3
	 u9lNH/7tXa8ndzwC/0w9ZckaZ1T6C1gVkk1Tb72A4KlqznADiPXBJyjDLdHxZU8lAM
	 bUbuwj7dBF8h4+AxLhhE0gqLeXSmXNcmjVOu+5qSdQatvqtx7aF2zdWbKEDCTppfjG
	 udYyT4FX4lojkT49SXjbawZ6rMNw8Fuq0IZAp50Of+XwtoU5O/2CYW2cZ1H0TDAATg
	 RdEQRyb0iwygw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ethan Tidmore <ethantidmore06@gmail.com>,
	stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 677/752] staging: rtl8723bs: fix null dereference in find_network
Date: Sat, 28 Feb 2026 12:46:28 -0500
Message-ID: <20260228174750.1542406-677-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 41460a19654c32d39fd0e3a3671cd8d4b7b8479f ]

The variable pwlan has the possibility of being NULL when passed into
rtw_free_network_nolock() which would later dereference the variable.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Link: https://patch.msgid.link/20260202205429.20181-1-ethantidmore06@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index c06d990350e69..362c904adddc5 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -835,8 +835,10 @@ static void find_network(struct adapter *adapter)
 	struct wlan_network *tgt_network = &pmlmepriv->cur_network;
 
 	pwlan = rtw_find_network(&pmlmepriv->scanned_queue, tgt_network->network.mac_address);
-	if (pwlan)
-		pwlan->fixed = false;
+	if (!pwlan)
+		return;
+
+	pwlan->fixed = false;
 
 	if (check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) &&
 	    (adapter->stapriv.asoc_sta_count == 1))
-- 
2.51.0

