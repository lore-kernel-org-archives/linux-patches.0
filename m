Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAFC189502;
	Tue, 30 Jul 2024 17:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359684; cv=none; b=ko5Nig9qKNF/waJMUydEbiZr8nXsEqIv5AXM3BRee+MLV61UPEKM5JVDnfQCBKw/EaoLDoMD5xWOsSnML36eX95uTjgOWNRZNFBnT/AStfkwgD+o4zYJwkX124ReU/j7ogNTrRHZSPA33btL25gXZOUEIq6LexbpkqcYj6tU7wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359684; c=relaxed/simple;
	bh=lU71u0NM1enL484wunKN/FIjWlOMqFJI1VgqF/8i5Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n53XjJIDNYnSvGPLvg4U0OtBamgdQCskJTjvi77L8ujgKCu1Fzb9R0mjh53C2Q+Md1rdIJM4kXvZPOZ4n2DDwWywOTJHziIvIs8WvOCdehHmt9HBWPRW226zo2G/p9OVL/u34WKim3hkF4mYDDOCfIQXBviGwoWlBn4yCgtjlKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0HMQG6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0HMQG6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B23EC4AF0C;
	Tue, 30 Jul 2024 17:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359683;
	bh=lU71u0NM1enL484wunKN/FIjWlOMqFJI1VgqF/8i5Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0HMQG6GH39u+nFJd3OTA9KKrMQhLTS1OQU5TVNaY9mnC8HpuYMLCtAiUsoEWA1mv
	 MGSzm/xKrVvrhIQe6Ilr+84C2uB2x0eLLflCqTkx2LjSnVCa7OZSrCnuyQgrxd8ZI5
	 WgpQ9cSuSYb4mJwxAv/kd//dZc3WJmyleOaaqEYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 522/568] um: time-travel: fix time-travel-start option
Date: Tue, 30 Jul 2024 17:50:29 +0200
Message-ID: <20240730151700.558643317@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 3e270da6b6f67..c8c4ef94c753f 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -874,9 +874,9 @@ int setup_time_travel_start(char *str)
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



