Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF9619DF7F;
	Thu,  6 Jun 2024 14:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683103; cv=none; b=WDNvxKowo7X+TW5IOC3lVKb1Q1B9KUHzF1vqbcHgsPKdXxM2Vx+0DXNeqt/59V3aOIKhbxi4XNLDfRRE+7Re3Q6qBueOojiqLxqtN9Gj6GC/tcOwY3J8AnPy/eAUGaa7wOhRuDm7Gw5C4LvzweZe9EGhj/1tktX+SbCfgmqLjQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683103; c=relaxed/simple;
	bh=OuDC6pe74QFbXmV9UZNVT2XPiQVXdzGPEWAbxrxjGfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdrGuT7zQG9nzaDuVClq3i/L5QHm5Soktp2VYvfdKRAuxm045EaOX9NzTPT5ZIE9ZXURSkiRGA5pnmon4cdUsW6bSEKmUR0hFIcMirXy+wFBUKzV6Mw+VlyNya5YJN4XpXqQ3rTq9j7Jb/uQQiNrcihnoiwT6S3/75tpJrD8Ia0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAVofLmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAVofLmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8C0C2BD10;
	Thu,  6 Jun 2024 14:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683103;
	bh=OuDC6pe74QFbXmV9UZNVT2XPiQVXdzGPEWAbxrxjGfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAVofLmJ4Vu3TtR+nhJR1cqsz0Wu52BYUXF4dKprZXMwbehsBJKattuvihCZdGv38
	 dFw+eXntAeOzIl8zEeJjgpwMtFpA5pRWPP3SzLI+Wz3ZD2xcgmkStXD2+uzChcYopu
	 Pau9VEdwMffpdCwLrFppThtTLXkM2l3T4CazJVMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 023/744] fs/ntfs3: Remove max link count info display during driver init
Date: Thu,  6 Jun 2024 15:54:55 +0200
Message-ID: <20240606131733.179967166@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit a8948b5450e7c65a3a34ebf4ccfcebc19335d4fb upstream.

Removes the output of this purely informational message from the
kernel buffer:

	"ntfs3: Max link count 4000"

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/super.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1804,8 +1804,6 @@ static int __init init_ntfs_fs(void)
 {
 	int err;
 
-	pr_info("ntfs3: Max link count %u\n", NTFS_LINK_MAX);
-
 	if (IS_ENABLED(CONFIG_NTFS3_FS_POSIX_ACL))
 		pr_info("ntfs3: Enabled Linux POSIX ACLs support\n");
 	if (IS_ENABLED(CONFIG_NTFS3_64BIT_CLUSTER))


