Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29A130F8F
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2682BC433CA;
	Wed, 20 Sep 2023 12:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212136;
	bh=Kw8C3p9yZu7WzSE9sKIVh7vVxX5ustZSTl/yDvd0+qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmh6+1sHN4dw4yZv/9Oq1o1KebRc6sOIxER7dwQ77sjvlMxBRd62M8OznTBkwo0mF
	 xFg+RXC/kMjDgywBS7Hm0sS35QfD2viNyqT2xfIkpflBvjVVqFXFMksY5eQAs2ww6D
	 0CqL/kUgWzxQVbIzwyqNZVqcDRfBsxkwIHLcUROo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/273] media: v4l2-fwnode: fix v4l2_fwnode_parse_link handling
Date: Wed, 20 Sep 2023 13:29:30 +0200
Message-ID: <20230920112850.531487837@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 453b0c8304dcbc6eed2836de8fee90bf5bcc7006 ]

Currently the driver differentiate the port number property handling for
ACPI and DT. This is wrong as because ACPI should use the "reg" val too
[1].

[1] https://patchwork.kernel.org/patch/11421985/

Fixes: ca50c197bd96 ("[media] v4l: fwnode: Support generic fwnode for parsing standardised properties")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: d7b13edd4cb4 ("media: v4l2-core: Fix a potential resource leak in v4l2_fwnode_parse_link()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 8046871e89f87..158548443fa7c 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -282,7 +282,7 @@ EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_alloc_parse);
 int v4l2_fwnode_parse_link(struct fwnode_handle *__fwnode,
 			   struct v4l2_fwnode_link *link)
 {
-	const char *port_prop = is_of_node(__fwnode) ? "reg" : "port";
+	const char *port_prop = "reg";
 	struct fwnode_handle *fwnode;
 
 	memset(link, 0, sizeof(*link));
-- 
2.40.1



