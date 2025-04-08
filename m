Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C4B26A0A7;
	Tue,  8 Apr 2025 12:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114407; cv=none; b=st16NGduHEkyUpK6ea0U0DTvqIh4sXgdo47oZAIxX7vaows02BqsMUDjTbYmUVDXuo+UaO6roFChhypvW7gipdBEtCZpUgxGmBpmIeop1lAKXxD8TtPJt69TuEs7SEZx7IM6hpxVUxOxlFAsHLxuPRz8xNL1HleNfgJzX3QDgts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114407; c=relaxed/simple;
	bh=V51c3etzpEp54deyUUWto8RLLSSoUzdR0XyY0kKCyyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qt+Td2rdBBx33cmwOC7NdIRV9VEmurElfYzXB5SuArm/TRlx5DgP50Dh2oNvn5192J5Omf5V+BmuJ/lBaa+7EqHV6OGGQjVeTVOBVYuqwzOQVEymNQBsUg/snHJqaND3xnbZ8DpBxJg1NlJNLYc/TiZhK6k3IG1xIJJRA3C3ACs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvKC2YYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvKC2YYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BA4C4CEE5;
	Tue,  8 Apr 2025 12:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114407;
	bh=V51c3etzpEp54deyUUWto8RLLSSoUzdR0XyY0kKCyyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvKC2YYZVNqjjYO+8Fhg4IC8aSHMCw1TLq1sPeGJkq61qAkCQsxRtxvEr2ENJtdpq
	 rrCAMfpTRIAQ6+6K7UH1r8SpgJg55TVukQNLktx4U0lEptxeyVbRKcK43Ltm+MSELy
	 SERCvzR8QHAoa3cgEMv5u6fzAQBOB+mn19I9d/Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 096/499] drm/panthor: Clean up FW version information display
Date: Tue,  8 Apr 2025 12:45:08 +0200
Message-ID: <20250408104853.612320726@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Price <steven.price@arm.com>

[ Upstream commit 3b87886bfb038de2c62e627079472ba612e89410 ]

Assigning a string to an array which is too small to include the NUL
byte at the end causes a warning on some compilers. But this function
also has some other oddities like the 'header' array which is only ever
used within sizeof().

Tidy up the function by removing the 'header' array, allow the NUL byte
to be present in git_sha_header, and calculate the length directly from
git_sha_header.

Reported-by: Will Deacon <will@kernel.org>
Closes: https://lore.kernel.org/all/20250213154237.GA11897@willie-the-truck/
Fixes: 9d443deb0441 ("drm/panthor: Display FW version information")
Signed-off-by: Steven Price <steven.price@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250213161248.1642392-1-steven.price@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_fw.c b/drivers/gpu/drm/panthor/panthor_fw.c
index ecca5565ce41a..5e002116f2bbd 100644
--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -647,8 +647,8 @@ static int panthor_fw_read_build_info(struct panthor_device *ptdev,
 				      u32 ehdr)
 {
 	struct panthor_fw_build_info_hdr hdr;
-	char header[9];
-	const char git_sha_header[sizeof(header)] = "git_sha: ";
+	static const char git_sha_header[] = "git_sha: ";
+	const int header_len = sizeof(git_sha_header) - 1;
 	int ret;
 
 	ret = panthor_fw_binary_iter_read(ptdev, iter, &hdr, sizeof(hdr));
@@ -662,8 +662,7 @@ static int panthor_fw_read_build_info(struct panthor_device *ptdev,
 		return 0;
 	}
 
-	if (memcmp(git_sha_header, fw->data + hdr.meta_start,
-		   sizeof(git_sha_header))) {
+	if (memcmp(git_sha_header, fw->data + hdr.meta_start, header_len)) {
 		/* Not the expected header, this isn't metadata we understand */
 		return 0;
 	}
@@ -676,7 +675,7 @@ static int panthor_fw_read_build_info(struct panthor_device *ptdev,
 	}
 
 	drm_info(&ptdev->base, "Firmware git sha: %s\n",
-		 fw->data + hdr.meta_start + sizeof(git_sha_header));
+		 fw->data + hdr.meta_start + header_len);
 
 	return 0;
 }
-- 
2.39.5



