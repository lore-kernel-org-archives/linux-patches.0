Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2A053E0A;
	Mon, 11 Dec 2023 18:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbhDji0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E514BC433C8;
	Mon, 11 Dec 2023 18:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319873;
	bh=xsSTY06up+Zh+Rqs0F4iVzvuB8y+ppWBMAEYXQ9hWKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbhDji0eQ9kUUVo1P7NM1RBnIKqjN/AXan3LXQCnX9Yrv3BSSLBw3zmx9gXLqMSWd
	 ct69ChX3BIZr7Jc4lthFrd8G0op08bwsUq2JjEcgAlyPpOQ6xfDu78s8gIVfj/8FnX
	 gnOwu0xm4C0r7fyCXjCH5i+UEGCxRjHyqBe0abzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/97] of: dynamic: Fix of_reconfig_get_state_change() return value documentation
Date: Mon, 11 Dec 2023 19:21:23 +0100
Message-ID: <20231211182020.653576690@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit d79972789d17499b6091ded2fc0c6763c501a5ba ]

The documented numeric return values do not match the actual returned
values. Fix them by using the enum names instead of raw numbers.

Fixes: b53a2340d0d3 ("of/reconfig: Add of_reconfig_get_state_change() of notifier helper.")
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://lore.kernel.org/r/20231123-fix-of_reconfig_get_state_change-docs-v1-1-f51892050ff9@bootlin.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/dynamic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index 1f55e46919004..b6a3ee65437b9 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -104,8 +104,9 @@ int of_reconfig_notify(unsigned long action, struct of_reconfig_data *p)
  *
  * Returns the new state of a device based on the notifier used.
  *
- * Return: 0 on device going from enabled to disabled, 1 on device
- * going from disabled to enabled and -1 on no change.
+ * Return: OF_RECONFIG_CHANGE_REMOVE on device going from enabled to
+ * disabled, OF_RECONFIG_CHANGE_ADD on device going from disabled to
+ * enabled and OF_RECONFIG_NO_CHANGE on no change.
  */
 int of_reconfig_get_state_change(unsigned long action, struct of_reconfig_data *pr)
 {
-- 
2.42.0



