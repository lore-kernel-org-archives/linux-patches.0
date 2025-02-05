Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45235376;
	Wed,  5 Feb 2025 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767994; cv=none; b=IgYHNiK5GrsZL1o3XiSbcKFkLo4c7dmqc7JhQLpnQuXKmTffnzEVxSizgeIxfgWyfeqY8Cz0HL8HlosfQ82Txnc8R+lVxd/laRrLK8wMWWh/3pCBj3zsPY8e+rMeUX9+Em0wOsL7d6EFRhAldzA3Jwwwr2EXusxampazhxJtKBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767994; c=relaxed/simple;
	bh=H0nfNkmAGs1turu+3u/Ci96JBNDFRU6ifr+RzY6jiMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACOwYTx4oC+VLU0gbuTOfEQlRznuvxG7JrOZyYsrrX5Ku9crIzA67CRTTX9LCWbtPIY3ykzOugkDSNFvPc3eE5kLvXlaip6Qq/31rpDJzH62otWV8R9HCT1Tq9IMqDauuetVvTGbM0ASOHdd7RyvpiioYc5XJgh5jrMfTQZ6+kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSQbIclu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSQbIclu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B410CC4CEDD;
	Wed,  5 Feb 2025 15:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767994;
	bh=H0nfNkmAGs1turu+3u/Ci96JBNDFRU6ifr+RzY6jiMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSQbIcluwP3Z7XqRd6piO/hhCUxWkAomQobWdlHui4nmolYDLXe50dxG9AEIjiSAy
	 483mFl83Au9CA4qUfCRUFY+q9KNk2ljzDWNEhatUTrvjPbk20QA3vgYAhqS5SHkO8R
	 pcAhO4HBMvmnkAI3TA9aSshzh9I3FajkyBo2RSqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH 6.12 539/590] md: add a new callback pers->bitmap_sector()
Date: Wed,  5 Feb 2025 14:44:54 +0100
Message-ID: <20250205134515.893991017@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 0c984a283a3ea3f10bebecd6c57c1d41b2e4f518 upstream.

This callback will be used in raid5 to convert io ranges from array to
bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/r/20250109015145.158868-4-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Yu Kuai <yukuai1@huaweicloud.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -746,6 +746,9 @@ struct md_personality
 	void *(*takeover) (struct mddev *mddev);
 	/* Changes the consistency policy of an active array. */
 	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
+	/* convert io ranges from array to bitmap */
+	void (*bitmap_sector)(struct mddev *mddev, sector_t *offset,
+			      unsigned long *sectors);
 };
 
 struct md_sysfs_entry {


