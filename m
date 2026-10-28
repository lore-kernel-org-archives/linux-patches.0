Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208662;
	b=VWUTM54ZCh2Lf1A1Lc9vZQqCLbGPwNXiOlUJ7f4qofEHf3n9TMaF8XmwJWU8U7tQh5vm
	 nsutgal4raEQ6FN8X/Lf5B2GfElmlAha+GQ+qRtuPKJHjIhkGPE3Q0pb7xUBhpsizS6x6
	 JzHjt5SObF4A5vaWJVg/HzYw94D/WVi9kXQl1SbsAZa/p/O+QkB9hunaxKXNyGOiPTEch
	 ZcvFGHXLIJslkG0RLJjdvG70HavYGKDkBK0/Bt3CqTFGpEkTP88ML9/XPRxA1jSs9P8K8
	 IIdC/DBa9Kuk7gK2/RlzwaSDTNVhr5OcZ6ASaegZTcmkODQhB84VGU6e4mpd8FPErxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wt980Kx8ziiwWVhjDRydgQlPJ2K3x3VyMDYXI3iV/t0=;
	b=kXmD9NdMOGvFo4Q83qmAnCRZfYdSjZlvi3uPoXZpv5ZFml/cs4Y1i/LzTGsK5tEp4Rux
	 +eMf/23gCXiyPZu7AdAjOH9LX5vGzhyCb2TKDOiAnzrdJDs+ivLHJkFp65r3AG3yQNX+i
	 e0QCa/brQIJ4FBjw5hObBlX+kGO5k919Hca/UfhiqLbTYBBZanTPAvePMmjUdXImmrS0r
	 oLVjSRGQkUVQTfTBblEhWChkOteioYlFqkWuQnk7ov+NkPVjd9ZxPW2UnPBtI68pZ9o0R
	 UfwPWwj7cntEU+RQqRwvNRgFaU/1Q6Ub8Cg1EX78k89zLJXo0b079cHcA79yMDz2rvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWJQMO4r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B28606A31A;
	Wed, 28 Oct 2026 17:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWJQMO4r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AC01F01825;
	Wed, 28 Oct 2026 17:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208661;
	bh=wt980Kx8ziiwWVhjDRydgQlPJ2K3x3VyMDYXI3iV/t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWJQMO4rQZkRw9oy+pksUs2k93hFHhXS8/77TsGwYlkO0XR2KaJvpFGjj48vt2SWH
	 E9FC7ZzZOUm91O3UEHLZcfP4P1VHGWGm5RTAERzWKxLeh2vjUX1JdEz2nJgRSlHXh6
	 X/y+oPYi8x1kAIAcqCqtdFwvVlHNYPN7O1qzkyow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 199/516] usb: typec: ucsi: Get the connector fwnode based on reg value
Date: Wed, 28 Oct 2026 17:55:51 +0100
Message-ID: <20261028170008.215266062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1060,10 +1060,21 @@ static struct fwnode_handle *ucsi_find_f
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
 


