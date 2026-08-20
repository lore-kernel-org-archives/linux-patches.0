Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6091247A0DA;
	Thu, 20 Aug 2026 16:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243560; cv=none; b=A59MVqWj12YDISGKyixWMxb2AyxLQqvxbPaB5Ig6gfs+EC6eRScz7qiDCASMCeYWdR0EwNkxMhBT9FUl0FNsjq9rnxS1eiWV15mahiwxaM9xs5dkl7MQj/bQnxS0C/obWVX5EE2GtpC6Xebbg9jo17WYEx6FvxaBrpAfLf1LN6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243560; c=relaxed/simple;
	bh=7pPv3G0vUhfy12JZzeLuDyGlTXddmYpt+OOfB3GReSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJ0MUdSihGNtg0ZuSYQHtGgfMyCRBlECR9kOo20qfxdK0ELNjavBemVoULbg5Jg/DlmlZm0DglROQM4zb3TjYBe8IkCxIPJ5M6BR2oEGw1gjNjADU6GI/ho6gm6o/aSBu/+h/MIDa0obZygy4uBVD8Hi67mtJUa6pjqGUl8uzHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCQ88/yF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCQ88/yF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E871F000E9;
	Thu, 20 Aug 2026 16:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243559;
	bh=umenswpA7EpbryVC3thTF+DXu3PZZ7WGooPxjAj0heM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fCQ88/yFyxPhB5mXVDbL+k8dd62J7WLiL7L13E9R6SgO9bBGP45QdRHD25zm+1qTI
	 NjbNywOQrPasuHygTf51fNcI6zJcK3WhQaK4ySuHIO1IP+k1MaZUNQY+yGrv/xncX4
	 ELVfGKNPto/Ex/q+Zd7iu0YWvjacfaln7Wt0/Feg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/272] dm-integrity: dont increment hash_offset twice
Date: Thu, 20 Aug 2026 16:55:20 +0200
Message-ID: <20260820145235.355104675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit edf025f083854f80032b73a1aad69a3c90db236f ]

hash_offset is already incremented in the loop "for (i = 0; i < to_copy;
i++, ts--)". Do not increment it again.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 84597a44a9d8 ("dm-integrity: dm integrity: add optional discard support")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1474,10 +1474,6 @@ thorough_test:
 			*metadata_offset = 0;
 		}
 
-		if (unlikely(!is_power_of_2(ic->tag_size))) {
-			hash_offset = (hash_offset + to_copy) % ic->tag_size;
-		}
-
 		total_size -= to_copy;
 	} while (unlikely(total_size));
 


