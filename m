Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B870C142624;
	Thu, 11 Apr 2024 10:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830219; cv=none; b=sWLPbKYGfDqBFnXsqeKZtwGBM57fFJB1lUtHg4oZtKXh2z5iNNY60Us85mwYB29kY/X0P8kxQcX3ujOswiApgJ/bC/OnFuFJxPq1aCZa3qcEqrf9ZgclETTdbLjI0aZGV6rtfn+HnDxmS8ZpfUnOgtt759TXW1zU9jrpo/KapVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830219; c=relaxed/simple;
	bh=CinONC1eDjdb6R7fgi0qGJyGYBqBZPqfRCV6CROOJOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3QDnYPJosOiBJRP2cg9IplwiKtgNFZKud7JKVRxmkRT8nOUMkpIQ2aMHMqMuu7AlU08DR1FIJVMucygRLlObcOqwYdaN2BZgcYqRXmX36ghmQrQM5fSa93SGy0IsBWkXtPiA12u5K15hVyuIVT8xoVMvROsbpq3Gb2WLE3nlTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKM4+29+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKM4+29+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4117EC433C7;
	Thu, 11 Apr 2024 10:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830219;
	bh=CinONC1eDjdb6R7fgi0qGJyGYBqBZPqfRCV6CROOJOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKM4+29+f/yPbTljSviAKImItlSBrsrF8rM8XwazjhHuxPVuX32RxmFyoSH3XjR/p
	 9uXUi0FrZs/xuuKC+2BhtnOAd6avQ1fwxZz4DB88CZvHy7WQa3YLU1Ct3o41HT+krk
	 u7LDs8fspNfy6cp8Dh3/oaERFGyjmJ5PXIRG8LSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 075/143] Julia Lawall reported this null pointer dereference, this should fix it.
Date: Thu, 11 Apr 2024 11:55:43 +0200
Message-ID: <20240411095423.171513114@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit 9bf93dcfc453fae192fe5d7874b89699e8f800ac ]

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index 5254256a224d7..4ca8ed410c3cf 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -527,7 +527,7 @@ struct dentry *orangefs_mount(struct file_system_type *fst,
 	sb->s_fs_info = kzalloc(sizeof(struct orangefs_sb_info_s), GFP_KERNEL);
 	if (!ORANGEFS_SB(sb)) {
 		d = ERR_PTR(-ENOMEM);
-		goto free_sb_and_op;
+		goto free_op;
 	}
 
 	ret = orangefs_fill_sb(sb,
-- 
2.43.0



