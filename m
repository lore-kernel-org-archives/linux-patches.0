Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4888729AB;
	Wed, 21 Feb 2024 13:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521485; cv=none; b=C2oZzDSvNl5BbLnqi6pLeE14IiwjE7pU82iMuM3vIBoiGIXG0km4wUNjWelBmCPwY5+VT6WA/jz1pf900dhnIIEY1EizNa4ERWqJSEOCdmUWN68i0lmURYjs3/Tw19d1al4EBvT10ZA7O0+1D/2YKsfZnPLlR4zZLJSG/W+7c/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521485; c=relaxed/simple;
	bh=yfc9AfOOijCZr/sjyIAmZE6YqBxKQjHG2/gomUI6lfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oig6IrNlg4uQpCX6J+GTsPSxmJz6lRtmNJMVH3WjeHPtyopbNlwP2BIgTyPar1OxE37carO4yQxQEH2M0hDzAZaixu5VePejRqkPLzXXumCIpTdfK+zGPLD8HX4siwhzDmEAQ5PC9oLPWC2wKN2ky5M1hdFCBesKZxy+Z0UCWeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGNr4RoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGNr4RoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9612FC433F1;
	Wed, 21 Feb 2024 13:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521485;
	bh=yfc9AfOOijCZr/sjyIAmZE6YqBxKQjHG2/gomUI6lfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGNr4RoVCcR04lX8om4hXmVy97ejnbU7SabG8q4lGKSFhYZ7i8NvgZT8C5SJHMYJq
	 S9y4kQOR8wICNZZ6GVTkgWHR2ZQ/oZOaLjwsE46HFEWTgBAmvPBpFyBOO/57xW+jPo
	 BrB6fdw9pk2v63mhQFlWkSJro0R7LHbv7KCTMUQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: =?UTF-8?q?=5BPATCH=204=2E19=20125/202=5D=20=3D=3FUTF-8=3Fq=3Fvirtio=3D5Fnet=3A=3D20Fix=3D20=22=3DE2=3D80=3D98=25d=3DE2=3D80=3D99=3D20directive=3F=3D=20=3D=3FUTF-8=3Fq=3F=3D20writing=3D20between=3D201=3D20and=3D2011=3D20bytes=3D20into=3D20a=3D20region=3F=3D=20=3D=3FUTF-8=3Fq=3F=3D20of=3D20size=3D2010=22=3D20warnings=3F=3D?=
Date: Wed, 21 Feb 2024 14:07:06 +0100
Message-ID: <20240221125935.747986090@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 331d74f9281b..2b012d7165cd 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2727,10 +2727,11 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
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
@@ -2767,8 +2768,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
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



