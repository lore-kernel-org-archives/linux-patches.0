Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023997;
	b=Xl8KJe/GGhNcM76QIdsCkG8dLw7rtCx6vHvwZ3aO+jk6mYAgYl2C4ZPkB/iRYC51XX3N
	 UewZ/d4zZLH1TB+zW3mzXnaQQWE2trCDDzI7l0qENTPQO65IiPmgQyq7UpoLyUhITjQa6
	 0MXstjI36h2NmwAIUJRgq/ZxhOXF2vzL6z1wozctcW/c1bHHjmykWZoLjHp7uKU7FkFtf
	 DWJ8+VzqBzaNzQvHPXC34vBTESPQhV76Kvs6WPxaojhfKoqVccIBclXhZwDVe1TePm/A0
	 dTsLj/XsyG8Uz+UgvMlAc50VzuNFoZnUKvlDE0aL6ktVdDbp8jM+HDjKjzUQrzrhqVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w+d1bwJv7w45sEhA0VkxYT8QTCC1w2XAmtWN0/AwQSc=;
	b=UGiG5phNnZx9DDyI6+3oheqD+ml6+PI0PHw4yo1emoPtq2wtS26lDixesNZhvS+UlLDX
	 nVNujXZmF2Qfmm2r9XaQKzbnKTFaTL2xizRlpMsaJDINCvf47QdStyoOqGnvUdT9G2QDK
	 vLgQgWXJ+S9Rea7MV38A92zAigHmTmgkQfvQ41EoqpFKN9eaApsVUwh1PwzslOYdW9nMS
	 XRJemIEg3OPJCeMqw5G0ygQ415t0aqfT5q6wu8tpiDFnmgnuUaCVuTg/b+5qzYfd17JK3
	 WcCPJZquRy53fKcfNJl4hbbOOVbkFBslDvoFL6kP4FbOJMAgej1sXkGWS8H9TK2QsDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgfH8cf8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28328606A31C;
	Wed, 18 Nov 2026 17:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgfH8cf8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE751F000C4;
	Wed, 18 Nov 2026 17:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023996;
	bh=w+d1bwJv7w45sEhA0VkxYT8QTCC1w2XAmtWN0/AwQSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pgfH8cf8wV8cebGjcyUEHf090BtPVIwHxqcZCcV4lYOGtE1rHjUxfLKLiSwm58eUu
	 AaFB67dKFMyWJaT1fDgyww0v9gHjeDPwrnnkeOPXqMvlpB7BB+2NL49d1zqpnO0oM4
	 7j/zOGIPAD3+v7zhwt8PTVt7FhqCMzv/lIa8mTdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0569/2151] pstore: reject persistent RAM zones too small for the buffer header
Date: Wed, 18 Nov 2026 15:38:24 +0100
Message-ID: <20261118150142.676528907@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 1b30df8662ac85a6759be4332f3bec7e3cb28efc ]

persistent_ram_buffer_map() computes

	prz->buffer_size = size - sizeof(struct persistent_ram_buffer);

without checking that size is large enough to hold the header.  A
ramoops zone configured with a tiny size (e.g. ramoops.pmsg_size=1)
underflows buffer_size to a huge value, which defeats every bounds
check in persistent_ram_write() and persistent_ram_write_user(); a
write to /dev/pmsg0 then copies user data far past the end of the zone
and corrupts kernel memory.

Reject zones that are not larger than the buffer header.

Fixes: 404a6043385de ("staging: android: persistent_ram: handle reserving and mapping memory")
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20260921202317.70595-3-parri.andrea@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 95675d4bab141..4d07280768975 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -507,6 +507,12 @@ static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
 	prz->paddr = start;
 	prz->size = size;
 
+	if (size <= sizeof(struct persistent_ram_buffer)) {
+		pr_err("%s: persistent ram zone too small (%#llx bytes)\n",
+		       prz->label, (unsigned long long)size);
+		return -EINVAL;
+	}
+
 	if (pfn_valid(start >> PAGE_SHIFT))
 		prz->vaddr = persistent_ram_vmap(start, size, memtype);
 	else
-- 
2.53.0



