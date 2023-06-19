Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB81C142
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF7AC433C8;
	Mon, 19 Jun 2023 10:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172325;
	bh=wEWia8yVDtnmHQPquC+xJbo/WH+NhQ+QOHfKxfPfcLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYftUxPq2orQ09nIhudy3s7UBdGiyw5yB/SO2e5TvQpAVRjMnSI0s/5YdKTUI9ZMT
	 tCghjmfE+A8LqlUdzC/CJRVF5Zfa1oxk8iUYMwo9Rl37qcF1rCtrWuiLw7XfAvWzur
	 Rn+IdG4wPfHuon7pKBY4eoQSrrpANJnGRxIawQzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/107] of: overlay: Fix missing of_node_put() in error case of init_overlay_changeset()
Date: Mon, 19 Jun 2023 12:29:52 +0200
Message-ID: <20230619102141.942902924@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
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
index 119dd6a0be868..74dd63089bb46 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -818,6 +818,7 @@ static int init_overlay_changeset(struct overlay_changeset *ovcs)
 		if (!fragment->target) {
 			pr_err("symbols in overlay, but not in live tree\n");
 			ret = -EINVAL;
+			of_node_put(node);
 			goto err_out;
 		}
 
-- 
2.39.2



