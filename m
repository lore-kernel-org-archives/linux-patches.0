Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF97951C5C;
	Mon, 11 Dec 2023 18:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbQVrYfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A32FC433CA;
	Mon, 11 Dec 2023 18:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319684;
	bh=MzpXPY3S9tgXQFTaaBhQY8VB2AyFZlFZEF/MM0rgKsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbQVrYfwsr5peYxvFGmowvkoGNUtbNcPStV2QPg8WEFdWtCBNT+bv35bJLwHdOORf
	 KeXUndPuq52Az88ID2dSXTG1WlSS1plWxJWJeobmwtW/jpleWRW27Oc6IYeh8+OS14
	 A1Z1NPYQaBXCZvBKutGFRligSMC9l3Xgwxsk02Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/244] misc: mei: client.c: fix problem of return -EOVERFLOW in mei_cl_write
Date: Mon, 11 Dec 2023 19:21:29 +0100
Message-ID: <20231211182054.732137881@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Su Hui <suhui@nfschina.com>

[ Upstream commit ee6236027218f8531916f1c5caa5dc330379f287 ]

Clang static analyzer complains that value stored to 'rets' is never
read.Let 'buf_len = -EOVERFLOW' to make sure we can return '-EOVERFLOW'.

Fixes: 8c8d964ce90f ("mei: move hbuf_depth from the mei device to the hw modules")
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20231120095523.178385-2-suhui@nfschina.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 75bc2a32ec0d7..32f2287823184 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -2032,7 +2032,7 @@ ssize_t mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, unsigned long time
 
 	hbuf_slots = mei_hbuf_empty_slots(dev);
 	if (hbuf_slots < 0) {
-		rets = -EOVERFLOW;
+		buf_len = -EOVERFLOW;
 		goto out;
 	}
 
-- 
2.42.0



