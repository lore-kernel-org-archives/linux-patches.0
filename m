Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32301C33
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA6CC433C1;
	Wed, 23 Nov 2022 09:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196542;
	bh=TY/QL7RZPjYhDXIfImiAIztPqnnDlUBUe8/9nBwgU7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vaG+xXssMPyB8mDgRso4ceH0o6swDZ3QApC7n0ktOvYvInJEVZ7gnhxtUTsVRQEhO
	 NFgv1rmDffApGdeOJzjdtQqVYC8tyW4U3+fzcI5ychkU9kQXIsC4mQGpYn5nCvygf1
	 iWNqP1PIzhl0NnDpHmMrYuLTfoOIVA1AurqjCQXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 060/314] tools/testing/cxl: Fix some error exits
Date: Wed, 23 Nov 2022 09:48:25 +0100
Message-Id: <20221123084628.203073675@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 86e86c3cb63325c12ea99fbce2cc5bafba86bb40 ]

Fix a few typos where 'goto err_port' was used rather than the object
specific cleanup.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/166752184255.947915.16163477849330181425.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index a072b2d3e726..133e4c73d370 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -695,7 +695,7 @@ static __init int cxl_test_init(void)
 
 		pdev = platform_device_alloc("cxl_switch_uport", i);
 		if (!pdev)
-			goto err_port;
+			goto err_uport;
 		pdev->dev.parent = &root_port->dev;
 
 		rc = platform_device_add(pdev);
@@ -713,7 +713,7 @@ static __init int cxl_test_init(void)
 
 		pdev = platform_device_alloc("cxl_switch_dport", i);
 		if (!pdev)
-			goto err_port;
+			goto err_dport;
 		pdev->dev.parent = &uport->dev;
 
 		rc = platform_device_add(pdev);
-- 
2.35.1



