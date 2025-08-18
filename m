Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD3D205AA1;
	Mon, 18 Aug 2025 13:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523816; cv=none; b=LmcXWUEtzGorlm9QS5pKzuwk+NuBKq9i1O5BtDIsKBaP4CbqZYDpfJUvs111djRHh35fO7g+YZ/QH2afUsskVo1Uwr/WGZ2HpuAo3Wo8QfhEiIoqH8SKtAtjWEs30gG21bUdQ8a99hNuqt+w7dwY/3EnUIlc8HqQS61bYRoPwQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523816; c=relaxed/simple;
	bh=LWom5YdR7PcyCRIYJOaH4mmgL213knB2x8gNJ2ZLbNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOGilJI9DChMX2/KSjcnbb58z0Vko0Xpd6CF3HVQkTmOXNbzL/hIxRkrWbn30kwTAnTPSfWQIyN3Qzeoyy+yBQ9SoYenDBuDt4FyxJR+zbmPO4dyuswsNYvWm1D1Lkg8wFJHnbzVGa823ycfn7js7Zh4yq36O7pRE7g0LDssAw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1X7eLm1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1X7eLm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3751C4CEEB;
	Mon, 18 Aug 2025 13:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523816;
	bh=LWom5YdR7PcyCRIYJOaH4mmgL213knB2x8gNJ2ZLbNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1X7eLm1J62szGvbhp+WWycTc5Ni/OJn9gvGVkExkQr+I/3oUcu5DRMHgNL+uCVi3
	 cESjritsFHj/g0oaaiUS6RE7SMqajnkHOfHhf19MmeVhqm/0FUnx1lS2OOrG+v8JK7
	 DigrUMT9i+ovB/Q9rxanWsf6ekCDcSNpf8VPuOZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 281/515] wifi: iwlwifi: mld: fix last_mlo_scan_time type
Date: Mon, 18 Aug 2025 14:44:27 +0200
Message-ID: <20250818124509.241201618@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f26281c1b727b90ec18ae90044d5f429d2250e82 ]

This should be u64, otherwise it rolls over quickly on 32-bit
systems.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250611222325.5381030253cd.I4e3a7bca5b52fc826e26311055286421508c4d1b@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/scan.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/scan.h b/drivers/net/wireless/intel/iwlwifi/mld/scan.h
index 3ae940d55065..4044cac3f086 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/scan.h
@@ -130,7 +130,7 @@ struct iwl_mld_scan {
 	void *cmd;
 	unsigned long last_6ghz_passive_jiffies;
 	unsigned long last_start_time_jiffies;
-	unsigned long last_mlo_scan_time;
+	u64 last_mlo_scan_time;
 };
 
 #endif /* __iwl_mld_scan_h__ */
-- 
2.39.5



