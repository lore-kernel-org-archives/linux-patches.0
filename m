Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1973381E98;
	Sat, 12 Sep 2026 09:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205532; cv=none; b=RgH41p7BfzlggXn28pP0YZKPcks8i4yQj+uIpsUB6fCNfn5H8LsfmLJpTW9Wftd8bxk9rYGGmr0A3BYDjT7e/x5ff1L/BQHxCNB0C+SdbPAoDsYKMpOvFYTOF6MrfFNCMRYUyq6QQdLaLqI+UnS2iKbkrbmjQPVPXPOQiK6NnDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205532; c=relaxed/simple;
	bh=L6QlqTSpszGUZisuaos7oeGya0MYuS2PMX7zFy1E82s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Et1Es+owgNt1U57bsjH+PBesvU7muG4zbOX22N4l5zD+0cJ38cMtAHglSMlxofTFThcFW0+J/MhBUf3ZI8py0FgGXJLgq04bG7qb3QdwSUZej/3JGoQOYyJRUKnhsvqB5GEnHA2ZMV2IBNujOZfAaOvUyNWrGSTKUY28dqVsa5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLoX6hng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLoX6hng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059C11F000FF;
	Sat, 12 Sep 2026 09:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205531;
	bh=gZYblb0eJnQScT2DTh7r+Q5ULFIKiuj96Jnx2r4uPXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HLoX6hng5w5F8ZUfUaYLFVI5kldUxTqP4X1y7IWoutW9kjRWExHeOj+UUa/dtIiGk
	 au3du9g4VyzHcXDsPJ8wqtebzfo425rmG+ghw0i6DVytarpj46d9qeITCWIvtYoh7P
	 UE5ZjKq7dl0jsUhZo/hK4416m+vOuVHNsWyUsPwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek BalachandharTN <vivek.balachandhar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0021/1518] staging: rtl8723bs: fix spacing around operators
Date: Sat, 12 Sep 2026 08:36:30 +0200
Message-ID: <20260912065623.899845831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2029,7 +2029,7 @@ int rtw_restruct_wmm_ie(struct adapter *
 			break;
 		}
 
-		i += (in_ie[i+1]+2); /*  to the next IE element */
+		i += (in_ie[i + 1] + 2); /*  to the next IE element */
 	}
 
 	return ielength;


