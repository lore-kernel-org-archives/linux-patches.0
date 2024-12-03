Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12141F76A8;
	Tue,  3 Dec 2024 15:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238560; cv=none; b=mjeNRPSXoUERzLelIHYdB6SgMf9aMBmgtKnJIBtf0YOd7QYYiICjXnR6SjZe9l8r8iaYEK2RuIEwitshBPyPHaneWM1ejc8FqeAysqcSPD9iQsGihwfLcPVDVSC66QbUoIs0MCZwgEdtip8fHShwEPIkLvoRCSubyQ4qKGVWbC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238560; c=relaxed/simple;
	bh=BjHL9RdsdcW5agsf0UAN7dIbGBpNmGhy+NaPLVGNFxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dn90Ox/S7gLE7zYvEWP/9vPMdxbMypiLGQdZ9hsAyXtgSz6wbQetyybjwYkP07GrrX4I/AjcFHprk4MhXuO7vbhaLmS7a+ZA2y2Do63ZfMgMfEfnjZND+XoueZDiiyvXyrcErkAwBZVTxO0HsxuTYmGuZAzKsVlu3K90BI6u+GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atfsKJTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atfsKJTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83FEC4CED8;
	Tue,  3 Dec 2024 15:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238560;
	bh=BjHL9RdsdcW5agsf0UAN7dIbGBpNmGhy+NaPLVGNFxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atfsKJTMYtMaUgiW1GVwnjBE9kYN2mZkpANX/FlshWTP4BJ+4WubaQl3oim2RN9kj
	 kSh4yNAUkC/f5UCj09D2YvJC6MW7I3UOmaieP1/w/bnDugKTb83FaZUEXwsoFRDVNb
	 BZlIaR5fGsiwb1KcEp1swh7oyMP5gAzl+DazyoJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurice Lambert <mauricelambert434@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 320/817] netlink: typographical error in nlmsg_type constants definition
Date: Tue,  3 Dec 2024 15:38:12 +0100
Message-ID: <20241203144008.309339085@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 3b687d20c9ed3..db7254d52d935 100644
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



