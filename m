Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059766;
	b=2C8ZYeeUpV7+nwcKQkaK8+e92CdsxnHcwUKLPt6lLVPP1VdpdgDkKQRzM3Avfz7Hjlko
	 AopSJ8uxO1sIY7vDnOYEEKziYci90GIrXjJkAYA65RB7yPiulEAC7R4CPxuZnYUt3+n/d
	 MjZ38S6cXB48mSx66JO8I4/2ZXkOobVthGxf/3IgWKVviGacG6Pks3i52cjLJDuImKu7u
	 Invf+Like9Y72aU8F6+T4OYsvQn/VMKV1j+DKnNtxrbNYH0yjx67qg4mkfFGXVOEEivfZ
	 XQpIZ1cKywJOfE6UcsKVTuDkfbHXmUdFKJzd6k7H28JFxA22LON/gfoQeZll7F2EoUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nt27vvbiyIuIHdyICIZINUcKM7dbSEWHIaey+A4VvhA=;
	b=c9S6zWyaOCFrQIyY38SLxf2LNS9sk2Wx7bIJS1cKGAp5Jz8izPdEJ2IcDCJSG4XDIjel
	 vyg/41ZlrQCP3Q+JZ6e/4iM2F3LJVZKSeOLIa4MLK9d9u6QwEbg55/AyDFfqhdduIC4xK
	 xaHPKGKkXOeTU3s3rIZjgTXDz8UHvYFpbpUb7CsvvoL/bDyaCZpOUYL9JhqJ1ZeTbY7wq
	 CsrcUw4GV3fU0NhGwTlzUFbnpRUdY13PQmPdCgrskyoZ9nlgNrncdIzPMd1r2cyYLhWe5
	 VdmIWZK15IVnHaXEr6s2QpF6PXBwEotOKr6k6MPJBcOEmfJE93b+BX6EZpZZ2LqjuJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uIi4YxzL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B716606A326;
	Thu, 19 Nov 2026 03:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uIi4YxzL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9102E1F000C4;
	Thu, 19 Nov 2026 03:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059766;
	bh=Nt27vvbiyIuIHdyICIZINUcKM7dbSEWHIaey+A4VvhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uIi4YxzL5lN1iKBapwbb5xQin7OhobBwEVl1oCSvCz+dvEJtKsrsHG/YFp8rtnP3/
	 XKOniX6f+cNl1P+CLN8lQFoINx2M2vGYUvwPImolkZj8gV0MO4AAqosAC8VVRwDRi0
	 TMpYMP628C4dKIb1VwXixrTi3tMQGXVc/xe0tDQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexey Charkov <alchark@flipper.net>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0932/1848] nvmem: rockchip-otp: Serialize reads
Date: Wed, 18 Nov 2026 15:49:30 +0100
Message-ID: <20261118145955.772058044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Alexey Charkov <alchark@flipper.net>

[ Upstream commit 9fc6a1592d844c0397f115ee8cbd935169b9a71e ]

The OTP controller is driven through a single set of registers holding a
state machine which has to be stepped through for every word read, yet
nothing keeps two readers out of each other's way. Concurrent reads
interleave, and the outcome is either a reader bailing out:

  rockchip-otp 2a580000.otp: timeout during read setup

or, worse, one of them silently taking delivery of the other's data.

Reading two cells in parallel from userspace on RK3576 reproduces both
within 150 iterations - 53 read errors and 9 corrupted results, the latter
either losing their first word or, in one case, ending in the two bytes
which belong to the other reader's cell - whereas the same reads issued
sequentially never fail. Concurrency is not hypothetical here, as six
thermal sensors source their trim values from the OTP and reach the driver
straight from asynchronous driver probing.

Guard the read path with a mutex. Reads are the only way into the hardware,
as the driver registers no write callback, and they always run in process
context, so a plain mutex spanning the whole clock-enable, read,
clock-disable sequence is enough.

Fixes: 755864feb729 ("nvmem: add Rockchip OTP driver")
Cc: stable@vger.kernel.org
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101329.1084348-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: replaced unavailable devm_mutex_init() and its error check with mutex_init() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/rockchip-otp.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/nvmem/rockchip-otp.c b/drivers/nvmem/rockchip-otp.c
index 9f53bcce2f877..f1eea1f5b1f50 100644
--- a/drivers/nvmem/rockchip-otp.c
+++ b/drivers/nvmem/rockchip-otp.c
@@ -12,6 +12,7 @@
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/nvmem-provider.h>
 #include <linux/reset.h>
 #include <linux/slab.h>
@@ -60,6 +61,8 @@ struct rockchip_otp {
 	struct clk_bulk_data	*clks;
 	int num_clks;
 	struct reset_control *rst;
+	/* Serializes access to the OTP controller state machine */
+	struct mutex mutex;
 };
 
 /* list of required clocks */
@@ -139,10 +142,12 @@ static int rockchip_otp_read(void *context, unsigned int offset,
 	u8 *buf = val;
 	int ret = 0;
 
+	mutex_lock(&otp->mutex);
+
 	ret = clk_bulk_prepare_enable(otp->num_clks, otp->clks);
 	if (ret < 0) {
 		dev_err(otp->dev, "failed to prepare/enable clks\n");
-		return ret;
+		goto unlock;
 	}
 
 	ret = rockchip_otp_reset(otp);
@@ -177,6 +182,9 @@ static int rockchip_otp_read(void *context, unsigned int offset,
 disable_clks:
 	clk_bulk_disable_unprepare(otp->num_clks, otp->clks);
 
+unlock:
+	mutex_unlock(&otp->mutex);
+
 	return ret;
 }
 
@@ -226,6 +234,9 @@ static int rockchip_otp_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	otp->dev = dev;
+
+	mutex_init(&otp->mutex);
+
 	otp->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(otp->base))
 		return PTR_ERR(otp->base);
-- 
2.53.0



