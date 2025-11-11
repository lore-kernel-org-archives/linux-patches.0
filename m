Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA7222301;
	Tue, 11 Nov 2025 01:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824567; cv=none; b=oXCWkiAJgnI/6jS7TRQppQB/oD1Apq2OBFYcYyztYL1TQFXr3BPQUXUcRrnEdGyG0OX3/sHeKvjXGRfDMFn/5fxQxoANiAlNeWQfFpNcSPDt/pyjJ3SUxiOOjwEik6cXR0P5GV8rOv/gQMd0VJd8wRu9pPgog+P2EM93loq5S2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824567; c=relaxed/simple;
	bh=NfLbOmu8X45X/nwzth9yQ04sIZEB0/4eDa2JWHejbio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdOJ76P9OsDh1qf/0S+IvZ3Ol35Kkor+6sJXQTpjR2CxxWcoyMMTHhoIHPnI5KlyhRvxrSN4ctwf9T+3klP4XYolqvBWJvbzAVlsZdJdK/HrKeaGDALsvRROKqKrw8egPg9p14iaYBHFuEI4JfrndiDNpw86kRCbLEaP3z/Uamk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBm9zKET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBm9zKET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4DBC4AF0B;
	Tue, 11 Nov 2025 01:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824567;
	bh=NfLbOmu8X45X/nwzth9yQ04sIZEB0/4eDa2JWHejbio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBm9zKET+7CMXBAiX5Sigm7rz+ZgoXwDHOoplfAUGn4YwPIfskSLIciMW/zZ/YrH4
	 rSuZ2+QGYRP/Rb4JojLo3lVpPjtTth/NkL7n18CqTKpFM3gpszuQgquVO0GhjddLOz
	 MQRi5TZoi6ybE7BzQHLKrDIOjW6tl+xiDIC5DERE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 525/849] udp_tunnel: use netdev_warn() instead of netdev_WARN()
Date: Tue, 11 Nov 2025 09:41:35 +0900
Message-ID: <20251111004549.113731433@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index ff66db48453cf..944b3cf25468e 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -930,7 +930,7 @@ udp_tunnel_nic_netdevice_event(struct notifier_block *unused,
 
 		err = udp_tunnel_nic_register(dev);
 		if (err)
-			netdev_WARN(dev, "failed to register for UDP tunnel offloads: %d", err);
+			netdev_warn(dev, "failed to register for UDP tunnel offloads: %d", err);
 		return notifier_from_errno(err);
 	}
 	/* All other events will need the udp_tunnel_nic state */
-- 
2.51.0



