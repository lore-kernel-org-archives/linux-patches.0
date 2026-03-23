Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999B126D4F9;
	Mon, 23 Mar 2026 14:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277656; cv=none; b=SsKnMTN4huIcI6sMW/KNkdc0ZW4F/IRJGhVmx/Nd7m1/h3zGed24cwZOuZp0nS2Kp93yHVpYuiYFba82m37fa4nlq8/jtQcutRqzEUAvz6oaWNB5JiF45hPankLF/Rfw3edzF18LoqkrdILb/A+F64rFDDw3w48EuEkuLj09Wtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277656; c=relaxed/simple;
	bh=U6a1vnDVxExjjG3/WJfXLnTzU/h1U3aNyBRjfSaP0Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fiuf23wf4e6xsDjmQfyMtvLLPNppnom8838c4Vkk1F2OaLyNrs4UKnissPe3CSEn+9UlvlS6QrHqp+SHr7cmrkJe6yRKot7FSqKOJqYllegSlb7s+YmDMl3JgfneS9+K7LUQPyXMMZBGRwZ9m9Ty1ocWeQm0Pv7s548Kg0fmr4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HT9QqVxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HT9QqVxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC5AC4CEF7;
	Mon, 23 Mar 2026 14:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277656;
	bh=U6a1vnDVxExjjG3/WJfXLnTzU/h1U3aNyBRjfSaP0Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HT9QqVxo+c7Oj2th/kLvJ1+4/t3sOIcoj6A7PmiHtZuFOcQuQJQcuj2u0DQVAQknl
	 xLegs2Dxjqx33Zta9vG3vQXjEfZ4EiZ3uwOzKZ6pU/14iOc8Vbo9zQ7wC025Y45ofw
	 ceo/KsaDo9aXqEOwOZDPoVVef+m9x9r372VX/Ln8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/567] mailbox: remove unused header files
Date: Mon, 23 Mar 2026 14:39:42 +0100
Message-ID: <20260323134535.352981169@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 4de14ec76b5e67d824896f774b3a23d86a2ebc87 ]

There's nothing used from these header files, remove their inclusion.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: fcd7f96c7836 ("mailbox: Prevent out-of-bounds access in fw_mbox_index_xlate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index c7134ece6d5dd..693975a87e19e 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -6,17 +6,14 @@
  * Author: Jassi Brar <jassisinghbrar@gmail.com>
  */
 
-#include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
-#include <linux/interrupt.h>
 #include <linux/mailbox_client.h>
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
-#include <linux/slab.h>
 #include <linux/spinlock.h>
 
 #include "mailbox.h"
-- 
2.51.0



