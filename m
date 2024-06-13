Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABBA1EEE0;
	Thu, 13 Jun 2024 12:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282392; cv=none; b=bLKl76enfTldSipAx5yaAKYqUTMaGwJ8eIY4LneqNEAeuzxQYugGzqqjUNlQZl3j4N1Flv+NcqiTUNgPmWaXE/SdPxB5nqz1ZExzDb0xEDggAC6uGALIc2MVXrPA5npKvvmLCCbVp2RIZdwIve0xzFqprHl5FKmwP+uvBYxGsLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282392; c=relaxed/simple;
	bh=ixyVLFtdvkQVtXy+vYMIvYYl3yBBJI3vuPWQUkANr88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxaoX2S4oRixag2lTE0jYBpl9EiDenDTX342ZZqU+SwwZa8dGD8TfMRTQ7nY0lGED4tunp3uYOmDQFWv5sAOmsqJLcA2+DOXj3GjCf3yKDGqSkXdhXjjjTNDdj7euRAQ+XErpeDbN4Inx9d/SJsDcpL5Noc/c9sP95iDdmzg+xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tr7Ot95n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tr7Ot95n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1274AC2BBFC;
	Thu, 13 Jun 2024 12:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282392;
	bh=ixyVLFtdvkQVtXy+vYMIvYYl3yBBJI3vuPWQUkANr88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tr7Ot95nrjHfKrgQGuBZXqbkf0Roq7BGTKJtPL5pt2Twr4h60rRRwwyIF/mCgF/8j
	 aCXN8upTDzPxgt/4RhZKsgYHfhd4saF92waJpCvZtCYj3OXEhYV06FJYWCdP0aMn9b
	 f2lXkxOTKkp2Qpcg3WP82NNIRHWan5Dg/43qTJkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 262/402] fs/ntfs3: Use variable length array instead of fixed size
Date: Thu, 13 Jun 2024 13:33:39 +0200
Message-ID: <20240613113312.372383634@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



