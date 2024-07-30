Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B021A6161;
	Tue, 30 Jul 2024 16:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357027; cv=none; b=MxfDlM3ZSIUSiEHC6wFNdCASPtu4n7DCcNvh5DUOWJ1j8eLJUfT7Df5jlzahWDCRvseKmtexPl5j9YQd+e1HnL+FbPKZZNRx8jO+YI2oZs+uDNlAku7NTQWEj1SDmthL8Z1FmKKz8kBYYpIlI466HJkNTgEQOUP8/FaQ6X+2Isc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357027; c=relaxed/simple;
	bh=Ubp10UyruLnmI5cOFXpL9zvp6AjulhryhH8x3bl/AkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmd3H+mtjW5rva+dd2Uh+J1IrOsJ212zU/JKgiG8HhCy2cVI+kOCGtv/wbMbAU3choGrAqmfdi5fwR2/8giVAulnCXiJFBH907jRSYO5Nd+Twug9K/DKHA9XGJdwhV3RPBZEDjR4iAbppqPlJRhI19NuQhW8SM9xsGN1qcDyKUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNpm2tOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNpm2tOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27B0C32782;
	Tue, 30 Jul 2024 16:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357027;
	bh=Ubp10UyruLnmI5cOFXpL9zvp6AjulhryhH8x3bl/AkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNpm2tOoZt+e8bpt2ZXcDUrszdz8UNCN7plUis8s3Y2rzHF8SGXx5Y7MFcNJxJdZg
	 o6aGnkDg9uzgKVYXMLTXkJ1WdMO986VfxXIqTUoT3cTR4PRLAo+BzIIWvSzEta34+h
	 nh43gcQKUUhjBkQkp3Z7Tg7RAJbu0HYhhr+h+HZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 211/809] wifi: iwlwifi: fix iwl_mvm_get_valid_rx_ant()
Date: Tue, 30 Jul 2024 17:41:27 +0200
Message-ID: <20240730151732.939525558@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Gabay <daniel.gabay@intel.com>

[ Upstream commit 0091eda01412805e0d2c8025638ac0992102a7fc ]

Fix incorrect use of _tx_ valid ant data in the function.

Fixes: 4ea1ed1d14d8 ("wifi: iwlwifi: mvm: support set_antenna()")
Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240618200104.b7c6a320c7dc.I3092eb5275056f2162b9694e583c310c38568b2a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 6837d8afb9877..ded094b6b63df 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1863,10 +1863,10 @@ static inline u8 iwl_mvm_get_valid_tx_ant(struct iwl_mvm *mvm)
 
 static inline u8 iwl_mvm_get_valid_rx_ant(struct iwl_mvm *mvm)
 {
-	u8 rx_ant = mvm->fw->valid_tx_ant;
+	u8 rx_ant = mvm->fw->valid_rx_ant;
 
 	if (mvm->nvm_data && mvm->nvm_data->valid_rx_ant)
-		rx_ant &= mvm->nvm_data->valid_tx_ant;
+		rx_ant &= mvm->nvm_data->valid_rx_ant;
 
 	if (mvm->set_rx_ant)
 		rx_ant &= mvm->set_rx_ant;
-- 
2.43.0



