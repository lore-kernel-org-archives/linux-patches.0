Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717618F58;
	Mon,  4 Mar 2024 21:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588583; cv=none; b=fZ2UqDOeYsB4SYJKK+wqvWul7avxovf3bkO3RWaApxSRSv9mifiA/xBaqMVQ4Of9SuGVdYLbPT+cka9UASa6RC9Pj/EqXhh8LO9oqHwT9vE6IMoQMSS4wo6EyAUTNsaabfdyAkqpYrjHGYc0mvceMUeip7pCOi0U6vf4ZS6BrYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588583; c=relaxed/simple;
	bh=/OZBvx3U/oh2XvEK6YNMWcsGhC4BvcByIfeSsXkmT54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXg4A8+udEACWkiyH3wrWjq88dJyva2GP03PxzB4mWGr8HqPUTV6KIxArPYxsv88ihx2hdVkz0R7l/lnoRV4VTNxPhCxRJskTqWKI7i8kJJHPqunpmM+QoYyfUwKkiQjqadwzS47Zz8MwIyK8U9cOfomDs6E2Etfd/vkh9kZZsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EemNW8bK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EemNW8bK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F5EC433F1;
	Mon,  4 Mar 2024 21:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588583;
	bh=/OZBvx3U/oh2XvEK6YNMWcsGhC4BvcByIfeSsXkmT54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EemNW8bKB9nWXAXU/bOJRxbtZSA0Yhr5Pyai9GFzzOgiDNWWRA5oeN6e6rGmd+5Lb
	 9zoviJtcHXZIC2oMWeciMcDui3WLYK8udqD834n1vpP9slFmuX4UxFN1cFHkoJBpd+
	 hr7ua7ZRIT91gXL3bDn3z1H/QOlS907uBBU+m24k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/215] net: restore alpha order to Ethernet devices in config
Date: Mon,  4 Mar 2024 21:21:11 +0000
Message-ID: <20240304211557.275181275@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit a1331535aeb41b08fe0c2c78af51885edc93615b ]

The filename "wangxun" sorts between "intel" and "xscale", but
xscale/Kconfig contains "Intel XScale" prompts, so Wangxun ends up in the
wrong place in the config front-ends.

Move wangxun/Kconfig so the Wangxun devices appear in order in the user
interface.

Fixes: 3ce7547e5b71 ("net: txgbe: Add build support for txgbe")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20230307221051.890135-1-helgaas@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 1917da7841919..5a274b99f2992 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -84,7 +84,6 @@ source "drivers/net/ethernet/huawei/Kconfig"
 source "drivers/net/ethernet/i825xx/Kconfig"
 source "drivers/net/ethernet/ibm/Kconfig"
 source "drivers/net/ethernet/intel/Kconfig"
-source "drivers/net/ethernet/wangxun/Kconfig"
 source "drivers/net/ethernet/xscale/Kconfig"
 
 config JME
@@ -189,6 +188,7 @@ source "drivers/net/ethernet/toshiba/Kconfig"
 source "drivers/net/ethernet/tundra/Kconfig"
 source "drivers/net/ethernet/vertexcom/Kconfig"
 source "drivers/net/ethernet/via/Kconfig"
+source "drivers/net/ethernet/wangxun/Kconfig"
 source "drivers/net/ethernet/wiznet/Kconfig"
 source "drivers/net/ethernet/xilinx/Kconfig"
 source "drivers/net/ethernet/xircom/Kconfig"
-- 
2.43.0



