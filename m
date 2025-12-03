Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AF331B812;
	Wed,  3 Dec 2025 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779313; cv=none; b=EBXoWCoCWUoiPn5zQWIOJGUpwXxMhIiOn4RDcxSll6hAC+mHiymLDmedQLjmAEL5tKQxuqgwi8BC1r7+ybDzXgJyHQeZrrJfCeXv8vELf+H80OmDsdizaBhuzndSKWCmNKfXXbpQgenDo5TOZF1PSkhvWgL+/NUiVNZoI6ETXqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779313; c=relaxed/simple;
	bh=caTy8JJG9m3EX3WgoLvtgjVD4FRl5wNCd96m9HvUutg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c++DA66/M6Qvcpy8RVHfaQ/b/HrKLmMdeF/7IEg/NQWwSUo53pil41JQ29jdKC4MhXDHXjVrBSiJqWvi/KnNCNWZBqe7A2HGrdlxnRsprPkI9QjkAgTVNwCdZ5yN6q2G3yZ/iT4Fcdv/CbChV7hEjK7kDuoL88rH/1P8x+F4aMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GE3QSJxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GE3QSJxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC632C4CEF5;
	Wed,  3 Dec 2025 16:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779313;
	bh=caTy8JJG9m3EX3WgoLvtgjVD4FRl5wNCd96m9HvUutg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GE3QSJxYPY12n5HO515EAmVlZcYasBP0+jTrgbY8k9BPmhqAFheZGbSoBqqIujdvE
	 HBYhFDlnn2xCmssKEocMFjUF6M1r2FO8q+Jv1Hw21G/4shqvPOvOVr0tSYmTqWH/Nm
	 3dwSw3Q0uWLkmL4X3BESw/4mHFZBPuT0dnlfshSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 221/568] udp_tunnel: use netdev_warn() instead of netdev_WARN()
Date: Wed,  3 Dec 2025 16:23:43 +0100
Message-ID: <20251203152448.816637230@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bc3a043a5d5c7..72b0210cdead7 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -897,7 +897,7 @@ udp_tunnel_nic_netdevice_event(struct notifier_block *unused,
 
 		err = udp_tunnel_nic_register(dev);
 		if (err)
-			netdev_WARN(dev, "failed to register for UDP tunnel offloads: %d", err);
+			netdev_warn(dev, "failed to register for UDP tunnel offloads: %d", err);
 		return notifier_from_errno(err);
 	}
 	/* All other events will need the udp_tunnel_nic state */
-- 
2.51.0



