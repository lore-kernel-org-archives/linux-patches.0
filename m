Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC752BF3E2;
	Tue, 10 Mar 2026 11:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141074; cv=none; b=agZlwgOwnO7kV/Br3pT0d8eru8OunNOXECuJvAgpeKgz1K3SdecD6PBS7tD5wA7evTlraWcQovEO06pgRfd9rnOZ+jQxDihpS68ZwMvcA3gBcdW+Zym8nQ0sn5EKAM651OVCFzuWsb/lHruMfmwM92jylWSclPhlP0lFwswpoCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141074; c=relaxed/simple;
	bh=MS1c82gY7zVCjfVR1o/3e7QRVFI3I2FAacK9UIiZgto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1CHxZacfezphta8iLZYxd8SwQ8c5sGa04EHPpzcgVy+qQdiyUMgZ2pIK2DN3vUq/LpnGyJNUvUCWziqlK6U/mHms8fe1zEQnvQZZssS7s9Z0/twcAvvNO7jjaFyxPvaPuLVxzgwYxaMrZWVWcQgYFP00mlG3jwvoclZ0PoLSxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SucU2Cy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SucU2Cy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DC8C19423;
	Tue, 10 Mar 2026 11:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141074;
	bh=MS1c82gY7zVCjfVR1o/3e7QRVFI3I2FAacK9UIiZgto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SucU2Cy5bSQvwHuXfHLL0Ty1XgL1XKvr1KK4PtT05fg47PPIJpk+gvgi8bXBfM5aP
	 R282z8+rJ7yJ4m9KoAQneqQFa5fxU4oCfPffVH9bVNt/0LLnJ4c7XX1qPOQ9xus8lg
	 6ZwoiI0nNHyDFM1SrgawxBvk/NoANS/doRN/U0R57/7m63ygzfPSvV0tAPTsVRP2OS
	 l16Nnxz2nVoNj3t/m5d5MEKK119XAlOHKJvyY4ZNscee+jMyBRjkwZmBYEpGw3X3n8
	 aULPsd55qNhKxtiyPPY5rD3AfX5awE6vNe5DQbNn8RL8jq9bYMWcDkYBHnpMITZspT
	 Xv1b+cYMEnvWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Chris Mason <clm@fb.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 074/311] btrfs: fix incorrect key offset in error message in check_dev_extent_item()
Date: Tue, 10 Mar 2026 07:02:01 -0400
Message-ID: <e6ced9b4d95e6be0b73793705751e0181dee3425.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 511dc8912ae3e929c1a182f5e6b2326516fd42a0 ]

Fix the error message in check_dev_extent_item(), when an overlapping
stripe is encountered. For dev extents, objectid is the disk number and
offset the physical address, so prev_key->objectid should actually be
prev_key->offset.

(I can't take any credit for this one - this was discovered by Chris and
his friend Claude.)

Reported-by: Chris Mason <clm@fb.com>
Fixes: 008e2512dc56 ("btrfs: tree-checker: add dev extent item checks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index c21c21adf61ed..6d4dceb144373 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1893,7 +1893,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
 		if (unlikely(prev_key->offset + prev_len > key->offset)) {
 			generic_err(leaf, slot,
 		"dev extent overlap, prev offset %llu len %llu current offset %llu",
-				    prev_key->objectid, prev_len, key->offset);
+				    prev_key->offset, prev_len, key->offset);
 			return -EUCLEAN;
 		}
 	}
-- 
2.51.0

