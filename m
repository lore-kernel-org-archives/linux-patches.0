Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175B5168C4;
	Mon, 27 May 2024 19:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837483; cv=none; b=p63hFYC7KRS+eX7nMEyaZ/q4amaCix91c8ZGT7cPhAt7hHzO4LwdC5+FbwnzI/Nsvi286xPDGwmT9zGptThY6AjHJ3TutA9KUgXgEGmsp45f67m+Zk6hMwGNWkc/hm1kGC1XSAfKzbBVhXOI/JPbYe6bCaQnBXFJUfr3nZGcSOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837483; c=relaxed/simple;
	bh=WzDzTl1PAq9tMieDHQFWwZWRHZk5o8LfyhGtpJuWbqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbSoudg904cq1d3U18cwI+6YMomVhNEN/wOo6fUt4pUw34/ioFofT/d63kibUr8vnuE+om0FhaKCFYAxJLZLqap155u0ZKFa+pH0crF7ssKgELNWbuDFX8QCCS4hX000FeveGm+WJE+/WwEgyqxdvacW/g3XF4IUSwQBJ+OnBuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tcxg3UK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tcxg3UK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951CCC2BBFC;
	Mon, 27 May 2024 19:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837482;
	bh=WzDzTl1PAq9tMieDHQFWwZWRHZk5o8LfyhGtpJuWbqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tcxg3UK8aoBI60a8SA6P4JOVICPmCCg7k1eQEmgcToJ16Tcw6T5bXmKp6Ax1apb9s
	 koSz4UIrmKGF63VVXhRviITiCav/gNDQM/TFn6PCkxo/PFyAvS5hR7pHh4TPEAjluK
	 oHrYNBJlw6Nv9X2rmaAR9yvxXIV7jO4CrTu/SRIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.8 028/493] fs/ntfs3: Remove max link count info display during driver init
Date: Mon, 27 May 2024 20:50:30 +0200
Message-ID: <20240527185629.208625832@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


