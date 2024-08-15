Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4369463D5;
	Thu, 15 Aug 2024 14:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732475; cv=none; b=lPO5SuuwRiPGO1RACTz5jzAjHrZKz/3pfdkMpk0j7Use5jRPBTC7w2Qx3uNIQYL4cnhIj4TipYezrv9jC/00mSix6eWFjlhSfTKMc587u32D4YGKTn1h+ODQB8U49YO/AVgJHNl39EyQGRB1j3d7/l/cQSXzydURi/FIC8mPpSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732475; c=relaxed/simple;
	bh=39fiNUQSlcDzFEx2wPzu0Edl/0dO/ottnwCUhckgYmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTI+8q6YKjjIuSLwXdxJyRl3CuwG7e/mFqIgh0WLPeTIJOmGnSzacnJrlg2ETc249wCjF7u/HGWfSdQYuknLZZFWzCxecmz/cWp8wUN6oBkSKpKuF1qAWAhXJtnnKR7U3pwBJ+ApNS+05suxzHyCc/FXvGdzz3JWfwM/vhec7yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVO6D1kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVO6D1kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1031C32786;
	Thu, 15 Aug 2024 14:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732475;
	bh=39fiNUQSlcDzFEx2wPzu0Edl/0dO/ottnwCUhckgYmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVO6D1kngbKzBjTffESJzjJAb2O5sJxCC5m2dwHhb33AnwdINQ1VX/51qw3b8yWqc
	 9kbrsHUzdQPU0obwebdBgbOFp4ApMhvdoCS3+ndqHiU3+QA4IK6u1HlF3sJFWgDv/y
	 sn2DzfcoF11a2KkRSOQ5s7kTE9EzF1CjhHbIqlSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/352] um: time-travel: fix time-travel-start option
Date: Thu, 15 Aug 2024 15:24:17 +0200
Message-ID: <20240815131926.659265159@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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
index 8dafc3f2add42..9a0fcafafd00b 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -756,9 +756,9 @@ int setup_time_travel_start(char *str)
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



