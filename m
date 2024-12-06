Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0BF13C9D9;
	Fri,  6 Dec 2024 15:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497233; cv=none; b=CsKya9LTFMPdNynpsBA9tAh35jV6KHOufL8tyjWfmqDiToOj94ErC5kK5s9rIReAwTq1SWhhh83lDK30B1qZyrPc+c7QCpnYhwvYVH6xOAlx6iWfLw++gXNmSHKHSMoS/zk/FVc7BjZtFGYrCUJSzpVO+bHN+xBaapwqepmIY1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497233; c=relaxed/simple;
	bh=HJr4zlY/n48Rf2E5xK3vE96+CsHnHTZrKiK5tMIxeIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIwC8xhdNi+f1UTusl/fxVza8e/WlQK5ogZzWn2pMFcORs28PTTXu18EDHsFGUMC669PBYrpA637Vli93JCG24NwtN8+7I1uKE26/zxrBkBs8BznJbYlElHkqH1XKzM9V8rIPj7ydLVavJLhCiYOOCryiGxNAj4IjlpwVcTSm3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iB219xhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iB219xhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D501C4CED1;
	Fri,  6 Dec 2024 15:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497232;
	bh=HJr4zlY/n48Rf2E5xK3vE96+CsHnHTZrKiK5tMIxeIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iB219xhZ0ajOgnK89P4k11eKrmx8UxUUCje7/VhZOjojmGGpagGuZGUu2VkO/u47+
	 K1WDds2XGh0px+LDNB+tMOP5PgArCkyxhVfgrEZ9Hh7F7UJLfZLloPrknrP7DiQ3FD
	 hOOLmhyf+BzEjdj2jsViUrQRDF3VfGXMGHZfkaZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurice Lambert <mauricelambert434@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/676] netlink: typographical error in nlmsg_type constants definition
Date: Fri,  6 Dec 2024 15:30:51 +0100
Message-ID: <20241206143702.395966307@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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



