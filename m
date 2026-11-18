Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025149;
	b=gq9IMUrB3s8icgkFXlKArTW2X5lsk4V/eN9iS9GZmrNer/rMjngc85T4OHZAAYNIyK6H
	 UU5WwKGCGcXzMlLj6pU27v4TtSZe2cuwWF4P+S1QPrydE62iIzKkYyKKyRWqcCfIJtCAG
	 P5/Eez59ia6/vraTOF8j6csKs73bOxOIV/Fv2ZYu4zYNhE1Vn6uVgrqQARJtMGjmKBvBI
	 injpW3FoG6EUoJnXdfIAZneFKgWUu4gummDJO8z9xL20ftKLmpkbfIH3a6EINmrge8DY6
	 XSXglhgYVdNi+0XbpwsNg33MQkiMD0FER0OT3a8zIY/KHk9bC9uVLf/7pjoCCKy3zRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2egiUJi81iniPFV3foy++gDQGuf8TsdolsJu9lgR57I=;
	b=fX529u5heXaWCx895b/tLvw+nX1Sl28vkAavSJXG28TeA07/BNsl6lnubZgMaW0tn7fs
	 HAuD13WF1MMEihJqVJ511wRT0RaTMUFNSzLYbSB/L/1bvYIsJsuL8soe6gum7B+0c0CEa
	 zbUcyoZt2WMrFWg9hk2U0F5UqL+QrM4YJ+3O1RI4Ovqm7qkp0cNouyKxICMbJ3knCOtks
	 Etne06dEoLJjwOq3xQU+1X3z3Pgd7w5Y/nuTW5ZojusCJRGKrWoaR4rqt0RnE1XA5xgPS
	 H+7V/92QOOsOfJzCKCX0fiSL3ZFD3GrAWoq+/tnQmp81ZGHeDXmLeXBk+nVPDeHnxlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZhiaDy3Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D0A606A339;
	Wed, 18 Nov 2026 18:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZhiaDy3Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E499D1F000C6;
	Wed, 18 Nov 2026 18:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025149;
	bh=2egiUJi81iniPFV3foy++gDQGuf8TsdolsJu9lgR57I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhiaDy3ZHt38wz//eVXQOW9inRow1WCQM5WMgU0a2S/UoFTWGj6ebyvUZzt16GXjW
	 Fi0TeUUrJaA6bHnteOROphlvkJEyufoEsVRm8eYnw/zq0thG4Dbp4faor++IwZ3fF+
	 YObt3Tr75UVYYjm4kfVqPMxIVjOJ9dPWT42ua7zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodolfo Giometti <giometti@enneenne.com>,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0936/2151] pps: generators: wake up PPS_GEN_FETCHEVENT readers on unregister
Date: Wed, 18 Nov 2026 15:44:31 +0100
Message-ID: <20261118150156.582675357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 5b864f8db0bd33216895f3fe0bb1ec245c596c8e ]

A reader sleeping in PPS_GEN_FETCHEVENT waits for the next event, but
no event comes after pps_gen_unregister_source(), so the reader sleeps
until it gets a signal. A PPS_GEN_FETCHEVENT issued after the
unregister sleeps the same way.

Wake up the readers on unregister, and make PPS_GEN_FETCHEVENT fail
with -ENODEV once the generator is gone, like the other ioctls. The
wait checks info without info_lock, so clear it with WRITE_ONCE().

Fixes: 86b525bed275 ("drivers pps: add PPS generators support")
Suggested-by: Rodolfo Giometti <giometti@enneenne.com>
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://patch.msgid.link/20260929124937.51114-5-danishkhateeb03@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/generators/pps_gen.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pps/generators/pps_gen.c b/drivers/pps/generators/pps_gen.c
index eda7fd933bec7..8b6aff42c050d 100644
--- a/drivers/pps/generators/pps_gen.c
+++ b/drivers/pps/generators/pps_gen.c
@@ -103,11 +103,14 @@ static long pps_gen_cdev_ioctl(struct file *file,
 		dev_dbg(&pps_gen->dev, "PPS_GEN_FETCHEVENT\n");
 
 		ret = wait_event_interruptible(pps_gen->queue,
-				ev != pps_gen->last_ev);
+				ev != pps_gen->last_ev ||
+				!READ_ONCE(pps_gen->info));
 		if (ret == -ERESTARTSYS) {
 			dev_dbg(&pps_gen->dev, "pending signal caught\n");
 			return -EINTR;
 		}
+		if (!READ_ONCE(pps_gen->info))
+			return -ENODEV;
 
 		spin_lock_irq(&pps_gen->lock);
 		info.sequence = pps_gen->sequence;
@@ -238,9 +241,12 @@ static void pps_gen_unregister_cdev(struct pps_gen_device *pps_gen)
 			pps_gen->info->enable(pps_gen, false);
 			pps_gen->enabled = false;
 		}
-		pps_gen->info = NULL;
+		WRITE_ONCE(pps_gen->info, NULL);
 	}
 
+	/* Wake up the readers in PPS_GEN_FETCHEVENT, they fail now as well */
+	wake_up_interruptible_all(&pps_gen->queue);
+
 	put_device(&pps_gen->dev);
 }
 
-- 
2.53.0



