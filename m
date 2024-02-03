Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C124171CE;
	Sat,  3 Feb 2024 04:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933549; cv=none; b=QqXROEGhDWctZmnok495dWxe7KLT9X4qEQUIqwzoTmuh2E2ufaWGuyqAidotl8GIjLpcKLn5kek24772deWOM0JdUPNvmebgHp3QIJ67u/6UYx6xzI+oWiYs/bzxbGoe+Syh/ty5vnfGEfbuxxiqr9Op9GnQERqsLUMLbx6kdmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933549; c=relaxed/simple;
	bh=APl8qYOIemWxiBPsYYqx2Wn551Q0bZ0GDs27jpqVjQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRljVh0bPPoGs+hyON2rN2LNzIxy18aio69VbJRG70jsDpZFT9+EW9klr1BTpuTDPm6h5DtRjE3j7gpiYcRJxs7mbeLJB+cu0OWp4a6Gmcqua1gaIlgq9zH1fXQIEkXdIjw/d6zP8UU7PbQP+Wd1Q53Bpw+YI9Fq2J9hkmxh8TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5iT0Os/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5iT0Os/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062DFC433F1;
	Sat,  3 Feb 2024 04:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933549;
	bh=APl8qYOIemWxiBPsYYqx2Wn551Q0bZ0GDs27jpqVjQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5iT0Os/XoUbvsde7x6O1REBW27GQ9UvB+7V3ri8HomoMniqU1Foz71g4CC2IZM+N
	 +OypHIxqAn3YSRwp9aPg3e1KfunJFNGzqq4IBadqLeaAjBRvpYeWBBw/RKQY4iED4Z
	 aVODfpbu7MR6ZpAIs0/z80xZedQWxj658Ui1oeTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Shah <tanmay.shah@xilinx.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/322] soc: xilinx: fix unhandled SGI warning message
Date: Fri,  2 Feb 2024 20:02:48 -0800
Message-ID: <20240203035401.455005704@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



