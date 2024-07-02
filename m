Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D90314293;
	Tue,  2 Jul 2024 17:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940863; cv=none; b=dqqV1JfIvheVL1NcxSWKkVm6trnTIQ2gPNcGQmGfY6x5oB0rB3IIor/JSQcVqtHtjXwGbYQOF4DYFuo4UYuTVJDY6beQ8GQHkTMKr0iNj7fi92F5Rrtgu8WIi6QwveTc5LIwaoUPEYtSloU7/FqCxbF6BKF6N1d8JRoomHSmnt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940863; c=relaxed/simple;
	bh=lA5EaMTy5cppLeDnx4juACCJtgVEGyK39KVfPKkFYeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iim304uLK5/xUJy5gvfWZl3GYzcvyahIfFo2Sw6aLf6jxDou7M//CchKZ6/siPRO0NmUZgD63RG9d5KfuekIYbWzimGyMFEVWzz6VGebUyGDptJyx+qfDztaduXYRWdHQxNVnySKaHp5ZF+nWqeNx1QccYpaztVrQm+kftVDEOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjWMDwSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjWMDwSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EEDC116B1;
	Tue,  2 Jul 2024 17:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940863;
	bh=lA5EaMTy5cppLeDnx4juACCJtgVEGyK39KVfPKkFYeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjWMDwSLyMAbhsepf/8/oGFFXkUEySF9MoN/a+YLtaU4JL5Oymop1jhvtiSO0PhJ3
	 EqmJmKXBRWoFQcnil+qErrajalLMNlcEW6of4zzK68Y6+7zd88QRmZlsI5x2j3yK3i
	 OI9YEAXMxwV/gL4rqAJU9Qc2xxfQyOWqZAlvW738=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/163] wifi: ieee80211: check for NULL in ieee80211_mle_size_ok()
Date: Tue,  2 Jul 2024 19:02:52 +0200
Message-ID: <20240702170235.260267032@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
index 5fbc08930941c..5f1e5a16d7b2c 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -4952,7 +4952,7 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
 	bool check_common_len = false;
 	u16 control;
 
-	if (len < fixed)
+	if (!data || len < fixed)
 		return false;
 
 	control = le16_to_cpu(mle->control);
-- 
2.43.0



