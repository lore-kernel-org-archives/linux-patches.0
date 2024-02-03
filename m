Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7668B101D0;
	Sat,  3 Feb 2024 04:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933921; cv=none; b=C2IpEOt1ubVMRP+heg4YlfRW4OqZ3PrADx5yVq1urffl0rdU8P/tcFApNZoRe5TkgsAsMrZLd3Lpxtl29w1LKCo6asEjt9/xfOR35QxsmaYk2uxQPnyzi2oLW/OJbDmwj2WcxcXPzMerwp8GevLJyzeS4jVFrYya8WL0Afue8bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933921; c=relaxed/simple;
	bh=vhof28BEAxqonqw4uuZpaDddLHHv7ypVqeHQ2WIpzfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lTFVUPpqFMIFQ25zKUz2MS3cMwKrbDgquwcZ6AADv2R2Z714sZrNhtPTMHX6puKPqGv0+6ieq5pSSGWGgTbAEfUdqGoqLd6r2fxlyeJm00VdghXWtRuQEnJJ0um+xjdwZJGZvsSNdBZwjGEs9upce0MZKJk3NdjxBu7APIx9Ss8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+VEa1HB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+VEa1HB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1D8C433F1;
	Sat,  3 Feb 2024 04:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933921;
	bh=vhof28BEAxqonqw4uuZpaDddLHHv7ypVqeHQ2WIpzfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+VEa1HB+qW4IC2pg5wlPQmL+OLDpGqwvsSF+SfMtpksAyJlljsTu7fWMJJcnYd4a
	 wkNTZAAa+BPr4Y1jv6DOGomOdLnItJzQFNpbiVFS3rT0T57+Wj6a/oZ04TaWTYTE6b
	 GC9AKv7uN58P0ECJw9TWSuTbQyYZrCcLlR+mV5wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: =?UTF-8?q?=5BPATCH=206=2E7=20276/353=5D=20=3D=3FUTF-8=3Fq=3Fvirtio=3D5Fnet=3A=3D20Fix=3D20=22=3DE2=3D80=3D98=25d=3DE2=3D80=3D99=3D20directive=3F=3D=20=3D=3FUTF-8=3Fq=3F=3D20writing=3D20between=3D201=3D20and=3D2011=3D20bytes=3D20into=3D20a=3D20region=3F=3D=20=3D=3FUTF-8=3Fq=3F=3D20of=3D20size=3D2010=22=3D20warnings=3F=3D?=
Date: Fri,  2 Feb 2024 20:06:34 -0800
Message-ID: <20240203035412.506479844@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit e3fe8d28c67bf6c291e920c6d04fa22afa14e6e4 ]

Fix the warnings when building virtio_net driver.

"
drivers/net/virtio_net.c: In function ‘init_vqs’:
drivers/net/virtio_net.c:4551:48: warning: ‘%d’ directive writing between 1 and 11 bytes into a region of size 10 [-Wformat-overflow=]
 4551 |                 sprintf(vi->rq[i].name, "input.%d", i);
      |                                                ^~
In function ‘virtnet_find_vqs’,
    inlined from ‘init_vqs’ at drivers/net/virtio_net.c:4645:8:
drivers/net/virtio_net.c:4551:41: note: directive argument in the range [-2147483643, 65534]
 4551 |                 sprintf(vi->rq[i].name, "input.%d", i);
      |                                         ^~~~~~~~~~
drivers/net/virtio_net.c:4551:17: note: ‘sprintf’ output between 8 and 18 bytes into a destination of size 16
 4551 |                 sprintf(vi->rq[i].name, "input.%d", i);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/virtio_net.c: In function ‘init_vqs’:
drivers/net/virtio_net.c:4552:49: warning: ‘%d’ directive writing between 1 and 11 bytes into a region of size 9 [-Wformat-overflow=]
 4552 |                 sprintf(vi->sq[i].name, "output.%d", i);
      |                                                 ^~
In function ‘virtnet_find_vqs’,
    inlined from ‘init_vqs’ at drivers/net/virtio_net.c:4645:8:
drivers/net/virtio_net.c:4552:41: note: directive argument in the range [-2147483643, 65534]
 4552 |                 sprintf(vi->sq[i].name, "output.%d", i);
      |                                         ^~~~~~~~~~~
drivers/net/virtio_net.c:4552:17: note: ‘sprintf’ output between 9 and 19 bytes into a destination of size 16
 4552 |                 sprintf(vi->sq[i].name, "output.%d", i);

"

Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://lore.kernel.org/r/20240104020902.2753599-1-yanjun.zhu@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 51b1868d2f22..1caf21fd5032 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -4096,10 +4096,11 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 {
 	vq_callback_t **callbacks;
 	struct virtqueue **vqs;
-	int ret = -ENOMEM;
-	int i, total_vqs;
 	const char **names;
+	int ret = -ENOMEM;
+	int total_vqs;
 	bool *ctx;
+	u16 i;
 
 	/* We expect 1 RX virtqueue followed by 1 TX virtqueue, followed by
 	 * possible N-1 RX/TX queue pairs used in multiqueue mode, followed by
@@ -4136,8 +4137,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		callbacks[rxq2vq(i)] = skb_recv_done;
 		callbacks[txq2vq(i)] = skb_xmit_done;
-		sprintf(vi->rq[i].name, "input.%d", i);
-		sprintf(vi->sq[i].name, "output.%d", i);
+		sprintf(vi->rq[i].name, "input.%u", i);
+		sprintf(vi->sq[i].name, "output.%u", i);
 		names[rxq2vq(i)] = vi->rq[i].name;
 		names[txq2vq(i)] = vi->sq[i].name;
 		if (ctx)
-- 
2.43.0



