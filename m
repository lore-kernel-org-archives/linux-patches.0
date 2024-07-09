Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAB8155389;
	Tue,  9 Jul 2024 11:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523622; cv=none; b=Iu9VEjRioKLaIsvzPmkbfcg8i7SJUs0gk68uceCBpPg58NKuHl2uf/MsZkOtGuXc7GUDYzSiUKW2Fc02yv5cBebNTcm4JN7+R9ifRvzwlUuZSOal2O2gv355VRvIhf/QX44xdQ5q8oLgbmZj15dKSgVKAGUgABVMjFIwUIY0bIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523622; c=relaxed/simple;
	bh=alg29UIv2mHmkPNDgTStbx428aqtM/oPlphXlMGnLx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SGJVOL6lPaGUqZuqODei/HFXcjTC8NdqYky9oTvJQjhJRa/Ica9zK63rYusAUr3PEB8WolIHHTLyTXpDP+/KU70iXdi26dQkh0dBBHU9BUnC1GGruBr8kEjhOiLNdEI6TfzLruwcIn0DNqRajLHn+ZU49U0/MHF1KjYkeh+tqAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/9LwFp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/9LwFp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450F9C3277B;
	Tue,  9 Jul 2024 11:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523622;
	bh=alg29UIv2mHmkPNDgTStbx428aqtM/oPlphXlMGnLx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/9LwFp6V44UG2lMQqzC0Lk9XJ89SzNO9zhZL7Pk0iKwoq6SSzrI3Jt2bkazXCBF8
	 tQxjTTddVVkp4GdIVw+OQsFzZpbT5BAzkP7jq0BFnKKENctHRlHs6A+HPn8hNzIC+R
	 /g5ByzfR0gWF2yBsfl/jNpiNHVoHe5d9aQF0JBfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Lu Yao <yaolu@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/139] btrfs: scrub: initialize ret in scrub_simple_mirror() to fix compilation warning
Date: Tue,  9 Jul 2024 13:09:15 +0200
Message-ID: <20240709110700.296416140@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Yao <yaolu@kylinos.cn>

[ Upstream commit b4e585fffc1cf877112ed231a91f089e85688c2a ]

The following error message is displayed:
  ../fs/btrfs/scrub.c:2152:9: error: ‘ret’ may be used uninitialized
  in this function [-Werror=maybe-uninitialized]"

Compiler version: gcc version: (Debian 10.2.1-6) 10.2.1 20210110

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Lu Yao <yaolu@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 819973c37a148..a2d91d9f8a109 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2020,7 +2020,7 @@ static int scrub_simple_mirror(struct scrub_ctx *sctx,
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	const u64 logical_end = logical_start + logical_length;
 	u64 cur_logical = logical_start;
-	int ret;
+	int ret = 0;
 
 	/* The range must be inside the bg */
 	ASSERT(logical_start >= bg->start && logical_end <= bg->start + bg->length);
-- 
2.43.0



