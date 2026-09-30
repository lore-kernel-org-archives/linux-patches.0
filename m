Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B9351DDE7;
	Wed, 30 Sep 2026 17:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789855; cv=none; b=M6zehYxmn1tpSsHDndplhQalYfi9mI8jhRTpUo0Eeelmy1/bnfzmQkllMBvxqiMCgshqPI1OtrUu0aMCqf/gjSCwd7ASs97Uvxel0GwjBWeBj1cWWOQ1pmPa+1B1L9HFhWC4+g0+9TV4V3njWWb/fVa5puYN42kY6oUzoX1xNjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789855; c=relaxed/simple;
	bh=BwJnLPsFAAfXqTURHI4OscCS2lzCX1s4S4M7xzmZTD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5z5mh5vxxADWWgmIW1KhqfWE7bLPwqLH7KbLW1NEAjLF7rizLxv+vB3PN5OeZ9QQsLjkzfNprta9Ts7NuBfax/wA/dQMMGHyh9jr3xtJTuFs2GsjMlgPvQ+q6tUVj0yC3VyT+1X9dfgXUZ5giiZXEGUv/gUwfDiBepx7nDA+sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAYrp2ga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAYrp2ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AE01F000FF;
	Wed, 30 Sep 2026 17:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789854;
	bh=6lykuDysX7BDia15DmJDduuuek8I7/7e0CN5lUgEvg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rAYrp2gaerGKm6ZHPjs7K2p0Xe+KlTIGYKpb0NylWfx7+73//rk1r/MNq/Ohl6GcS
	 EW/LM7vLj9IBjkvf2nKTZOayq2QrjBEu8Smasfu2Uh+k0FF6+8hJ/GehT5gpMJhJQQ
	 L73OTK1rJLWuFnbv4CWGrHKD2+lJfc8IaYNflO5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek BalachandharTN <vivek.balachandhar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 623/877] staging: rtl8723bs: fix spacing around operators
Date: Wed, 30 Sep 2026 17:25:34 +0200
Message-ID: <20260930152428.093338788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivek BalachandharTN <vivek.balachandhar@gmail.com>

[ Upstream commit 2038fe84b8bdf894b634f777096685e78e8f3774 ]

Fix several instances where operators lacked spaces around them.
This improves readability and brings the driver closer to kernel
coding-style guidelines. No functional change.

Signed-off-by: Vivek BalachandharTN <vivek.balachandhar@gmail.com>
Link: https://patch.msgid.link/20251205021417.2705864-3-vivek.balachandhar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

For this stable dependency, retain only the spacing change to the IE
advance in rtw_restruct_wmm_ie(). This supplies the exact context needed
by target commit 28a289beaf226 ("staging: rtl8723bs: fix OOB read in
rtw_restruct_wmm_ie()"). Drop the unrelated operator-spacing hunks.

Keep the existing bounds-first WMM match condition from stable commit
4dd2d9cf563c5 (upstream a75281626fc8f); applying the older condition
would undo its out-of-bounds-read fix. No functional change.

Stable-dep-of: 28a289beaf22 ("staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -1950,7 +1950,7 @@ int rtw_restruct_wmm_ie(struct adapter *
 			break;
 		}
 
-		i += (in_ie[i+1]+2); /*  to the next IE element */
+		i += (in_ie[i + 1] + 2); /*  to the next IE element */
 	}
 
 	return ielength;


