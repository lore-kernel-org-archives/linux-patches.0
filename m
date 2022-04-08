Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A162C80
	for <patches@lists.linux.dev>; Fri,  8 Apr 2022 20:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840A2C385A3;
	Fri,  8 Apr 2022 20:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1649448551;
	bh=INxKj1/Eanumd3G10GxRywr5ChlEaetXXPiQm7G9d88=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=z+f5MKcgHh3a6wz7x5/NIrVot0I3Rb+4K//+4efkNJ0PSiTiaTuahUUB4EmM//drT
	 CgboOeLOm2qVgSQD1RQNPjGUJh9iPqs9X5x48klF3SYiXg/wLohu7Pvh1pbPnMDrB/
	 EpT6v9YMd4MWd+MlMeQGakFbZhVK4jSSM67lMQ+s=
Date: Fri, 08 Apr 2022 13:09:10 -0700
To: vasily.averin@linux.dev,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220408130819.a89195e527ce58dfbe0700b9@linux-foundation.org>
Subject: [patch 7/9] mailmap: update Vasily Averin's email address
Message-Id: <20220408200911.840A2C385A3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Vasily Averin <vasily.averin@linux.dev>
Subject: mailmap: update Vasily Averin's email address

I'm moving to a @linux.dev account. Map my old addresses.

Link: https://lkml.kernel.org/r/737c7c2b-cdab-63ee-be90-cb33316c9657@linux.dev
Signed-off-by: Vasily Averin <vasily.averin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    4 ++++
 1 file changed, 4 insertions(+)

--- a/.mailmap~mailmap-update-vasily-averins-email-address
+++ a/.mailmap
@@ -391,6 +391,10 @@ Uwe Kleine-König <ukleinek@strlen.de>
 Uwe Kleine-König <ukl@pengutronix.de>
 Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
 Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
+Vasily Averin <vasily.averin@linux.dev> <vvs@virtuozzo.com>
+Vasily Averin <vasily.averin@linux.dev> <vvs@openvz.org>
+Vasily Averin <vasily.averin@linux.dev> <vvs@parallels.com>
+Vasily Averin <vasily.averin@linux.dev> <vvs@sw.ru>
 Vinod Koul <vkoul@kernel.org> <vinod.koul@intel.com>
 Vinod Koul <vkoul@kernel.org> <vinod.koul@linux.intel.com>
 Vinod Koul <vkoul@kernel.org> <vkoul@infradead.org>
_
