Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4724E1D6;
	Mon,  1 Apr 2024 16:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990343; cv=none; b=d9DLl5R2/DZQTIMLdAKpfvipcfXFQjn6GW7Y2mHsRbY41xI929kAFWxfv259bclwa7nN6zz7SUWiwqfeUdIuJy6st8abeE3h20qlPOTqI2ScXvGEeiZLDWc9IIFabSMFk513/EZhNZKkEiZzs9M3EyXDb3ac3ZkfdhkpluF4G3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990343; c=relaxed/simple;
	bh=o0a3fu1UgUvmYE+JWRv7ok1x6UEihRcM5NAaSW76cZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyTUx3JNUsGLE7NbY7VEdzYULGvUYklmOoWCPJklAibvyZcHNgId4hZ/p4CO2mjtclS3IjctqTI8hZXMychJd2/7T3TCVql8f5m/k+O+sM6xdJSnoUWjrqaVH5R+SIvinZyQUzGRiOFRbbPPCHcGo8mHFvJ99IVs6N0whq0ZN7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRg5czjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRg5czjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A7EC433F1;
	Mon,  1 Apr 2024 16:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990343;
	bh=o0a3fu1UgUvmYE+JWRv7ok1x6UEihRcM5NAaSW76cZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRg5czjj1yUYuWxWFNSOClqkA2aC0zI2cFJgJjCmWJhI+QNbrzKux+0hytHdUT3cf
	 tig6ei7fOMuWdT33lTuK7Dsu5FNCa7cQUAtQr1RGKjtyfOQkKTQsFnwpVYlg6e9oJT
	 /9XKfxa7kTre052xOVJJJXbMwFOD2RCKogke2bQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 322/396] wifi: iwlwifi: mvm: disable MLO for the time being
Date: Mon,  1 Apr 2024 17:46:11 +0200
Message-ID: <20240401152557.515524071@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -318,7 +318,7 @@ int iwl_mvm_mac_setup_register(struct iw
 	if (mvm->mld_api_is_used && mvm->nvm_data->sku_cap_11be_enable &&
 	    !iwlwifi_mod_params.disable_11ax &&
 	    !iwlwifi_mod_params.disable_11be)
-		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_MLO;
+		hw->wiphy->flags |= WIPHY_FLAG_DISABLE_WEXT;
 
 	/* With MLD FW API, it tracks timing by itself,
 	 * no need for any timing from the host


