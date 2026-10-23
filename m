Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773962;
	b=z+mBhMP4Ekk+SZGEEqm5UlRBjNG0ABgNK0d/DkXZHg+c50NRcfXwBGUTO3Wxelad47/J
	 8ih0d/63AxLjpqZ8x0kpLiLKhxs9ur4ixsmrCY0bw3H3myBAbetMS7+oxYx3AO5uHsESW
	 sLbaKrX4BabH7B77A6SWJINc4zbKx7vVqI23PIU1zT3o9vVbFhHyaai0JtAkox8uls+S/
	 AEgN876y2g+DXedWhu2ChAVTYeib+f8dWP8AtvDig4kySXz+28++pehnOF9s8kOeAqgwg
	 OfG/F/l2Eo/pT2N8OaN3Quq+bVCcw177wKQIupIy6o1ckIZyDpzt0k2XluzcU7L2auQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y6l4kln/2ZFows/WKSMFu3ZhlryZY3SqerzYH83yGF8=;
	b=NvwPg5H8NMwmIcXB3DMX2H8bfyi5fhV3t1i8sLU16DNCs09rIfyuLp+RDApMS2KlwfjQ
	 sQoS6yqTmlzhASHKop4CDmws8EEnusA7eC3jHiXjjklkY9Llp4bJJzukJTHJIqeOOaSKV
	 aDWiyQGkbRhNa7qS1yI6EyNOe6qZ+CFy5SQqWB/S7YSORKLHJwhcbBCs5lW3wXajjC4jt
	 d2zSJAmuz9LSv3R0BggY0kdQNa0kEvc9G0YPfpmaOh2+3yy1KQ9blyC9Le+FH9l4Im5ql
	 Xg28j2qGbiFTwWIh6RCNtb6SYzbkrLMGEhOEQvAoeu/Upm6+jhZ0nY5vhRKL2fZz+2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQRb9d9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57E6606A31D;
	Fri, 23 Oct 2026 16:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQRb9d9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433721F01825;
	Fri, 23 Oct 2026 16:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773961;
	bh=Y6l4kln/2ZFows/WKSMFu3ZhlryZY3SqerzYH83yGF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQRb9d9V666KzOuVoCBaIa1FmKPSqcWcElCC+hrBgNaC3SRb/CtoDjSWA82U6t7/d
	 sxjoCw4fCUIJ7BBhjOECo9FwD80mFlLUD5XxLEJJBLDzg19oz/0ahkmMxiOhlfTdAk
	 mjrweBcd3mVSiT5ejXE+APYZmGIGaFESwsnR9eAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 074/193] bootconfig: give the footer size static_assert a message
Date: Fri, 23 Oct 2026 18:35:51 +0200
Message-ID: <20261023163715.954615329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Sasha Levin <sashal@kernel.org>

commit a1ddc2721467fb68241372db77657fd0dcf6cda5 upstream.

static_assert() without a message is a C23 feature, so clang warns:

  main.c:498:56: warning: '_Static_assert' with no message is a C23 extension [-Wc23-extensions]

Add a message.

Link: http://lkml.kernel.org/r/20261011223358.2327625-13-sashal@kernel.org

Fixes: 6ed5e20466c79 ("bootconfig: Fix unaligned access when building footer")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bootconfig/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -458,7 +458,8 @@ static int apply_xbc(const char *path, c
 	footer.size = htole32(size);
 	footer.csum = htole32(csum);
 	memcpy(footer.magic, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN);
-	static_assert(sizeof(footer) == BOOTCONFIG_FOOTER_SIZE);
+	static_assert(sizeof(footer) == BOOTCONFIG_FOOTER_SIZE,
+		      "bootconfig footer size mismatch");
 	memcpy(data + size, &footer, BOOTCONFIG_FOOTER_SIZE);
 
 	total_size = size + BOOTCONFIG_FOOTER_SIZE;


