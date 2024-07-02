Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E2515218A;
	Tue,  2 Jul 2024 17:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940181; cv=none; b=UUpUDVqChn14thCMZBukzn2x/Ai1J8OgaF8BcTDP6wikHAler9uej9bVWa1gI7BRDAp2KwqTIJp2LC2W9kvK/NzEnAkO6vXki8+qrA0cx2dh9WQ3u7D4GKdl/z9EapGgiCVNV5t4nSuiEYjda9VZ9YcxJ1FW4Vj/InEcvtLMZJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940181; c=relaxed/simple;
	bh=QuSTVOja5AQanNZN47m3KBAh6IhzyDFP0WSdYRdz5HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvnrFlLSD7du5/TU1B6dirmN7qnsrll4nmgIE2ja+H3x7Bvx/vHYy+yo5eSWPqAaTSBMDHIy1OfVkOOOED2skm2vcUNzDcj3EkWzCVl+/vZttRcm9MpPVf+nhCCF5vY6CgVXbdCho8LCs8twrzqxM6rAagUhMj2kSpD1WGUIVMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpX7gEQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpX7gEQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FA9C116B1;
	Tue,  2 Jul 2024 17:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940180;
	bh=QuSTVOja5AQanNZN47m3KBAh6IhzyDFP0WSdYRdz5HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpX7gEQAfOtV323j6NbEyMcLp7T/tE+N7bDZNZvrrAxvrSPUwX2on5Dbm5pKEYzJK
	 pXIF+h+xjsMXq08W6Ji3CZ2swiU/FIJesnRaE+NqrLVtcAYNPvoyefDUZIfKf1ovT7
	 ERdleVRLmtM/Wdp8ZIbi5iWVpOM50YZGUqd1IwYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 075/222] wifi: ieee80211: check for NULL in ieee80211_mle_size_ok()
Date: Tue,  2 Jul 2024 19:01:53 +0200
Message-ID: <20240702170246.847211712@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b7793a1a2f370c28b17d9554b58e9dc51afcfcbd ]

For simplicity, we may want to pass a NULL element, and
while we should then pass also a zero length, just be a
bit more careful here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240318184907.4d983653cb8d.Ic3ea99b60c61ac2f7d38cb9fd202a03c97a05601@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ac5be38d8aaf0..4fd9735bb75e5 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -5166,7 +5166,7 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
 	bool check_common_len = false;
 	u16 control;
 
-	if (len < fixed)
+	if (!data || len < fixed)
 		return false;
 
 	control = le16_to_cpu(mle->control);
-- 
2.43.0



