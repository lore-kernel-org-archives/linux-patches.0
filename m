Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024350;
	b=L15cCL2YF+TMFTjOhjvVfjgyj6/YSTTOeX1t8jdO76zbEKmXPJbMwg8D9k2j29ORLwoI
	 pRvv+1XS48karWeRRlCLh3xtZdRkgfzTzgdjs70/IdaaLRTwGoA6R8ezsHythajiY8AHM
	 hdeTiRvDlqy+rNZKX7TwgHDrMAbmANCY6gMdsVJH/0yyeBSazDqw4cGbHNGqBBbb5TXws
	 eQZP8mkMRrpjL0WP42g8rceNTapnyie6+cwt4vu2OysqBkxkT8wg13XwBEGR1Ib1+3x9s
	 +/baAlAIDG0ZrWwKj0p9/EE+s94mmfI88OvonX8RpK9azJqO4m/9JHurN3JffuEWbWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Zlem4Z3U1GcKGR7gvmSvrkvkSYJirj0KhtWhhnh6+A=;
	b=WrluxLalfkYtQ52W8ylqDB21HuhopnYsPmETcJRZNwP2/ILUOwajhhafM1TRkpF9xhGy
	 PYQbbgOXIDFPxpscdvcQLDIxLVczbVYUn6NVYapVsMOUXzrqv7wJeYnzpQuVukETMzUgX
	 ZlCbsoYl6GSyg6/ojyMVr4fe4KHhrbZI17H8k7d7oICojXntkdFWf9ScrS+P9rh7HV7wV
	 zj8yslaS1wDW2/jbSYHH/sWLNN1rw+rZUSbXBcM8XxdSSrp3yizFsX2tR5ZoXttnZ5nNf
	 B6JFgVxdqLVKhpunDCxLJArS5hb1KsOuL+9HzyXVQ93ge4iCAaI65Nw9l6XnC2AA3qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQzu3dHB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA4460A262E;
	Wed, 18 Nov 2026 17:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQzu3dHB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAE61F000C5;
	Wed, 18 Nov 2026 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024350;
	bh=4Zlem4Z3U1GcKGR7gvmSvrkvkSYJirj0KhtWhhnh6+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQzu3dHB5w/J0RCI22Yrg2/0YmUBB8d9/JdcAmz6FJ6wRU6aOyWM5EbqlmtES659p
	 0j6zVuKDjHRZucNxgg0EYlrn+jRRbT5+zB9ZjvPoJRx/Y2N0vlmhXXfM++voZSA3h9
	 T/cYJW1gln3zkpe/XTfeXO0szAO0T6HZKu3xA3Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0653/2151] media: staging/ipu7: release ISYS firmware resources on remove
Date: Wed, 18 Nov 2026 15:39:48 +0100
Message-ID: <20261118150145.624709147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 628a575c99e767d6fac81215fca1190b61867148 ]

isys_remove() tears down the registered ISYS devices but does not call
ipu7_fw_isys_release() after a successful probe. The probe error path
already uses this helper after ipu7_fw_isys_init() succeeds.

Without the matching release, resources initialized by
ipu7_fw_isys_init() remain allocated on normal device removal.

Call ipu7_fw_isys_release() after unregistering the ISYS devices to match
the cleanup performed by the probe error path.

Fixes: a516d36bdc3d ("media: staging/ipu7: add IPU7 input system device driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu7/ipu7-isys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/ipu7/ipu7-isys.c b/drivers/staging/media/ipu7/ipu7-isys.c
index 601e5a79ef8ec..a54393fbb9db6 100644
--- a/drivers/staging/media/ipu7/ipu7-isys.c
+++ b/drivers/staging/media/ipu7/ipu7-isys.c
@@ -590,6 +590,7 @@ static void isys_remove(struct auxiliary_device *auxdev)
 
 	isys_notifier_cleanup(isys);
 	isys_unregister_devices(isys);
+	ipu7_fw_isys_release(isys);
 
 	cpu_latency_qos_remove_request(&isys->pm_qos);
 
-- 
2.53.0



