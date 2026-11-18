Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028429;
	b=WSe2zpoSsKMhaNT+KQM7fwPT9lPSW8/HTofH8NUx78cYstKikR2epyk4im5NAJTE3znb
	 hvmnUH6PxipJTqIrWb0hPF7716X6KXB3IZ+jqTMh4Wey/ixKDum6Y9j4P/ejP50b3iaXn
	 A4+iLh/XoLWtxkpbNtB+PBTMMx65YUulZ3PkAJ6NKfrSmk5HTKVF5b9NocdYdRfZ1v/0p
	 2vl0d646oYJmkK/UYEHJH1oJV+Nt+4xrkFudOH9nwPYzvb8FsjGnQZ7qiMc4JysHUnluP
	 mTPZqVbACKLWzeAnKaFcTONd72FRNxVx7LQU7X02/GRwVo50nggg5hUEmaAXwJmYrZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VxGny6YSfQyuKpXHI2B63ov+YYnn7imtX2IZOlurPVc=;
	b=meMZ+kkJa+IBehBAlaQ+nXezGFiGD0G7CufRnuKDaSY7MBHAU4Lppp7VVEAckpBpkz9p
	 Mix+YFUHIoXALi3LmGdrPQcFRWqp5atfZjJmFWekyswuDpJvvOl0EEYzieOm3Cw6hpTrM
	 co3Ana0B0al7oGQOa4WY32+TulZSCENX9tWPY5d6q3pIu4I4YZ9bM7VaOhEvlCt+jKtjk
	 ic/J97Gilk2I5XhD77MpBlJT8zPtZVeV4dU5BgvTsDjfVXInYtygwdMUrgeKzP/8tjIk2
	 1i3LNSw+UNXijnly+h/OhMNJnXKEhfrccsAyvHHnCw+cg+WT0Nt9kbliU1u1807XQEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="r5/QQvyv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18728606A31C;
	Wed, 18 Nov 2026 19:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5/QQvyv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B1B1F000C8;
	Wed, 18 Nov 2026 19:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028429;
	bh=VxGny6YSfQyuKpXHI2B63ov+YYnn7imtX2IZOlurPVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5/QQvyvAkxhoXyaDRLB3o9i9B4bavhy/eZ2nYUhELM8SN+r4DOqpNby0xBjtx91w
	 J68EwCK6KRgXF9FLZBOT/12NJ+XZtnIAGjh+zRviRGHQthROCrAkJHnIHYX3Q2ATeu
	 KYlSYwGCo8BuIL19+h1qGARkp/Se0NSZa5hCVJDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH 6.18 2142/2151] PCI/P2PDMA: Add missing struct p2pdma_provider documentation
Date: Wed, 18 Nov 2026 16:04:37 +0100
Message-ID: <20261118150239.696405291@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

commit 80d9411c00e805488b631c91034e9b6c14a6dbdc upstream.

Two fields in struct p2pdma_provider were not documented, which resulted
in the following kernel-doc warning:

  Warning: include/linux/pci-p2pdma.h:26 struct member 'owner' not described in 'p2pdma_provider'
  Warning: include/linux/pci-p2pdma.h:26 struct member 'bus_offset' not described in 'p2pdma_provider'

Repro:

  $ scripts/kernel-doc -none include/linux/pci-p2pdma.h

Fixes: f58ef9d1d135 ("PCI/P2PDMA: Separate the mmap() support from the core logic")
Reported-by: Bjorn Helgaas <helgaas@kernel.org>
Closes: https://lore.kernel.org/all/20260102234033.GA246107@bhelgaas
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Link: https://patch.msgid.link/20260104-fix-p2p-kdoc-v1-1-6d181233f8bc@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pci-p2pdma.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -20,6 +20,8 @@ struct scatterlist;
  * struct p2pdma_provider
  *
  * A p2pdma provider is a range of MMIO address space available to the CPU.
+ * @owner: Device to which this provider belongs.
+ * @bus_offset: Bus offset for p2p communication.
  */
 struct p2pdma_provider {
 	struct device *owner;


