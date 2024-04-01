Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6498A3D961;
	Mon,  1 Apr 2024 16:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988985; cv=none; b=Jn38ggD8ds8oBlPv2oBYUqw+PLaou2E63MBY1+rygMSrkdbEUKDBEA2/8WmnWYQwdqkxssOtY4115dFa3IzxIXRA5+gD3lQCrSGxXuyKpvx2lwphJHpQ4q6GzyaznSEg7f7v1LpLBBSwar8yZsuZBQzOWvmNUJeNUZy0KjlNjwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988985; c=relaxed/simple;
	bh=IYAWSUJ7hI3hPEbrdqA94R74ya7cbXZA7gIg7ezgPRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDecU18t4iGvc66ANMoYJFgLMVWNGyRM4rqrvz3eq7pfgpIH2q3A0FIIeWupJwHaRym/WJwgrZ22sob9+hwh10wlINKqfVzdyGUP8qQe0LyOpcqty/Y5HsnY3RmBnf5nzpzheIJ23nF3txSkeq8+5alwjGz/mtOdaRi9ScqEZdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGqD+ZYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGqD+ZYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82CDC433C7;
	Mon,  1 Apr 2024 16:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988985;
	bh=IYAWSUJ7hI3hPEbrdqA94R74ya7cbXZA7gIg7ezgPRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGqD+ZYkD+/Bmf2bVJcDnEkLFxnh7gpK1GlXiz29o/MdCLFJQAo331+ihiEfczNim
	 qy5rjda1nLtFeDB+i/WL+lYv0R/IRnPa8PEdtDcaHyT1XYGE+gzts/cWILPry1bQuy
	 ipFY2mA1sRHiZE563w6OZyYSKpusf9P8pR0GtL+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.7 347/432] wifi: iwlwifi: mvm: disable MLO for the time being
Date: Mon,  1 Apr 2024 17:45:34 +0200
Message-ID: <20240401152603.589670217@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 5f404005055304830bbbee0d66af2964fc48f29e upstream.

MLO ended up not really fully stable yet, we want to make
sure it works well with the ecosystem before enabling it.
Thus, remove the flag, but set WIPHY_FLAG_DISABLE_WEXT so
we don't get wireless extensions back until we enable MLO
for this hardware.

Cc: stable@vger.kernel.org
Reviewed-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240314110951.d6ad146df98d.I47127e4fdbdef89e4ccf7483641570ee7871d4e6@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -344,7 +344,7 @@ int iwl_mvm_mac_setup_register(struct iw
 	if (mvm->mld_api_is_used && mvm->nvm_data->sku_cap_11be_enable &&
 	    !iwlwifi_mod_params.disable_11ax &&
 	    !iwlwifi_mod_params.disable_11be)
-		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_MLO;
+		hw->wiphy->flags |= WIPHY_FLAG_DISABLE_WEXT;
 
 	/* With MLD FW API, it tracks timing by itself,
 	 * no need for any timing from the host


