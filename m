Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019747;
	b=MXhvorgG5Rjckijy4g9al0cBwgsdsxXqR7oypprYx6FfcZmdNCkgWOKzdQ1TJ+v5qFp3
	 DIjadgQMC/kbocAQJP6zPv5RU7d8uCOk1vwfNt59EKbR0HRSWXClJkIyBtD4OmeoUtjvJ
	 ime6Y6MHTDBDPRryXaC88XT+ZH6JEmUYRMLxIrNVeTkAb7bCNwQzPYOMJMXnLUD1HEgBX
	 fWQzqzZQQPKIk3Xc7BuZQa92Qkn1aSHWgiXS5QgEiTyIhMt8FAZclblYyICws06Qdw3CR
	 o/Gj9UvU+RzP5IspkugpnH15oW8fcxMyzXXQR4RPm5LUoQKA+y9M1Rnb/j7r1JM3uiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L5wTwP4+qWB/j9suLlGrgRcs6R+QJFrL3mRKoWruDtg=;
	b=mu3KZtLfbM9b1qGgVNd7XOMaERdFNQljwJVpmOpYSvu3zu+VRaqvf99HXwJctKKg/grZ
	 Q/Iw20U0slujVWa1iLGIYfSl1r//o4tkG9ruenAhSP72OmY46fXL0cn/km+QLtKZYzrem
	 TgNjTeFgMCK3u4L95cbYl6eUSFc35VSoh1e39T2KpUeH689oHEP2EzU9ELWNlRYJmIs7p
	 HthCnEQcbpnskmCXjDU8g/ELjjDnLB+sPheVBCtjAoZFjITfLoDg25vuToQTnhytnOM4c
	 mefyEB39H601zffJtkcjdma8NOlHNx7uE7vmvg86J/J2TwgJH1ionpsbS2aMsLMJ55g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BnpEgQSk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08306606A31C;
	Wed, 18 Nov 2026 16:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BnpEgQSk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346901F000C4;
	Wed, 18 Nov 2026 16:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019746;
	bh=L5wTwP4+qWB/j9suLlGrgRcs6R+QJFrL3mRKoWruDtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnpEgQSkZyvjTDYEtYBBQFKZYN7Tix5aA7BPsF7l7vzUoGUkdy/A7q6SmOw7wq855
	 6/2RopMYFKNd2bN8kwPCPhK6Rz3BtPmkkmTE/BhnBGKaihN9qcgflQw50zIyDOToi0
	 C9Ah9OcrZBds03eAT7i3zuJ7Eu8k4II/7sBcdYOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sidong Yang <sidong.yang@furiosa.ai>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1666/2651] accel/rocket: Dont tear down the scheduler when drm_sched_init() fails
Date: Wed, 18 Nov 2026 15:48:26 +0100
Message-ID: <20261118150347.694535181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Sidong Yang <sidong.yang@furiosa.ai>

[ Upstream commit a6709a58a01c8fc357e316bee31f369c2ea56235 ]

drm_sched_init() cleans up after itself when it fails, but
rocket_job_init() then calls drm_sched_fini() on the same scheduler.
That wakes a wait queue that was never initialised, dereferencing a
NULL pointer, and can destroy the submit workqueue a second time.

Only destroy the reset workqueue on this path.

Fixes: 0810d5ad88a1 ("accel/rocket: Add job submission IOCTL")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260912114524.7A6131F00893@smtp.kernel.org/
Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20261004164727.466164-2-sidong.yang@furiosa.ai
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/rocket/rocket_job.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/accel/rocket/rocket_job.c b/drivers/accel/rocket/rocket_job.c
index 4bc4f9c8ee403..088e41e404338 100644
--- a/drivers/accel/rocket/rocket_job.c
+++ b/drivers/accel/rocket/rocket_job.c
@@ -494,8 +494,6 @@ int rocket_job_init(struct rocket_core *core)
 	return 0;
 
 err_sched:
-	drm_sched_fini(&core->sched);
-
 	destroy_workqueue(core->reset.wq);
 	return ret;
 }
-- 
2.53.0



