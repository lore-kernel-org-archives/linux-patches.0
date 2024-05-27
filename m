Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADFA15FA85;
	Mon, 27 May 2024 18:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836383; cv=none; b=uyST2FiiOb7CU62ri3ypqWMoogG8P//5gEf7YC0uytttiZUDZ/dqYDULIl5b1VfbZsKprEL7A1cVwvH900YjhltyR4J9EO5OptytTZprsT4Y3JVQHCUfD8yd0DiRUixHU0q2FP7b7kHbppa0ziDSuMPnGdCGXdhbWoHyFUSouGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836383; c=relaxed/simple;
	bh=CmkwJOxtOOHH2nbFEhBuV+5R9uUel8AftLjPHweXtJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUQSAfkAvQwe5CHjtInlbIJGVSOqh4zU/JSv7wbj3Mxkw2SZeqS+MO3PSgq2FbCpyi+o/noBG99DWYw82PICDQNQtXc0p6YOJeOuEvGa4GBxjWuQihFB2uELZ7EgVw8/0tBUi9ywd0VjbRbtJZaru27si8KHVWLFCbWZv4x7Y/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvowGlKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvowGlKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A334DC2BBFC;
	Mon, 27 May 2024 18:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836383;
	bh=CmkwJOxtOOHH2nbFEhBuV+5R9uUel8AftLjPHweXtJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvowGlKvbuN4D9KgeersNYYUU0ccTH8WBapfA1e/o0pa+XiIJZfNuHf48xwBE1Gye
	 rMj1X5m47dmDgaWqyhTNj3ialGaLCL3OrCzxqIOlVbYxz62OAEcu/VmxU7RDqrhztj
	 wNjbM00IrlWvRzjbePGExTmZH+IYkicBFmv2Q2j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.9 031/427] fs/ntfs3: Remove max link count info display during driver init
Date: Mon, 27 May 2024 20:51:18 +0200
Message-ID: <20240527185604.596766721@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1861,8 +1861,6 @@ static int __init init_ntfs_fs(void)
 {
 	int err;
 
-	pr_info("ntfs3: Max link count %u\n", NTFS_LINK_MAX);
-
 	if (IS_ENABLED(CONFIG_NTFS3_FS_POSIX_ACL))
 		pr_info("ntfs3: Enabled Linux POSIX ACLs support\n");
 	if (IS_ENABLED(CONFIG_NTFS3_64BIT_CLUSTER))


