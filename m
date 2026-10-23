Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774461;
	b=ALGjz0JVJVugR2Xj/MSoeBnz2F5fU7ZPg5ViBsI7kM2Eh3m7yrMpXoMAPWdEVLE8/I5u
	 +TBIEmhYGPm3fnOvVJalHGIE7wKKU+E4VeoD7y/Tnvlu8oWLaALmEwworO5dxH3OWrTVF
	 j+Jd0MQffAVoLwQEme5TtsqicYgAFa0P7R+Yx0QFq0F7E7TEIRAe+d8DF13ipgFtfVFTq
	 zblNFwjfWQ1NOYnY3h49VulQoKuVOrhGlWlbzunmQIaw9D1CildNOGzx19iSYQZD9MF0g
	 T/oc1DcS/GhYz7+4BPRLMTLkKNQdzLMor7/Bt5/aojB/D8bZIBMrd7vAGdw6yVnfjxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8H/ijl1v9vMscGI3OIMp5RK2t7VTADUKGzeGmv+7pg8=;
	b=N/MyaSg+aKIarDtUdJL1MJjEnQ4mC2qVnibyK2ZhpI4mh5rHWGB2qwZvXzknZH5uz0SA
	 HNSPZdrKKL9Djos81FJSa0usLRZwEsmmQJj2hYaNJWK6xL8pudkU7l0Qbdq4KZskVOkEY
	 Lt0vQr5D3kDEgseDPhORP4CKkYIyAPyI4lt52a+ImTZ19kMGdq74JGXcU7VrOPGfY2mu2
	 zHqn6lgYZcOh8QR8Jgw8gGTqpvOVv+2bQvYeB+oli1JIYQYJK6Ah1iqB71Q2s9NLVikx/
	 P08DWas2i6LUOt+BqkD3Yf6FLh2OhmPJjbCxI0plucIw3t8hL4lvJ6DByQRL/0i7Rpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kt5k62pz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FAE606A31D;
	Fri, 23 Oct 2026 16:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kt5k62pz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738BD1F031E0;
	Fri, 23 Oct 2026 16:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774461;
	bh=8H/ijl1v9vMscGI3OIMp5RK2t7VTADUKGzeGmv+7pg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kt5k62pzL3dkuoE6eutDVPZI+2lBvOVANf+2hO/NRvivqxrKNx8EiiYdv7CBIVRUc
	 rdIwQRXzSKiLMDt54THp/TDV9LAdGcquCook/GSKf3Nn9FwQx4Hc8dQIg3XpyKxh4w
	 K9DWBx0yh+rtVi3Y8IL1K20UgVERp3JEcNkXZPRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 010/242] Drivers: hv: Dont reset VMBus connection state on error/exit paths
Date: Fri, 23 Oct 2026 18:37:32 +0200
Message-ID: <20261023163714.041651994@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhkelley58@gmail.com>

[ Upstream commit ec31dc39e835ccde0930daccece8c492d28282fc ]

In two places, current code forces vmbus_connection.conn_state to
DISCONNECTED prior to calling vmbus_disconnect(). But vmbus_disconnect()
calls vmbus_initiate_unload(), which unloads the VMBus connection
only if the conn_state is CONNECTED. Consequently, the connection
remains and the Hyper-V host might continue to send messages or post
VMBus interrupts.

The problem was introduced in commit 74347a99e73ae ("x86/Hyper-V:
Unload vmbus channel in hv panic callback"), in that
vmbus_initiate_unload() started checking the current connection
state before doing the unload. This commit removed some occurrences
where conn_state was forced to DISCONNECTED, but these two remained,
apparently due to an oversight at the time.

Fix this by not forcing conn_state to DISCONNECTED during VMBus exit,
or if a failure occurs when establishing the connection in the first
place. Whatever value conn_state has at the time is then read by
vmbus_initiate_unload() to determine if there is a connection to
be unloaded.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-hyperv/20260805205806.B5AC31F000E9@smtp.kernel.org/
Fixes: 74347a99e73ae ("x86/Hyper-V: Unload vmbus channel in hv panic callback")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c | 1 -
 drivers/hv/vmbus_drv.c  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 0fd50d4cb5739..4c8bc57fbb5aa 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -343,7 +343,6 @@ int vmbus_connect(void)
 cleanup:
 	pr_err("Unable to connect to host\n");
 
-	vmbus_connection.conn_state = DISCONNECTED;
 	vmbus_disconnect();
 
 	kfree(msginfo);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 18ee549d98809..300762315b902 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -3049,7 +3049,6 @@ static void __exit vmbus_exit(void)
 
 	hv_remove_kexec_handler();
 	hv_remove_crash_handler();
-	vmbus_connection.conn_state = DISCONNECTED;
 	hv_stimer_global_cleanup();
 	vmbus_disconnect();
 	if (vmbus_irq == -1)
-- 
2.53.0



