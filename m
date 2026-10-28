Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216577;
	b=n9VLfHSyJJ0lOMUe3YYOryPve11YUWyOk3GMNHe1AMdjpwBGTKgp4K6fClDu6gx4stvm
	 8pCThcw+hmSEn99dNvM5ssuRDA2hw1KcwfwFl7J/hCASr2A8n8li8ZDsCRB7LMWRWyWml
	 MyubuiVhRygtkjNVEgVHUzgnodAAWPGB2ikfG01LLLVNXfxxjT0fU/mOYzKTT7fvkjWXL
	 c/3Hhy9/ZzOWfJcyAAj0yomYj/dsLurBCO7h7ObJXt9TDEHmxNwX6Dq1EjruKPU5wJHnL
	 peRUNwPMUOWvkVfddb5k86G87A7GRQYMoX8EXGNJDWmfEWEUpdY5NEZEdheRt5XeL2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=92gI5MYxQ2WF112SQN3YUce3SAsxiCaSBnrbISw7EWg=;
	b=jAjla5pjVC8tM16bo5sfUZGACiwQGWxX3OWylAgffkpwAGFJTfj1svGoYy/uY8nJgXpg
	 KFjEWgZ0XqD7jS8IGybQleDw/XBZOvEARnmy/Ito9r3otWc+HV39nFkyEh/Fs7WBjwaVP
	 K4E5qoFZs/vo8Emo/kAypyfRg/F5XAJq/a6NZVFAfrrpJwfuGVUaWab5XB9qoRfe5SSZb
	 WyyEPmCkRzZO686Ia+IOpLkDhUXuRctjzEBJSKKehrWzdyW++G1pF1TIcpQlCncOvhNs0
	 NrkOxvl9qqMJAxZRQQ/qSOBdUF4ojRJcoSWRV+d/joeuc9R3AntUnbVJzZylEo4IQMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UJO/pBFV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9729C606A31C;
	Wed, 28 Oct 2026 19:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UJO/pBFV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B011F01825;
	Wed, 28 Oct 2026 19:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216577;
	bh=92gI5MYxQ2WF112SQN3YUce3SAsxiCaSBnrbISw7EWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJO/pBFVa1CN7TTnVlK591A+X7FT0PB9+kz7c3zKk60qViII/YMrs0PAPP5Vof3Me
	 5mnSp9AGQIYevBSEC7APWsFj4utQa6CeZNJnUy/g6onvJiD6OTbfcghX8vIgdR5I1Z
	 umvC/iULUB+bUhIcIcLZuoj5RC8U+Qub8Wr27xlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1598/1887] md/raid1: create serial pool adding rdev to array with serialize_policy=1
Date: Wed, 28 Oct 2026 18:01:34 +0100
Message-ID: <20261028170535.835159369@linuxfoundation.org>
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

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 140234b2380ffb8ffb0cfc46fee0e822f43adef7 ]

The following bug has been observed with kernel 7.1.3 after adding a new
rdev to an existing RAID1 array with serialize_policy enabled:

  Oops: 0002 [#1]
  CPU: 0 UID: 0 PID: 19639 Comm: ext4lazyinit Not tainted 7.1.3-1-default
  RIP: _raw_spin_lock_irqsave+0x27/0x50
  CR2: 0000000000004960
  Call Trace:
   wait_for_serialization+0xb9/0x260 [raid1]
   raid1_make_request+0x762/0xaff [raid1]
   md_handle_request+0x1c9/0x2e0 [md_mod]

The raid1.c code calls wait_for_serialization() if the MD_SERIALIZE_POLICY
is set, and wait_for_serialization assumes that rdev->serial is
initialized. Normally this will be the case for arrays that have
the serialize_policy sysfs attribute set to 1.

But when a new rdev is added to an existing array in bind_rdev_to_array(),
the condition at mddev_create_serial_pool() causes creation of rdev->serial
to be skipped. Fix it.

Fixes: 69b00b5bb235 ("md: introduce a new struct for IO serialization")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://patch.msgid.link/20260723112741.1206836-1-mwilck@suse.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ce5063114449c..e268eb0be6da9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -213,7 +213,8 @@ void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
 {
 	int ret = 0;
 
-	if (rdev && !rdev_need_serial(rdev) &&
+	if (!mddev->serialize_policy &&
+	    rdev && !rdev_need_serial(rdev) &&
 	    !test_bit(CollisionCheck, &rdev->flags))
 		return;
 
-- 
2.53.0



