Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763608F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB14C433C7;
	Sun, 16 Jul 2023 20:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538761;
	bh=ds0A0dnnA/trpag9nC1V9LB66m2XLN0s3JOkGx1m1pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OzxOFxpRC9xLIeh9sxYZMuaDwr8BDyJqmLAtnrnqUX6D7vjCY5I1kbp5crZ6H5bFW
	 HD0kZLJoiZJOtCUfilEEzIN+QGvYh3QqM61UnPHlBUhde379Dz85IYSEalRy1voUlg
	 3oWmvhkM3bGyImSBFHRT683zfdT0fc4IX4viEIsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 537/800] tools/testing/cxl: Fix command effects for inject/clear poison
Date: Sun, 16 Jul 2023 21:46:30 +0200
Message-ID: <20230716195001.566682860@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vishal Verma <vishal.l.verma@intel.com>

[ Upstream commit b46c5fa57cc60692412f616ac66ab624a941fdb3 ]

The CXL spec (3.0, section 8.2.9.8.4) Lists Inject Poison and Clear
Poison as having the effects of "Immediate Data Change". Fix this in the
mock driver so that the command effect log is populated correctly.

Fixes: 371c16101ee8 ("tools/testing/cxl: Mock the Inject Poison mailbox command")
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/20230602-vv-fw_update-v4-2-c6265bd7343b@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/mem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 34b48027b3def..403cd36087726 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -52,11 +52,11 @@ static struct cxl_cel_entry mock_cel[] = {
 	},
 	{
 		.opcode = cpu_to_le16(CXL_MBOX_OP_INJECT_POISON),
-		.effect = cpu_to_le16(0),
+		.effect = cpu_to_le16(EFFECT(2)),
 	},
 	{
 		.opcode = cpu_to_le16(CXL_MBOX_OP_CLEAR_POISON),
-		.effect = cpu_to_le16(0),
+		.effect = cpu_to_le16(EFFECT(2)),
 	},
 };
 
-- 
2.39.2



