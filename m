Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039941;
	b=PljoV8ZNFKmR0FkY1gN3nWzuMPCCRG7UZq3daGBI6RDVygUIn5ojYZJ4TQohvUJEb6JS
	 N6Nc6VsEr1h25dZkJRprbjDpGrmg8BJbJGC5Rz9izDsg+x1bwS11+D5H6LZP4L1L4x5qE
	 RWK3L7i9a+kDJqykXnYwxNqCpHf0sLD2OhRvODrf4vsYPV6AkzxLNSOnBrCvCswLbVFT6
	 w62f5Zf0qS5irvTGu+E5wIZH6KSDsrLtUGtMtgvjJNQ/rdOBNSrTwqRVrCirlyVVnKxuW
	 0Y8BBhMjBdAeVobiOHqXe1LZ9LQAXeHnbfmlkW6OtB6CdG2Y6nlSHsiZNa8Eroc4F7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r6YuNPCV0Y5zIzWCcObQ5mugDARXgN25UHFG7xh67Wc=;
	b=DI6S+tDS7owNKjc6g9t4ffD748j9RUbiwSFUGOJ+HMD6ADdoP0rWhtqv3V7e6a9RmhIT
	 jX5G3he7lbDd39O0YeZdKTFvZwFwa7kbfff8yXVI4PE+U19/6sVDS3IG5pghy67ToAGEH
	 rXZPEee++NBH8Y7+2YAC4qLVYLgHqe2OS7HutfhfjN4vCG03mvrJa75saC8WnE0vbO4+7
	 EIgGMK0bc9LIFePzozaysYiE3U6ObVcimXTG9z45gzeJeVVEKT385oZanqHFDZI/DsLxg
	 pafRomaYIifCuk3z/p074AjALPrOKY8OpDoDiYBHhi8caZPIdIf9J5GQmdZCZoVxbCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+v5+4Xl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B28606A325;
	Wed, 18 Nov 2026 22:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+v5+4Xl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040BC1F000C4;
	Wed, 18 Nov 2026 22:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039940;
	bh=r6YuNPCV0Y5zIzWCcObQ5mugDARXgN25UHFG7xh67Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+v5+4XlM5KjNM/cxAzO5Vb/AXxmiA60ilve+V5LboRZw55H5ICykCBcle6djBhvR
	 d5/ZfEczB/6XeWMg3cFJhr3pteri0R0qvRKFNFMrk0CFWcLFpqWIdsBd3t2XvrOcs5
	 7mrULwS8PKEcSYWC5UoUvE5eYB7neI7g/5jbbHnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2281/3318] pstore: reject persistent RAM zones too small for the buffer header
Date: Wed, 18 Nov 2026 15:48:23 +0100
Message-ID: <20261118150430.201244455@linuxfoundation.org>
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



