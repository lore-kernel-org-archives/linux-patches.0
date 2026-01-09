Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1EA33D511;
	Fri,  9 Jan 2026 11:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959667; cv=none; b=Psej10MutyDsnmOm/eoT+yMKjb0mM9UXuYZaDLryD/7cYp04vt1kMFvP26YKDv8YXi3XXT0vsuWcyEe1Wk0S0fVN/AnBLXctgsNx3fcrOskWoFK06DBqOO5v48DqDHzTFSLC5gd9Z24DHlij1lGqxcPN6rp/OuJvzM4BXvR3dXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959667; c=relaxed/simple;
	bh=vxn95n7WKLxAcgBDpVd/SonW+4geCnYrtE3ht8aqsPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TX2q/77ygTmXSiZzbCiMzLH5YpI6sUc33dl8W64GykUHrZj8VVqG0L214noW1h8CUfr7mW5b9o9nZlF5NthVMhbW+ZqIxtpKwIzZHpbzveSHNVt0qxCzgB4BaJMdJ321wOldwp0APsQuaz+RDKyqMEBS5Kbmf7AubqNZTXuH8Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sE2Vb6O0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sE2Vb6O0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB49CC19424;
	Fri,  9 Jan 2026 11:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959667;
	bh=vxn95n7WKLxAcgBDpVd/SonW+4geCnYrtE3ht8aqsPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sE2Vb6O0WNZZ2p75Ps5OZnK+iUWxtUpBJgiCArm32DXwLtF9f2MhclyUpO8i23PKN
	 u98qaN/7IYHPKhdzTKVHHujC1rnCj+iQjdt8+IFLZCu72tsWUfpLfpiuucCLf11vRR
	 5VbKFrEaxCaEu7urBtsRdOz5Rzt7hx2G3TTDgYiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/737] staging: most: i2c: Drop explicit initialization of struct i2c_device_id::driver_data to 0
Date: Fri,  9 Jan 2026 12:34:31 +0100
Message-ID: <20260109112138.966600062@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit b5b7a2c92332b6f799e81f256aed6a93a0e037fd ]

These drivers don't use the driver_data member of struct i2c_device_id,
so don't explicitly initialize this member.

This prepares putting driver_data in an anonymous union which requires
either no initialization or named designators. But it's also a nice
cleanup on its own.

While touching the initializer, also remove the comma after the sentinel
entry.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/20240920153430.503212-15-u.kleine-koenig@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 495df2da6944 ("staging: most: remove broken i2c driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/most/i2c/i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/most/i2c/i2c.c b/drivers/staging/most/i2c/i2c.c
index ce869280a056b..184b2dd11fc34 100644
--- a/drivers/staging/most/i2c/i2c.c
+++ b/drivers/staging/most/i2c/i2c.c
@@ -352,8 +352,8 @@ static void i2c_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id i2c_id[] = {
-	{ "most_i2c", 0 },
-	{ }, /* Terminating entry */
+	{ "most_i2c" },
+	{ } /* Terminating entry */
 };
 
 MODULE_DEVICE_TABLE(i2c, i2c_id);
-- 
2.51.0



