Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFB32765FF;
	Mon, 13 Apr 2026 16:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096754; cv=none; b=EB4b15Am0d9aQDDZThWBuIeTK7Djbu8abmy59F0uBMoSoEFC69grKzzJmD+zBeDvNE0JZsul4NCqLjRYEITSnNdCGYxAtK6dGsrOpFKvFefoYQ+u8Ius71ARclkoM4u9fhA/EUfZVLRgLHCRT0jJvjpXlfjBG6lFaJz41iwaoY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096754; c=relaxed/simple;
	bh=FCS3r5MiBOQ5NQOYtULG18z4vH+Nhnl4uEIof6zt9Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r83rMiSv7l3ofyakZiVoSpfLEZlVNnDmGl/WLQ+RqL+aMvCo2RE85RH/F/yct3GpoTfZWZ77bMWF5noV1xlWe3jt/xjSb9M5iWcx7yrxH5KkMb2XlAORj/BffmVgD63OXm12t5WJATmvWOemfrVG3gxSLl13cuw4ULLMGcmZAOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jh6Spzxb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jh6Spzxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D64C2BCAF;
	Mon, 13 Apr 2026 16:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096753;
	bh=FCS3r5MiBOQ5NQOYtULG18z4vH+Nhnl4uEIof6zt9Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jh6SpzxbsEuFPnRTf4RiUj3/D2d8TKRDC6txtGaEi+uYGWS0bhw+cotGzdq+sciJv
	 PCAbbyVzh9v0Ta+mb2SJflUyzaMlrt6CB7Db3ZwfONXIFJEDtZ9oLmZBcXJUc7gBWQ
	 HLdKLjF0bozT6ZSpnlefRhp2V4YsV1SWjLGVv5jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Daniel Vacek <neelx@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 17/70] btrfs: remove unused flag EXTENT_BUFFER_READAHEAD
Date: Mon, 13 Apr 2026 18:00:12 +0200
Message-ID: <20260413155728.830660975@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

From: Daniel Vacek <neelx@suse.com>

[ Upstream commit 350362e95fbbe86008c240093697756d52049686 ]

This flag is no longer being used.  It was added by commit ab0fff03055d
("btrfs: add READAHEAD extent buffer flag") and used in commits:

79fb65a1f6d9 ("Btrfs: don't call readahead hook until we have read the entire eb")
78e62c02abb9 ("btrfs: Remove extent_io_ops::readpage_io_failed_hook")
371cdc0700c7 ("btrfs: introduce subpage metadata validation check")

Finally all the code using it was removed by commit f26c92386028 ("btrfs: remove
reada infrastructure").

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 316fb1b3169e ("btrfs: fix incorrect return value after changing leaf in lookup_extent_data_ref()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index f21fd8b50abc8..4126fe7f3f10e 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -39,8 +39,6 @@ enum {
 	EXTENT_BUFFER_UPTODATE,
 	EXTENT_BUFFER_DIRTY,
 	EXTENT_BUFFER_CORRUPT,
-	/* this got triggered by readahead */
-	EXTENT_BUFFER_READAHEAD,
 	EXTENT_BUFFER_TREE_REF,
 	EXTENT_BUFFER_STALE,
 	EXTENT_BUFFER_WRITEBACK,
-- 
2.53.0



