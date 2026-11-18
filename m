Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042296;
	b=ij+xbspxa3WP0+c5LkyDujd4+TopIAcQoUal/KdInGCsAT0aqEh3OMywpVm42ICusoJn
	 2CUy7+wFbtB0OYqfr1VoCcrL/EqqcnwP0aX96vVlhJgpIjAa9N9Im+xxHdIN4pBrjLr1t
	 dHCANLzDGipaKPXKnhrJhE2Ei9ab2KUlhwDDNVbV7/uwUlLkRGbLT+g3WtEC/c5d/YtiX
	 KW54Cn42Yjwkz2CpdMyxY4IUv22rvNjekuprgw4Bof9yaSS5nMRg1sQ05OjGy1Q2eHD8a
	 VLx26k+jsH3c1H3G2zqJo9k4jJq16XvThOuyrxacPDr5cZqYxWz8oZOv+YIVeuuIURQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=emrP3qyXAGFY8CU1a/j8go4SN7bj3yBahloXgbvYKX0=;
	b=tlw/R+JG77HzfADShTkLxNJ9accKx4f4gKIYBh9vy3aYvlIw+ISEHsntiM2NU2OI8tNW
	 WC0SEmFi50fc5D2cFW9v/qgBztNT6m7mEjxzS0QoSzXNkC8i29FzJAwyrPM/DUVCEMr6T
	 QFWlTF8PBUEHzXTbWNo7oNLXzkNolGPIv6+x/Tx1MRsROAKiB2eK55RIQkmtzA5dnOjJ5
	 LOfAowdqj0GxVn9XtehxWlDRG8OqlsRArBySgi0By9mdw0d6skmrIE6N4XfUIA/O2vbr6
	 iEvf5AJLqgWA1PIfXfE41chc+gLtnpLrPnthKfQAvPHK/W8SzGkEy7P960xn8jvI4JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yv+P2vid;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED4C606A325;
	Wed, 18 Nov 2026 22:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yv+P2vid
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A53A1F000C5;
	Wed, 18 Nov 2026 22:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042296;
	bh=emrP3qyXAGFY8CU1a/j8go4SN7bj3yBahloXgbvYKX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yv+P2vidwVgFsuvKNJ32u4lRkY0IAT/22KIhT7hT/2X3TgKSFnXCd4bBwqSJxhM4m
	 1tGso6osmpfoZR5TRbwASTfv8a5SQtgAZWAfRewtw2jf4Kkh82jbzQhx20bvoQjKLj
	 i2lPmOUyHeFChhDMWv72cKjM5VSY6gjFas6+CQFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3121/3318] nvme-fabrics: limit each queue type to the number of online CPUs
Date: Wed, 18 Nov 2026 16:02:23 +0100
Message-ID: <20261118150453.568856861@linuxfoundation.org>
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

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 99fd0cbae84988e0af34784aa18ddd51ae094ade ]

nvmf_nr_io_queues limits each queue type to the number of online CPUs
when asking for I/O queues, but nvmf_set_io_queues hands out the
granted queues without these limits, and only nr_io_queues is clamped
when parsing the options.

E.g. with 2 CPUs, nr_io_queues=2, nr_write_queues=10 and
nr_poll_queues=10, 2 + 2 + 2 = 6 queues are requested, but handed out
as 4 default, 2 read and 0 poll queues.  blk_mq_map_queues can't create
more CPU masks than there are CPUs, so default queues 2 and 3 take over
the CPUs of default queues 0 and 1, and connecting the I/O queue of
default queue 1 fails with -EXDEV.

Apply the same limits in nvmf_set_io_queues.  A queue type with more
queues than online CPUs always has a hardware context without an online
CPU, so no working setup changes.  The options are not modified, so the
limits follow CPU hotplug on reconnect.

Fixes: 6486199378a5 ("nvme-tcp: fix queue mapping when queue count is limited")
Fixes: a249d3066de6 ("nvme-fabrics: add queue setup helpers")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 6641ae68cb917..7c1c712308014 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1016,18 +1016,27 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 void nvmf_set_io_queues(struct nvmf_ctrl_options *opts, u32 nr_io_queues,
 			u32 io_queues[HCTX_MAX_TYPES])
 {
+	/*
+	 * Each queue type is mapped to the CPUs separately, so a type with
+	 * more queues than online CPUs has hardware contexts without an online
+	 * CPU.  Use the same limits as nvmf_nr_io_queues.
+	 */
+	u32 nr_io = min(opts->nr_io_queues, num_online_cpus());
+	u32 nr_write = min(opts->nr_write_queues, num_online_cpus());
+	u32 nr_poll = min(opts->nr_poll_queues, num_online_cpus());
+
 	memset(io_queues, 0, sizeof(*io_queues) * HCTX_MAX_TYPES);
 
-	if (opts->nr_write_queues && opts->nr_io_queues < nr_io_queues) {
+	if (nr_write && nr_io < nr_io_queues) {
 		/*
 		 * separate read/write queues
 		 * hand out dedicated default queues only after we have
 		 * sufficient read queues.
 		 */
-		io_queues[HCTX_TYPE_READ] = opts->nr_io_queues;
+		io_queues[HCTX_TYPE_READ] = nr_io;
 		nr_io_queues -= io_queues[HCTX_TYPE_READ];
 		io_queues[HCTX_TYPE_DEFAULT] =
-			min(opts->nr_write_queues, nr_io_queues);
+			min(nr_write, nr_io_queues);
 		nr_io_queues -= io_queues[HCTX_TYPE_DEFAULT];
 	} else {
 		/*
@@ -1036,14 +1045,14 @@ void nvmf_set_io_queues(struct nvmf_ctrl_options *opts, u32 nr_io_queues,
 		 * sufficient queue count to have dedicated default queues.
 		 */
 		io_queues[HCTX_TYPE_DEFAULT] =
-			min(opts->nr_io_queues, nr_io_queues);
+			min(nr_io, nr_io_queues);
 		nr_io_queues -= io_queues[HCTX_TYPE_DEFAULT];
 	}
 
-	if (opts->nr_poll_queues && nr_io_queues) {
+	if (nr_poll && nr_io_queues) {
 		/* map dedicated poll queues only if we have queues left */
 		io_queues[HCTX_TYPE_POLL] =
-			min(opts->nr_poll_queues, nr_io_queues);
+			min(nr_poll, nr_io_queues);
 	}
 }
 EXPORT_SYMBOL_GPL(nvmf_set_io_queues);
-- 
2.53.0



