Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B3C10970
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776F7C433C8;
	Mon, 19 Jun 2023 10:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170733;
	bh=b31AJd8TsvXjiJpSsKYtmGvMn42mhKKqaVZWngsRhlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGqd5yhlon+cTcaszt8FuUWImu2whJXc5zF/r8xeA9EWvz/oYjZ4i9nZYERb7inm5
	 23a5X4Y1c5hVBrHxBA0OQ7NC9P0/Kv2nABvwFfRfwSCPr90+pjlTnIfqNOUbdYQ4k3
	 aMqedwUt4e0dbEEDpqoLEA+FgH/tlhCBhTYQFoA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 008/187] of: overlay: Fix missing of_node_put() in error case of init_overlay_changeset()
Date: Mon, 19 Jun 2023 12:27:06 +0200
Message-ID: <20230619102158.023786702@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 39affd1fdf65983904fafc07cf607cff737eaf30 ]

In init_overlay_changeset(), the variable "node" is from
of_get_child_by_name(), and the "node" should be discarded in error case.

Fixes: d1651b03c2df ("of: overlay: add overlay symbols to live device tree")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/20230602020502.11693-1-hayashi.kunihiko@socionext.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index 2e01960f1aeb3..7feb643f13707 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -811,6 +811,7 @@ static int init_overlay_changeset(struct overlay_changeset *ovcs)
 		if (!fragment->target) {
 			pr_err("symbols in overlay, but not in live tree\n");
 			ret = -EINVAL;
+			of_node_put(node);
 			goto err_out;
 		}
 
-- 
2.39.2



