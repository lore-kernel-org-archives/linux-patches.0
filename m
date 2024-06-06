Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D1C198E92;
	Thu,  6 Jun 2024 14:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683487; cv=none; b=CCBZhuy929gZ5YcKt/nNFtNvOc9wu8kLT+LpQBU27Qtmi3qSAi9GPlhU7jJTpUTlT4q8XrVkP7hx2KaHrEG0aFey/9Gv5aYDw8I/z9ZRW9cvdTZkrBgBpBtQvVJDSugdZbdHQPA2PZIlYuw41irmmUQIuHm09CciPCe4+pUU7eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683487; c=relaxed/simple;
	bh=FrNdciAJOpTcTXQzfRWqY9E/Z7NCNkKQsLQTIaIbSFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwX/QmHWrYKRIR/s2z6SWT5Z0E8KMkSAwizQVD7lHtWqeMFYA0VV6HnZUfP5o+9dq3BYBP0sHauSlM00XYrUAughl6bXlJNo9t8X6IznmchFudhF52YK91GmYdKGn7KPUqa9VOVSb61IYYIWOi3hCingRtIyi4/n4FFEFpezxLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lALYT9C0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lALYT9C0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2602C2BD10;
	Thu,  6 Jun 2024 14:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683486;
	bh=FrNdciAJOpTcTXQzfRWqY9E/Z7NCNkKQsLQTIaIbSFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lALYT9C0ck5B5sW1cRMyFtQ/yhOHEzhRCk+YMBKwjgKZNPGl0OIRzTLTK8xkGYpx+
	 mY05edoLD7ARkYmlGItZzeRm6owtqQaaafN4KO8k8JhddRAQym7Gx9myFTvCSGWVHa
	 m7X3y1vE+l2qTFFWBL/WGe9KT5ZxKxrW2w5DGLio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 377/473] fs/ntfs3: Use variable length array instead of fixed size
Date: Thu,  6 Jun 2024 16:05:06 +0200
Message-ID: <20240606131712.337451808@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1997cdc3e727526aa5d84b32f7cbb3f56459b7ef ]

Should fix smatch warning:
	ntfs_set_label() error: __builtin_memcpy() 'uni->name' too small (20 vs 256)

Fixes: 4534a70b7056f ("fs/ntfs3: Add headers and misc files")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202401091421.3RJ24Mn3-lkp@intel.com/
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/ntfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index ba26a465b3091..324c0b036fdc1 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -59,7 +59,7 @@ struct GUID {
 struct cpu_str {
 	u8 len;
 	u8 unused;
-	u16 name[10];
+	u16 name[];
 };
 
 struct le_str {
-- 
2.43.0



