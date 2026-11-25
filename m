Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623403;
	b=cTndTHT4im+d5HNLosheceuXp2VLHaMDk4KzSROPN2z6ci9OZk7nI5i308abXntQANjJ
	 VcQgwdpGj3RL8P20LzwTMrVl8L0O99X7iq2VYqe5gNOMjfr3NjsQGdjNM244yN0KQH+kH
	 V6HYLFWUT0XokcW6GeAdHT3NFPuaybBMtXezhunq+UG1Kx/GTkgIyaRdeh8K70sVNX/82
	 ZFesb81MwVFc9VJjBp82mLQnNxaPmy+SCDBkpSWqWvZbPX/Go5eVogiaht0lX0EoGhiMi
	 rqC6bFEcha+Dg0retdr+vKAZ1Bx2FKGw781hXzT+KM2OeVccQndPvNSZ2mbvC+s7yrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dGBFT+GOPsIBvJr98l1iUGiJRP2iSEP0mQXAu4l8a7s=;
	b=4NniKVKhJtEz4gj9L7ElzBt2nlYW9zGLz+nSy6LrzPbGFbdAGmm0EXjE1ai1BOrlD6nA
	 3Xo8a/4GNWkvipuDa0SjPnhCSJVX8KfCm41VA0AoO540y9T9aI050dW59OYW1e/DaoUeS
	 Bm7h1ivwM1I0D3lWFscd1N/B/2XMtjV4mpsG0KKWpwttQyJ/Lxgka5Z19mkWqgt4zQk17
	 HmKz3mB8Cx4kCSY9TraimkGXRyXSVURfU3oChKIbMMEt215YohLBQGZKtoBE+mEhxAfgQ
	 bLtAs0aANBgzepBD6x5mLRHUYuz4X5B47U09GG63lh9GUxt/tj+QX5HA0BNLOtzRzpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GE1riFjG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80920606A31E;
	Wed, 25 Nov 2026 16:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GE1riFjG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FB51F000C0;
	Wed, 25 Nov 2026 16:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623403;
	bh=dGBFT+GOPsIBvJr98l1iUGiJRP2iSEP0mQXAu4l8a7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GE1riFjGO9eHKReRN77AkAYMmnMI4BD/K/6ZUg94y2ArzqCp1CgDeMs8EDtd3VX07
	 Kki9o5N2wv/SY3+VJQBhMA+seNhZ4qKK66PA+6KKyy3OjuXk5SQmkcnC+P83TsDMWh
	 fs983U0lph/JRJ4GM6sCYWN12oSZQYudDMExx5c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 849/990] dm log userspace: drop the device reference on error
Date: Wed, 25 Nov 2026 15:36:56 +0100
Message-ID: <20261125143841.916610788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>

commit 0550d3b14e008b033b02cfce668008ec6addffe4 upstream.

userspace_ctr() takes a reference on the log device with
dm_get_device().  When the integrated-flush workqueue allocation fails it
jumps to the shared error path, which frees the log context without
dropping that reference, so the device stays busy and cannot be removed.

userspace_dtr() drops the reference correctly; do the same here.

Fixes: 5066a4df1f42 ("dm log userspace: allow mark requests to piggyback on flush requests")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-log-userspace-base.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -294,9 +294,11 @@ static int userspace_ctr(struct dm_dirty
 		}
 		r = dm_get_device(ti, devices_rdata,
 				  dm_table_get_mode(ti->table), &lc->log_dev);
-		if (r)
+		if (r) {
 			DMERR("Failed to register %s with device-mapper",
 			      devices_rdata);
+			goto out;
+		}
 	}
 
 	if (lc->integrated_flush) {
@@ -315,6 +317,8 @@ static int userspace_ctr(struct dm_dirty
 out:
 	kfree(devices_rdata);
 	if (r) {
+		if (lc->log_dev)
+			dm_put_device(lc->ti, lc->log_dev);
 		mempool_exit(&lc->flush_entry_pool);
 		kfree(lc);
 		kfree(ctr_str);


