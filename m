Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214544;
	b=mJA1KhXqMk3doENjdLxcYzhkJcYLu1aXQESQuci+C9Qc7f8Ta+qv0aediseUMNxMNlUf
	 xomCuWwI9GIH9DVUX8nMnjG/7WyLVloIH9JpbMWcZz3hq7jUz1z8LpkFgkZlC06MChRLH
	 dqpUTMo/qR3mca1lQvdhM2JOMxaZ4zDXUUwVHhLnmNksF3RP4m7RTa/9EQl5OY/NaXdeF
	 LNJpHHKMSGo3elhExLFr5mNRVJg/cptKpDi9ave29kTNMy0m6mEQWKuTjcqQJKmRrW5TP
	 P8d798d6kSrLqoRkTndUUS8C/Rf7WGQ1rVoTWVSdDs5qcfeQTPfMrEfgDSds6A2XdHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fZVFOM+bx5kX9IQPJGOHCuywyZzSly1+xysC3QwnTIo=;
	b=INsiTjDDydQXkkknK1fZo0Gw2ffMLp/MLTa6zCcUCTLRIYfiKLus8MFTKs1dy0WsicVz
	 mpIUqeGtNNUWne/MEi4+GpLYbMcnkuymViYthp1NXg0p4n+CRbGUh9RsGBXejBOGhn3i/
	 KkW0LQIXeX9m+2YA3MKU+8EgNHCEvRSynZrnsJv+nCXnOSxEK8p0Jn4Vz4Yim/CV/9U1G
	 /iO3y7SCRvmZWqxeZxs8s0IuQ3oXaBZ+g/mJ6Y9WsI75UTIewoJ+3SdWJJbKXWuAbG2VY
	 Gg4zngBs+H2fbG8id6DWGrvqsfYDtj9j7En+n6K7U+dqwhgSlAe5rmU17Vd05DlyMUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eRmyNmn4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE5A60A260C;
	Wed, 28 Oct 2026 19:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eRmyNmn4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2BE1F01825;
	Wed, 28 Oct 2026 19:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214544;
	bh=fZVFOM+bx5kX9IQPJGOHCuywyZzSly1+xysC3QwnTIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eRmyNmn4G1I8F7OnjWKWKvx6Xzk6JPB2YLVb7ePY/W/HgJqqU+kY6IAqJeL/K+zef
	 rCH0r8d8EnBKXKnjsb+7p5ogDCRW9PzuXA6DymKuUEVGu0jhd5r57fn/vDHnjNkQS2
	 0lSa6Nn1/Kb52m/eJHXyCbY2QrmzAXMUPGX695fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0894/1887] scsi: imm: Fix use-after-free bug caused by unfinished delayed work
Date: Wed, 28 Oct 2026 17:49:50 +0100
Message-ID: <20261028170519.762824119@linuxfoundation.org>
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

[ Upstream commit ab58153ec64fa3fc9aea09ca09dc9322e0b54a7c ]

The delayed work item 'imm_tq' is initialized in imm_attach() and
scheduled via imm_queuecommand() for processing SCSI commands.  When the
IMM parallel port SCSI host adapter is detached through imm_detach(),
the imm_struct device instance is deallocated.

However, the delayed work might still be pending or executing
when imm_detach() is called, leading to use-after-free bugs
when the work function imm_interrupt() accesses the already
freed imm_struct memory.

The race condition can occur as follows:

CPU 0(detach thread)   | CPU 1
                       | imm_queuecommand()
                       |   imm_queuecommand_lck()
imm_detach()           |     schedule_delayed_work()
  kfree(dev) //FREE    | imm_interrupt()
                       |   dev = container_of(...) //USE
                           dev-> //USE

Add disable_delayed_work_sync() in imm_detach() to guarantee proper
cancellation of the delayed work item before imm_struct is deallocated.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/20251028100149.40721-1-duoming@zju.edu.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/imm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 7a499d621c258..9754c0e28c363 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1269,6 +1269,7 @@ static void imm_detach(struct parport *pb)
 		if (dev->dev->port == pb) {
 			list_del_init(&dev->list);
 			scsi_remove_host(dev->host);
+			cancel_delayed_work_sync(&dev->imm_tq);
 			scsi_host_put(dev->host);
 			parport_unregister_device(dev->dev);
 			kfree(dev);
-- 
2.53.0



