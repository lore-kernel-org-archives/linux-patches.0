Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026354;
	b=BYP86oFNx/Bx5QS87G69ylXtptjxy42AAp9rc42T5AePWepWdefyIneR6L0AJAr3F3fb
	 K8UNOHrClj46KW3KSi08Pg9HKfwf4zWfjf4YqhyJKbrZ6FLi1QtUN/p+bPXdsKm+krYRS
	 dcpKPYOA9fL30idztJfYNEk0PYPo3JeRdKWtM55DaMjTIFV2X3h503rgvT8o2CSxRjwb2
	 6idBsAhh7iRntBgzt80ETF1VwAoNRWtMofyf1E8/jjk9fKCM0SVFeKk88aFSJ5eza8smb
	 wHCJzs8vecQotWPBhG2tMQ3wXScQrEoTr4wcYl7Vdsy6iphK8rHoC2igAAdqlvhFJoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Cdy8St/QJGHAbVCf8KSznH3Ivooq8OtpUMXrHI0ld4=;
	b=WbyAm0kow905f/DsJXEKAFaolATTlppXl5mtL48jYNlTfz8/4QDzPD2Jr+hzmqKEt4JY
	 zDXCdQLzMqNSVZeiN4Qjte2a6SxOIUUax5kh1H4g1Qv5jBiTaDFxb2hUSaoNOxWH7fn0/
	 UUQO3aphBCSMn5HwQMUQ9C0ZtukDK6r4eCDdjDQLJ6yzs2wPZQdDnuL1ligBJv99VvZRM
	 h8gLYurz+7ijrpvuOl6Z/6NfPeRg7OgMynsypFPcDLnk2a8uacKxD+8IVxWRbPbm7tTNh
	 FuTo74u5VtYHvbzbPTI32sVFOJ+Bd4d0at9vQ5VY11TOx/Wj2ikRXcFVVO9jlYmQ+tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iNE6Z7G6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAF4606A31C;
	Wed, 18 Nov 2026 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iNE6Z7G6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974ED1F000C4;
	Wed, 18 Nov 2026 18:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026354;
	bh=8Cdy8St/QJGHAbVCf8KSznH3Ivooq8OtpUMXrHI0ld4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNE6Z7G6GbbEhibK3RDP0eg2D6Q+UvHn8PXi7UwEPWqMu8+CPHbTYJyR+zEBgPbCd
	 XAKdPSPVqD6qUuF2j+M/VJVqsBZ57k5mDlzw+CxjC/jb2FYiI7KuYgzYia0DpNbGI3
	 30ZD+CTmwM9Y3ACGC5k8DKZG9qHEL5suKBxt8u9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jerome Glisse <jglisse@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1378/2151] mm/hmm/test: reject overflowing page counts
Date: Wed, 18 Nov 2026 15:51:53 +0100
Message-ID: <20261118150212.210508912@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit b59925301211ccc351d98d70b11f6d1b2c63150f ]

The number of pages comes directly from userspace.  Shifting a value
larger than ULONG_MAX >> PAGE_SHIFT discards its high bits before the
existing end-address check.  A request for a huge number of pages can
therefore be accepted and processed as a much smaller request.

Reject page counts that cannot be represented as a byte size before
performing the shift.

So far as ChatGPT and I can tell this doesn't cause an issue in practice
but preventing this integer overflow is the correct thing to do.

Link: https://lore.kernel.org/6f0d39089e938d4f53dc72632eb84aca34de7015.1789457465.git.error27@gmail.com
Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Assisted-by: ChatGPT:gpt-5
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_hmm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index ec1df4cd84807..5eaa18b80f00c 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1301,6 +1301,8 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 
 	if (cmd.addr & ~PAGE_MASK)
 		return -EINVAL;
+	if (cmd.npages > ULONG_MAX >> PAGE_SHIFT)
+		return -EINVAL;
 	if (cmd.addr >= (cmd.addr + (cmd.npages << PAGE_SHIFT)))
 		return -EINVAL;
 
-- 
2.53.0



