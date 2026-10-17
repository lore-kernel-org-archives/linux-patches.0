Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE1E3B19CF;
	Sat, 17 Oct 2026 16:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255306; cv=none; b=vBSWv2CSMD/CYzkUlPrYrhS+GoApG/BV/U3b/QrOM/IZtqZ96rk2BQs35WDMGxwJvhs0MaZYg6f8858Xrr/z/Uk7tb2XqGQthEYaX1f8kEz3QazRI1b+LPYwaufmsiCWTQxr+wmtNjJYP0MxJHt6B9MbTWboi7VC0ySN25N0vl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255306; c=relaxed/simple;
	bh=BrM0Vrxx/qgj+cs/UVO6yk0aVwDdbMbJFddPWbcXZ2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2rk3uqRG7zm7uzsZs6oStt5GXalllKZc1bDJdbX2dmldxCS2oLuCKYwV/Fu6ZjwHz/RqGO4OsbaNJ9cTfzHPgmyGUGOelXDTbIv3J0lHiFM0alB3xapb4Kbl5DxyWv3bVqdg3L/+NW52qU8tZXUCd7EQZRSmit4Q4/Xk1K3Hj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4hzrfUR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4hzrfUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF631F000C4;
	Sat, 17 Oct 2026 16:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255305;
	bh=/rDQIUjImZyzgS9b6tg4GqwHahB+U7ZqMMhlyjbBENY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4hzrfUR91jAIWH6KlP9Dr6O7r3mT3TtvfI8V2SQhmVRvale3MOGdZzkLeaccE1H7
	 e/MmT/n9+y8eiY9SaUY7KjlV0Zfu3DHmW1qXvyZkH0Len1oIWwR393tKnkXDpjI2aq
	 tehIrafqWHnKPN0SArNJkbYIuLX1I7rCMWJtooVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Fei Li <fei1.li@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 731/869] virt: acrn: Remove unused list acrn_irqfd_clients
Date: Sat, 17 Oct 2026 17:59:32 +0200
Message-ID: <20261017160055.690266611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dr. David Alan Gilbert <linux@treblig.org>

[ Upstream commit 97e72c1e0c5424cd8d7b95c31144e713c44c4244 ]

It doesn't look like this was ever used.

Build tested only.

Signed-off-by: "Dr. David Alan Gilbert" <linux@treblig.org>
Acked-by: Fei Li <fei1.li@intel.com>
Link: https://lore.kernel.org/r/20250430003623.313541-1-linux@treblig.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 666c7f9e0792 ("virt: acrn: Fix irqfd use-after-free during eventfd shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/acrn/irqfd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/virt/acrn/irqfd.c b/drivers/virt/acrn/irqfd.c
index 9994d818bb7e1..5574fbf878209 100644
--- a/drivers/virt/acrn/irqfd.c
+++ b/drivers/virt/acrn/irqfd.c
@@ -16,8 +16,6 @@
 
 #include "acrn_drv.h"
 
-static LIST_HEAD(acrn_irqfd_clients);
-
 /**
  * struct hsm_irqfd - Properties of HSM irqfd
  * @vm:		Associated VM pointer
-- 
2.53.0



