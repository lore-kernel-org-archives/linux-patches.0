Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023676;
	b=zzqxMD+XbWZp8a/e4NzDztefBet6SCG6cl/KVDJGSwH/tTdJz+TJjGIufSu+svueFej0
	 CLTQiJXJ3AqLZR5ZGkDw7EwLrvBTCbFbH2XfExdeJAQfNwEEU2U/+QR2JcN67AuovuN0e
	 T4JIZBLIpW1avZj7cZJ3+Dke9XC/POB3Uf2X25Av1pGBHtdKLFI8aVRsO8l0WZxmPXHZc
	 TJaSN0us7rxMtLyI9vHQlMeLh8Fr/cdxfJ1rstaBvjX2YQbXYtNvrUwX4amkNMhTzwNvZ
	 JRdknSbAD9Cykd5a2lpgm7uXpqwdRLlW8iJm+m5NQtkxtWlXdMoFQJFvJy9eHT+cgQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bD/5NJZRjk8+4j85Ebgtl0k0ixdAhlvGb78cuKTAsOM=;
	b=DL9NUyvZm0566KJoC4OREc6viYZJEDEvxTQXpZBxln49pA8A2HL5F6HaojS8/OXyE5ss
	 6FJ3LaFxMYX7K3+Aeh7BP6gEfu8C+g4zHxy/YKSt/PrUnxLpytRw0gWedyWzvDLagHCEz
	 BJ5heVzYCWXKWDJk1w5OzIlpsEHK0ep+r4jm7mRSnTcJ0HLFS/kldpUakryI5hkhBAnRr
	 M349GIj93t2JThbSCeBjhogu9BjrOV1oWMq18moUGpcKmWp7/eu6yqbPx+fVIWNafKIS9
	 uj21dT1vPMZAxoBvLJVAs2o5YAs1UJiDzJ31XbTBftYTLW4fMn9B2J2dir4jz8FVZNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUAkQqjA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B6B606A31C;
	Wed, 18 Nov 2026 17:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUAkQqjA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551DB1F000C7;
	Wed, 18 Nov 2026 17:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023675;
	bh=bD/5NJZRjk8+4j85Ebgtl0k0ixdAhlvGb78cuKTAsOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUAkQqjABwzHkML4m8+4WyasunqwDnltcYE0j/74n1VmT/k85Rp1wL8FK+9/P/gpg
	 qme3oD+sj0NNaWideQLxinwGflnk/Bsr/ynpykfTz7QrSHpo7GkLGoXDEkCtVdGnJG
	 Pv2qLQVZ3Xhspir/JG+AeyIoUaHJn3zkg01FOWXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghao Zhang <hyz3367@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0454/2151] remoteproc: core: Set trace buffer name for diagnostics
Date: Wed, 18 Nov 2026 15:36:29 +0100
Message-ID: <20261118150138.565577169@linuxfoundation.org>
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

From: Yonghao Zhang <hyz3367@gmail.com>

[ Upstream commit e23eab619b0d2dd796618406ba25da62f4d539a2 ]

rproc_trace_read() (in remoteproc_debugfs.c) prints the name of a
trace buffer whose device address could not be resolved, but nothing
ever assigns trace_mem.name, so that the diagnostics always prints
an empty string:

	Trace  not available

Copy the generated "trace%d" name into the memory entry, so the
diagnostics identifies the buffer failed to translate.

Fixes: a987e6b91a5a ("remoteproc: fix trace buffer va initialization")
Assisted-by: Claude-Code:glm-5.3
Signed-off-by: Yonghao Zhang <hyz3367@gmail.com>
Link: https://lore.kernel.org/r/20260911081810.740028-1-hyz3367@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 1e277333de871..eae7b0b2b43a7 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -579,6 +579,9 @@ static int rproc_handle_trace(struct rproc *rproc, void *ptr,
 	/* create the debugfs entry */
 	trace->tfile = rproc_create_trace_file(name, rproc, trace);
 
+	/* keep the name for the diagnostic in rproc_trace_read() */
+	strscpy(trace->trace_mem.name, name, sizeof(trace->trace_mem.name));
+
 	list_add_tail(&trace->node, &rproc->traces);
 
 	rproc->num_traces++;
-- 
2.53.0



