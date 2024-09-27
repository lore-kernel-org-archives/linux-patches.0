Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40B518C016;
	Fri, 27 Sep 2024 12:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440317; cv=none; b=FIZ2q1ngb9/UA7CUDSAZmZ+N3r9cC8NexeXjIqT7rO8wJb8BH6lgq7OzDiqqWIh772hIeQYtNi8EIKekHmp7Jj6ot/TEkr72i9wyTLwx16+9hoQTDYzEHA7J4M5jKgOn6ktAxmbCULZB7vtOQHjYja/zq8cL21JhE/jX0cmeUUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440317; c=relaxed/simple;
	bh=6aQ+8OOMsyrjvuCjYuBD5xaNj6+7Y6SV7FYLBGRcVBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgL2LTecwspdJ5q26RNaxbci5K8RCvOlgwzeKXhtjdhRXviU2iQpmidwD0lj4zbJ4uUSm2nX1044a8OWo+k92UDJMg4Eio27sxRq+Slstgk4e1+B69cLiNRC6VaK2FZBQE4M/0iqHvO7IKEUD5bQ2uIIwQfWGE7RDWg0Es2AAmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9xYGO05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9xYGO05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B51C4CEC4;
	Fri, 27 Sep 2024 12:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440317;
	bh=6aQ+8OOMsyrjvuCjYuBD5xaNj6+7Y6SV7FYLBGRcVBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9xYGO05RBF4sJ/9KFR87TRcHewlTZvrFS1ZJvEcsnCx1FnUm69qVhDMSxmKKRCPE
	 qrcu2Cp4Tj2Iy8NI3wAGyXv64Bk16lG29rZcaBcDdbii9sz7WvWRdrHYQDhFpbt5x8
	 yrPv7T+hMCy2tTGoQA1XQkh8LzWWEnKu49TG+EPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <lenb@kernel.org>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 12/73] wifi: iwlwifi: lower message level for FW buffer destination
Date: Fri, 27 Sep 2024 14:23:23 +0200
Message-ID: <20240927121720.354826182@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit f8a129c1e10256c785164ed5efa5d17d45fbd81b ]

An invalid buffer destination is not a problem for the driver and it
does not make sense to report it with the KERN_ERR message level. As
such, change the message to use IWL_DEBUG_FW.

Reported-by: Len Brown <lenb@kernel.org>
Closes: https://lore.kernel.org/r/CAJvTdKkcxJss=DM2sxgv_MR5BeZ4_OC-3ad6tA40TYH2yqHCWw@mail.gmail.com
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240825191257.20abf78f05bc.Ifbcecc2ae9fb40b9698302507dcba8b922c8d856@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index 75fd386b048e9..35c60faf8e8fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -68,7 +68,8 @@ iwl_pcie_ctxt_info_dbg_enable(struct iwl_trans *trans,
 		}
 		break;
 	default:
-		IWL_ERR(trans, "WRT: Invalid buffer destination\n");
+		IWL_DEBUG_FW(trans, "WRT: Invalid buffer destination (%d)\n",
+			     le32_to_cpu(fw_mon_cfg->buf_location));
 	}
 out:
 	if (dbg_flags)
-- 
2.43.0



