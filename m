Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7692749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A04C433F0;
	Thu, 12 Jan 2023 14:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532720;
	bh=PNYxQ4gbJXH00k7LcULfpP5dn23lqv6yiGWcguIefYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRp1Qpmo94VAZBOXeSYfe1Pa5dxfyH7PzWxgHgbUAtuMY9vZrwHgs4jJUgAYDQgI8
	 RQBp35o4DkBhplTm+R9cIFmrSgmQ49mtx1602qRimRyY3Ifr4jToyHDD4tygfooatM
	 dgkraKsd3hfcG7jMNgF+M776NhvtlpyvybVoJAsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 237/783] media: c8sectpfe: Add of_node_put() when breaking out of loop
Date: Thu, 12 Jan 2023 14:49:13 +0100
Message-Id: <20230112135535.355704799@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liang He <windhl@126.com>

[ Upstream commit 63ff05a1ad242a5a0f897921c87b70d601bda59c ]

In configure_channels(), we should call of_node_put() when breaking
out of for_each_child_of_node() which will automatically increase
and decrease the refcount.

Fixes: c5f5d0f99794 ("[media] c8sectpfe: STiH407/10 Linux DVB demux support")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index dbe7788083a4..b7e0ec265b70 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -937,6 +937,7 @@ static int configure_channels(struct c8sectpfei *fei)
 		if (ret) {
 			dev_err(fei->dev,
 				"configure_memdma_and_inputblock failed\n");
+			of_node_put(child);
 			goto err_unmap;
 		}
 		index++;
-- 
2.35.1



