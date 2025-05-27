Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E88327933A;
	Tue, 27 May 2025 17:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366395; cv=none; b=eBXmwqxKuzHHeKP3IlyKJO8A0WKKPDj2iHS8AHtLOU+l6+mUSoKMVteCO2M64dPDFjJK/SaI9hjYAJJE49YYWsbf/usvKYMwnrOn0dS8huFgG1mhs/KabNMHqcbQGDa7C3xpUr/jBkgZui832ynvkeK/6CQ3IN2dcPLPfGhRTto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366395; c=relaxed/simple;
	bh=GMwvu03qraqXTsDW4xRB4r7g8Bjd9scaTP9ysM2+tV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebkhNo6CnNsUrgIZ7Ny5sntX16RIZHKU/NXn4Vd+FQXa+61j1EUaXQIOLKMaG7KnIISO9c13y8sSvKqKxNfhqS9sI/HMHzwT4p3p0xsymJ4+x3KVIJLBDfdgSZhe8w14Rt8pDd/UcWfH8VaTwWX4WbFnkRXe+UikYOQHyo7COto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSop1Pct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSop1Pct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218A7C4CEEB;
	Tue, 27 May 2025 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366394;
	bh=GMwvu03qraqXTsDW4xRB4r7g8Bjd9scaTP9ysM2+tV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSop1PctqYKEs07CZ5u3vjiLuaEiQHJkSAU9sCPPULtYgXNapCVyrKEQLB7h0TLJ2
	 qwO1ScMm65KF1+cJm8BXhp+Qo2JIBM3ijqWjoXE+g1Dbu7KPVxG/GETRc9v04bQ/Tj
	 t6aH3SguHOQ0Pv3Hb/e3ud7I/X+F21ccqSKHIsBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 023/783] btrfs: tree-checker: adjust error code for header level check
Date: Tue, 27 May 2025 18:17:00 +0200
Message-ID: <20250527162514.043102939@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit f1ab0171e9be96fd530329fa54761cff5e09ea95 ]

The whole tree checker returns EUCLEAN, except the one check in
btrfs_verify_level_key(). This was inherited from the function that was
moved from disk-io.c in 2cac5af16537 ("btrfs: move
btrfs_verify_level_key into tree-checker.c") but this should be unified
with the rest.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 43979891f7c89..2b66a6130269a 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2235,7 +2235,7 @@ int btrfs_verify_level_key(struct extent_buffer *eb,
 		btrfs_err(fs_info,
 "tree level mismatch detected, bytenr=%llu level expected=%u has=%u",
 			  eb->start, check->level, found_level);
-		return -EIO;
+		return -EUCLEAN;
 	}
 
 	if (!check->has_first_key)
-- 
2.39.5



