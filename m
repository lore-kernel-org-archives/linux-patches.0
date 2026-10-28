Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214607;
	b=U7o2RB9iq+A8QT5CWPhkiyvawPbaDMDaeIAjxQGpAKp5kJPIXVgCAaVlddcDhJqQcav0
	 wZbqzMh5BcqdYmqQBOuDWNr5b0Ry8+x01sIsytfzc7jDsZRh+7TOWot90OzcP3A5JqoIQ
	 Q1328CKogZNZ80Eq86QX2UAiFt7z4so9zsmwuxS75jICmDhL76yX3KcjZDfbmEvSeSoCE
	 XYQodosl5x/gp7PTaDT7x7ME52OczdQVAAYYb3stfmJO29K31rVOszwpUspd5nRmG777z
	 cX97gMBxTNtduR8wUDBXvuHSSdRAMA+9JEO5UG+mTHHadeXbT+PDwKa7GG2qk4ZYjew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RoqyhMduos7xmVpWpPfbRgGKrhEGUaywW1T8S5VQnIo=;
	b=zk7sYJ9VEZWVzZEoqtBRkQTpsdqgwmNo2Liw/2zWb06Sa0KnJf1E/I3CMUiyWsGiZt5I
	 Tc/8QI+Ky2sSxcTXV7Gzm/Mzi0KTXJrL/CTInADuk6Fh0gMXxblUjqgRSZnwUpv0KuyFj
	 mRXK92tlj8Hv/qrk+Wljm87OTeti3+ccUSqfADYCnXJ8IIc3MUaSAMVIX/9LJhQ/6xsuu
	 pz41MOrtGmM95lyYLvor1m0ADfJBSyi+7tjFVwZeL6ILFgLy/O8OzmjjzUV/mcmhNShFt
	 58ns0Ql2YupZeHOcXMr8Q7RoxEx/XeZzN5HH61b8xollESOn899PhdSjYlFlsKFlhIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQxoHqIg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181B2606AB0E;
	Wed, 28 Oct 2026 19:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQxoHqIg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679DA1F031E0;
	Wed, 28 Oct 2026 19:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214606;
	bh=RoqyhMduos7xmVpWpPfbRgGKrhEGUaywW1T8S5VQnIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uQxoHqIg0tz7S+pud6S8evWCmt/ZdEetmvnPf5MN9n2yZ1AsEI3bWycu7Dr+n2XP4
	 LZClwOFs84JUOap/9F5g6bLnUn903wkYQVsG8ml+mBvM74BRfUWYjRHVm2Q+Yq8Qcg
	 q247zti4vr3SjNhpSuHhNF0oR8KSiSr2uStaXAJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Duoming Zhou <duoming@zju.edu.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0901/1887] Input: alps - fix use-after-free bugs caused by dev3_register_work
Date: Wed, 28 Oct 2026 17:49:57 +0100
Message-ID: <20261028170519.921102763@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit bf40644ef8c8a288742fa45580897ed0e0289474 ]

The dev3_register_work delayed work item is initialized within
alps_reconnect() and scheduled upon receipt of the first bare
PS/2 packet from an external PS/2 device connected to the ALPS
touchpad. During device detachment, the original implementation
calls flush_workqueue() in psmouse_disconnect() to ensure
completion of dev3_register_work. However, the flush_workqueue()
in psmouse_disconnect() only blocks and waits for work items that
were already queued to the workqueue prior to its invocation. Any
work items submitted after flush_workqueue() is called are not
included in the set of tasks that the flush operation awaits.
This means that after flush_workqueue() has finished executing,
the dev3_register_work could still be scheduled. Although the
psmouse state is set to PSMOUSE_CMD_MODE in psmouse_disconnect(),
the scheduling of dev3_register_work remains unaffected.

The race condition can occur as follows:

CPU 0 (cleanup path)     | CPU 1 (delayed work)
psmouse_disconnect()     |
  psmouse_set_state()    |
  flush_workqueue()      | alps_report_bare_ps2_packet()
  alps_disconnect()      |   psmouse_queue_work()
    kfree(priv); // FREE | alps_register_bare_ps2_mouse()
                         |   priv = container_of(work...); // USE
                         |   priv->dev3 // USE

Add disable_delayed_work_sync() in alps_disconnect() to ensure
that dev3_register_work is properly canceled and prevented from
executing after the alps_data structure has been deallocated.

This bug is identified by static analysis.

Fixes: 04aae283ba6a ("Input: ALPS - do not mix trackstick and external PS/2 mouse data")
Cc: stable@kernel.org
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/b57b0a9ccca51a3f06be141bfc02b9ffe69d1845.1765939397.git.duoming@zju.edu.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/alps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index dd08ce97e7c90..b23f8cf72fe96 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2971,6 +2971,8 @@ static void alps_disconnect(struct psmouse *psmouse)
 
 	psmouse_reset(psmouse);
 	del_timer_sync(&priv->timer);
+	psmouse_set_state(psmouse, PSMOUSE_IGNORE);
+	cancel_delayed_work_sync(&priv->dev3_register_work);
 	if (priv->dev2)
 		input_unregister_device(priv->dev2);
 	if (!IS_ERR_OR_NULL(priv->dev3))
-- 
2.53.0



