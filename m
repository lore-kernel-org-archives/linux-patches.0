Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4833419FA8D;
	Thu, 15 Aug 2024 13:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729998; cv=none; b=PGiQoSoG3WQuBef/at5igjZDE4zD4dYY/2/cxAClPvqRRTZ+G7ut8iwuhNGiYXWZ1wIzJGRu4IM6TFSNbkkRBIGYl6DqVGCw2sb1E2eZQwC2eSggd4fna4FJNvPseBLYqOYY59X4d6HN3dijGgbASL3pNIl4C4GCW7mim1m3T7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729998; c=relaxed/simple;
	bh=J48ORG19DyO84ZAe1JEK11peCZkc4uc2Kgcqqsh63VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixc8Q8jpwssIzmzkDPBAHN5fQWCoUpt7nhmkTw45fwuGB/TYKhKtpveQg3VDVt9DtsxEVi59K5b2SvhU8yLQTdxMnG7K1ODH9Z+cZCWvcdJ5qxlC1WOCXOPwBPi0JJhSUgUnDI+1U5xEOXCaNNeCsIYuCJ+t4OuCqkMOaIrTO/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1sYy8td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1sYy8td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99886C4AF11;
	Thu, 15 Aug 2024 13:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729998;
	bh=J48ORG19DyO84ZAe1JEK11peCZkc4uc2Kgcqqsh63VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1sYy8td0buqxc2wrqWjdzvOWSNNs7uaXHhGej2sULCDms6NXq2fmCx10/IAI4t+w
	 RZGN/e4rwjsCcx8+11wa9YMCK3KuwPq9jTg1oIqBQC1uUEA9J1ShH+K9gxsW4chh+h
	 umqpUPwqj+LYcbHB2+2lEWEwaB8A5qzORXNzC4kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 265/484] um: time-travel: fix time-travel-start option
Date: Thu, 15 Aug 2024 15:22:03 +0200
Message-ID: <20240815131951.637551854@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



