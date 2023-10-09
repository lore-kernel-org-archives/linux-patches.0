Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09879328DB
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJMx7BRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7625DC433C8;
	Mon,  9 Oct 2023 13:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859168;
	bh=FDaoQPjhSdPMnQcWUjBq8HOPQGlkkiPNjJtTkebq4Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJMx7BRWKyF7cEujcMVb53LFKEFwBJFN0U967LO9fCUZwnDdgTaFusLyDmb4BJ+mX
	 M7Pgt9Iu1ThLZvvgLCvB1xlIUvQjWnR1ePCcPteSodds0ESIqH1YFsRsJQj+b6CFEq
	 H3g/IK4tN/U3BrPYy83lM7yYFToSRASLLiVlkGdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.10 221/226] RDMA/uverbs: Fix typo of sizeof argument
Date: Mon,  9 Oct 2023 15:03:02 +0200
Message-ID: <20231009130132.297940389@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

commit c489800e0d48097fc6afebd862c6afa039110a36 upstream.

Since size of 'hdr' pointer and '*hdr' structure is equal on 64-bit
machines issue probably didn't cause any wrong behavior. But anyway,
fixing of typo is required.

Fixes: da0f60df7bd5 ("RDMA/uverbs: Prohibit write() calls with too small buffers")
Co-developed-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Link: https://lore.kernel.org/r/20230905103258.1738246-1-konstantin.meskhidze@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/uverbs_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -535,7 +535,7 @@ static ssize_t verify_hdr(struct ib_uver
 	if (hdr->in_words * 4 != count)
 		return -EINVAL;
 
-	if (count < method_elm->req_size + sizeof(hdr)) {
+	if (count < method_elm->req_size + sizeof(*hdr)) {
 		/*
 		 * rdma-core v18 and v19 have a bug where they send DESTROY_CQ
 		 * with a 16 byte write instead of 24. Old kernels didn't


