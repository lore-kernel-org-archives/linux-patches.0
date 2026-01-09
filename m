Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDD32DEA6F;
	Fri,  9 Jan 2026 11:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959990; cv=none; b=N4MuO8qVuKr8tExCI2TgFC9AMQYtbYRbMo726IYnBI1+wLYcEHIv3QRd1PORIDOI6/FEwBLQ3fM29BjPkJFBSZrCA2Af4g68lNwb8tU08PbTKTd684z3ft9PKh0YeQ3KAlwr+g2gzCwEIGJNTKbP3koslO9KrajR7Mb1QOBN3iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959990; c=relaxed/simple;
	bh=AA7BCjBN6AkNpyDS1MidjW12S/l2GwI7KEnocXqElSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hanQjDNs1JS2BNW7h/FNnkKkYmr7m1uz2T7OjPTjRTsLmTrsDuuna2iQgy1eCPJIvpDh79P8Put4V+dVw2WyjHuJBP06AVrvyYUXZ2ayN7uw0k6UArl1MvP/jIsWOYkeEyZwFMj5OYdZAcjMCCxtwfrwl9kyV7aruVEgJ8Yp8n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuT1x3yJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuT1x3yJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3B6C4CEF1;
	Fri,  9 Jan 2026 11:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959990;
	bh=AA7BCjBN6AkNpyDS1MidjW12S/l2GwI7KEnocXqElSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuT1x3yJ6RHCn5giQBnIQZS42ih8vwI7ss2gmRdRBIaQGUfMIHy+ihMBuWik33zM6
	 4OxnyyvegfLdqpsXoNIOPGCbm9amBsmQrZWkgjp42EPRshWXYdvrow7xu55HRo/UYP
	 YEUZZj2urCpdFns3FtyklQPd5jEZNVbn3k1LUPi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 245/737] selftests: bonding: add missing build configs
Date: Fri,  9 Jan 2026 12:36:24 +0100
Message-ID: <20260109112143.210861763@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 03fb8565c880d57952d9b4ba0b36468bae52b554 ]

bonding tests also try to create bridge, veth and dummy
interfaces. These are not currently listed in config.

Fixes: bbb774d921e2 ("net: Add tests for bonding and team address list management")
Fixes: c078290a2b76 ("selftests: include bonding tests into the kselftest infra")
Acked-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/r/20240116020201.1883023-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2c28ee720ad1 ("selftests: bonding: add delay before each xvlan_over_bond connectivity check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/bonding/config | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/bonding/config b/tools/testing/selftests/drivers/net/bonding/config
index 70638fa50b2cc..f85b16fc5128c 100644
--- a/tools/testing/selftests/drivers/net/bonding/config
+++ b/tools/testing/selftests/drivers/net/bonding/config
@@ -1,2 +1,5 @@
 CONFIG_BONDING=y
+CONFIG_BRIDGE=y
+CONFIG_DUMMY=y
 CONFIG_MACVLAN=y
+CONFIG_VETH=y
-- 
2.51.0



