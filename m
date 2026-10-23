Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774443;
	b=hUggxS1yn3LXG9+QsNVidLIyE5ObxTbvvcIDzAjoMCJwLWUkE3TIHydZ1RSvUFeYwHfj
	 Loi7O0T3JBLQEOxdi0ZyK9EqbelYLvk8Be3Gx8Xi8KVdmjv6wSCOevlIHBbGybOl8u4ms
	 0Ly475gSyvZfxcgTJGZNIVP+wJRkfPTiQP1ZddhH6ib1BdYI+uRZdKXdh57yHmwDToGni
	 3Mj8TGG5UXgldOLxFkNrPPE47prA8ac+Ze3VeE6Xt3jJ2SeBhni2t7k7tWCIU4jzDwyyl
	 8Qgrld/7eG6UnultdJBIPYz+GvE6QD7358tDu+48UDmO7/Y0IYwyUVRd4o7UI5KrYEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bc4Ubbgr+bPf6z2FjWRMJ4LHHiXj5ATor/Unufx6Vuw=;
	b=A5p0e7HpDtC7Bce8n4KNo5YGqtSIGlK5yHk8OM28e7NizmhWAAchFZLzUmru2p6elaVw
	 pvn1Z/W+844/qTPY3edtMq/tMrFTyjIha42QgLJ9Odoz39yJ/fV64CioTueuTw57TbD3q
	 18AgEb5mY0rZIRhDSDr8kBdVNpdQkFilfF/pYiYtLabmT87DgRxIe1F2FP6qn8Y5nbKUm
	 25mCRodwWGyHrf0B3QLta6pCg+G6+gwiNHeSOis9Zj0Bu4ONUH9KRxfe2aElhiskTl4Es
	 P70g87ooMgo3OgVcxpeGAasAkATVlZkw6SGcHknDaK40w0UTsIcQXxY80QZDdchz53w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wQkk01B8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B4C606A31B;
	Fri, 23 Oct 2026 16:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wQkk01B8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917F71F01825;
	Fri, 23 Oct 2026 16:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774443;
	bh=bc4Ubbgr+bPf6z2FjWRMJ4LHHiXj5ATor/Unufx6Vuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wQkk01B80PpPK6FRtMeU2x7l+HrP7UFOfrs7ckAMGVHn7sA3FPmAzX32j7+8OTdBb
	 WeTKapyP3zBfdjqNo9+8yow1UyUgW+2ehhfQ7Rm/tDo+VDJsvu6CchGLXEhwoey5S6
	 1vFpNz+nMiGQJzpQ66FIIiDL3jKN4YjN4ciWX2Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Igor Paunovic <royalnet026@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 041/242] accel/rocket: clear rdev on device init failure
Date: Fri, 23 Oct 2026 18:38:03 +0200
Message-ID: <20261023163714.750307062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 4ac852419f0d317c7bd8db5b8acb3cc78be7fe33 ]

rocket_probe() stores the return value from rocket_device_init() in the
file-scoped rdev pointer before checking whether it is an error pointer.
If rocket_device_init() fails, rdev is left as an ERR_PTR.

The rdev pointer is also used as the marker for whether the shared rocket
device has already been initialized. A later core probe can therefore see
a non-NULL rdev, skip rocket_device_init(), and dereference the error
pointer when reading rdev->num_cores.

Save the error code and clear rdev before returning from the
rocket_device_init() failure path.

Fixes: ed98261b4168 ("accel/rocket: Add a new driver for Rockchip's NPU")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Igor Paunovic <royalnet026@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260708062845.716487-1-lgs201920130244@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/rocket/rocket_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/rocket/rocket_drv.c b/drivers/accel/rocket/rocket_drv.c
index 8bbbce594883e..67e7f543fe4c7 100644
--- a/drivers/accel/rocket/rocket_drv.c
+++ b/drivers/accel/rocket/rocket_drv.c
@@ -165,8 +165,11 @@ static int rocket_probe(struct platform_device *pdev)
 		/* First core probing, initialize DRM device. */
 		rdev = rocket_device_init(drm_dev, &rocket_drm_driver);
 		if (IS_ERR(rdev)) {
+			int err = PTR_ERR(rdev);
+
 			dev_err(&pdev->dev, "failed to initialize rocket device\n");
-			return PTR_ERR(rdev);
+			rdev = NULL;
+			return err;
 		}
 	}
 
-- 
2.53.0



