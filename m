Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5945911CA1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA11C433EF;
	Mon,  8 May 2023 11:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544684;
	bh=jAxO56Fpjvt+Jssu65eXkWuwKzwm9suv0lf9WFx46U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dP9c+KzDkjbG0rSZkRE6Uy3r7FHIqiki6yDAF3YVsLFjAZCZeDZ7stsGNG6d29OkO
	 ZCjUlYXWArk8+lzysMUJRwpr039REEepeb1u14KAR7+nAM2y9C+sxie3IVvexlcW0i
	 LP3zTDJ4gfPkqjiY3VvNpSrVlzX3yyujk2FKY6EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Pagani <marpagan@redhat.com>,
	Tom Rix <trix@redhat.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 491/694] fpga: bridge: fix kernel-doc parameter description
Date: Mon,  8 May 2023 11:45:26 +0200
Message-Id: <20230508094449.910448573@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marco Pagani <marpagan@redhat.com>

[ Upstream commit 7ef1a2c1c9dffa177ecc3ea50b7f5ee63a621137 ]

Fix the kernel-doc description for the "struct fpga_image_info *info"
parameter of the fpga_bridge_get() function.

Fixes: 060ac5c8fa7b ("fpga: bridge: kernel-doc fixes")
Signed-off-by: Marco Pagani <marpagan@redhat.com>
Reviewed-by: Tom Rix <trix@redhat.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20230301140309.512578-1-marpagan@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/fpga-bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/fpga-bridge.c b/drivers/fpga/fpga-bridge.c
index 0953e6e4db041..c07fcec5ab1b7 100644
--- a/drivers/fpga/fpga-bridge.c
+++ b/drivers/fpga/fpga-bridge.c
@@ -115,7 +115,7 @@ static int fpga_bridge_dev_match(struct device *dev, const void *data)
 /**
  * fpga_bridge_get - get an exclusive reference to an fpga bridge
  * @dev:	parent device that fpga bridge was registered with
- * @info:	fpga manager info
+ * @info:	fpga image specific information
  *
  * Given a device, get an exclusive reference to an fpga bridge.
  *
-- 
2.39.2



