Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CB61D0BB2;
	Wed,  2 Oct 2024 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880527; cv=none; b=Ltu8Lcx5bIcHSbP9/tUc/zmA+H2WSffVsWB4pS9zid0Wzj1GipUjLPxAeEQq+grX98sfVHwVI5LEk6Xm4oskM76qbsSZml4bmKE2yEdX5TEOIYqT5iM4N6Bi8QNkWL+s8F4B05HKH1ukVbIQk1fJ/K9Mtv9owU/JB8LEMo5HrM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880527; c=relaxed/simple;
	bh=it3Ens22ALcOF2KOAId0k4e2RKRm46wcsM3IHfTHxqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdfNTJJGgjFHarmslMjEbBrR6jef1zmOB3pKg/L1tQWqjKYcKFRMN8VIQfJBF45kTp9snMfsIUdBtUf6AQxIGpRrLWmQlZ4+QzUAx3GCjZ8piE4jv2+dASWAXDQ6L4GHQfeMNhAWup2HzhzPI/ECQVRs08HzuIpLXYU1VOYuaqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHx3zAPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHx3zAPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7C0C4CECD;
	Wed,  2 Oct 2024 14:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880527;
	bh=it3Ens22ALcOF2KOAId0k4e2RKRm46wcsM3IHfTHxqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHx3zAPAql8woXIlZhs9h/6Mlx8qvCiE22HbmofidQHwhW33I8RoqVLxqfK2fqUKD
	 E9XIWoab5nSLRlBuXhFprAX9enEcdFNIHYJWXhaF3jP9LlRWzUgk2+KgaK5+ee3Q4J
	 9SLYwLkJNE7Ugk3VM/5MnmwDECk7HjhoBqZ5NRMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 489/538] pps: remove usage of the deprecated ida_simple_xx() API
Date: Wed,  2 Oct 2024 15:02:08 +0200
Message-ID: <20241002125811.743234963@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 55dbc5b5174d0e7d1fa397d05aa4cb145e8b887e ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Link: https://lkml.kernel.org/r/9f681747d446b874952a892491387d79ffe565a9.1713089394.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 62c5a01a5711 ("pps: add an error check in parport_attach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/clients/pps_parport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pps/clients/pps_parport.c b/drivers/pps/clients/pps_parport.c
index 42f93d4c6ee32..af972cdc04b53 100644
--- a/drivers/pps/clients/pps_parport.c
+++ b/drivers/pps/clients/pps_parport.c
@@ -148,7 +148,7 @@ static void parport_attach(struct parport *port)
 		return;
 	}
 
-	index = ida_simple_get(&pps_client_index, 0, 0, GFP_KERNEL);
+	index = ida_alloc(&pps_client_index, GFP_KERNEL);
 	memset(&pps_client_cb, 0, sizeof(pps_client_cb));
 	pps_client_cb.private = device;
 	pps_client_cb.irq_func = parport_irq;
@@ -188,7 +188,7 @@ static void parport_attach(struct parport *port)
 err_unregister_dev:
 	parport_unregister_device(device->pardev);
 err_free:
-	ida_simple_remove(&pps_client_index, index);
+	ida_free(&pps_client_index, index);
 	kfree(device);
 }
 
@@ -208,7 +208,7 @@ static void parport_detach(struct parport *port)
 	pps_unregister_source(device->pps);
 	parport_release(pardev);
 	parport_unregister_device(pardev);
-	ida_simple_remove(&pps_client_index, device->index);
+	ida_free(&pps_client_index, device->index);
 	kfree(device);
 }
 
-- 
2.43.0



