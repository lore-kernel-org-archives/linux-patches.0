Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620378;
	b=RmYfh+G8yuMu7u2DelFuDk3tJfYOLVgWYHcjdUpIbFWFJAOJ4SULrONFJQIwDPG80a4W
	 ju87aWATQN/i20AXZ+6JfJBOZfwKnAlBEy9eNZJd1d8XB7wwEY51+gESBOiW6oSkaYfCE
	 MWBRJOJ6BUwr8NUVlG53QxsZXjqmPi80UoGpTs+Tm4K8dA+IBmBrBqM6mko2TJrsc37LR
	 ZlhUGqdTAt9+r8g8wxTV8HknvVEsLgzPhd4kJOAnd0d3l/GEwhVuOO4AM5ordc8QmA5nT
	 30V/WNmicqyUM2O3D7GUWG0v0y56tAHNWDeqNZRDPXHrFNq2teyv8SWtYf7+m8xDDrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qWYGzf5Mm9avQHnpZvzCHG36BjtmT/r4yvL2zGcaU24=;
	b=5h/iym9xKC+sd0vTsDojmFD66gOZHaP6bxEEAazvkFmcVYKxExHQPyrsUwIC3hI0hRqb
	 sMFRlS/ZtXdCL/4PyXip8YBDKFH6VPxs31ywmu5JPSpLl86wWRrbZM7Lg/QidKFpSfTKS
	 xzugf96xvmvMNsBTZ4ifqmLngJfjD2U4g6dfaQuWqV5c8rOlMnNaLPHdKs1FnvJ8bHIF0
	 kECtDnrQ29D0tVZQD9Ak8EqitUc9O1no9FBHy2Y+3wi6RsodArSu2x/++0N8ZAMbp/1+1
	 tbcbbuQ2ulJSoucpBBfb5H43ghsOB7dGs0D8pUrkTKEOFMguoaTD+aY7mMM8Q7a1SDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKbEpelo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F52606A321;
	Wed, 25 Nov 2026 15:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKbEpelo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04B91F000C0;
	Wed, 25 Nov 2026 15:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620378;
	bh=qWYGzf5Mm9avQHnpZvzCHG36BjtmT/r4yvL2zGcaU24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKbEpelooMa0KCOtOeKbZlPRyKBhUrHrBbkPelH2Z1GtXsVY49C6Y4dz2TPeFqETU
	 2SNt791+NIOhNz/poLLkG1ptS/uxEqLdkWcci+toHys5YP/nQbIOl0g6FuCd/EjKco
	 L6q+2wsL9Py/WRXLIU5zz7ABy0UBZoYuklGNHo/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 7.3 0898/1005] mei: lb: read the MTU once
Date: Wed, 25 Nov 2026 15:37:16 +0100
Message-ID: <20261125143842.730780642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 1115120f89f5c22bf49f7423cf158a04a474dd93 upstream.

mei_cldev_mtu() returns 0 if the client is not connected. A link reset
disconnects all clients at any time, from the reset work.

mei_lb_push_payload_v2() asks for the MTU to allocate the request buffer
and asks again for every chunk. If the reset comes in between,

	chunk_size = min(payload_size - sent_data, 0 - sizeof(*req));

makes the chunk the whole rest of the payload, and the memcpy() behind it
writes over the end of the buffer. If the reset comes before the first
call, kzalloc(0) returns ZERO_SIZE_PTR, which passes the NULL check and is
dereferenced. An MTU not bigger than the request header has the same
effect as 0.

Read the MTU once and refuse one which leaves no room for payload. If the
client has gone, sending the chunk fails.

Fixes: 773a43b8627f ("mei: lb: add late binding version 2")
Cc: stable <stable@kernel.org>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/2026102739-boil-startup-145b@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/mei_lb.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/misc/mei/mei_lb.c
+++ b/drivers/misc/mei/mei_lb.c
@@ -312,16 +312,24 @@ static int mei_lb_push_payload_v2(struct
 	size_t chunk_size;
 	size_t req_size;
 	ssize_t bytes;
+	size_t mtu;
 	int ret;
 
-	struct mei_lb2_req *req __free(kfree) = kzalloc(mei_cldev_mtu(cldev), GFP_KERNEL);
+	/* The MTU turns into 0 when a link reset disconnects the client */
+	mtu = mei_cldev_mtu(cldev);
+	if (mtu <= sizeof(struct mei_lb2_req)) {
+		dev_err(dev, "MTU is too small: %zu\n", mtu);
+		return -EMSGSIZE;
+	}
+
+	struct mei_lb2_req *req __free(kfree) = kzalloc(mtu, GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 
 	first_chunk = MEI_LB2_FLAG_FST_CHUNK;
 	last_chunk = 0;
 	do {
-		chunk_size = min(payload_size - sent_data, mei_cldev_mtu(cldev) - sizeof(*req));
+		chunk_size = min(payload_size - sent_data, mtu - sizeof(*req));
 
 		req_size = struct_size(req, payload, chunk_size);
 		if (sent_data + chunk_size == payload_size)


