Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D428118CC1F;
	Mon, 28 Oct 2024 06:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096931; cv=none; b=G65t4OiUC5edWQvbSGrXSF6wJvt9EEhfaKSX9ijJYlh3dVLQ0DgTWhs4wpcvaiAnG73OzDtvSbavz5i8vVGJ6nuRtfCDjoosB58UNvw29+XoddfwHV2LteEBc//OrMf4kHF3KraW2ym/zKfHOUUNgNcKd+vkSmULUqkzRFFbZ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096931; c=relaxed/simple;
	bh=Nl/sCs4zlKlDVkfk5i/DCF1lYYGRrfFnDySNl4p09R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0dnMD38kk+J09tCFfhEibJ075dEj874QzVsgk+echSwiUE7p2XgZ8+9xAO9S0ZjrS9hscOBuB0ICZFjAjLnDfaOhLGxlMWSeZus4tXMMPyBErF/Y14/fibeJaRBfkxBvVl1ZKvi21zvlS5vY5jZdBa/QSPVMQg+1OYhHT++Fn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJLHcGaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJLHcGaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7729CC4CEC3;
	Mon, 28 Oct 2024 06:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096931;
	bh=Nl/sCs4zlKlDVkfk5i/DCF1lYYGRrfFnDySNl4p09R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJLHcGaM8cwEJmTd+lttvk6MAaaWbqpQd/ipWLVaNYolNoA4QeQRH0v7MFmWXbeaU
	 iV1H0zNb8Srj+Mnr4tgQNho1T5uSxTLuylc8IoDqrTkjN6cK4ULglfCIxAUjWYbL61
	 sPsUJwS5+vYNrQ1yiZBA32JG3BS6FNJC5VIjBRwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 50/80] jfs: Fix sanity check in dbMount
Date: Mon, 28 Oct 2024 07:25:30 +0100
Message-ID: <20241028062254.008705219@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit 67373ca8404fe57eb1bb4b57f314cff77ce54932 ]

MAXAG is a legitimate value for bmp->db_numag

Fixes: e63866a47556 ("jfs: fix out-of-bounds in dbNextAG() and diAlloc()")

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 2c8905391ad3e..3fa78e5f9b21e 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -187,7 +187,7 @@ int dbMount(struct inode *ipbmap)
 	}
 
 	bmp->db_numag = le32_to_cpu(dbmp_le->dn_numag);
-	if (!bmp->db_numag || bmp->db_numag >= MAXAG) {
+	if (!bmp->db_numag || bmp->db_numag > MAXAG) {
 		err = -EINVAL;
 		goto err_release_metapage;
 	}
-- 
2.43.0



