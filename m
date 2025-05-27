Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7B8271476;
	Tue, 27 May 2025 17:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368068; cv=none; b=KRuoxVsVlnzxWf2+hMV1BaFiYzvbLqRimno7TnPQrnyfPcHErpWmZ8t78oOZs78hoMB1HGqi04ziC0J7C8P4w6Dw2ydETkaqKy9+YYJw/+qWbvy4Ix04u4hCPxQ7Z5U0TaqQk3krIwFbXNzUUaFSlLJnexpXTFztKtF803fl0Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368068; c=relaxed/simple;
	bh=89UMIw1VMkuUc99xaMLqPKHPQURPAjSbliTIPXRKXUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LPH3ekYI3wkxGmhRw7fvzSzTK9uSrf88waMXkgfEEdEurV5fABP6/4zFmWMoKIZqS5fcoYEYBb2jxmE5//uPYnFJMDm9jjzXHHxbqGiqsZQJ3ItwRpv6OMOsSMZwmTujKryiyw22eLxfZrQFFlxt40J9PVoZuiSn8Z3GeBBxXuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyuoGNI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyuoGNI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357D0C4CEE9;
	Tue, 27 May 2025 17:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368068;
	bh=89UMIw1VMkuUc99xaMLqPKHPQURPAjSbliTIPXRKXUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyuoGNI7ufPRJSnmSl/gnbazL35+v3AutGHAN8DjcbgYO0P1L8PhQtOsvX7tkUGAj
	 ammuaCOTlC9j1gTRqvj4oFJLoCrWa0YvYvT4mcNHXr2lth69jaJzjlspNvSwD/yruv
	 30MURzwVyhvYyW0e+zg5pKK0z9bDwGt69t/+qfCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chung Chung <cchung@redhat.com>,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 589/783] dm vdo indexer: prevent unterminated string warning
Date: Tue, 27 May 2025 18:26:26 +0200
Message-ID: <20250527162537.120994185@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index af8fab83b0f3e..61edf2b72427d 100644
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



