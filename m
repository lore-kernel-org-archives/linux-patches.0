Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455FD32D7DD;
	Mon, 27 Oct 2025 18:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590949; cv=none; b=NMyAms8MNcmuY8DCeWelaah1OxO6dP48C7moyGXfJKNqnZwnbFQinN1PEArZbzSiDfRBN88y4WbJgLe8hd2RqvdAJLp8OHSQZnU75lgVBlSNF11IKsgFPkaY/eLABvEw1wi8CKgt3bxURfZJvIgDgx0bKAG35dGSP9H0El5Nux4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590949; c=relaxed/simple;
	bh=w109jyVgLvnPcMArRNbn8RI9q/Z38ivVZL+rOK7AiFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AF3gxosN8MyGvNo2CQokA30hYZQdnnimkFt4+8w4SfjPZtAwXsXC0rhXAF3e7CUMbepp60z3KVpTYsRvJZRJWIzTNZLD3UsHvhXniq5+cNxAhavHSVbcQvA9D2M13v6VBpWPl8Q+MQwqPDNBrHtLzKCn4Vjywr0J0bqssVkVNgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l73HaiEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l73HaiEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADC7C4CEF1;
	Mon, 27 Oct 2025 18:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590948;
	bh=w109jyVgLvnPcMArRNbn8RI9q/Z38ivVZL+rOK7AiFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l73HaiEFE4yxK5SIkABx5EQD9HZjryXWW77mECfcPFdXYFz6mqu7OqTyP3+MyiGrM
	 I/5gppIk9FmHFxtC9vglv6iWoDqygcSc23gm5WuK0PsASl4x9CFEWHJdONtXzimyw4
	 Mwo0vvDhepsizSnoYfHfNP4A1UD45UTQCqAvgGuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/332] dm-integrity: limit MAX_TAG_SIZE to 255
Date: Mon, 27 Oct 2025 19:31:03 +0100
Message-ID: <20251027183524.894529620@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 77b8e6fbf9848d651f5cb7508f18ad0971f3ffdb ]

MAX_TAG_SIZE was 0x1a8 and it may be truncated in the "bi->metadata_size
= ic->tag_size" assignment. We need to limit it to 255.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 07a7b4e51f0ef..6e5627975cdf5 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -119,7 +119,7 @@ struct journal_sector {
 	commit_id_t commit_id;
 };
 
-#define MAX_TAG_SIZE			(JOURNAL_SECTOR_DATA - JOURNAL_MAC_PER_SECTOR - offsetof(struct journal_entry, last_bytes[MAX_SECTORS_PER_BLOCK]))
+#define MAX_TAG_SIZE			255
 
 #define METADATA_PADDING_SECTORS	8
 
-- 
2.51.0



