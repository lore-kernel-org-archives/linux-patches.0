Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA78A3D75C9;
	Wed,  8 Apr 2026 18:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674268; cv=none; b=B8harbGp3+VTdlYujKhYnOZ7rImID93sKg+z+lAcgrMMRsEYBHO/1pJ8Iy/iHYKEBGXCZJdtpaI2FoAk2IXu5mMJXDs9PUqSH5Dh88Rm4Pk81Tg7A4h8H/B4GWdubHWINcs12bff3B5sl/nfdlXkmRJHm2+3g+58g3r/+77hLmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674268; c=relaxed/simple;
	bh=N6pF9w4vPW6a/3GQd4PiSZExHtXYazbs29P/n9fHC/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4AnAd+Jy1YQNZsULZaaznsNyuHQ+fSxBmFaJglmQBU2hYNiDbHiOOkQcK5ByrewllQ/+th2Zu+DZ+WLqvfQmsA5QldgzT0A0/tabnioNOdk+GLhx3SOSsszud1GNOGrkIY0BlXuYzMDYBO2RZ32aMoWe/jI4n4amMwJMjz+zt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNAhjSlv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNAhjSlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805B7C19421;
	Wed,  8 Apr 2026 18:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674267;
	bh=N6pF9w4vPW6a/3GQd4PiSZExHtXYazbs29P/n9fHC/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNAhjSlvsb1+aWrnM4IlGOWK9eauzG8OI+vcXTq+nc9i0Q2aIbmcmR6n1wL9sK+5N
	 frpXGFEqs1jP9htABEY5uVNnjMasaWj70I8OA9AU85vWbjKvSB6dwlQhdH8g3OKtBY
	 /GzaU5wkbyHq3Bw/Jw7g4qXhIGLsgANdc+N4xlo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 030/311] wifi: iwlwifi: mvm: dont send a 6E related command when not supported
Date: Wed,  8 Apr 2026 20:00:30 +0200
Message-ID: <20260408175940.540688436@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 323156c3541e23da7e582008a7ac30cd51b60acd ]

MCC_ALLOWED_AP_TYPE_CMD is related to 6E support. Do not send it if the
device doesn't support 6E.
Apparently, the firmware is mistakenly advertising support for this
command even on AX201 which does not support 6E and then the firmware
crashes.

Fixes: 0d2fc8821a7d ("wifi: iwlwifi: nvm: parse the VLP/AFC bit from regulatory")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220804
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260324113316.e171f0163f2a.I0c444d1f82d1773054e7ffc391ad49697d58f44e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index edae13755ee61..b9c9ee30272ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -470,7 +470,8 @@ static void iwl_mvm_uats_init(struct iwl_mvm *mvm)
 		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
 	};
 
-	if (mvm->trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_AX210) {
+	if (mvm->trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_AX210 ||
+	    !mvm->trans->cfg->uhb_supported) {
 		IWL_DEBUG_RADIO(mvm, "UATS feature is not supported\n");
 		return;
 	}
-- 
2.53.0



