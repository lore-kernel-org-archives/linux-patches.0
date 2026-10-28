Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208875;
	b=CdPfGMLZCL0QgkCvRN+h6cdGUORb28uFV2w3O5PAUKauB816pqlUekw35vmtx8WLVqvW
	 GLvF1sZ1dW6uBFPBRZbsgIt6OinNht1TUjVyY3fxpcjYzAMedYeI85HPTtjCZvYr/ct9b
	 mMcguC1X0r/1KYvJSKFQE3tmYZBTG/HhpKkbHdcibQPllJwwffXTPX1jR5uteLcWDtDz5
	 y6FvCREbXvAdQ6+tqUu8iSWNzU8gkcguF6QU8vyli9Io+jf0h1E+vdY7hWsnVgHhxoS+L
	 hUWudwytGN5MZNXWZ6inRdcXu8dwwghug0gcqQ7cK8MDf+imSpHjHc9XwCgKYBb8tQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/gYVytuEAqy6qZOjkBW4JFLe+CCSx7HCbHiosE9cSWw=;
	b=AJPsie3fh87YrJDiQLK8eXim6IY3mo13UR3yCZZ+GGpqklPWl8WsQT+ssCenIYqmQf8F
	 dPKH+tohqIEzQqYml0OYsL1bH5ZjMwdIUAXs7f3qU6YtS7FupM79fRHhhJDToUY66P/sb
	 JYZk08qRUgLU6jaGRYTuZuFoRWsf72rYBSEY07LvPRsj8DFFVdBGX7kXFQe8bINHnjRB8
	 IfRlNOKnxNVJI/1jMUcCbGTUDZ2Ygog/YKNbZsYGq3bjQyVsaGXonukLUKcVCI6cU8CR2
	 u7rVG/6DzvAun3L89errTYSXVBa6UnzUheZ1uzlq74Jh9W0Q5ATlhSU2axYrV2Sl/lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDXSH2E3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E513C606A31A;
	Wed, 28 Oct 2026 17:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDXSH2E3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460901F01825;
	Wed, 28 Oct 2026 17:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208874;
	bh=/gYVytuEAqy6qZOjkBW4JFLe+CCSx7HCbHiosE9cSWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDXSH2E36PjFzl78KIkCHxU9AJMT/xBodH8R3UJ43k3at6E1bsvBWBgQbmER4sJjk
	 nV8ZsH1jp3EDpHzeR6XHwsGhHUQlzGAMPC84fOUmQ5+UaUjL2AXMy7ig0lboMPpbiN
	 t0ihtpYr4YECStiSb1XB9kIe0OaKZ6rZcdKHscfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Bruno Produit <bruno.produit@trailofbits.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 272/516] ALSA: seq: Serialize compat port-info ioctls
Date: Wed, 28 Oct 2026 17:57:04 +0100
Message-ID: <20261028170009.935818342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 95b2e0361c88753afa030c10698be0a1a5b67650 ]

The native sequencer ioctl path serializes handler calls with
client->ioctl_mutex, but the translated port-info compat path invokes the
same handlers through snd_seq_kernel_client_ctl() without taking that
mutex.

This lets concurrent compat CREATE_PORT requests pass the port-count
check before any request reaches the serialized insertion. The computed
integer port index can then exceed the address field range and wrap to an
existing index. Subsequent subscriber teardown can resolve the duplicate
address to the wrong port and access a freed subscriber.

Take ioctl_mutex while dispatching converted port-info requests, matching
the native ioctl path. All translated port-info commands share this
helper, so their accesses to the client port state are serialized as
well.

Fixes: b3defb791b26 ("ALSA: seq: Make ioctls race-free")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol gpt-6-astra
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Bruno Produit <bruno.produit@trailofbits.com>
Link: https://patch.msgid.link/20260917105643.90102-1-bruno.produit@trailofbits.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Replaced scoped_guard() with explicit mutex_lock() and mutex_unlock() for GNU89 compatibility. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/seq/seq_compat.c b/sound/core/seq/seq_compat.c
index 54723566ce242..35f67ba5e16ee 100644
--- a/sound/core/seq/seq_compat.c
+++ b/sound/core/seq/seq_compat.c
@@ -44,7 +44,9 @@ static int snd_seq_call_port_info_ioctl(struct snd_seq_client *client, unsigned
 		goto error;
 	data->kernel = NULL;
 
+	mutex_lock(&client->ioctl_mutex);
 	err = snd_seq_kernel_client_ctl(client->number, cmd, data);
+	mutex_unlock(&client->ioctl_mutex);
 	if (err < 0)
 		goto error;
 
-- 
2.53.0



