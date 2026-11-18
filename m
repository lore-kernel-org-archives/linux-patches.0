Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016404;
	b=M8lvTmwbm4oV9LKkgpD41W8xQcBmfH1dSs9ZPelW88v806fJzJFeJqIVIcfwx4e0lSsi
	 jBIbDga0BGCZHAcKEx/SpzZYcs1oeScuk3dPk6a6n+SZFVg5Aqe5j8E7olLiepWMvWpr1
	 DGBCWZsvphMqNSXw9rdxi+y00i8GnkMYAFjyvi2SZYGf3//TZi9QqpcBM9o44OcBsYmsP
	 LYFeqo4IJ3NihM3lJ6HN6Zf/xRIj/TzB8BJjKpfXQaz2rBUSBn9CjvmOsskx3AGMOqIL1
	 KQnwvd/DExEL5m7SYynF4kgG7gndk1daq+7lQ8ZQbkTN8Fh7tQFnLAROlMaO080PKNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B1tDSExPhZ6r/brT9eTPlaai/uqX4vVQXH0MWtfMXw4=;
	b=kh3xNFoqBY6dJ9znl+n/8UTKyzfFSNzbdfU1XCgTmZLSGmEXbjbR/OpcSzcWsgTgQwsy
	 /MWbvJBm3XfaC+RSn6p7+JGEprZwcYDxkWZHit1/fc96G2xVNX07++5lr364fmSz+oPed
	 gZCp0socU6lR6kgxEcWvlE2G8ITVC++7vkP5SqcCWQdU4Vnw7NnV9hgwW8c9z/ZN4r4r8
	 Iuhyjb8t/nNgTlHAjYko0SQLEa0fUHEs/afgeQEp/zJuhdtAv4jvBzFYJ+gucj2qjShkr
	 YZOWID6aSgZDpbVYGrlciPm/ApPbZ4bcLmQ/U5fqhyv5HlzlgNenHCW5vyvoDmH45/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1tThMUQv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE5A60A263E;
	Wed, 18 Nov 2026 15:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1tThMUQv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8921F000C5;
	Wed, 18 Nov 2026 15:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016404;
	bh=B1tDSExPhZ6r/brT9eTPlaai/uqX4vVQXH0MWtfMXw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1tThMUQvkzkh2lBCuCtajp5kI6tP0mg1UH99sywdbLkN7hwD09jXakDOI/xinaSWE
	 yqohUHxAzx0gR0eZoYr1LNJjKcYmCTBsOmJ38e223Ftr6LIyJu1SiJpnTP2lLLf6G6
	 O98ZG3ZqO0WLpjwfrQo1SeSpmgksSy1yORfV4HOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0476/2651] media: i2c: ar0521: remove duplicate media entity cleanup
Date: Wed, 18 Nov 2026 15:28:36 +0100
Message-ID: <20261118150304.923878847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 069a0343581bfcaee44bc598e2b95be2e2789807 ]

The error path taken when ar0521_power_on() fails calls
media_entity_cleanup() at the disable label and then falls through to
the entity_cleanup label, where media_entity_cleanup() is called again.

There is no need to clean up the media entity twice. Remove the first
call and let all error paths converge on the common entity_cleanup
label.

This issue was found by manual code inspection.

Fixes: 852b50aeed15 ("media: On Semi AR0521 sensor driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ar0521.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/ar0521.c b/drivers/media/i2c/ar0521.c
index ed324c2d87aa2..be68789eb8f5a 100644
--- a/drivers/media/i2c/ar0521.c
+++ b/drivers/media/i2c/ar0521.c
@@ -1142,7 +1142,6 @@ static int ar0521_probe(struct i2c_client *client)
 
 disable:
 	v4l2_async_unregister_subdev(&sensor->sd);
-	media_entity_cleanup(&sensor->sd.entity);
 free_ctrls:
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 entity_cleanup:
-- 
2.53.0



