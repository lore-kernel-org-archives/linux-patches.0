Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278C532A3C7;
	Mon, 18 Aug 2025 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525605; cv=none; b=o8Wcp85X6UiJ2FIVQD1sE7/BuAqZZNNxMNIEhaXUM9tI1GnjoJTKURukC8T8xJr5Wiz1Fm6047P8m7ohgRY893VDUCYe4FAenRR5ku8knjSM30Y1cjnvq+jVFsWp/rQC2feg8xQp/p+TNhAcBAmxCyVtJWx396udPThgc+K8b7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525605; c=relaxed/simple;
	bh=eqJxLxPdTGfBpAJ1Ubk2X7wKLXaAyPhBcQ+n2GCiwnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDGWrKrV/RrhMOpFTeSXxSrCjctQz7bu2RNTb4bHswQ9nizWRIRPoqgXXhxcwT2b2jP0OSd3MELIZOvi0LiWEX5uU8bQ0qsgMRBkY6a+77EqPjvbTf4CcWFC8mFo/dXW8wt8BiLu3XjipEFTawVN6do8aYt1PsSukLRVHqWfOvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nv/hfWDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nv/hfWDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A198C4CEEB;
	Mon, 18 Aug 2025 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525604;
	bh=eqJxLxPdTGfBpAJ1Ubk2X7wKLXaAyPhBcQ+n2GCiwnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nv/hfWDtoImOkE9Jbv7bc89mVtv5lOJeBgX4Bc1do2wmWC9fWLC4QmhrPWSvuyk3F
	 lvYtdk/hbMSRPuxYcuyZ68OMHBNVy2RizXVwmVp0z/aGt59af/VUO6kVilI0AvYYFd
	 sN8xtR/sg3hWfleZj1hHb+OTgqcJ/drXSIm5o3K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 305/570] wifi: iwlwifi: mld: fix last_mlo_scan_time type
Date: Mon, 18 Aug 2025 14:44:52 +0200
Message-ID: <20250818124517.615442883@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



