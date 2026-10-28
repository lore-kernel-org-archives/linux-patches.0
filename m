Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208312;
	b=ETpUFV1BR8fdf7QSKGHLo4YguQeR+9d1nwl8wvUEYhMTK1N67/1TDNiCL9hIGA23pglD
	 vv5ADViK9LiEMUzBgPJXRKW3CpXpeUMG0g0d2e+q4XwRhY1YRf4eKUbDFEW9iU5B5uHoG
	 YWHYHTbi9G/htm2iiOwYgruhMr1XAkebu4Q0mYk6tPwIJv0SzZnez3YBBRMBiLF0doLdT
	 qIYoezZSVm1I+wksqwnBFRT//wkqYPVxc5bdO1Sk3NFS0gZDAJXAw28cRyCAGpjT5tF2v
	 897yHilL8fdFE7p4ZeYcD5aM9+9lpJueXfQgQj6AZNZTFUnO5aZZYJtwQhXDLA6z5rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eZzWJkJuPxWhCtH0FilXHM+zEKxVj78ub1HJnKz/UZY=;
	b=l4Lwc+mcK3+GdZOMl6Uy/q+XoZAlTcu7OyxVdWNovbiKR9NYB2ZL8Ptn7dZes7G/8Ngu
	 dpQkJCSdkxQ9siBFSY1y/JLTrfq3YYOFTe/0SFdJLiacijxQu8NO3ZIbG5m+IYPqIOktJ
	 JUMYOhWe2WkinDkF5NAhKajbg2qDGHT5zIr0MNjySmEZoEyET5ZQS0A6YcL7xgqAIJl9w
	 W9O2t26dTsuh70vPjw2hY8cmqavjZRaQU6C5KYPvRAgqfY1MR2lgtMYDyw12fKVVrN2pY
	 kFUYAYocGfULTNKUVByAU5NcLN2Y/Pkfrl9qLIgoLMyrGjkXO6a85On8B7NpviD4i+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VaVv6kVZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9563606A31A;
	Wed, 28 Oct 2026 17:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VaVv6kVZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4752F1F031E1;
	Wed, 28 Oct 2026 17:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208311;
	bh=eZzWJkJuPxWhCtH0FilXHM+zEKxVj78ub1HJnKz/UZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VaVv6kVZK9YA+16sQU2qXNoao3Se3WFqhTQC1wSlIlzJsQ4nDh8P5SRmVCrcB1NbU
	 YvyAcipa5mBuOX4I5hakuhIiVKd1ylLCjq0PmSqi5+LRUpfkjPzvHWzv7WMLtxD+h0
	 7x2jkm/z0jlqMfV03Rnek8mWTpWxeJ87kBLr2uEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/516] i3c: master: Do not treat master device as a duplicate target
Date: Wed, 28 Oct 2026 17:53:47 +0100
Message-ID: <20261028170005.298806266@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0fff6e6e0b53a..a51170aedd0a9 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1871,7 +1871,8 @@ i3c_master_search_i3c_dev_duplicate(struct i3c_dev_desc *refdev)
 	struct i3c_dev_desc *i3cdev;
 
 	i3c_bus_for_each_i3cdev(&master->bus, i3cdev) {
-		if (i3cdev != refdev && i3cdev->info.pid == refdev->info.pid)
+		if (i3cdev != refdev && i3cdev->info.pid == refdev->info.pid &&
+		    i3cdev != master->this)
 			return i3cdev;
 	}
 
-- 
2.53.0



