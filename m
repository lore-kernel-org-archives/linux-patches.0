Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032565;
	b=WQ841J5PLF2Wf5KJabGky6/1tghf8NfRveI0uljFiwmI4sU4quLsyvnembUYxfxYSL5I
	 C6vgzhk39O9toUQAQdHOy4foZjtHBHYIFseHCcq/2+tGBNmCqBMBeJc8ZNqRry3y4Pfx4
	 nsWTYjTP1PR5PMy4iege5RwFYNqHTAAkVfVm7OvjuyJNJiciBGAeDWiR0LkymXMy5lUA4
	 tJxXcsIg3JSsl3nDn//u5+dvsgTFc0dhmfaYU9gZmbCMQ/4wZqNtk+UxQ1y1obqfpcdCJ
	 1anm15PKXSA/2hAPW3OYIbl6JZf/SYdKi9pUYc0zFISntnC3Waye6FS7H+q+3/oGt9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BdtVbins4mKsMsK3xNUXZmJH0q2jUp3dVl6ZqRPEAxs=;
	b=0JsV5ubIPZv+28SaQr/7LHx7gHHxm7sbNb/Q4SPqs+ry3jUZwn5j3nScAhrDSSVgFcb6
	 A89Kw+8y5qUGF0CcpthXNSYQz4w6zFNucncTN8HbjFQv6crhSvR00WfpTneAZNGCV9NVF
	 LKO4VZQdp8DeAcOtzJNnLirpyXp80ivTnt11A3sfNDvxfAzTW+qQQpVHWQIekwvkgyFMD
	 j3//WpmuWIpYbH6BedF3vqxfvAtO7r4NY6YZaQDk+PzOZ2pPDI0D56BDtavz04Uh4tSHh
	 XuuqbJ/hrGuCrgN1yFOnTiaRfEyraOV0XI0bdU5Ih/wVlpOGy+XRqI/eaEj09dh7NEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBIi8a0r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F84606A325;
	Wed, 18 Nov 2026 20:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBIi8a0r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C481F000C5;
	Wed, 18 Nov 2026 20:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032565;
	bh=BdtVbins4mKsMsK3xNUXZmJH0q2jUp3dVl6ZqRPEAxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uBIi8a0rT9g4XaXAyIDrbuiuzC73u8B20ZbwlY/m0ae/MpgpZWuLmArcQ+8hLhI0s
	 crB4ifRhaSy9UaiiOpyqs1cJ56LnWw29ffdkFi8gvIq0vDXaaQRsoTKG4VxV9fIVIK
	 y5sdNZRD3Wp6UvuXsFJJpuEl1Z+VgebzcrnXMgDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1454/1756] net: bcmasp: fix OF node reference leak for phy_dn
Date: Wed, 18 Nov 2026 15:59:41 +0100
Message-ID: <20261118150106.979738880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit a31623d91c6e48b08c74dc95567aeb62f1f35938 ]

In bcmasp_interface_create(), intf->phy_dn is obtained via
of_parse_phandle() or assigned ndev_dn. of_parse_phandle() returns a
node reference with its refcount incremented, but of_node_put() was
never called on intf->phy_dn in bcmasp_interface_destroy() or the
error unwind path in bcmasp_interface_create().

Acquire a reference on ndev_dn for the fixed-link case as well so that
intf->phy_dn consistently holds a reference, and release it with
of_node_put() on teardown and error.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261013204439.3494046-5-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 74df12df941f1..d44662063f1b0 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -1260,7 +1260,7 @@ struct bcmasp_intf *bcmasp_interface_create(struct bcmasp_priv *priv,
 				 ndev_dn->name);
 			goto err_free_netdev;
 		}
-		intf->phy_dn = ndev_dn;
+		intf->phy_dn = of_node_get(ndev_dn);
 	}
 
 	/* Map resource */
@@ -1299,6 +1299,7 @@ struct bcmasp_intf *bcmasp_interface_create(struct bcmasp_priv *priv,
 err_deregister_fixed_link:
 	if (of_phy_is_fixed_link(ndev_dn))
 		of_phy_deregister_fixed_link(ndev_dn);
+	of_node_put(intf->phy_dn);
 err_free_netdev:
 	free_netdev(ndev);
 err:
@@ -1311,6 +1312,7 @@ void bcmasp_interface_destroy(struct bcmasp_intf *intf)
 		unregister_netdev(intf->ndev);
 	if (of_phy_is_fixed_link(intf->ndev_dn))
 		of_phy_deregister_fixed_link(intf->ndev_dn);
+	of_node_put(intf->phy_dn);
 	free_netdev(intf->ndev);
 }
 
-- 
2.53.0



