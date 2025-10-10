Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E7A28314A;
	Fri, 10 Oct 2025 13:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102476; cv=none; b=SbuyUxoZbASVubwo3VSYeqC+HuePF/Z5FE8U4rb6zYbJMh2VuY15E3cGbm6WFKLeIVrotpGDbimn0V4IgKoI+R3UeiGXKqaXZ0TRNPWfcjs4dX9vfEwZ/PQhketdyJ0s+L6PS8BHqpOoSI3h6vHPUWdcXJYbirDBZFGciOUtreo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102476; c=relaxed/simple;
	bh=L8bYTKMgT9RRvfGfmGinHqHIVUzpy+yX+WR6EjQfzP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zk1yn8a+kbb8teoQjC4lMi81oBDnWxEasnhplkNJkY5dZO4HdVgokPLVmPQMGBQiiudziS8HItL30Q50st1vZYlS20W6EdZqn7RArH5TwfXGGgZoxrIlqAiIfRMI5tK9gsPqh1LduUixHHIAvCm8gaKKbmspyalfkLOpWHx+JvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFK8w1us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFK8w1us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A10C4CEF1;
	Fri, 10 Oct 2025 13:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102476;
	bh=L8bYTKMgT9RRvfGfmGinHqHIVUzpy+yX+WR6EjQfzP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFK8w1usa6v/LZ4K8URnKpT4KNEiYqbNWPDMoEvWNXatF+9g8cwmCiPOx15yVB31m
	 hJE0QcLci1gRCAL74rYOlTAZtnze2U1Lr+8jhsz1xZFi6mS9D7A38ddasN2kNjZ/Xk
	 6RUxM6jpmAZkNxeP9SOxErP58iTn/LSeqiQYhJUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 09/35] dm-integrity: limit MAX_TAG_SIZE to 255
Date: Fri, 10 Oct 2025 15:16:11 +0200
Message-ID: <20251010131332.129620964@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 450e1a7e7bac7..444cf35feebf4 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -133,7 +133,7 @@ struct journal_sector {
 	commit_id_t commit_id;
 };
 
-#define MAX_TAG_SIZE			(JOURNAL_SECTOR_DATA - JOURNAL_MAC_PER_SECTOR - offsetof(struct journal_entry, last_bytes[MAX_SECTORS_PER_BLOCK]))
+#define MAX_TAG_SIZE			255
 
 #define METADATA_PADDING_SECTORS	8
 
-- 
2.51.0



