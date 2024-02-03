Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51A54BA80;
	Sat,  3 Feb 2024 04:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933774; cv=none; b=LRZzSaiDFygvObEdFLQyKmfffF69rBtYS6cS7ARymsihb8ZBli49Um3SG9h2LYR+vvND17wX7W90ucaccraZzsKT9q6/SMZ3kma8zXgNH4Kf4vxAtLuiMDU2ITC9IhXlLdjkGZi7hAKlutn+OIPiMrPu6EcCbAlbIF+oEDN4X7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933774; c=relaxed/simple;
	bh=2fGX1l6YTlZoCEEK3t42sY2GaEDSmD64f9AP7K2ziFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOwQQUxZraXp+jChy3mRh45yHoaO409ebKc6jP7vITF9moWqen3oS+iLxhi77ZKWy86qXM6Q2R1wtMz+vEKQnkGuRfAlU08IQBoK6F6mzX683Lnn6RqthIAcqJyt1ePx5S7QZ6+lkFKnbexaBvjOpgUGz5+3X50P3MiSMtmNGV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWmFc3YL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWmFc3YL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE9DC433F1;
	Sat,  3 Feb 2024 04:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933773;
	bh=2fGX1l6YTlZoCEEK3t42sY2GaEDSmD64f9AP7K2ziFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWmFc3YL4OTgsCB2XfXbMKfX3HkIAXN6tN9Do8em0VaM0JzZAWB32DcESGHZ11nvp
	 fmZmhx5SG6l/LYBBCUxbxvGrizO7YRZ/QL4s3y+QZ7e2Q6raiL7VjJXL7WqiOs9nJf
	 r602JPeWbzzTQm46Eo+IzHNHBaq8siIlCn4IMWz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Shah <tanmay.shah@xilinx.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 076/353] soc: xilinx: fix unhandled SGI warning message
Date: Fri,  2 Feb 2024 20:03:14 -0800
Message-ID: <20240203035406.223764978@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tanmay Shah <tanmay.shah@xilinx.com>

[ Upstream commit 9c6724abf969251af53cdae525ad8100ec78d3c2 ]

Xen broadcasts SGI to each VM when multiple VMs run on Xen hypervisor. In
such case spurious SGI is expected if one event is registered by one VM and
not registered by another VM. We let users know that Unhandled SGI is not
error and expected if kernel is running on Xen hypervisor.

Signed-off-by: Tanmay Shah <tanmay.shah@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/1698431039-2734260-1-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/xlnx_event_manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/xilinx/xlnx_event_manager.c b/drivers/soc/xilinx/xlnx_event_manager.c
index edfb1d5c10c6..042553abe1bf 100644
--- a/drivers/soc/xilinx/xlnx_event_manager.c
+++ b/drivers/soc/xilinx/xlnx_event_manager.c
@@ -477,7 +477,7 @@ static void xlnx_call_notify_cb_handler(const u32 *payload)
 		}
 	}
 	if (!is_callback_found)
-		pr_warn("Didn't find any registered callback for 0x%x 0x%x\n",
+		pr_warn("Unhandled SGI node 0x%x event 0x%x. Expected with Xen hypervisor\n",
 			payload[1], payload[2]);
 }
 
-- 
2.43.0



