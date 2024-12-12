Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFC422330D;
	Thu, 12 Dec 2024 16:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019325; cv=none; b=UBLY0QKvkJEcAbahw7zekuVy6Zd4Ju3YuQl2HPNpXg5vhuMGPmylCpjYDmCt7XoJdK4fCz0hQV462AYEq+cBcE8j+5Sl+3BBIk95dzUVP+hwD9DgQwzHHxyaVlEz6V+I7DpM7CCjASTVT0rdNWwMw+fleGxUhEiHNbZ1gg43H1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019325; c=relaxed/simple;
	bh=cxPsyrDTtMeSVNYIKIZK8SCa7MXVQY0Gh2Mi4GWid78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeHgSOvwz0qd990n7eMmIa69OEsoIsWbSjIIIifdFpwgwyWn29ZpJYAaB0plxMvxV4c0zL/dUbc/QsZWns7tJK/mmIp5KuCpQ+ouyXm65mwHQvuSRSyHZOxFuOdRI3QJ0EGQ9oiF1iBdzZpyTXxkErAmvEuHSh7Ehg3XhIJXlBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToNxkb5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToNxkb5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EC0C4CED0;
	Thu, 12 Dec 2024 16:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019324;
	bh=cxPsyrDTtMeSVNYIKIZK8SCa7MXVQY0Gh2Mi4GWid78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToNxkb5sVsgzG7YgfMLFyEuPYyDwwnYThk4ZyVLUN7U4NE/axDoQW32OLOaTMR3Re
	 Hvt5Lw0PifaIQsvVnjGLLGJSXG6WXYtqfMulbnOg4F5pzTGcXqggVx+ypxPM5rwQ6p
	 0DdJOnL89I4yqw0CS5ekD511Bxo+ykMfndXgYX+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurice Lambert <mauricelambert434@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/772] netlink: typographical error in nlmsg_type constants definition
Date: Thu, 12 Dec 2024 15:52:02 +0100
Message-ID: <20241212144357.256645839@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Maurice Lambert <mauricelambert434@gmail.com>

[ Upstream commit 84bfbfbbd32aee136afea4b6bf82581dce79c305 ]

This commit fix a typographical error in netlink nlmsg_type constants definition in the include/uapi/linux/rtnetlink.h at line 177. The definition is RTM_NEWNVLAN RTM_NEWVLAN instead of RTM_NEWVLAN RTM_NEWVLAN.

Signed-off-by: Maurice Lambert <mauricelambert434@gmail.com>
Fixes: 8dcea187088b ("net: bridge: vlan: add rtm definitions and dump support")
Link: https://patch.msgid.link/20241103223950.230300-1-mauricelambert434@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/rtnetlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 51c13cf9c5aee..63a0922937e72 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -174,7 +174,7 @@ enum {
 #define RTM_GETLINKPROP	RTM_GETLINKPROP
 
 	RTM_NEWVLAN = 112,
-#define RTM_NEWNVLAN	RTM_NEWVLAN
+#define RTM_NEWVLAN	RTM_NEWVLAN
 	RTM_DELVLAN,
 #define RTM_DELVLAN	RTM_DELVLAN
 	RTM_GETVLAN,
-- 
2.43.0



