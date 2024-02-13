Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4DF5FF04;
	Tue, 13 Feb 2024 17:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845952; cv=none; b=m+fkgh8ojPeELI6IeAwxMG2N87PvreuuKMUlSHm139piQeO4v6YAISSMlnFdSM5CwLQ0TcFHOLrncw0ZyCe0QmYNj77EzgjskvaswQNDYKwZKR7hRWyYEjXsnS4LDdYyzAYG9zRWsezE8oWI8nhk6Hn4YW5wOxP5wYvFZQ5/V3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845952; c=relaxed/simple;
	bh=nbgkVGmzcpsgH1eLTbVcXFUPdixJ8ImJDCAKXvkOenQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOxCzoCNP0acdLGL/deY352NXnc4YO54RdAsYLgZhB8JNN4+IdeJRRr/NjRplknGvPWNN6qFvbyD5vTOaxRn8hWsvRj+IDjZC/WPetPGHSRRbG+9OiyRt1jRABNdD65xQJZAuYI3DcqOfWAVLwpjo2XfJGegaO5SOJxLyli5Eg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asi6Bw9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asi6Bw9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2421BC433C7;
	Tue, 13 Feb 2024 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845952;
	bh=nbgkVGmzcpsgH1eLTbVcXFUPdixJ8ImJDCAKXvkOenQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asi6Bw9ldmLapBIedYBi5z44+gUwl4Ev6BUfCJbJZ+WLsyHRgsSHGqgXkDOlCYlXO
	 Ar60l4rfY9lzHUGSTEg58uJ/lN2kxGjQVI4/edW6nB701PtYcNs+Jo4XpofGWWh8E2
	 JjBSNpIKD17ooJRYmM8GfizAQjoquRGcKpIxxHNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Eilon Rinat <eilon.rinat@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.7 104/124] wifi: iwlwifi: mvm: fix a battery life regression
Date: Tue, 13 Feb 2024 18:22:06 +0100
Message-ID: <20240213171856.766729935@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 1fa942f31665ea5dc5d4d95893dd13723eaa97cc upstream.

Fix the DBG_CONFIG_TOKEN to not enable debug components that would
prevent the device to save power.

Fixes: fc2fe0a5e856 ("wifi: iwlwifi: fw: disable firmware debug asserts")
Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Eilon Rinat <eilon.rinat@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240128084842.90d2600edc27.Id657ea2f0ddb131f5f9d0ac39aeb8c88754fe54b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
@@ -531,7 +531,7 @@ enum iwl_fw_dbg_config_cmd_type {
 }; /* LDBG_CFG_CMD_TYPE_API_E_VER_1 */
 
 /* this token disables debug asserts in the firmware */
-#define IWL_FW_DBG_CONFIG_TOKEN 0x00011301
+#define IWL_FW_DBG_CONFIG_TOKEN 0x00010001
 
 /**
  * struct iwl_fw_dbg_config_cmd - configure FW debug


