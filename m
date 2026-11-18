Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059236;
	b=mMUuzArVMkkbLqrSja/DjN4bAXhnPdNiT/eUvVjLVfrf9rUysoSpMmM2c+76slwu2/Pi
	 kkcd00x6DuNMhjVYsWGgahPMF0LW+iUplY4fJTxlj6OB/bgxELSdVNSapx11bT0NDqtD/
	 CFZyBrnxvRWBe1PgfKJ5Pp1765JR1Dd3VAsn0lwojflunE8PAVCpN1NQySbnsy+VYfMc9
	 qv8K8lXMLogONaNva7j8+Ia4qjzCoNMwuGpKV9Y79rtdSd+eSCSwl9ubruzGtue71mhya
	 7uuQMaoFoRT01p9b6jAjZzyuI3QIcahntm4qq8deKkMd9l1LSpgGAQ9g0VKCSXnS/Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m1sqsqf1kYlIvs8ngKwzO/KK5w/Q8VlY7tn68ctodQE=;
	b=0GuG/aCULBbeamrbjzeGqhvhacEksV2BGfMNky5okeNzXcwzYCbUC132yngU7X1LPcgr
	 6oPjMYtfNSyWr3sXDLCsQz/NYMSq4l/eSLwbAku/BCL18WIhLVR8fzkLovK5W31I1EtNu
	 aKoUlICPdqey3sspzv7QGiHXdxZRNDC4NAiBoQ4si9SNxfx8aKyhCjz8cJB+L+86w884Q
	 Up+Lf0JFmhsbuN4c7Do80Q3vnx8vHNvmLNGcKIWPbK8Nk46XXpZqH/gdBlYsWhHcfRc+S
	 QBVAki2H0YEstBn5zavQWQ6fGWW1j67h2bcuFq6uBWgsvIYceJf0Ax8YqsRbqyzhu8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HaJMCKFd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7129606A320;
	Thu, 19 Nov 2026 03:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HaJMCKFd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F361F000C4;
	Thu, 19 Nov 2026 03:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059236;
	bh=m1sqsqf1kYlIvs8ngKwzO/KK5w/Q8VlY7tn68ctodQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HaJMCKFdERHBh1pzN86fFnmNsX8i5aFA0kK5a7FhYOq1EibrIQQodWcujCwDFripE
	 Zjh5i1RRt/C6f77dk+zzg2SB2LMA/4l5N2PF4aSksohFefZRcOfA6da3n+Gg0m6t9K
	 I5Ml/qqacx5c1S0OQZLI0AXQI/+608ZBGkVHnRNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0753/1848] nvmet: bound the traddr and trsvcid configfs writes
Date: Wed, 18 Nov 2026 15:46:31 +0100
Message-ID: <20261118145948.028391288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shao Mingyin <shao.mingyin@zte.com.cn>

[ Upstream commit cf399d4abbeddc317f8160a79fefb4016c469862 ]

nvmet_addr_traddr_store() and nvmet_addr_trsvcid_store() reject a write
only when count is larger than NVMF_TRADDR_SIZE (256) respectively
NVMF_TRSVCID_SIZE (32).  A write of exactly that many characters is
accepted, and the following

	sscanf(page, "%s\n", port->disc_addr.traddr)

has no field width.  configfs terminates the buffer at page[count], so
the scan writes 256 characters plus the trailing NUL, i.e. 257 bytes,
into traddr[256].  The extra byte lands in the following tsas field of
the discovery log entry, silently clearing the first TSAS byte (the
RDMA queue type, or the TLS section type for TCP).  trsvcid has the
same off-by-one with a 32-byte write; there the extra byte lands in
the reserved bytes that follow trsvcid.

Limit the scans to one byte less than the destination arrays.  The
count checks can stay as they are so that a normal newline-terminated
write is still accepted.

Fixes: 9ba2a5cb8896 ("nvmet: filter newlines from user input")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 55057d34a4e99..beef58d9d011e 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -141,7 +141,7 @@ static ssize_t nvmet_addr_traddr_store(struct config_item *item,
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
 
-	if (sscanf(page, "%s\n", port->disc_addr.traddr) != 1)
+	if (sscanf(page, "%255s", port->disc_addr.traddr) != 1)
 		return -EINVAL;
 	return count;
 }
@@ -215,7 +215,7 @@ static ssize_t nvmet_addr_trsvcid_store(struct config_item *item,
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
 
-	if (sscanf(page, "%s\n", port->disc_addr.trsvcid) != 1)
+	if (sscanf(page, "%31s", port->disc_addr.trsvcid) != 1)
 		return -EINVAL;
 	return count;
 }
-- 
2.53.0



