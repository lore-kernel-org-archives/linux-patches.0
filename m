Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7617E16DEAC;
	Wed,  3 Jul 2024 11:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005033; cv=none; b=XKZkcrowcT3Q/Ppayum1W8UZrkFNEqfWJ3KJz1+78nedwvkuewSKIjRAKCvRSnUY2NYTVkbORrWNa1cJNM2JufESMfioEliKU0EuQaMnVVS60BWeYOsHKl7cGv5HPqIiF9OY5J9EOLeneVkQdEebAJcwOgIrvyBj8Avgge/UepA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005033; c=relaxed/simple;
	bh=S6JaHazxBOlaVdlT0mcHwoVdyeyFzTrOVhP3S84EGKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPFIhHeqqJDce6S9n9G+wzHIjsEDBuaUkttJHKoA+9VkwbJ7jZ8StKfkaiVeVQf93jRvWTGR42eQHZ+6BX4mGmANdI8KrrhFo/LyFJgKxiw7vbFPckJ+PaApf+jo4Fhc+0rZDNkEes7nDoFIE7aEeGK2DbUuztZ4O8whR5n4I/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kzs1uIz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kzs1uIz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4465C4AF0D;
	Wed,  3 Jul 2024 11:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005031;
	bh=S6JaHazxBOlaVdlT0mcHwoVdyeyFzTrOVhP3S84EGKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kzs1uIz9xPJPBn0FPvHvn+EEQfWau+ofSn6xVIdpc0Yx6hcFaH/BKe/8tSqQjbgas
	 /Z//U/l6Ycg/CBOOB39W4rIDpU7ufvNPemeVWJzdeZ2LMU7oJr1sTNF0Klh2gSNjU0
	 ETTYq8uKuGTAwrSSWI/xKhZmWInxCSmwdgphQDzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/290] nvme: fixup comment for nvme RDMA Provider Type
Date: Wed,  3 Jul 2024 12:40:19 +0200
Message-ID: <20240703102913.140219973@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit f80a55fa90fa76d01e3fffaa5d0413e522ab9a00 ]

PRTYPE is the provider type, not the QP service type.

Fixes: eb793e2c9286 ("nvme.h: add NVMe over Fabrics definitions")
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index f454dd1003347..ddf9ae37a2cce 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -71,8 +71,8 @@ enum {
 	NVMF_RDMA_QPTYPE_DATAGRAM	= 2, /* Reliable Datagram */
 };
 
-/* RDMA QP Service Type codes for Discovery Log Page entry TSAS
- * RDMA_QPTYPE field
+/* RDMA Provider Type codes for Discovery Log Page entry TSAS
+ * RDMA_PRTYPE field
  */
 enum {
 	NVMF_RDMA_PRTYPE_NOT_SPECIFIED	= 1, /* No Provider Specified */
-- 
2.43.0



