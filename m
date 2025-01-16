Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929DC25A65D;
	Thu, 16 Jan 2025 23:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737071621; cv=none; b=R556DpsuisL2QwYJ1ke2I5UANluobUE6vytnD2BMG3r8sLXlWgeGt+5S+NgnlScOKybJllDomCBsaQsAvgNZIlO/Qd5J2jpvCqbb2cPbxrx7IqirJFi/hRwv7K1mIx+99rewO5oP0GleriHBjh583yIFbw9fvIlFHzR7+c15SIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737071621; c=relaxed/simple;
	bh=CKYp2W7Af4jmiVpHhMc5PuyhKFcx6vw7YQLeT6QE5nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QA9Zq9w4U8JRK51H92e6u7w2EsPZ/fgyyYD3r3foF4PuUyhI6yI6Ey3GLJTVn3vFrlbinzls8/BbogyJZ65NxlzUVu5W/rjIDnwadcIC3hQHMsEAX62/swc2eHe9MnWEctGXSV5eCya2GA/HBPtWduzpCOOTKFC1xos3RPB1Qcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KPC5shO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KPC5shO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EF2C4CEDF;
	Thu, 16 Jan 2025 23:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737071621;
	bh=CKYp2W7Af4jmiVpHhMc5PuyhKFcx6vw7YQLeT6QE5nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPC5shO28M6faZ0kyjj2KUbWHH5Jnbx4MzchFgwzv71Ph+WMntaRu71qzcf+fDjRK
	 UaYDDqvmNuzc4h1qEPkiwrrzdiZFHKbHbkH7lUyBcJ3wVn1eWxyFFuDj/nOSJnomeF
	 MweecJHHfziIHSWlV2SJwrjVes4W2ueysNAzoNIt6TnzjhjQeXT1CG4QDodYOAJSTh
	 fZgej0gwBZ/66W7uZKIxgX3pzMJ17qIbhrMSqcYVl0HS0XOBx/9co4SOe2NvQLClzw
	 IKy0ZGKDAWD96+a0iIeKObLHvw9iEAVHNWheoSO/evD7WSifN6H77bR0OPTc4Kaqpn
	 OSUtt6yHxafjw==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Saravana Kannan <saravanak@google.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/2] spmi: Set fwnode for spmi devices
Date: Thu, 16 Jan 2025 15:53:37 -0800
Message-ID: <20250116235339.300485-2-sboyd@kernel.org>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
In-Reply-To: <20250116235339.300485-1-sboyd@kernel.org>
References: <20250116235339.300485-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Saravana Kannan <saravanak@google.com>

This allows fw_devlink to do proper dependency tracking for SPMI
devices. So, better deferred probe handling, async probing, async
suspend/resume, etc.

Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20241115230509.1793191-1-saravanak@google.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spmi/spmi.c b/drivers/spmi/spmi.c
index fb0101da1485..3cf8d9bd4566 100644
--- a/drivers/spmi/spmi.c
+++ b/drivers/spmi/spmi.c
@@ -517,7 +517,7 @@ static void of_spmi_register_devices(struct spmi_controller *ctrl)
 		if (!sdev)
 			continue;
 
-		sdev->dev.of_node = node;
+		device_set_node(&sdev->dev, of_fwnode_handle(node));
 		sdev->usid = (u8)reg[0];
 
 		err = spmi_device_add(sdev);
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

