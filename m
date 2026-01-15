Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19DB3BFE38;
	Thu, 15 Jan 2026 17:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497996; cv=none; b=EnlWh2ztJpY3KhKcCywEx12sdOECO2wgCn+bNPAiP3FBJOER50KQ1baoD+aVKdblAfZmCfjF/SYQcGWU0im+r9jU6rXIkr1QLrnrZuZvUon53Bd2AR0hXbOqxejjQQUaEmGN1ii5C3PSw5aDC3hqiUUBNVXHiT2nbZUZWjMY/S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497996; c=relaxed/simple;
	bh=ZZHa229FKdjRNJyMnf6Fb/cvfQSMpcOg8jWgRvDPgJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsOwYwyT1KJz9UScAvbPaf+fgHqflR8maZeEkSsmPHNa9/5e6xSd/3Kj+aq3W0t7IXMLrIs9ze9lExjJrmd4tTmbtgp1XdVCjlqL15hfoGOh0dsWL3AGssFRsd0wVb3iW4faOQm0aFWGCK6vI0Axqgbh7iHpr3QynNqgyHpyh8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVqbLXpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVqbLXpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4A6C116D0;
	Thu, 15 Jan 2026 17:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497995;
	bh=ZZHa229FKdjRNJyMnf6Fb/cvfQSMpcOg8jWgRvDPgJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVqbLXpE2V/VVRONs+5YYKKuvRnTg3y6dpXLgXLbRBIvHJvIroYJeiPjXWOt8qXWx
	 yUK0R7xPoBUJsvY3ydklLqTigvIsssDgoRHFG3Cbfxvj6A0+lPqPa46iputzY6j1PT
	 fQ8OXTrrDBxHeW5Q3OxWy0n6cAiY7NtymDOINwaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chen <chenhao288@hisilicon.com>,
	Guangbin Huang <huangguangbin2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 243/554] net: hns3: Align type of some variables with their print type
Date: Thu, 15 Jan 2026 17:45:09 +0100
Message-ID: <20260115164255.038322205@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Chen <chenhao288@hisilicon.com>

[ Upstream commit 0cc25c6a14efd709f2cfcde345e3d5c6aa20f80e ]

The c language has a set of implicit type conversions, when
two variables perform bitwise or arithmetic operations.

For example, variable A (type u16/u8) -1, its output is int type variable.
u16/u8 will convert to int type implicitly before it does arithmetic
operations. So, change 1 to unsigned type.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d180c11aa8a6 ("net: hns3: using the num_tqps to check whether tqp_index is out of range when vf get ring info from mbx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 63665e8a7c718..016cd7cf11931 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -99,7 +99,7 @@ static void hclge_dbg_fill_content(char *content, u16 len,
 static char *hclge_dbg_get_func_id_str(char *buf, u8 id)
 {
 	if (id)
-		sprintf(buf, "vf%u", id - 1);
+		sprintf(buf, "vf%u", id - 1U);
 	else
 		sprintf(buf, "pf");
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 492a754f84a94..1dffd1532bd76 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6692,7 +6692,7 @@ static int hclge_fd_parse_ring_cookie(struct hclge_dev *hdev, u64 ring_cookie,
 		if (vf > hdev->num_req_vfs) {
 			dev_err(&hdev->pdev->dev,
 				"Error: vf id (%u) should be less than %u\n",
-				vf - 1, hdev->num_req_vfs);
+				vf - 1U, hdev->num_req_vfs);
 			return -EINVAL;
 		}
 
@@ -6702,7 +6702,7 @@ static int hclge_fd_parse_ring_cookie(struct hclge_dev *hdev, u64 ring_cookie,
 		if (ring >= tqps) {
 			dev_err(&hdev->pdev->dev,
 				"Error: queue id (%u) > max tqp num (%u)\n",
-				ring, tqps - 1);
+				ring, tqps - 1U);
 			return -EINVAL;
 		}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index e2fe41d3972fb..e2cd0eb124bac 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -190,7 +190,7 @@ static int hclge_get_ring_chain_from_mbx(
 		if (req->msg.param[i].tqp_index >= vport->nic.kinfo.rss_size) {
 			dev_err(&hdev->pdev->dev, "tqp index(%u) is out of range(0-%u)\n",
 				req->msg.param[i].tqp_index,
-				vport->nic.kinfo.rss_size - 1);
+				vport->nic.kinfo.rss_size - 1U);
 			return -EINVAL;
 		}
 	}
-- 
2.51.0



