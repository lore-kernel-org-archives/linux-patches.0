Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4A83F825C;
	Tue, 21 Jul 2026 20:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667422; cv=none; b=eLjNlWy9s/RsWnM27HvIXyrOHPycqbOWwyAIjVn1Q+2BQssJJbL0nOL+N2L6pF70SW5pPgtk1laX8KP1BxFFMZyatoyG199epnFlHDdXupeyOumoJNHNxcK2LFoy9dx/tFrlVo6aIoH9YO67W/7M9/0VBCPhSQrqtEBKi4Wo7FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667422; c=relaxed/simple;
	bh=Fv1EJj9MtNg6R1jx+RO3LKuOGrpZUw8LVcu1KnPOpmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2nXyENrW/XrGbP//ujXIi5U0WhkC430ryhGfoftn8hcIlJCXNNhiK/FWc+VGZec+NHKa6RE8nRIBaQL6JXcqmUF7ShfESvoU7LXKCTxtNFK9bOJzc3K4I39qSlqCCBKKZu00dc27RlJ1iyML5OK+yGh9LvpKPLBViptwZoABVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgDu0udF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgDu0udF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D1D1F000E9;
	Tue, 21 Jul 2026 20:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667421;
	bh=6Z2k/nPHenf+IzKOM9x/x9l0ga2zsZHlY5zcTJLRelw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgDu0udFDtGjnvDMX3+8e+BUJDSSzDCNkdRWFzk6Ol8FHHh6qUL7TjAbAoHEeikeg
	 171byQ2LD7q2yRfPXkx3BGSsgTbsy2k5aBjLFxNegVwxm4CD+l8vHHXWofcvHZ106V
	 N303OJ9LI0VFoss1Zlc8kHXoG0MqlaI9PwLisn40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 1053/1266] dm-integrity: dont increment hash_offset twice
Date: Tue, 21 Jul 2026 17:24:50 +0200
Message-ID: <20260721152505.381159521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit edf025f083854f80032b73a1aad69a3c90db236f upstream.

hash_offset is already incremented in the loop "for (i = 0; i < to_copy;
i++, ts--)". Do not increment it again.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 84597a44a9d8 ("dm-integrity: dm integrity: add optional discard support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1483,9 +1483,6 @@ thorough_test:
 			*metadata_offset = 0;
 		}
 
-		if (unlikely(!is_power_of_2(ic->tag_size)))
-			hash_offset = (hash_offset + to_copy) % ic->tag_size;
-
 		total_size -= to_copy;
 	} while (unlikely(total_size));
 


