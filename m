Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1068316F84F;
	Wed,  2 Oct 2024 13:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875402; cv=none; b=YV2FfAGiCIm3m2gQWT4yFRYhgvKR9KmJOgGLZm4aAU+3qJeyM8OGZnbBrzDw/jlSUq5HEvvBEVS4/mY9feiyKdnNJQeB4F3qUdovOfzzgrs6LzJ51E8SDmToLJYQBoxMnbqpzx8PM+O1+zlAj571kdD3bSmz/XycAzzl8ewU1Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875402; c=relaxed/simple;
	bh=4MNlHYDsspHFJNFl1nNOrVRpLKNY/Zyg0bGtKB42Z0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrXX/OYTwJ1yUh02nMyEWFFHjslynVaRxeNwkB+N/+1+dWuCGOMnVO8LFjP21B9XrJwaovt+X0UJimLE+2boli9RLup208hGXwAfkl2s8JMvEj1bTXqcwrJOmmF0JzFHcxCYk30tthb4z9uAoOlqrYQot+44to4uTSHZHi8kQKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4jGUzUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4jGUzUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674CEC4CEC5;
	Wed,  2 Oct 2024 13:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875401;
	bh=4MNlHYDsspHFJNFl1nNOrVRpLKNY/Zyg0bGtKB42Z0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B4jGUzUm4rxo3NSxE2be7QG7nrc41/el+jw0ABzIAAet+8Ibpg57a7AqWodjJjlt2
	 8P//Jyte7EXXmJfOGevPe0iJWMcQf4FjVdJb7sKZfbUdWMejqS4OQmPLUCQcN2eypr
	 MgxES3AghMBJ9Y9Rxf1UYkOAjPe6LKnY9AJOs6aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 048/695] wifi: iwlwifi: mvm: set the cipher for secured NDP ranging
Date: Wed,  2 Oct 2024 14:50:46 +0200
Message-ID: <20241002125824.406775272@linuxfoundation.org>
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

[ Upstream commit a949075d4bbf1ca83ccdeaa6ef4ac2ce7526c5f4 ]

The cipher pointer is not set, but is derefereced trying to set its
content, which leads to a NULL pointer dereference.
Fix it by pointing to the cipher parameter before dereferencing.

Fixes: 626be4bf99f6 ("wifi: iwlwifi: mvm: modify iwl_mvm_ftm_set_secured_ranging() parameters")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240729201718.24e83369f136.I80501ddcb82920561f450d00020d860e7a3f90c6@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index afd90a52d4ecb..55245f913286b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -772,6 +772,7 @@ iwl_mvm_ftm_set_secured_ranging(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			struct iwl_mvm_ftm_iter_data target;
 
 			target.bssid = bssid;
+			target.cipher = cipher;
 			ieee80211_iter_keys(mvm->hw, vif, iter, &target);
 		} else {
 			memcpy(tk, entry->tk, sizeof(entry->tk));
-- 
2.43.0



