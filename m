Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212257;
	b=Mte4CeR1wTutRjSDKoz0FaryjgezD14f5hXL2yjk2GOYfbyDeqOCqhT7i5fIjL1+KQCB
	 Pxv+24rmzaY1hJdcac7VW/U1SNfVBu+p9SKGS3zosn63NxpX7TMiTMzzjYy87nDOhu9H8
	 SkHU/BCGPrd3UNxXSrxBP9XOHOHBmI8aWU2h4Qkx17RSUSKET2qVRPkYyPdmHxtCijpb7
	 L0hMfBBYG7J7TUCljEeOT7shmGUWTOEnw5fEgHMTdYJml3fQyXmu0wygVSljaMDk53khk
	 e65W3J6T6S9c7q3BZjgSGnKiljEiCgRWdm+hltGSpSqNPANpN8cxWSBxzMSfxfXGAxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EuZmwQTmCSaAACDHYZgZNOfQ+yUkYfQ+4JA+sn1wtww=;
	b=R1crGHFKV7u0P2KaJzl8vf8LOPttQ7IfasryC2CGDajWrxNDxyuLBsE1bXqP/OkFiCoM
	 Anvxu1I/Ej/lWyu9pADYpr+SbpXIRn54jZf3jLsOkdMwSP0dGJcN8LtOeBsHAo+3r6tHI
	 5uLI5qYqjutKLUn7eaGCN1qa5tJzcE62CqIrJeiAVaXBXdxky0++3DyualvoDkjPLl+n1
	 +8rWhp/x45WCVn9/XZrfnJjJlEN5nSJAc5H7QGEgNrWzpai3TSFXWUWJ0QPFPqmSSKuQ2
	 7JqGaro1okETx0aFuB3Yk/I1vcZ7Ebqo9JULbvIdEafFzsvB49sK0CwFl/M6VX9UJNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gUdqZbC6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9217F606A31D;
	Wed, 28 Oct 2026 18:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gUdqZbC6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4861F031E0;
	Wed, 28 Oct 2026 18:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212257;
	bh=EuZmwQTmCSaAACDHYZgZNOfQ+yUkYfQ+4JA+sn1wtww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUdqZbC6yCmulKBssuYabvt4ePW8c6WBWecfDx+ygLRVvSSVSgvJjPWwTHkUT9zIq
	 Ghzz3dutK2GCY3IIg0WBbwM1xQSIuA7qnqvSolksX1VqgQ1xPNUt4+pyyxmfwbMWVv
	 Kvds8NPo3R4bQxyXFcdDhpa60J+2Njq9CYztnZBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0092/1887] i3c: master: Do not treat master device as a duplicate target
Date: Wed, 28 Oct 2026 17:36:28 +0100
Message-ID: <20261028170501.327787526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 4dc1b3eeba7991905a5b5b8129ebea51be7d87b7 ]

i3c_master_search_i3c_dev_duplicate() searches the bus for another I3C
device with the same PID as the reference device.  The search can match
master->this, causing the controller itself to be returned as a
duplicate.

Since the controller is not a target device, it cannot be a duplicate of
one.  Exclude master->this from matching so that the function only
returns real duplicate target devices.

Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
Link: https://patch.msgid.link/20260807145638.168865-4-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
[ adjusted the duplicate-device comparison to match the older branch’s PID handling without nonzero-PID checks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 059ddd50e8590..d0f5ae21ea1f3 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1978,7 +1978,8 @@ i3c_master_search_i3c_dev_duplicate(struct i3c_dev_desc *refdev)
 	struct i3c_dev_desc *i3cdev;
 
 	i3c_bus_for_each_i3cdev(&master->bus, i3cdev) {
-		if (i3cdev != refdev && i3cdev->info.pid == refdev->info.pid)
+		if (i3cdev != refdev && i3cdev->info.pid == refdev->info.pid &&
+		    i3cdev != master->this)
 			return i3cdev;
 	}
 
-- 
2.53.0



