Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596C9FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9ED6C433D2;
	Mon, 15 May 2023 17:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172309;
	bh=KwVfrzlbyY5ajKYbW5tVXtxkgv2sPILb28d72PKKTVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sduCYmHwNhtnJ6gFqvK14Krxj0qRrFzi7HUdOjxsFmHrnYzMtXhOTtax9GJ5eqoOK
	 wrssSOzWrnfdubYT0jYv7lzFJ4n8xHUh8J62/irRNgNCOzJGRShrGOhagtIy4sp3W8
	 8ookxbqunJgIc2BTYDAvv/gtqrKWem6jx8K9H6HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tang Bin <tangbin@cmss.chinamobile.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/381] media: rcar_fdp1: Fix the correct variable assignments
Date: Mon, 15 May 2023 18:26:03 +0200
Message-Id: <20230515161741.876774135@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit af88c2adbb72a09ab1bb5c37ba388c98fecca69b ]

In the function fdp1_probe(), when get irq failed, the
function platform_get_irq() log an error message, so
remove redundant message here. And the variable type
of "ret" is int, the "fdp1->irq" is unsigned int, when
irq failed, this place maybe wrong, thus fix it.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: c766c90faf93 ("media: rcar_fdp1: Fix refcount leak in probe and remove function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar_fdp1.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index 782e805b85da2..1dd8bebb66f53 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -2291,11 +2291,10 @@ static int fdp1_probe(struct platform_device *pdev)
 		return PTR_ERR(fdp1->regs);
 
 	/* Interrupt service routine registration */
-	fdp1->irq = ret = platform_get_irq(pdev, 0);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "cannot find IRQ\n");
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
 		return ret;
-	}
+	fdp1->irq = ret;
 
 	ret = devm_request_irq(&pdev->dev, fdp1->irq, fdp1_irq_handler, 0,
 			       dev_name(&pdev->dev), fdp1);
-- 
2.39.2



