Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214669;
	b=NrssSleVUp2kp0RK7mSxp+JKes6/Tl6VfmzeMMvYDkWNnRT7ihpdfx/IuicAml5rzP4b
	 r9UU2WfTuKTQA8jj377XH5i3K+ldxzRHhERdbOQIzjgMGUPC8kpFcctEICSKRvJN7hx3q
	 zj69uKp4WxWp6GJDQ3Ue2f7z5g61c7wQUzCi/Zj/A8tyI9yOmgf709mWmmzuwXcFKK0OS
	 21FNy2AFnTe7nhy1rLePjfVX6WrJg8Opq0LcIKOtOukLesBVODvoZtgRg+MjrqQv5H8qZ
	 05rE/ae4mo+ZnIbsv3UZpSXIq+ki5TUPyIZtVFu3gHGUEHka94pwcweuZAPlUNAZwfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MYdI/2wqbqA6qhMn6vOTrh5lfwIzEkq4WLLvehJQzr8=;
	b=PxmTCNz0/9ZyOemkmXuk8yheZ0XIr/t9rmeVkZ+Ku6iCCEsdPo8kB0+7AwxWEUnnOrS8
	 lTx0mGBZ3Eq8LxMxJid855g4Ei6OsxdkjpFidCPHp7LUUfhVr14X8faI3+9u5pjy+j+Xy
	 LC+h34Ohua6p4RsQ9p2TqqUGVxPWk5Y2tBXDQtf4prpSQv++fxhV+OyOxlpBjfEkqJ+AE
	 uTpr3awOpixcJ9uccwWN1riiGwM8A7MLst8O4HfIqh33wYLRNTu06q4Apo+RRfFcVIokr
	 7Jk8TjVMP5WIAKHMrf21f2wbrDzeqCvcChQ8W9zSytIcaVP/VoSnryJ3w1jRDvQaH4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13LMNsKp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3199A606AB18;
	Wed, 28 Oct 2026 19:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13LMNsKp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F661F01829;
	Wed, 28 Oct 2026 19:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214669;
	bh=MYdI/2wqbqA6qhMn6vOTrh5lfwIzEkq4WLLvehJQzr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13LMNsKpF1LU4wPbA6q6pXS7X1RXp4N5YJT0PlcBQmRLQgaNGev6ZravJ345/DaQA
	 kWK6oTbgCj4pu9PlYBu9ZfSvsOPB9lbcqoBPzGT+McBHkBbWkuautBmWkZd2Di3VBI
	 LSZGVuLWtWrtJGQH7ZgeTNuWqbjByRe3/PNvLk40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minseong Kim <ii4gsp@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0903/1887] Input: lkkbd - disable pending work before freeing device
Date: Wed, 28 Oct 2026 17:49:59 +0100
Message-ID: <20261028170519.965968783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minseong Kim <ii4gsp@gmail.com>

[ Upstream commit e58c88f0cb2d8ed89de78f6f17409d29cfab6c5c ]

lkkbd_interrupt() schedules lk->tq via schedule_work(), and the work
handler lkkbd_reinit() dereferences the lkkbd structure and its
serio/input_dev fields.

lkkbd_disconnect() and error paths in lkkbd_connect() free the lkkbd
structure without preventing the reinit work from being queued again
until serio_close() returns. This can allow the work handler to run
after the structure has been freed, leading to a potential use-after-free.

Use disable_work_sync() instead of cancel_work_sync() to ensure the
reinit work cannot be re-queued, and call it both in lkkbd_disconnect()
and in lkkbd_connect() error paths after serio_open().

Signed-off-by: Minseong Kim <ii4gsp@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251212052314.16139-1-ii4gsp@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/lkkbd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/keyboard/lkkbd.c b/drivers/input/keyboard/lkkbd.c
index 047b654b3752c..7b57577a1715c 100644
--- a/drivers/input/keyboard/lkkbd.c
+++ b/drivers/input/keyboard/lkkbd.c
@@ -671,6 +671,7 @@ static int lkkbd_connect(struct serio *serio, struct serio_driver *drv)
 	return 0;
 
  fail3:	serio_close(serio);
+	cancel_work_sync(&lk->tq);
  fail2:	serio_set_drvdata(serio, NULL);
  fail1:	input_free_device(input_dev);
 	kfree(lk);
@@ -687,6 +688,7 @@ static void lkkbd_disconnect(struct serio *serio)
 	input_get_device(lk->dev);
 	input_unregister_device(lk->dev);
 	serio_close(serio);
+	cancel_work_sync(&lk->tq);
 	serio_set_drvdata(serio, NULL);
 	input_put_device(lk->dev);
 	kfree(lk);
-- 
2.53.0



