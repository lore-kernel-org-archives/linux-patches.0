Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1CC34DCC6;
	Wed,  3 Dec 2025 16:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777805; cv=none; b=KzviLUV1cEI8U78hl+FgtSrwM1DGCKgbu2VtJv/IjXkr/bgCU8PVfzGLne8NlCZ4/SIa34ijb04/npz+uEGFpEtRssoATNFN7V2X2kmtG9d8TkFzw/xqqDLuSVSv9aRcugi94mbtkS4LPDaOlAtJXkqIHnVU+aGHz4r0yIAoX9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777805; c=relaxed/simple;
	bh=kR/UUYBv2H9ZhwIkolKEWATwC7e16ygOCVluAP8/XV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+pGv1Q41Kgiu0zGyDmQofTLVU1s0FCIGSdbvQuBMMsJdZfhNGlO+pER7zASPZJTyN5ITfBmgsxhhc2QsB1vEmfwcx1gqKb0B/zp9Ca78KlgwS4NsGIFEd8zSaIQ6al6MqbJCo091sUHYJ4xcEeOAR1QdJIPO8XN5FwUW0shWwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNC/l0RT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNC/l0RT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA00C4CEF5;
	Wed,  3 Dec 2025 16:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777805;
	bh=kR/UUYBv2H9ZhwIkolKEWATwC7e16ygOCVluAP8/XV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNC/l0RTQc79AFLqbEJA/ERcqksIc9jYXvHMpJmB9wJ+WlP3MmHtiyUvoMoeSp9m5
	 jv8S/kpPLuCB1e0JiAPjQ7qyJvo12HfWUipdgmH5EVEbyXnaOULOi/Uqfj9EmIy4je
	 eAaqyaR5LpuRMOIaoRbg1LMiwysVITsiW9NVAQWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/392] udp_tunnel: use netdev_warn() instead of netdev_WARN()
Date: Wed,  3 Dec 2025 16:25:02 +0100
Message-ID: <20251203152419.676162145@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



