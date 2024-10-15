Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4BC1C07ED;
	Tue, 15 Oct 2024 13:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997926; cv=none; b=j0c4lyuHuaBB8UhMLX7F7+zxiIPfnzO1IjIphR2QexFvwNdRx2PsCE+irW29n2Pl4lRkHDEwWmpq/HhY0S0zPOiDnmlDw+lGE5MneDD1uF66Fi4s/5nJ38L9SeehtvTTaaXuqsKW7CWhhQQGYgRWaEdAxrm/LG+C4SF4F6tAayc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997926; c=relaxed/simple;
	bh=NTqLVmBs9JoPFvS3Ihxip7oNgaau0tZXF+BuRl669oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTCe5rFn0GPYZ6lMixi+dt8GflhEh3TylThOKrNyW3U0UhJ5y4XcS4I6uUDt4/tuCwPncxG2AxtonjVgbgJ42USJ44Wps1Sn1KWaxSEsy4fF9GFDxpZvHpggA4+XIBNDouEePdHELy2bOSOLoPf8+CE/5ob8SFD48GvBizb1ESs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5urklGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5urklGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02CBC4CEC6;
	Tue, 15 Oct 2024 13:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997926;
	bh=NTqLVmBs9JoPFvS3Ihxip7oNgaau0tZXF+BuRl669oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5urklGmK1+LsfYQsY3vrnVMTqYfS7N+pn1QvZcwhXCYSu9Sg6c1GlovTlpXFdPst
	 cDv6TD6k4KPY6YE63SoXXYrKkzveVgU9N5A6X2+NQI4OVO9xiUYaG0kubQ0vDrmxc6
	 MAxgclkBaymOvuJ3C5mguYvZN2FJu2yy1S9OfeCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/518] power: reset: brcmstb: Do not go into infinite loop if reset fails
Date: Tue, 15 Oct 2024 14:43:52 +0200
Message-ID: <20241015123929.638650551@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davis <afd@ti.com>

[ Upstream commit cf8c39b00e982fa506b16f9d76657838c09150cb ]

There may be other backup reset methods available, do not halt
here so that other reset methods can be tried.

Signed-off-by: Andrew Davis <afd@ti.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20240610142836.168603-5-afd@ti.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/brcmstb-reboot.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/power/reset/brcmstb-reboot.c b/drivers/power/reset/brcmstb-reboot.c
index 884b53c483c09..9f8b9e5cad93a 100644
--- a/drivers/power/reset/brcmstb-reboot.c
+++ b/drivers/power/reset/brcmstb-reboot.c
@@ -72,9 +72,6 @@ static int brcmstb_restart_handler(struct notifier_block *this,
 		return NOTIFY_DONE;
 	}
 
-	while (1)
-		;
-
 	return NOTIFY_DONE;
 }
 
-- 
2.43.0



