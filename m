Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017814;
	b=M3bbdI3GobKGcRJkIzXh9hDp77I0yjNsnqOlwfGOJblD497QQz6+9jgIH/+DbUT9ZvSv
	 QDVJ097Kc2A9jb73WpUngzuzQQcMKflzUyIjbcvH5mhB5baxpAqPpiHjnI4Cbmbhqnwb+
	 9thHP4WijvQn428AzFdIhUtI8RSbUzv/IFp2bb2YYyNqgANSOPvSQ2v0+w+cx0OKuXLsu
	 BTDJ9pW6V/3ITys7ca7yqV0slK3UXDKAqJG+3RgK+FbPQmysi9TJ/mjU2lyg7JzivSxT1
	 XOfXdRiUWQjpVCr3E0ROBrRAOpk8lmmdEdIco7JNtRadRgo27TUf2MhUOK//c21Ldww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oKi2qZb1eo+HM+AYMBlwogo9w1wZ4lBZqxtspOodluA=;
	b=TnlCmSGr1h1vk4Mx/ASNM61+SNsqtS9UlQs0j+pJj4NPRnC+glGrvhOxDskFsmLT0EGZ
	 XuySElldHOrpVQkb/k8GpeQGdfM1zhSsBK6qc8VR0cpitSGNmXIbZ9zoNC/H8L112b/YL
	 48mdSfn6Z/sj55BE+TYXvn/5z1iM6IkAY6aCa2f0tH561I8bCN0AjzouffFZYkcVFp7Sf
	 ZadJu5a4GEjA29GqItqm3m9d5xC65TbmKpUIf48kOUP8OUDGShkTIAOQscnh4dZxLCs1g
	 ExghvpUYHY7+D+QTz8pvmx5nULG65Jz3bX4ZHb50uFo7/AzIyaKHH2JgVhMqnQOKS5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hodt7ORd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D130606A31C;
	Wed, 18 Nov 2026 16:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hodt7ORd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2891F000C5;
	Wed, 18 Nov 2026 16:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017813;
	bh=oKi2qZb1eo+HM+AYMBlwogo9w1wZ4lBZqxtspOodluA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hodt7ORdAkqsvce0dwdo0uy6tBYyj+eQFPA0MZbxK+kLZq4V2vzsPwu4186A27btt
	 5siDDnxh1xTgQQmKub/Gvu4fN9WV/OUQDQdzgqo+kj/b0Kb2B/SLk50Vl4yRB7B/BH
	 MGU7dWNlhNZXBa8hLDE4x0rSasrW309cvH1t0VjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malte Wechter <maltewechter@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1018/2651] rnull: configfs: add power to configfs features
Date: Wed, 18 Nov 2026 15:37:38 +0100
Message-ID: <20261118150324.577419966@linuxfoundation.org>
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

From: Malte Wechter <maltewechter@gmail.com>

[ Upstream commit 0cd698e89375d0dfc257f9ae978420aa7fe5359d ]

features displayed by configfs for rnull was inconsistent with the
actual features available. This correctly exposes `power` as a feature,
which is also consistent with the C null_blk driver.

Fixes: d969d504bc13 ("rnull: enable configuration via `configfs`")

Signed-off-by: Malte Wechter <maltewechter@gmail.com>
Link: https://msgid.link/20260924-upstream-v7-3-rc3-v2-1-ca56ae7a73e9@gmail.com
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://patch.msgid.link/20260929-rust-block-for-v7-4-rc1-b4-v1-8-642a4c1aebd7@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnull/configfs.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 32c10c3f4d0fd..5f1cdd54cf48a 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -35,7 +35,7 @@ impl AttributeOperations<0> for Config {
 
     fn show(_this: &Config, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
         let mut writer = kernel::str::Formatter::new(page);
-        writer.write_str("blocksize,size,rotational,irqmode\n")?;
+        writer.write_str("blocksize,size,rotational,irqmode,power\n")?;
         Ok(writer.bytes_written())
     }
 }
-- 
2.53.0



