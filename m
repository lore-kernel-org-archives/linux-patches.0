Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621554;
	b=AN0X5Jake8dmZ0yOMm9HUU1JWC4UJRbZy+YbW69vsYMmWuRhd94utSrEuWxpW1qBuzPR
	 WuF51rGXErk6UlpdCPyiIGwQdgftf8mkc+CBr/u3OmOw6wkPFjCeKnVtLm5s7N0YKDvGv
	 WYDoLlG5BJd0DEgEi5XyrHMY9YiT9QL+7MFrAJqKPF4JemSnduW0kIp0erI8/zal1dV91
	 6I/0Krj9tJhR0stB+y6qBSsvawII4/UChkjkOu1x0r6lImQ9AxXl2uD5uj4rtKGwV7lHG
	 Sw1qlNiK1WT711dCTKHmemvqHRh/hUoGXWWI7y+oZGIOeNr9yVa3aYOpSvYffsKHZyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FfIEWGu2Qnk/WXvVcI9e6lZZf1mbYFNxKJLRLJKNna0=;
	b=gmzIeuO5CJ6n3uPIKmiegH9jvOlG446nmD2bWu/myAvmBYJlwSZACW13N+77MXCXg2lO
	 Rsak0L0XDhmfwCQ9zBh9J2TneZzLHeDXXamEO25CFvSLMu4dNK0xVYmSjqI1YaSgTsyjL
	 GZsAWhAKs6tkz1qwDrYGGv5j7RtJ70EyxRfGUdYb9vXbq1NxaMB4/tIoPC1HUp4hnWDga
	 K2Nczrd82H0ZZUuMdsvCfxvOeHKvkHgysufuW8SYU8bzQf7TNXaPY2QO5/qhIdP3KT178
	 ADf9OpYeGZPGE2f9V3Kde6HuNUTORHqWLnlSBJ9I59+dUxwqRot8PmWMz93w5ZO0qqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tVo9bKnj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C40606A31E;
	Wed, 25 Nov 2026 15:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tVo9bKnj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E571F000C0;
	Wed, 25 Nov 2026 15:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621553;
	bh=FfIEWGu2Qnk/WXvVcI9e6lZZf1mbYFNxKJLRLJKNna0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVo9bKnj7DfvGpc4VhABbNzaaPKbS9K6CjcD41r9hcN/utifrNFipTmFRe05TmltY
	 ZBgeQ1eAjz0dmagZ9ewHXjpMH6XT7wIr8NuK5eCYAsZWrQNz6Hnqi+PZw4mbLxgD6c
	 sO9+Fr8a4LgqrrP5wK3wVJFyG1kvisfMD2s/IfTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 206/990] vhost: reject backend enable without a kick file
Date: Wed, 25 Nov 2026 15:26:13 +0100
Message-ID: <20261125143826.917834907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit 509f6bd229e94fc39506e01be692c4aa22338b49 ]

Enabling a backend without VHOST_SET_VRING_KICK dereferences a NULL
vq->kick in vhost_poll_start(). Reject the request with -EINVAL.

Fixes: 264ee5aa81ec ("tools/virtio: Add --reset")
Assisted-by: OpenAI-Codex:GPT-5.6
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261011-fix-null-pointer-in-vhost_test_set_backend-v1-1-60b2f12d64c6@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 42c955a5b2111..997f869284377 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -281,6 +281,10 @@ static long vhost_test_set_backend(struct vhost_test *n, unsigned index, int fd)
 		r = -EFAULT;
 		goto err_vq;
 	}
+	if (enable && !vq->kick) {
+		r = -EINVAL;
+		goto err_vq;
+	}
 	if (!enable) {
 		vhost_poll_stop(&vq->poll);
 		backend = vhost_vq_get_backend(vq);
-- 
2.53.0



