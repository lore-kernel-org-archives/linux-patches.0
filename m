Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBF51C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7499C433F0;
	Wed, 28 Dec 2022 16:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244901;
	bh=X0hgkm9GaYB7WJBQeBOv0mpFuJQF232PPMR9F5CfBkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBW/wljHQaNbnzS83BNRQDAZBY9XxMxHImkI5YXe3BxY6xNPLsODeEuJ0Vb+c7SbP
	 Q6PGTxpb7TG8qmgRHoRWRVoFkRYJbAyVRCMh+3BllojkRbFhnn457UPwL0jUQYoMEz
	 lqYBzF3HWGohNfiiW4SIMhMlLvXwXszdz5ivI+Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hacash Robot <hacashRobot@santino.com>,
	Xie Shaowen <studentxswpy@163.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0796/1073] macintosh/macio-adb: check the return value of ioremap()
Date: Wed, 28 Dec 2022 15:39:44 +0100
Message-Id: <20221228144349.629987897@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xie Shaowen <studentxswpy@163.com>

[ Upstream commit dbaa3105736d4d73063ea0a3b01cd7fafce924e6 ]

The function ioremap() in macio_init() can fail, so its return value
should be checked.

Fixes: 36874579dbf4c ("[PATCH] powerpc: macio-adb build fix")
Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: Xie Shaowen <studentxswpy@163.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220802074148.3213659-1-studentxswpy@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/macio-adb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/macintosh/macio-adb.c b/drivers/macintosh/macio-adb.c
index 9b63bd2551c6..cd4e34d15c26 100644
--- a/drivers/macintosh/macio-adb.c
+++ b/drivers/macintosh/macio-adb.c
@@ -108,6 +108,10 @@ int macio_init(void)
 		return -ENXIO;
 	}
 	adb = ioremap(r.start, sizeof(struct adb_regs));
+	if (!adb) {
+		of_node_put(adbs);
+		return -ENOMEM;
+	}
 
 	out_8(&adb->ctrl.r, 0);
 	out_8(&adb->intr.r, 0);
-- 
2.35.1



