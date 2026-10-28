Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210970;
	b=UcVtpgvGrohqk1WtkHZilIz7ZLH/MENwTVUWpV4PuAJWw3Ld+U5SQN2nmmL+yr7YSfkt
	 y3A5DZYJVuyfzBY+bcP5UYzTCu9h8vBN6L6BwjH5Osn7r2j5oN+JILWWRNwv8RMD0k3hK
	 k2eU/akPsdZ6iTTdzDuZ4uIKmc/aE5KC/k244OFtcUbrJSo45c/T3YrASC/fXXEcRdiVd
	 kR/rZsOtgDlHY8hMyQhY/9MEt/KN7xm5amOVjnzXbwCHTD683ByTOeU2+Thx6qs2F/KA8
	 OKVJFXqDSk3tZKLJZim3lCUphK78t8MOuJJx9yTCUIhP771f/EPPVXwxBmPzM4n9vDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YjHLWzw6j6YQVbqIXPniact+HaOpQr80mkkYs8OAwWg=;
	b=G8bxlK/DeY71CeLoXQ72HO9McyvCClrPAwDWTi++1UpncWBrbmgvu5pFug7m5nBDoOH3
	 MWxzWx6Ihozf7kTibTak1asDI5SgOU/0wnDaBWfjTKkybX3RXHm94cKQnbLteXC0F3IyP
	 tALc228g7tiocgFv2xQpGXNPfH3ki8fOJJsIOgJPU9JT38T6fd/CNIl27S6WO/yDJkBZI
	 zxcpPjk/aMWwmhsgR33QCq6sLXO9D2vI+hr40SJ7ZSI6nMK62dJnJ2mlPM3jeuo0BVus8
	 47lAteQPVMiFfV86OvW1nPmBXL2enbT8sit14KVXJ26c0DqsDISzjZAgBA8ZE3ti7ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lH96aAp0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C84C606A31C;
	Wed, 28 Oct 2026 18:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lH96aAp0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2401F01825;
	Wed, 28 Oct 2026 18:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210970;
	bh=YjHLWzw6j6YQVbqIXPniact+HaOpQr80mkkYs8OAwWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lH96aAp0rldtVIAjEaIDUfaTrHKMS2LRDeUCi4wgOe/kOJzAb2A1djeUYMLdbjByi
	 1yreQEGvl1wzXs8rJgtUwLKoWEMWwyVnEJkSaAAOL6DVIvMl5ZsU9QhnkYkd0F3eT4
	 UAd4rXMTo4GLGLDbqw3koFqJ7lmDSL7Xm6rRUUXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 212/571] usb: typec: ucsi: Get the connector fwnode based on reg value
Date: Wed, 28 Oct 2026 17:55:59 +0100
Message-ID: <20261028170013.034173788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <prashanth.k@oss.qualcomm.com>

commit 6c51f09c6db5868a5090e8dd4d7764660c87f1ad upstream.

ucsi_find_fwnode() currently maps UCSI connectors to Device tree
connector nodes based on the order in which connector child nodes
are described in DT.

This can fail because the ordering of child nodes isn't guaranteed
in Device-tree. For example, DTB may contain connector@1 before
connector@0, causing connector numbers to be associated with the wrong
fwnode. As a result, role switch and Type-C notifications can be
delivered to the wrong remote endpoints.

Fix this by using the "reg" property of each connector to match
its corresponding fwnode. While at it, if the reg property isn't
present, then fall back to the old method.

Fixes: c1b0bc2dabfa ("usb: typec: Add support for UCSI interface")
Cc: stable <stable@kernel.org>
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260916042808.2879079-1-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1081,10 +1081,21 @@ static struct fwnode_handle *ucsi_find_f
 {
 	struct fwnode_handle *fwnode;
 	int i = 1;
+	int ret;
+	u32 port;
 
-	device_for_each_child_node(con->ucsi->dev, fwnode)
-		if (i++ == con->num)
-			return fwnode;
+	device_for_each_child_node(con->ucsi->dev, fwnode) {
+		ret = fwnode_property_read_u32(fwnode, "reg", &port);
+		if (ret < 0) {
+			if (i == con->num)
+				return fwnode;
+		} else {
+			if (port == con->num - 1)
+				return fwnode;
+		}
+
+		i++;
+	}
 	return NULL;
 }
 


