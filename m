Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048978;
	b=2TQ35YS7VC4JBsmbBz5bPFVhZX1Y7bRHmJzeKZywiSLr/tQNEBKSdkC0eKw9LB/jtO/K
	 itMQNusC6xOIjaVgGEABSA/KfG+mKrMTlhbPqYtNpHbRqonDYyysWcCEMH+wrCrauCBF/
	 Rged2FzouIUOFY2lWINJJzXY+xapUa1xpuCg5E+8UQu3pDAG36qjkUcj9tDvTYvdKQkbA
	 BTlP6gBCPAJkRgsJOx9Ua2rdCSEVnzoGUIv2ODs4lHseDi6bPb21nVO5pDYSaXYTst31R
	 BA3t+BDwMSuumsju5asVQuBsIeMgmYMYTH7DrQKo/kxprfBryxq3kPTY9uKAhqP6x4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YMewI+JgmbdByqwgP6uJy5EyWF/teTSJDtbhwQwNGlI=;
	b=hnw429LBVHL3789YHl2yalZNU/Y6Y3wYaPeDxGm5UC5FCE2PvOPwPpc7/dRo2O2xk5v4
	 X0bCgS7a13LX4vF3jszKkyc811QQuR3NZ9jrhQwJkfeIZEEqO3Eg8VmI1lgn4zCpIiX5q
	 WkzKZI5kaX6yU4XoD5tUfMb4EQbJnp2K+YtqsBkRR4N7FBSZkNd9UP4ajBe70gWtASPha
	 3dj1ssn5Rgw/wxF0DV28I7SKaMSvg74O0r/TlgEz21z3k0fXWivShDl9ejgKS23W4qVxz
	 /lvkuygNhy4fa1w/12mRyJcCzFdumOlhhMv5GbJPvu1jBjUamqu4Pi/8DsfT35g4hzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A297JVrE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C9A606A320;
	Thu, 19 Nov 2026 00:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A297JVrE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565921F000C4;
	Thu, 19 Nov 2026 00:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048977;
	bh=YMewI+JgmbdByqwgP6uJy5EyWF/teTSJDtbhwQwNGlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A297JVrE8kL7qiJRGgJof76B5BE0tLfABVsn33J/lMs3srYO+pkHMjuGeQtxooSVN
	 1xCnC7j/uFYQe7NSSadA9OyeTscdeJkXkr7ELhTWHFBOwUQPLoVHxKkiX8qE0hAwsO
	 K4QTqlGmMD48yqpl2nQZWHQptxdkb/AJHzsYDaDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2170/2857] platform/chrome: cros_ec_typec: Stash port driver info
Date: Wed, 18 Nov 2026 15:53:24 +0100
Message-ID: <20261118150319.533218136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit 4dc9355cef4f507f12289c56b7ea5df911758278 ]

Stash port number and a pointer to the driver-specific struct in the
local typec port struct.

These can be useful to the port driver to figure out how to communicate
with the Chrome EC when an altmode-driver related callback is invoked
from the Type-C class code.

Signed-off-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221228004648.793339-4-pmalani@chromium.org
Stable-dep-of: 317e7abcaf60 ("platform/chrome: cros_ec_typec: Validate SVID and mode counts in discovery data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index bf204a96b740b..7414d33016922 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -45,6 +45,7 @@ struct cros_typec_altmode_node {
 /* Per port data. */
 struct cros_typec_port {
 	struct typec_port *port;
+	int port_num;
 	/* Initial capabilities for the port. */
 	struct typec_capability caps;
 	struct typec_partner *partner;
@@ -78,6 +79,8 @@ struct cros_typec_port {
 	struct usb_power_delivery *partner_pd;
 	struct usb_power_delivery_capabilities *partner_src_caps;
 	struct usb_power_delivery_capabilities *partner_sink_caps;
+
+	struct cros_typec_data *typec_data;
 };
 
 /* Platform-specific data for the Chrome OS EC Type C controller. */
@@ -408,6 +411,8 @@ static int cros_typec_init_ports(struct cros_typec_data *typec)
 			goto unregister_ports;
 		}
 
+		cros_port->port_num = port_num;
+		cros_port->typec_data = typec;
 		typec->ports[port_num] = cros_port;
 		cap = &cros_port->caps;
 
-- 
2.53.0



