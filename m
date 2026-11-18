Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031366;
	b=SUBLlwn52iku8Ff5RXlTdDXSqDQiuyz6s+qrxeK/LXqc7++lCaGaU9CYQxJASLZNxf6Z
	 XDmOoi+qzeBhifXm31q4aBiUqKxLjQOTo0zLDjlQzpX9nvsXqRnrYwgBPus2GkA+e0gID
	 C3i80x/NnMf16/o1rUVd48Eh/zlQ/zbQ/3awNimri7Ewpwb+s7DDO2IeUsuZ0swFvrOxt
	 Vzav8xppsNhKm7N8VF4k7/Gh5qExIsti370U3yld2EyNDsilHLZTqoAodsrhvQ56ESMKq
	 VMmdbjrYpwDlyRvi9g2zIKqljNnDRyrbsZ6ziQBAeokd6WprIixIDu2kget7jE5j2Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+MPdfSZlZ9ANln5gv0UDQrWXILoQYo3j9asfof+lZE4=;
	b=MSt6p+NkGyW7CR3pL3xpkR3bOAHQIf3g8vaySXbrw9sb43DFpKKtP4un/qEh1EON5YUp
	 Z8KSjJtQ1KDFqjUv5s8fjOtjf/aRSQ8oLP0Ouc0VOjg/XOuLkqJY1oPyVKSJhznB59SMu
	 BYIVqytgVRdC77QXHcquvmDGkxTziQZpepyNIITn4fIp7vpoYznEQkq9cWC0He4t8MGsx
	 jL7D5MTrwtq9ung0kQNXltGyXKaSI8AZb6q5RvvDBN6zH+e1h++xzGOLu1JgyShESKuBZ
	 VyS3YJD5q8QtjqUQ0BUoU0TMEPV1OuKpTt+VcdDVzxVppyJOlnB54PBv3Joxm+eS9Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jr+gVQAQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BF6606A31C;
	Wed, 18 Nov 2026 19:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jr+gVQAQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07761F000C4;
	Wed, 18 Nov 2026 19:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031366;
	bh=+MPdfSZlZ9ANln5gv0UDQrWXILoQYo3j9asfof+lZE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jr+gVQAQjt84rrRZRGP8S6Yl/1HrRFvLdRbHfV60rr62e42qhsGUSV4ya50GNg9To
	 IrJ0bJRDKElX+hS0hFnUl7ViIGFbhCxyf1jmobB3ogF3jOHuLTe63oc48WbbOl6rWd
	 noZ41B4tEkQ3pUsD73e+SDKu4DRnlmGj4WWaItgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Cheng <leo-cheng@vip.qq.com>,
	Michael Walle <mwalle@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1033/1756] nvmem: layouts: onie-tlv: fix device_node reference leak in error path
Date: Wed, 18 Nov 2026 15:52:40 +0100
Message-ID: <20261118150051.195348973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Cheng <leo-cheng@vip.qq.com>

[ Upstream commit 9d44e80151dd360fad6155f36b6bfa57efb0f2f5 ]

onie_tlv_add_cells() takes a reference on the child node via
of_get_child_by_name() for each parsed TLV and passes it to
nvmem_add_one_cell() as cell.np. On success the created cell entry
adopts that reference and releases it later via of_node_put(); on
failure nvmem_add_one_cell() does not consume it, so the caller still
owns it, but the error path only puts layout before returning, leaking
the child node reference.

Put cell.np on the error path as well. of_node_put(NULL) is a no-op, so
this is safe even when of_get_child_by_name() returned NULL.

Fixes: d3c0d12f6474 ("nvmem: layouts: onie-tlv: Add new layout driver")
Signed-off-by: Leo Cheng <leo-cheng@vip.qq.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101329.1084348-4-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/layouts/onie-tlv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/layouts/onie-tlv.c b/drivers/nvmem/layouts/onie-tlv.c
index 8b0f3c1b8a0e9..4da3a704388e9 100644
--- a/drivers/nvmem/layouts/onie-tlv.c
+++ b/drivers/nvmem/layouts/onie-tlv.c
@@ -128,6 +128,7 @@ static int onie_tlv_add_cells(struct device *dev, struct nvmem_device *nvmem,
 
 		ret = nvmem_add_one_cell(nvmem, &cell);
 		if (ret) {
+			of_node_put(cell.np);
 			of_node_put(layout);
 			return ret;
 		}
-- 
2.53.0



