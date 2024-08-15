Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10EF1AC8BB;
	Thu, 15 Aug 2024 14:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731562; cv=none; b=irjmeL3lfNqjLFXgSS8xo5UZTHbB6Cfu4Mr1IP2lur6VK1XNXdeO+JYoRM4zaKkVqwSb3Vxgqb0eOCioDGO7HRgd9IvemW/30ZnyA6ROzULMxYrZJvuT8ZHPliVyLkyQRShTo60ayt9k3Yop1+CEzCww9hfB3lcXnZN0CIpk3tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731562; c=relaxed/simple;
	bh=t+fEuMhR2nVmbatv4OoX/HwYbwmCJK7vMAMpfiPEV5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLamQYUS/6hXQcbDdOnWHajUwZHbWxb0J635+u24dqLWUANncB+K76FAUTWycMEESQvmVn2YTgTlJqvyXhFgwpfsT8zqG9KwfOmaQhAYD+5HaRaafpg1Qz50xHXgJxHVCyuuccQZvgaO/pzOHmZuL2rXXxJnlHfhr5zbGkMyf4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dh62IEK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dh62IEK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9507C32786;
	Thu, 15 Aug 2024 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731562;
	bh=t+fEuMhR2nVmbatv4OoX/HwYbwmCJK7vMAMpfiPEV5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dh62IEK+b10Lhzmn3DnjqHqYfdFQTl0Qcl6UkeQklrz927RrqHy68DFEduDRBOn8q
	 XZq8m8u28MCjekE17Rqwl1+bLVP/vArQWT/vvQbaPdCs96n3q4a6GaRWetjE5MCumB
	 CmVfhpzUrWMOcqbVXuFGzvJjHp9/vtVhQQScxOUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/259] um: time-travel: fix time-travel-start option
Date: Thu, 15 Aug 2024 15:24:30 +0200
Message-ID: <20240815131908.084400782@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 94ea87bd231cb..3ccbb42c171c6 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -256,9 +256,9 @@ int setup_time_travel_start(char *str)
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



