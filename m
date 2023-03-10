Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568A9882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13BCC433D2;
	Fri, 10 Mar 2023 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461015;
	bh=zC8lk43VVsn404hbBnc8ADXfyQIVTE44HMGfX8Xk4hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZ0PCEArTwwqkiAChCZFgEUJMl9xfXAghtI1gy7rrbL2nd9ZunyRwRFqVt8J6moR+
	 mcPeBiUPghPNoXjz41d0IwrrN6aAUKcntWgw027Hsqw322V+0Y1XPfTMXSWsgzcWj7
	 HHVu8EgBSBhoUWygrWMHUPcdJp9adsYGL0Zc3iqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10 527/529] malidp: Fix NULL vs IS_ERR() checking
Date: Fri, 10 Mar 2023 14:41:10 +0100
Message-Id: <20230310133829.228355743@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

commit 15342f930ebebcfe36f2415049736a77d7d2e045 upstream.

The get_sg_table() function does not return NULL.
It returns error pointers.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/dri-devel/20211213072115.18098-1-linmq006@gmail.com/
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/arm/malidp_planes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/arm/malidp_planes.c
+++ b/drivers/gpu/drm/arm/malidp_planes.c
@@ -348,7 +348,7 @@ static bool malidp_check_pages_threshold
 		else
 			sgt = obj->funcs->get_sg_table(obj);
 
-		if (!sgt)
+		if (IS_ERR(sgt))
 			return false;
 
 		sgl = sgt->sgl;


