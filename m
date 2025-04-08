Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70174224F6;
	Tue,  8 Apr 2025 11:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111135; cv=none; b=drY/0zPcQIOqIa4ec3wLLoA7sUcJhWj4qF957Uqc10eQLOu8Ile/Hpn+k4Jkv9m8jtVPQYHPAZ4stgfEF1KcWR/XSL8Hfv/7t6mUUQJ3VZnq1gKzOeXvTTT7WxgAzrnExa7cngtw7kHkmGXHejI0V9+OYGFeUVVL2V0lZ6I1tIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111135; c=relaxed/simple;
	bh=mBK7ftn9spvpX1jXgG1l770MSf1YvTdX2SV8x4b/K1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDnzjDIORMyAKOvEKKcJXxtOiiVRAaVTKAgCilLMbjg3ywjgbfc5FlYZUdDiCfAdk6FOIuhTbMCdDi/GnqwzoeEn3i673isMPdybfaLlJBN7CReY1rTil1ixyzewtVv/QlzVB733YRkBzHzfXEdkwNxMB9FyDSsWFafjfrzIicA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGIsEXqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGIsEXqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AE0C4CEE5;
	Tue,  8 Apr 2025 11:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111135;
	bh=mBK7ftn9spvpX1jXgG1l770MSf1YvTdX2SV8x4b/K1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGIsEXqtc03VtQr+bP7m9GWqSx0xyRmt3yIG8PWZor2ELVjCjWc/ckUHYhFoEoP9F
	 s3gXGTVhRA3YsXT4/GALEfUecBx3s3xUhH60RenM7U/zYylj5bQ0ytDDDt1PIj8Qv7
	 aDBAI8lKMzIDiqy6mQs3Im5H3BdT6fD12B4jNfRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 321/731] drm/panthor: Clean up FW version information display
Date: Tue,  8 Apr 2025 12:43:38 +0200
Message-ID: <20250408104921.742368037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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
index 68eb4fb4d3a8a..a024b475b6887 100644
--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -637,8 +637,8 @@ static int panthor_fw_read_build_info(struct panthor_device *ptdev,
 				      u32 ehdr)
 {
 	struct panthor_fw_build_info_hdr hdr;
-	char header[9];
-	const char git_sha_header[sizeof(header)] = "git_sha: ";
+	static const char git_sha_header[] = "git_sha: ";
+	const int header_len = sizeof(git_sha_header) - 1;
 	int ret;
 
 	ret = panthor_fw_binary_iter_read(ptdev, iter, &hdr, sizeof(hdr));
@@ -652,8 +652,7 @@ static int panthor_fw_read_build_info(struct panthor_device *ptdev,
 		return 0;
 	}
 
-	if (memcmp(git_sha_header, fw->data + hdr.meta_start,
-		   sizeof(git_sha_header))) {
+	if (memcmp(git_sha_header, fw->data + hdr.meta_start, header_len)) {
 		/* Not the expected header, this isn't metadata we understand */
 		return 0;
 	}
@@ -666,7 +665,7 @@ static int panthor_fw_read_build_info(struct panthor_device *ptdev,
 	}
 
 	drm_info(&ptdev->base, "Firmware git sha: %s\n",
-		 fw->data + hdr.meta_start + sizeof(git_sha_header));
+		 fw->data + hdr.meta_start + header_len);
 
 	return 0;
 }
-- 
2.39.5



