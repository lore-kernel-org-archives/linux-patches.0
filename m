Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042863;
	b=wKxLSuzuz+uT0IbG1oPteLFoG2HxW+J6JNRVUQxg4Q5IocTcsiobVEUhVxhMJzC9kpMT
	 CfcFprpQpXQfUqU7TUR0W3823EFLrdXTPM3G8ZYolCGxhIcmSKvsOtcXb0TccbDpR+eU+
	 pStFKOd7MBGjz3qkW10lsMLsdz8U+qJXQrej6q5BJXWqnUGWX5AEYxHtzm/wOv8O9ckuy
	 sBBSYsqqm7h3HNhlahebFmQFIloNT74eydHHjEIxR4LSav/pwf3JWA8se7hdkLpT0LbNO
	 yTU+ulmjJOjxhAwu5MCgY03Lj9VY0cEWDtF7PiKemb1s1IRP/IMOM21r8XlCInlqhIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tGARcBlvBqtItxPFrHY0UfLBCJ5AtQNq41cb4DUq7m0=;
	b=3xhrdVyNEhR4h0STil70jtyWaLoM5ieB8OMY1h+2HFlCx9MdC3QS/sR7FpRpAqU5Vjif
	 YVc+YLNmnyYNah1+F/dLZP+jVSMlPfXLqaf4VPihEtyf1aHy6u40vHBT19NhkoHR8vSGz
	 D3M5rQx1DucLA8KzymjG0btfse1N0XEIx5q369dgXY0+e4oXyVnatDX+03O5o18W5vTu+
	 2Y8bHEgHTB0WlO49qc93E+bUCijmVxYx/SZ41p8RlcvgSS5zeZRB6QkBgpA1Wn1SV1m/9
	 2YHndZHGliRETLLtqE0GxrOmQ1WxcUGlgthox9HuLCh/cXsdzzxrpJ8ofg4H6mPOx7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YE9HytXE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84670606A320;
	Wed, 18 Nov 2026 23:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YE9HytXE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7211F000C5;
	Wed, 18 Nov 2026 23:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042863;
	bh=tGARcBlvBqtItxPFrHY0UfLBCJ5AtQNq41cb4DUq7m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YE9HytXEy+kkROOL4sZZK3FppRoSmIndFrXFoLIawbn6NfgnGkyiCPSnUFHSHHEw+
	 gBnddgliAGCNtp/ZAh2qUdU7ALtQb0jBSwSUS1AcKr3YELJkcOY/Pr9VEpxjYZ+Fsr
	 irhk25W6V1Pte1WL1nmHi42xikbpH5zs2r+1ACeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Omar Sandoval <osandov@fb.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3291/3318] block: remove redundant explicit memory barrier from rq_qos waiter and waker
Date: Wed, 18 Nov 2026 16:05:13 +0100
Message-ID: <20261118150458.325321245@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 904ebd2527c507752f5ddb358f887d2e0dab96a0 ]

The memory barriers in list_del_init_careful() and list_empty_careful()
in pairs already handle the proper ordering between data.got_token
and data.wq.entry. So remove the redundant explicit barriers. And also
change a "break" statement to "return" to avoid redundant calling of
finish_wait().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Link: https://lore.kernel.org/r/20241021085251.73353-1-songmuchun@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: f3a6dae67c9c ("fs_pin: do not trust the pin after a spurious wakeup in pin_kill()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-rq-qos.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index dc510f493ba57..9b0aa7dd6779f 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -218,7 +218,6 @@ static int rq_qos_wake_function(struct wait_queue_entry *curr,
 		return -1;
 
 	data->got_token = true;
-	smp_wmb();
 	wake_up_process(data->task);
 	list_del_init_careful(&curr->entry);
 	return 1;
@@ -274,10 +273,9 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 			 * which means we now have two. Put our local token
 			 * and wake anyone else potentially waiting for one.
 			 */
-			smp_rmb();
 			if (data.got_token)
 				cleanup_cb(rqw, private_data);
-			break;
+			return;
 		}
 		io_schedule();
 		has_sleeper = true;
-- 
2.53.0



