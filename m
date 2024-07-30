Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B741A76DA;
	Tue, 30 Jul 2024 17:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359533; cv=none; b=h4j7Eyn2OEdVJAtC6I3o6iSMzfa91GTJCQEtyiIKn8b57g79Ig05qvsewHw3TqNqtHkTP1bGP3sqVJESNsS5mm+BizIgmF4q4K0sDXKN4eb9PYJ6Ty+F02jGNRl/J1cW/8YBSFL9EQ7rz8RWaWcAHrdRZL37z8GLqvWVGO5BJJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359533; c=relaxed/simple;
	bh=JrHZQGDZjgQlZ3KXbE9XUCxB5BRRnzFOAxU5A+i4UwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDqnPkrtIgBNWNvZ10ej4nQ5SrOAbpcMRzFQerLPUBALtjoLz/EJfDmTnk2BBGZwqdSu3Zdj/j8tgPWOoabqiDlXMnwxJYUs+ag07e2fuotrl6Y/RG+WrnyfgH3zPrFQZs8NC9gKROhaqFHdBsbvFLVe4dIxN7ZllJDxEMTpCJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPfGOjH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPfGOjH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1366BC4AF0A;
	Tue, 30 Jul 2024 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359533;
	bh=JrHZQGDZjgQlZ3KXbE9XUCxB5BRRnzFOAxU5A+i4UwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPfGOjH9L2IhqPLnHWauaMU1N+w2VDkjiU2YaRBfTFEUrq+h/B6ajVD4+C0RVveZ2
	 yX0RkqXhP4v86HHhDmRUg5AYbKXsHu6WmQ8kcvxndW5txtQIxgBc7oF0pKrlnAPMgl
	 ZwQ56IYTeMbmLKM2ZfVk8EyHOGQ4nwfFhPKN9WaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 497/809] fs/ntfs3: Drop stray \ (backslash) in formatting string
Date: Tue, 30 Jul 2024 17:46:13 +0200
Message-ID: <20240730151744.367107046@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit b366809dd151e8abb29decda02fd6a78b498831f ]

CHECK   /home/andy/prj/linux-topic-uart/fs/ntfs3/super.c
fs/ntfs3/super.c:471:23: warning: unknown escape sequence: '\%'

Drop stray '\' (backslash) in formatting string.

Fixes: d27e202b9ac4 ("fs/ntfs3: Add more info into /proc/fs/ntfs3/<dev>/volinfo")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 27fbde2701b63..24a134eeb45a2 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -468,7 +468,7 @@ static int ntfs3_volinfo(struct seq_file *m, void *o)
 	struct super_block *sb = m->private;
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 
-	seq_printf(m, "ntfs%d.%d\n%u\n%zu\n\%zu\n%zu\n%s\n%s\n",
+	seq_printf(m, "ntfs%d.%d\n%u\n%zu\n%zu\n%zu\n%s\n%s\n",
 		   sbi->volume.major_ver, sbi->volume.minor_ver,
 		   sbi->cluster_size, sbi->used.bitmap.nbits,
 		   sbi->mft.bitmap.nbits,
-- 
2.43.0



