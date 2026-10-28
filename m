Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210578;
	b=PL9wKMSW+Uu1fkOERd0apgFRA5l5C6QhO8a9cG99zxItr4IoSA7VEDVSsFHsxVXGIr9/
	 rRh5p2e2iYD89nCkPqxNJZKtoCoKErJAGT2RdhN30aTJYXfwyMFV3u5hDCnMmHphw9Pb6
	 eN23TmtWbbOOmIjEJh2LErU2IRprF+nZeA+0OR/qe6tdvlCkRNshhZJuK2Bq5La8GbxDi
	 s+IZO1SH1uzfIYKJXFJ+sp/xZRZPD9zhdLblhf9Ox41By1aJeWLPDLd0jeHJBp0zOORtl
	 NG7EGnUDMrAZIgxQvC330LZUdyL9LOgdm+qBiQV0CfHnCE5N+xfJveFSsFNqVjbc2NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=R44NAeycO0n22M0TjA4buTtOTWK2qHk3O5jhhDNmSFI=;
	b=Jutzg+jgX7hcsZrDgYiyaugvk9NdBreyJJKpRJEp39zqMCouvKovutxmP6n28N5Xoi5Y
	 g0WOCrnOYZ6PsOShBlFyFIfoRYrCmutJIXLFN5TrEAWOMlZ9lV42/ikGsJFiqCgCtg2Uz
	 l6EvEoVLkZ4q5Geb+bMOZFNnkhWzg9kKkzeTFTKQ5OTMQeh8od0J2vmqTNvO9tn3IpJt7
	 IFh/mqiVE82DphPvSEdvLPG18UZkdBymKpQj2yE0Qx0fGCmKDbIevxjfcexh0xSAq6WIB
	 7ZKdz1/Nd5YQ1Z2HOa6qUW72E2XMHUc6Vy8NZyZV5m2FqBd6mVX0b/uwAa6jvKxBSag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPOcOl95;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1EA606A31D;
	Wed, 28 Oct 2026 18:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPOcOl95
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B81E1F01825;
	Wed, 28 Oct 2026 18:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210577;
	bh=R44NAeycO0n22M0TjA4buTtOTWK2qHk3O5jhhDNmSFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aPOcOl95K5/VuIHM2MBvOyzOutNxrDqoaFSCFCKRFchhINZlJR+u+txD96q1ZLapr
	 yfuWBuh7d+qnMJnDbJLqR8fDFwCetcXnKbkeWTl5jxOuDwvdlvYROKYYN21ejDZpqp
	 Q88eflZVyklGX2vTY3w4VQQUfc0NLLz3STbKm6oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/571] i3c: master: Do not treat master device as a duplicate target
Date: Wed, 28 Oct 2026 17:53:40 +0100
Message-ID: <20261028170009.758473016@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 48f4f2e31e597..79f92b2ab5dff 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1830,7 +1830,8 @@ i3c_master_search_i3c_dev_duplicate(struct i3c_dev_desc *refdev)
 	struct i3c_dev_desc *i3cdev;
 
 	i3c_bus_for_each_i3cdev(&master->bus, i3cdev) {
-		if (i3cdev != refdev && i3cdev->info.pid == refdev->info.pid)
+		if (i3cdev != refdev && i3cdev->info.pid == refdev->info.pid &&
+		    i3cdev != master->this)
 			return i3cdev;
 	}
 
-- 
2.53.0



