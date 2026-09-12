Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD4E4195DA;
	Sat, 12 Sep 2026 15:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225234; cv=none; b=o9sA/vBgZYlDu2gLtF7uKASUKksZ8Lc5elI0g0huzSY2jn8gO/sHYuqz7RVsNLJsV/KNK97mDU7xY4Zaj25tOBI5j1J0c1YW8h6jQ/o7/JQzXGYgaRtsYyGzhPAvMbflIcr9B+Pm2RsKdMV4E8Fd5z8a5c9PzEOz43bEIlYGJ2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225234; c=relaxed/simple;
	bh=Un79tgvYxnuhpggkF5BE7php8/Qp5d+uOLPtnsLv4O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqGvV7+d4gSvlrsKXWS+y/7v82VQ4kL17zpgmbFm+deMimQ6TzeVFusBzGa+KLnFPqWkNe0X5FY0PtBinw8EMcS7rPwjezp3RdfXqSX7G45YuTjNm0SfBYIzCYZ1fT/oFkpcewZKlNa1ceazfPqx7BJjD4GVeNC6ZSbjPeQPZWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAVYM/9t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAVYM/9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB5C1F000FF;
	Sat, 12 Sep 2026 15:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225232;
	bh=xROS+gKYRUrI+TaW8DYHybJt1PFAR7JTG/bfSh3fbtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VAVYM/9t/J5LAiWlKdb2mvsQeZXsQ84AeH/uoIkvLqXS1/vYAVTtHuYSCx7n7+Qq6
	 r7hORHM4YiS40WVVWeCpE1JZ8A7QDB0jWD36xnxYMiKUwV4hQZOo9yxnMeRfxIUGMQ
	 lATxHlhZxn+MmFe4TwI74svouCMC9bFvlwM1gVFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yunje Shin <ioerts@kookmin.ac.kr>,
	Hannes Reinecke <hare@suse.de>,
	Chris Leech <cleech@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1156/1424] nvme: Add the DHCHAP maximum HD IDs
Date: Sat, 12 Sep 2026 08:59:48 +0200
Message-ID: <20260912065633.186158962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alistair Francis <alistair.francis@wdc.com>

[ Upstream commit 09e8f0f93491c6be867f32d4edc0b16fb5da785e ]

In preperation for using DHCHAP length in upcoming host and target
patches let's add the hash and diffie-hellman ID length macros.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Yunje Shin <ioerts@kookmin.ac.kr>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 5bb96cc21883 ("nvmet: fix heap out-of-bounds read in nvmet_auth_negotiate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 09cd06f20da61..815850270be57 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -2101,4 +2101,8 @@ enum nvme_pr_change_ptpl {
 
 #define NVME_PR_IGNORE_KEY (1 << 3)
 
+/* Section 8.3.4.5.2 of the NVMe 2.1 */
+#define NVME_AUTH_DHCHAP_MAX_HASH_IDS 30
+#define NVME_AUTH_DHCHAP_MAX_DH_IDS 30
+
 #endif /* _LINUX_NVME_H */
-- 
2.53.0



