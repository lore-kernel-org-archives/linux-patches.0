Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C972FC88B;
	Fri, 21 Nov 2025 13:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732731; cv=none; b=fMmUqwxQXe5tIvqG0hsO8kH7o/2pmqPGfOZ01AhDAy2bEI0gOg7rYGbwfz1QjqjmNPrYaoVSQl7cVE5wz5Bo2Nk5sF/vXqeehWJQXXwN+eA5a3E//oY8B6p8aAE/1IlLm5CO1aVOpZBo0xMWO4Ue1am9GzmgVHATTfv6SvKjgGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732731; c=relaxed/simple;
	bh=Rxfwl5UfgHWjxgJlhreGWm7FREySm4hnA6ZzeD9+wYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5PqQxvceYZM7JdpllfN6MKdNWdvxNJIUmYPl89oTn6PDSJz6Y1TRhGgrslLW2KnvxzNmOcFKSTVYk2QYPHRTmsoIl9pdJKYXOFzEPCqu1yHalHROmnNWPVHjfB5dlBXOlkYA0AekcKYiFUoelsbVRBJII+P2et+ggdQg1UIOu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X913E4n/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X913E4n/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAF5C4CEF1;
	Fri, 21 Nov 2025 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732730;
	bh=Rxfwl5UfgHWjxgJlhreGWm7FREySm4hnA6ZzeD9+wYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X913E4n/3/JMsratAveeW3ogM9nZTLeKAKjLjcsD655g7N4Nm1TcCbTj6xiA1wmCC
	 l5C4YCoRtr8n308SCylpusRYmahCkYxNIVgD3XQp9ezW7g4Zr4MUi5kZMvSPBIzd3L
	 YwvBd1VlNdCi8K6WQCoYpjlETsuJ7JLZ7udYLj84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 223/529] udp_tunnel: use netdev_warn() instead of netdev_WARN()
Date: Fri, 21 Nov 2025 14:08:42 +0100
Message-ID: <20251121130238.947455852@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit dc2f650f7e6857bf384069c1a56b2937a1ee370d ]

netdev_WARN() uses WARN/WARN_ON to print a backtrace along with
file and line information. In this case, udp_tunnel_nic_register()
returning an error is just a failed operation, not a kernel bug.

udp_tunnel_nic_register() can fail due to a memory allocation
failure (kzalloc() or udp_tunnel_nic_alloc()).
This is a normal runtime error and not a kernel bug.

Replace netdev_WARN() with netdev_warn() accordingly.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250910195031.3784748-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_tunnel_nic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index 0292197497850..a08b0b6e0727c 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -899,7 +899,7 @@ udp_tunnel_nic_netdevice_event(struct notifier_block *unused,
 
 		err = udp_tunnel_nic_register(dev);
 		if (err)
-			netdev_WARN(dev, "failed to register for UDP tunnel offloads: %d", err);
+			netdev_warn(dev, "failed to register for UDP tunnel offloads: %d", err);
 		return notifier_from_errno(err);
 	}
 	/* All other events will need the udp_tunnel_nic state */
-- 
2.51.0



