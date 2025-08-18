Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA011F462D;
	Mon, 18 Aug 2025 13:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522046; cv=none; b=SXjFWXWM6n5PlzpveyLoRc9jUX9XZCpZlhpUbnE+yA/4BlnSRwfLXRLXnSewEA4wcVa0Ot3jHqXtS6eT8exDC7+y+BFVZBBo3eERXFuuoMp01LjTYKNaTVzm3Z+s3YG63dVMz5rg6Dw8nGpA4V3NVeFzrPRYhpzUFF47c5oS6gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522046; c=relaxed/simple;
	bh=CZuE6X4JIu2p6F0FzyoZm1sMvmIGbJVqQzS6PoSp5d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kyny+mA3kT1Ix72i3ZixwyusSjx1M9kVOovfrGXFLHYW2uH5AuLnQMSu2lzFLFJzfCwHK7x43eW0VCoKxffDExEMUd/u0xv0M0TPql2Xz2oYT9fLGflXPxmoi7iP6/INBo3aF90sAC46UMOj7GJKzeH/8bns0kaxilUvMkujVuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMlsGEcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMlsGEcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C38C4CEEB;
	Mon, 18 Aug 2025 13:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522045;
	bh=CZuE6X4JIu2p6F0FzyoZm1sMvmIGbJVqQzS6PoSp5d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xMlsGEcVuOxc82sG04fzEwIwHtLYFwb3FR11VszMkh4wt7cSYE48L5/He988luP9h
	 u/u/wFhk2B0aquTcq/euHvvf2s4r6xSzsDwePz58G3IMoZomRli9LsBbffkolsK7nD
	 rLq39QkMNmA33gU3bjeyvUNyEWW8s8EenoXyq920=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/444] wifi: iwlwifi: mvm: fix scan request validation
Date: Mon, 18 Aug 2025 14:43:45 +0200
Message-ID: <20250818124456.325135948@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 7c2f3ec7707188d8d5269ae2dce97d7be3e9f261 ]

The scan request validation function uses bitwise and instead
of logical and. Fix it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250709230308.3fbc1f27871b.I7a8ee91f463c1a2d9d8561c8232e196885d02c43@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index ddcbd80a49fb..853b95709a79 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -835,7 +835,7 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
 				     int n_channels)
 {
 	return ((n_ssids <= PROBE_OPTION_MAX) &&
-		(n_channels <= mvm->fw->ucode_capa.n_scan_channels) &
+		(n_channels <= mvm->fw->ucode_capa.n_scan_channels) &&
 		(ies->common_ie_len +
 		 ies->len[NL80211_BAND_2GHZ] + ies->len[NL80211_BAND_5GHZ] +
 		 ies->len[NL80211_BAND_6GHZ] <=
-- 
2.39.5



