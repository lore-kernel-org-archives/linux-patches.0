Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBF33AC21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71925C433C8;
	Wed, 20 Sep 2023 12:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213072;
	bh=RsfYrrqWtIU+FIgNXzS8rY/mPpELizKK5k9RaIfScAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnIw+XbRhffGOL3G8adtSu+cubx7Zr3NbXyDoEd7gaFogZCVGmWrCg83B70+6UhhR
	 FuKa9Ak6nEd44XtxduBA1Zr4RcXEeGO5rT/DA6uJxe2g4H1hwQ3xH8Oez2OUD5Tqg1
	 glPgtDgXLXo/0250jIFfbun20rsnzxCgSaQHUNVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/367] media: v4l2-fwnode: fix v4l2_fwnode_parse_link handling
Date: Wed, 20 Sep 2023 13:28:47 +0200
Message-ID: <20230920112902.549708013@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 48c3b9f72722a..217d67cb31af2 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -563,7 +563,7 @@ EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_alloc_parse);
 int v4l2_fwnode_parse_link(struct fwnode_handle *__fwnode,
 			   struct v4l2_fwnode_link *link)
 {
-	const char *port_prop = is_of_node(__fwnode) ? "reg" : "port";
+	const char *port_prop = "reg";
 	struct fwnode_handle *fwnode;
 
 	memset(link, 0, sizeof(*link));
-- 
2.40.1



