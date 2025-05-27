Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F351139579;
	Tue, 27 May 2025 17:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365743; cv=none; b=FEineVHK0Na3dwTJ0PTg0XpzWiTNfdFMj5W6Yz2ksVXJk67VhY3oOAd30d3Q5TKuCZMLFZtA2jRzwbfXcg5z1FZr8yYTQis4hz7wCd+0ijPaM0CoIv53X8oj6xqC6FRuN/LHmVg7avHN4HbxUTQguKdf/mRHJWQ3X+mLeFvZW2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365743; c=relaxed/simple;
	bh=+xdlizxoN2KlhmbR5/4nYlp+eF2mun4++bAfNIT8Yrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B6j4YRpYt0S7ALJVabDyarfgHP0oVuEzwIY+mcEn3NIITL5e7uqHwR6id+5WP+s9eSN0Bt4f/ECiAnLOl+E7MEwL7gXekuM7iPKG4UvuEUKCQ92SeztcB/K2Hts+9w4Yp7YGP0FTfqN5KP4tEvAehbz4jFKKBhgmtKP+PISdu3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRikfKJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRikfKJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F116AC4CEE9;
	Tue, 27 May 2025 17:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365743;
	bh=+xdlizxoN2KlhmbR5/4nYlp+eF2mun4++bAfNIT8Yrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRikfKJHLfFSUy1DA5LXxFd30Om2JXPtytaFoUb89WA9H90ZqZA3W1pO2Fy2Q+5Fj
	 sK1IsX4C0b6+FtPfirNu1AqPsVcxnap+UjfJceR4AdBfcb0ojDrAJ9OhVoBGbnWChF
	 GD9zQ1hHP0MBclNg0VRiNHzZGWk1VQrqHd8/eUJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chung Chung <cchung@redhat.com>,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 473/626] dm vdo indexer: prevent unterminated string warning
Date: Tue, 27 May 2025 18:26:06 +0200
Message-ID: <20250527162504.210129128@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chung Chung <cchung@redhat.com>

[ Upstream commit f4e99b846c90163d350c69d6581ac38dd5818eb8 ]

Fix array initialization that triggers a warning:

error: initializer-string for array of ‘unsigned char’ is too long
 [-Werror=unterminated-string-initialization]

Signed-off-by: Chung Chung <cchung@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-vdo/indexer/index-layout.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 627adc24af3b7..053b7845d1f34 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -54,7 +54,6 @@
  * Each save also has a unique nonce.
  */
 
-#define MAGIC_SIZE 32
 #define NONCE_INFO_SIZE 32
 #define MAX_SAVES 2
 
@@ -98,9 +97,11 @@ enum region_type {
 #define SUPER_VERSION_CURRENT 3
 #define SUPER_VERSION_MAXIMUM 7
 
-static const u8 LAYOUT_MAGIC[MAGIC_SIZE] = "*ALBIREO*SINGLE*FILE*LAYOUT*001*";
+static const u8 LAYOUT_MAGIC[] = "*ALBIREO*SINGLE*FILE*LAYOUT*001*";
 static const u64 REGION_MAGIC = 0x416c6252676e3031; /* 'AlbRgn01' */
 
+#define MAGIC_SIZE (sizeof(LAYOUT_MAGIC) - 1)
+
 struct region_header {
 	u64 magic;
 	u64 region_blocks;
-- 
2.39.5



