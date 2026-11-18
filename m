Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026055;
	b=nBQQqCJoEIae/3MdHFZQhNnVuv5ve+JTrjKCyqiwicQYJUR7xBnBudWJY4LwZQD1Pp/H
	 Ffrp/zyQmtmpANw3inYMpROrtNtKnXm018K7ooloW6a6ZhlOQnV7Jxe7M8y5Ibk6iU7U4
	 6QP3DG8s/VmX46jyrAXVA14T3RtZqzExwRNqdJqLAjmN9v2C3gY/TGY7YbxzfdYpHaUAQ
	 p7sAOjZDUHcBuA/Kif/svBJiZECUZn8TGw+qQgNnLbA/v5DBiJ04YNRwC5qmNetviZbY9
	 h9IXH94yD/mHgwc349P5X6pxk/Dv29P5N8YPknMWdGNqyOV/pQO4zWSKLZzad5DQg4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p80nura68UvlstNaLKbT6Jc23QjeRYLSxoNsovX+Lno=;
	b=llWRW1XEZRT5MtXRWisYaiWyv9fYC4ebfeWnt3Qait/flgJ/k8FQKsw3oozgkz+W6iEv
	 NIN+gnAW1c4esRc+7yXf6c9LR3YbLV1ETkLcvttZqv6Mb0O7RDOE31HSjvrb9lLUHuHDz
	 tgFViFDrfnzXFnGFu4o8vG7/gLXBJLQhyvs32UQiPPBGiAVTj7LhJejKBfrG5wsrTLIWi
	 tLj2q+v8Z+Yw1oJ/yXfLTFgtlyHyZGoBzJ2wg/9CPDfbb9L3w1FSLdEMeF8eW0obw36qJ
	 EdE5n86Z6otJjCas6dV5Dkjkipt354DDxg9L+DGESmKZXr+kIztud2WwMwB4UyvdbcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5q7LsMp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8D5606A320;
	Wed, 18 Nov 2026 18:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5q7LsMp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5C11F000C4;
	Wed, 18 Nov 2026 18:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026054;
	bh=p80nura68UvlstNaLKbT6Jc23QjeRYLSxoNsovX+Lno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5q7LsMpKkHnFxpErvomtWcbHyPjz98l7SUNSpCwZO7QiA8Mn52M4ZTo0Ojs5VPlx
	 e3kTbHGPbGd+Bk7MJW4xMSEc56aLtKd2R1ff0nXy5SgDHiljQJnF2YRMexy0NzXk1c
	 hUx3H0P/sMuwXi6eL2lkTvvyZZRSqFs9rMdDewOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Cheng <leo-cheng@vip.qq.com>,
	Michael Walle <mwalle@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1299/2151] nvmem: layouts: onie-tlv: fix device_node reference leak in error path
Date: Wed, 18 Nov 2026 15:50:34 +0100
Message-ID: <20261118150209.430123044@linuxfoundation.org>
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



