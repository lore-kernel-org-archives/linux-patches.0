Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8353C33A6F1;
	Wed, 30 Sep 2026 19:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795152; cv=none; b=pO2EtHkWXKdOPJgUBP6LKnoIMJY7SYSagYVw4yRZfAIJkz1IEGPl9HVs43Xvwm/f6DMZ16ez8WYpAXUVpdIGTaILhoA2Tj53wgLX0vmC4KOvnA4ZbUKG403/bottrwwZjEvgdZpm2MVTjafRAuEzdsSVi6B6aaDGCpHPZXOrQmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795152; c=relaxed/simple;
	bh=vZabMeFOdVDKMDMBjMY93hPWMik1RewwF0uULadQBVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ4alqo+ydmM64OKt7vpUwFGk6Ea3oc5ewFejaumHmYXY9SfIAOyreni6i57VNh6A1UChdXqrpLqQYCULNDHGsqNfn4gvwDd2TBoHkZIG9LAf9Xk1/Hh7c3eMNo1B7wZMYf5ExSZQF6kNpZU0KGpd/rbPGDKq6GlEH8VgRISQto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ortLluJA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ortLluJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5671F000FF;
	Wed, 30 Sep 2026 19:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795151;
	bh=DKkqOcsA6r50WTRxnvjfr+O0WBnSoy7lD4U8vm6UKWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ortLluJAi56tEUsHGNH7NubzvaPqR6UTDenejjnLeHXucYbehX0BvLceROf1hX544
	 Oc3iYJbhcyyecrVcIADVdcsxHm2HhP+qm0YJBxb9KjubYSjKtz/LIC30JHAIWiMZCc
	 F6Pz2IpfvM62nDrWHkwZbD+LW9o8cCBskA8QYIMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0459/1193] btrfs: directly return 0 on no error code in btrfs_insert_raid_extent()
Date: Wed, 30 Sep 2026 17:19:03 +0200
Message-ID: <20260930152444.370922805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit b8212814d1e8428a082234223105e4071b844fab ]

It's more obvious to return a literal zero instead of "return ret;".
Plus Smatch complains that ret could be uninitialized if the
ordered_extent->bioc_list list is empty and this silences that warning.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: afbe73778338 ("btrfs: fix the possible bioc_list memory leak during error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/raid-stripe-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 38917236bbb95..7fe5adce9a100 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -82,5 +82,5 @@ int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 		btrfs_put_bioc(bioc);
 	}
 
-	return ret;
+	return 0;
 }
-- 
2.53.0



