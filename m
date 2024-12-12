Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27E31F2381;
	Thu, 12 Dec 2024 17:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023963; cv=none; b=G/MtbeR3slQDCQp398DDHPUI22P6FXpKGpAgqaZ/OO7Jc6jrSLBqsW37+VOw9hnBqLFJFMcQbGAI57WKOvFQ7MpRq7nOmaJMq1FMr4gNXrQoKS0WuyJ0rUypRhRwYSOFb/iY7lBzdjKYyV0QokES2XKanZOZlZnYVcILc9vmSpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023963; c=relaxed/simple;
	bh=pdnbKn3/7es/aDh4x1xMSv7czRhQkR/zMbsBYZGi4Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/3g3qAgxEzRQgHoSrjHAy7tXHZXawrrpj5Kh43sn33RHABZhMGHPr9THYXtBSN0sGaeiXv5kgoISl405104wvrqPV4e79xbcJbuHyDSRy4taZzsTGgexMonAowae7Lquv52kC9KYGQWb4rH//RO8nasZGAbcRuKllYN0gYDD4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIiXhfJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIiXhfJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C00FC4CECE;
	Thu, 12 Dec 2024 17:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023962;
	bh=pdnbKn3/7es/aDh4x1xMSv7czRhQkR/zMbsBYZGi4Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIiXhfJdjs1WTUaPBRUnBz9mpw7qp2bwJ5JHwAZhV/Uz28Qt8MrmmxeSZrDVDcm1G
	 fgHBUApM+afrB+mX9Pz0irXnU6KiQdWcejYBBCnVU1TCLnWqcH5m4hfojQ7wd7nrPA
	 Bq4kxRJrpnOEzpZ7K5hK7bRconuo9nbxXwRPwPKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurice Lambert <mauricelambert434@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/459] netlink: typographical error in nlmsg_type constants definition
Date: Thu, 12 Dec 2024 15:57:58 +0100
Message-ID: <20241212144259.039780211@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
index 9b814c92de123..31be7345e0c2e 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -172,7 +172,7 @@ enum {
 #define RTM_GETLINKPROP	RTM_GETLINKPROP
 
 	RTM_NEWVLAN = 112,
-#define RTM_NEWNVLAN	RTM_NEWVLAN
+#define RTM_NEWVLAN	RTM_NEWVLAN
 	RTM_DELVLAN,
 #define RTM_DELVLAN	RTM_DELVLAN
 	RTM_GETVLAN,
-- 
2.43.0



