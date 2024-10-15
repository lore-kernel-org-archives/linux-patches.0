Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6FB1C07C2;
	Tue, 15 Oct 2024 12:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997027; cv=none; b=VjQlJ8I4Bt1wWr+bS8oTnQ/pjRlsCwA5xxXVsfSYbaz2rs23FAcjY9MVLFtu4uM7AKlU7WPPmJTlHduA+skH2/Z4/NfsnYCs4aMQwEZnnL0UlbOPcLJ/ESBOwZo821enkjJcvuZnzMo/5+EDC/IR2svlUmhTSqXC7I9U7arjauY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997027; c=relaxed/simple;
	bh=Ty31nIEM55Tbx2mmi8dJAc5ZTqSzg4wgemejGBvC3Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sye1fzAM0DjWi1guqKDq7KghsAT1RkPD4NoL2gQYXKZIXyQoYMPDbAjwamr4pQSmWA9ALzO93VFVbN7VB2HKLYw2+hGq6POfXuQwnkbhFSl82Tqdxp+44/wAnN/pXfXNtW1gtPJhvbnHmobBi99+sjpzKWEzGekDxG3tES//Dg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aT09fYo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aT09fYo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE7AC4CEC6;
	Tue, 15 Oct 2024 12:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997027;
	bh=Ty31nIEM55Tbx2mmi8dJAc5ZTqSzg4wgemejGBvC3Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aT09fYo1KVQI6QxqjTGufLgIRGDcMnjMT28xcg+njIcQc6W8SUbtXaID5ocwV3SkB
	 R5lB8t43ShABk+HUX7vp5+6r6REDarbA/GFP65ZSmm52zzw1J+rsWaCjNp6ga+ohHM
	 QR5ruy6VbiIcc8oL2PS5rqxbeWg7MaUimtPlSCJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <lenb@kernel.org>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/518] wifi: iwlwifi: lower message level for FW buffer destination
Date: Tue, 15 Oct 2024 14:38:59 +0200
Message-ID: <20241015123918.358423496@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 56f63f5f5dd34..2afa5c91bc76b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -111,7 +111,8 @@ iwl_pcie_ctxt_info_dbg_enable(struct iwl_trans *trans,
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



