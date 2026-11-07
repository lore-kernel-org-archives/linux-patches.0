Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064589;
	b=dDYkl3IVSPwU6XlxRG9sNfLK994Vze7aLfxiAlZDDDvyIrVP9m/JEvfKRhrgfx3IQb+O
	 mPrZ/z5YmqydEMh/MKD1/PLqkdoZZiwJ9gnFpgprYOjHt8X6W73Z+KX4GdXYQuV08TBiC
	 6nvZfUW2aEoyzRRm3kBgy8auyIeDdinGT3zi9g4iOUZ0nsUMP+tsEfUWEP0dUGSWBS2at
	 pwLe058OVpZ29rJXIUEd9UwgpVg60no1NHo24kmj0iuCbJMnyPtMqt45aCP/GYC3HpEfh
	 +C7ClcuSt1V5ebd642dKl1I687uIhUEDeMk2J4L/UOCEbq1NpRdnhQAcxMM6ZkqIfsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wkz5nWVk2Vp1e3sOveQCTjT9ji5M+NH0emVjMiYY2W8=;
	b=wsk8Q6sH0J0GVpCsOWINalqgC5NgJ2I2OxgKNhlaNF4iSwSzgG8vvzN6HSYjetVDZh2o
	 1VCpE0fLmnKd2Je9ikL1JnXvF4oIbRoTgu3gt+6KJn2C/dYJxuyibSCvffQr19oXu/psx
	 pDBxCyCQ+1ilGsxAsQIA7NZYvovFjK3373mZfUUE4zb+xwvWjlmetYps/cqZkRxeT1i+Z
	 /ufvxbuFB5VKP+3r0oK/PHPxsH3tf7aEcxgP8D77mCpQOpgAwsX+IEkv/+Ava9IYhmGNy
	 vT8FuxnedUtJ8fTWvWrBAVMrkxixQ4kqLO85dA3CVOKVA+XIVeHuX7hHfWIJwsnk88Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3EwsXh5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535DC606A332;
	Sat,  7 Nov 2026 15:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3EwsXh5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26A51F0089F;
	Sat,  7 Nov 2026 15:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064589;
	bh=wkz5nWVk2Vp1e3sOveQCTjT9ji5M+NH0emVjMiYY2W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s3EwsXh58YOf+8JLv2us1QRYJKivn8jzb4ij0n7Fph7osMjxRmJ8eerflcG5phzhP
	 doq6p76R6BxIMQbu0a4qGeSP7TblP/Q9F/YjdBlV7PdtnLAYzbJSUawU3U7YlCyTLy
	 S7fIHfi5vu8ESi0zmy1+uHxrqwgqwBkTuvz4b1Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0605/1257] misc: fastrpc: fix double-free in fastrpc_map_attach() error path
Date: Sat,  7 Nov 2026 08:48:21 -0500
Message-ID: <20261107134956.023691657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Yifei Gao <gyf161023@gmail.com>

[ Upstream commit 09fa66ec1b4896ab841da085ca58b6433f28f07f ]

map->table is assigned right after dma_buf_map_attachment_unlocked()
succeeds. The two failure checks that follow, the len > map->size test
and, where subsystem VMIDs are configured, a failed qcom_scm_assign_mem(),
jump to map_err with map->table already set.

map_err manually calls dma_buf_detach() and dma_buf_put() and then falls
through to fastrpc_map_put(). Since that change the error path tail is
fastrpc_map_put() -> fastrpc_free_map(), and fastrpc_free_map() already
unmaps, detaches and puts the dma-buf whenever map->table is set.
The two operations therefore run twice: the second dma_buf_put() drops an
extra reference on map->buf, and dma_buf_unmap_attachment_unlocked()
dereferences the map->attach already freed by the manual dma_buf_detach().
kref_init() sets the refcount to 1 with no intervening get, so the final
fastrpc_map_put() frees the map synchronously and the redundant cleanup is
deterministic.

The len > map->size branch is reachable by an unprivileged process via
FASTRPC_IOCTL_MEM_MAP with an fd whose dma-buf is smaller than the
requested length, before any DSP invocation.

Route both map->table-is-set failure branches to get_err instead of
map_err, so fastrpc_free_map() is the single owner of the
unmap/detach/put sequence. map_err is retained for the
dma_buf_map_attachment_unlocked() failure, which is reached with
map->table still NULL and an attachment that fastrpc_free_map() will not
clean up, so its dma_buf_detach()/dma_buf_put() must still run manually.

Fixes: 334f1a1cbe03 ("misc: fastrpc: Use fastrpc_map_put in fastrpc_map_create on fail")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Reviewed-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101220.1084101-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index d4fac2caca867..b35751212095d 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -927,7 +927,7 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
 		dev_dbg(sess->dev, "Bad size passed len 0x%llx map size 0x%llx\n",
 				len, map->size);
 		err = -EINVAL;
-		goto map_err;
+		goto get_err;
 	}
 	map->va = sg_virt(map->table->sgl);
 	map->len = len;
@@ -950,7 +950,7 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
 			dev_err(sess->dev,
 				"Failed to assign memory with dma_addr %pad size 0x%llx err %d\n",
 				&map->dma_addr, map->len, err);
-			goto map_err;
+			goto get_err;
 		}
 	}
 	spin_lock(&fl->lock);
-- 
2.53.0



