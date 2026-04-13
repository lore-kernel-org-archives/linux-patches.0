Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0F7327C1D;
	Mon, 13 Apr 2026 16:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099319; cv=none; b=DCD4nSlDanwTZcwvp/NK6/DV0nLXKtB6bozpmY5bqgFdpxraldEdJH79YjppYdQU0F8zXprJ8H4hW1tn0xO7YOwsONRiULJfpgkdQMg08O5EkM/boeU4oZ1yuw7GN+TnBe6D75Dm0tLXmCF0UsMvLNSlUKGW/qttGA8pN71FZLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099319; c=relaxed/simple;
	bh=EIpapzGe7G3BaZxIYLLGCCpnHItrlhadzNsEWASwLHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kcq5V+NLaI/ou3+4O4EysxVHrBB23ZzgXKg79DjVh2b3G4CtJc9ipzfmWEBDce4hMy/QOb9Eak6WPFYoTLJWnKwW4mlsyiBw4w9WrzzFW813Khc0G7vUVMo1K/lZg/YZSvNDh1JBS9k1Q9mhNdqMv+z/m3E7xHyZjTOyv2h+dBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGiaHxEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGiaHxEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890B1C2BCB8;
	Mon, 13 Apr 2026 16:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099318;
	bh=EIpapzGe7G3BaZxIYLLGCCpnHItrlhadzNsEWASwLHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGiaHxEd3EWOR21sHzKnmRuATTsJGdELHgepSFRUTpn629J5W5DvqBlf3lB9flaXJ
	 k3axrQcRLEAGoGfXMzvUEMnFcPsAyJ/5T4ZQ5S8S9u+EGlKzeo+p35iMwH9dyiNMS/
	 Qs38v2cPmp1/Va6J05Gq3UbqliOlyCEP0lN/nyDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 295/491] s390/barrier: Make array_index_mask_nospec() __always_inline
Date: Mon, 13 Apr 2026 17:59:00 +0200
Message-ID: <20260413155830.088738391@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

commit c5c0a268b38adffbb2e70e6957017537ff54c157 upstream.

Mark array_index_mask_nospec() as __always_inline to guarantee the
mitigation is emitted inline regardless of compiler inlining decisions.

Fixes: e2dd833389cc ("s390: add optimized array_index_mask_nospec")
Cc: stable@kernel.org
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/barrier.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/barrier.h
+++ b/arch/s390/include/asm/barrier.h
@@ -56,8 +56,8 @@ do {									\
  * @size: number of elements in array
  */
 #define array_index_mask_nospec array_index_mask_nospec
-static inline unsigned long array_index_mask_nospec(unsigned long index,
-						    unsigned long size)
+static __always_inline unsigned long array_index_mask_nospec(unsigned long index,
+							     unsigned long size)
 {
 	unsigned long mask;
 


