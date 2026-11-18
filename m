Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040989;
	b=XJnSipruI8lD/PMrXvylntzoLSe7I6feqkykJQHRYGxTLyt+i1prn3CNF5oP7QagmEQF
	 6UFxmQWmIcrvXOt+XMJxVA0KCKKDhcdqdrpAsTfn9GasIjmBIABMBLjFZweM3JtdpVDLJ
	 YDVHF0RmFQXc20sNpw4H8kN6u3r8ZOF+OIkBJdeIbEu83/9RUcYjF/J/OfvJ6tMbCnMXD
	 KEthqSgPVwehABGH7CNnEnYpgFtojwBJlFdc7kXAIahZUESGQ4J6w9ycvDkbu9FYZdGn3
	 Fc5HUfeb5dNr6XPX0xwsNmQp4Q0MOqrm23YhsP9JPYqfbNv9is/8X3sfmD4G40fS/9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S5fyiXHmQVfDlooSCkUyYsKd7jPSLB4piSiltpfbPFM=;
	b=3skOla0ttBp7zJsM8zNawduUDQ3Ky1tgZV+0BHBUgdBoTh70XX2WljESF2riXeAkYgp5
	 sozMkwHmh+bEcnXs2QZznT0wK0q2UYDkUNiqY57mn8zk2j4RUsnyhPo0wArHtM1BHqMNZ
	 Fqw1UjPtCSgX126lrpuB+3p9fKe2GDv6aQAfpp0thmSxw3zLHSDWdvHa2JOyuBzF9UaIj
	 DVERbWzq/S+vULZf2o9PbDSIgoqVoNYXD5FDKZJjhKUzXOAJN5cP3JxYipRw0GijY0pVg
	 mXR2+zH6lhNAJkP7PpdKYZMlFOed2w3HdsACteUwFOCdgUojyIFsMC6kfiKMwBYFv0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttLrvEZD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825A5606A320;
	Wed, 18 Nov 2026 22:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttLrvEZD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BF51F000C4;
	Wed, 18 Nov 2026 22:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040989;
	bh=S5fyiXHmQVfDlooSCkUyYsKd7jPSLB4piSiltpfbPFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ttLrvEZDePlCUm9lrC/qKECyj+GLvO+1MRMgXeEGlV/wuWQvXoigvy37Hvj0xBs6L
	 Mhy8ySm+ivKeqGTRYHucdWbveKkKStw0F5jlcmCVmKBHTAezYuJgR15xr0vzm1AQnA
	 ZG2uzUeuj5si2uhlSHHFwzVg61Ian2Vfcs0C6+W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2653/3318] pinctrl: sprd: free maps on DT map failure
Date: Wed, 18 Nov 2026 15:54:35 +0100
Message-ID: <20261118150440.634992104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit e873c665e503ebfb6dafaf9346c3956695686226 ]

sprd_dt_node_to_map() reserves map storage before adding mux and
configuration entries.  If a later operation fails, the error path only
frees the temporary configurations and leaves the map allocation reachable
through the output pointer.

Free the partially built map on failure.  The caller ignores the output
parameters when the mapping callback returns an error, so they do not need
to be reset after freeing the map.

Fixes: 41d32cfce1ae ("pinctrl: sprd: Add Spreadtrum pin control driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sprd/pinctrl-sprd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/sprd/pinctrl-sprd.c b/drivers/pinctrl/sprd/pinctrl-sprd.c
index ccdcc91c7fa5f..d865d449264a7 100644
--- a/drivers/pinctrl/sprd/pinctrl-sprd.c
+++ b/drivers/pinctrl/sprd/pinctrl-sprd.c
@@ -329,6 +329,9 @@ static int sprd_dt_node_to_map(struct pinctrl_dev *pctldev,
 
 out:
 	kfree(configs);
+	if (ret < 0)
+		pinctrl_utils_free_map(pctldev, *map, *num_maps);
+
 	return ret;
 }
 
-- 
2.53.0



