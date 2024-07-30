Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4656E1A76CB;
	Tue, 30 Jul 2024 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360589; cv=none; b=IGOfc/GmAvx/1C6IUU4oGH6v8Tgm2N5Uvnw+2y3h1GFY9X77SvrTjc9T5A5z58kKzgKVMp8miAEBLDxCihxesZoKvbxV22FJHFtqRCL3pgFi8yYjf5LUSiIY3QZDm/oFVncQNdSkoNRKxBMlFH/rY5BPfpuTt8C5JZvrFT4vBf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360589; c=relaxed/simple;
	bh=tE7cJSEL+QIgK+FA4Gi5e4gqQJSU1Th2sWM37YU0sJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaiE4MRiTczGtwtRlLWKhn9ZK56rSVKJWVh0XXr2GumGf6HJeGE/ep3sNgtXUi+Xpu95NcAiI5tRe0qP0xyt3KN+DnlXlg1BbqRF8K9dMwgQUmdQF51QOTVMgbetqznQ0jWZMftVdPIz12IUHMMgNXw57JYsf+U1d7MqrPZH+xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQTopR7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQTopR7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8259C4AF0E;
	Tue, 30 Jul 2024 17:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360589;
	bh=tE7cJSEL+QIgK+FA4Gi5e4gqQJSU1Th2sWM37YU0sJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQTopR7NYaQutf27oByoGHxyr8kxIl1WtX7iH4dYPLCZ/nj2ebwxXwIkw9oaWaR0m
	 WhjIjNLkP60JnCkKeI3aVr+ydI/vpcMvgP7bfTys9SZKv/eJAnzqds6oWSs1rb+FqV
	 iXqbR5lmwo8X3WWiIf4HepNBTEl3FXWiYwxr6aao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 745/809] um: time-travel: fix time-travel-start option
Date: Tue, 30 Jul 2024 17:50:21 +0200
Message-ID: <20240730151754.381069312@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7d0a8a490aa3a2a82de8826aaf1dfa38575cb77a ]

We need to have the = as part of the option so that the
value can be parsed properly. Also document that it must
be given in nanoseconds, not seconds.

Fixes: 065038706f77 ("um: Support time travel mode")
Link: https://patch.msgid.link/20240417102744.14b9a9d4eba0.Ib22e9136513126b2099d932650f55f193120cd97@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index a8bfe8be15260..5b5fd8f68d9c1 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -875,9 +875,9 @@ static int setup_time_travel_start(char *str)
 	return 1;
 }
 
-__setup("time-travel-start", setup_time_travel_start);
+__setup("time-travel-start=", setup_time_travel_start);
 __uml_help(setup_time_travel_start,
-"time-travel-start=<seconds>\n"
+"time-travel-start=<nanoseconds>\n"
 "Configure the UML instance's wall clock to start at this value rather than\n"
 "the host's wall clock at the time of UML boot.\n");
 #endif
-- 
2.43.0



