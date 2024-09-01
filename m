Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5251E87B;
	Sun,  1 Sep 2024 16:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208501; cv=none; b=RLThX3JlR5Rcw7UuyKU6qeFPo+kv34A+ViW5xSHBcGVk4hag8kRn/vXBhXjt5hvEVutXmjw6xxKHRKTzljeP3dA9uwa2IwL3MZHlKEhg6OZSmAzjfwzBYXfh2+iwNKJmFUUVi0cK7kthsK0yFXExQQFLQKOA9BI91cTjVFJHR44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208501; c=relaxed/simple;
	bh=VGqBIj9MvDgSUiuFwn8DBIHgmS5+MvY+enDU+/5R50g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wc5HEZzGuuWZucBjDSp6GOLM1PJaSxw5k0TGXf9lfC3P2rcdzKd6/UqSnzcaMoTHOVi0qq69pfrETI0fboufslAIgcpoLdsQmQbSO+JgMXqm/tWB83WXSEmlZD1+cHbH48jiT6RLS1y84ox1jP2WiDR0To7O6suYx2Y32VNniUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxbDYDQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxbDYDQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E67FC4CEC3;
	Sun,  1 Sep 2024 16:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208501;
	bh=VGqBIj9MvDgSUiuFwn8DBIHgmS5+MvY+enDU+/5R50g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxbDYDQoWXXV6eeWH0WoDale1OdokXHXqq1rG2j0dP9JlNpgexYOfQt7ng5kKvIth
	 9p83A1FbI3KDSu2QO+oKrePDDRxsbYweg0KxnodmvQYKYS4Ae2fPLfEpD4j7vB9oh9
	 aiTyj0UaOvneKmBAiqStlKvJPf30ibtQHuiFyvS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 102/149] selftests: forwarding: no_forwarding: Down ports on cleanup
Date: Sun,  1 Sep 2024 18:16:53 +0200
Message-ID: <20240901160821.294969505@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit e8497d6951ee8541d73784f9aac9942a7f239980 ]

This test neglects to put ports down on cleanup. Fix it.

Fixes: 476a4f05d9b8 ("selftests: forwarding: add a no_forwarding.sh test")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/0baf91dc24b95ae0cadfdf5db05b74888e6a228a.1724430120.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/no_forwarding.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/no_forwarding.sh b/tools/testing/selftests/net/forwarding/no_forwarding.sh
index af3b398d13f01..9e677aa64a06a 100755
--- a/tools/testing/selftests/net/forwarding/no_forwarding.sh
+++ b/tools/testing/selftests/net/forwarding/no_forwarding.sh
@@ -233,6 +233,9 @@ cleanup()
 {
 	pre_cleanup
 
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+
 	h2_destroy
 	h1_destroy
 
-- 
2.43.0



