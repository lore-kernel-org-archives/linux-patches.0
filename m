Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBCE24A078;
	Tue, 21 Jul 2026 20:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664818; cv=none; b=b6cxG/BRUg91eD27fl+WCGu3FPkyPEcF/N5WNHuxD4fuHxlXNRh2TJqHYWBx5hsXSF9zAnEOmr7cYgaDBuDn2NqoIi8Sg4YNPszP+Y2qwUgQJlkCD2chQMnjcIyeHUYHFkoPAOEOgFDhSuFPzYQVSbvfIZklatN8Y+eiquGuYEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664818; c=relaxed/simple;
	bh=q17nWFZbR0dVAvPeqiKpb7nAiuTsRsnnbtMez1kGtUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Su8ACvozpoAkl2dSsQSwggjUeQ8epc2VqU3U3zLRnNAdWVfdihtkEVK+p3SOOqatWWrY6TVWoWz1HK055g7Z1dhAFFhB1GxDNw/l1gidecZli95iXZbge6mn1R+4fPyJp0AfQ+JZhFyDjk7uWBywVTyDyR1btIU3t0UlCOF0Y4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0NHoxmjq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NHoxmjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCEA1F000E9;
	Tue, 21 Jul 2026 20:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664817;
	bh=TaqjYV8IyrDJkQZcmzyHGtBgRbQurUlrWt9y5RR2lS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0NHoxmjqLyQqiwbHy0gLJdrzNxhcHIhYmI2E1pbk8IkNibI0welxw0y1nEi1haIR8
	 dTLlWSb9BkdwbueXuRIyUuorSufVf96O4YGOos2LYMdHpfhZjGR79daO6NR46GMJrl
	 GGJLiky77GxoIiKf0jzVSsc2QbLWhKi1ZrevOk+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0043/1266] net: team: rename team to team_core for linking
Date: Tue, 21 Jul 2026 17:08:00 +0200
Message-ID: <20260721152442.767309904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit a0393e3e3ddbb177b25f0a978c72f5efe942fe7d ]

Similar with commit 08d323234d10 ("net: fou: rename the source for linking"),
We'll need to link two objects together to form the team module.
This means the source can't be called team, the build system expects
team.o to be the combined object.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20240401031004.1159713-3-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Stable-dep-of: 425000dbf173 ("team: fix header_ops type confusion with non-Ethernet ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/Makefile                | 1 +
 drivers/net/team/{team.c => team_core.c} | 0
 2 files changed, 1 insertion(+)
 rename drivers/net/team/{team.c => team_core.c} (100%)

diff --git a/drivers/net/team/Makefile b/drivers/net/team/Makefile
index f582d81a509119..244db32c1060e1 100644
--- a/drivers/net/team/Makefile
+++ b/drivers/net/team/Makefile
@@ -3,6 +3,7 @@
 # Makefile for the network team driver
 #
 
+team-y:= team_core.o
 obj-$(CONFIG_NET_TEAM) += team.o
 obj-$(CONFIG_NET_TEAM_MODE_BROADCAST) += team_mode_broadcast.o
 obj-$(CONFIG_NET_TEAM_MODE_ROUNDROBIN) += team_mode_roundrobin.o
diff --git a/drivers/net/team/team.c b/drivers/net/team/team_core.c
similarity index 100%
rename from drivers/net/team/team.c
rename to drivers/net/team/team_core.c
-- 
2.53.0



