Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81946F9D7;
	Sat,  3 Feb 2024 04:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933348; cv=none; b=S8bmXcnRXW6dTSmpjnHE2szMavXpLIgRx8MvO3FEvAtyf234z0c7fjBWw5q3R6D/qsz9muqtJpf+QqHfrZu/YJvvfhBCciH1lb1JGsFCT0nRP3WoA6Gt4J7JRWqvVSnrEL6s2RgGi5hWHQPQYXmryjCA4t5XB3R48MgIOHyNJ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933348; c=relaxed/simple;
	bh=10nTu/tDo4hDl9zZTRfKi1Fyczongzk3p67xdQZmmNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oe7gSqR0cjPxSxBdjmJW6+nQWq0HhMK7BJJDwTmctALg5zov0Yai9xjQUOqXyJxDUXQi6jfyUmHK9Ren7O940vNuJFkYmGVCzGSfz/+R5JZccBx9GgKPinxOHwVBpLZ4n1ry2Hp6nl5+ypvkrHHH1Vp8DCaBes2gkOMEfjllWUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYJbtWvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYJbtWvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B416C433C7;
	Sat,  3 Feb 2024 04:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933348;
	bh=10nTu/tDo4hDl9zZTRfKi1Fyczongzk3p67xdQZmmNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYJbtWvdcmQTj5dFtvqXZJlBZJI27aBHY5z7NU8ZnT9ntpUNyJ7h+r/xeqTctMLUb
	 dhoM5u39qP4jTgkuEPX6raRm+Y473nn2AOxB18/d6QB5mycXIAOAZuxvAM1LIcJ9QD
	 Ac47J8oK0obwn/igzuuyRJ5RNh3tgbV3AY8HraOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Shah <tanmay.shah@xilinx.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/219] soc: xilinx: fix unhandled SGI warning message
Date: Fri,  2 Feb 2024 20:03:44 -0800
Message-ID: <20240203035323.856921585@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 56d22d3989bb..8293cc40047f 100644
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



