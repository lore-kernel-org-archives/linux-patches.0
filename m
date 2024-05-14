Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09607320F;
	Tue, 14 May 2024 10:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682906; cv=none; b=FUadf7Pq1mGiP1ME9H8m0Me8wWwU762af+HktXa797v5m5oJnZ7FWq9qv9XpuEaEG3qs5IASXvm8wjwwkA0mplmwQP4fv5sUVoAiCZd+xZubRdUJHcYLCeKUY2QcZfLdinU7WC9oCeeRVIegPp7WMHo+DeUG4chvx6XtinAGk+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682906; c=relaxed/simple;
	bh=dCO1+fnqbs6SJCrfV/XdJRB7IG5ojEz3ffm8ehJkn24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tI+cxp3GiQCM11S2FuxZWFfsUbiD/fbF9bQPyoNAIt2YaY3xD3atX03/t1I7ec+d3F0ghdp9bRH/UYRe/jfe7nxcACMR+9xC3k5Wa9DZZ9gSYX2TZPFplNRRWECpHUu7IUCoe6pQAysvHZoc2ZF6qHfUhjLoPv1ySWgYURfxO6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibv9qm6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibv9qm6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C68C2BD10;
	Tue, 14 May 2024 10:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682905;
	bh=dCO1+fnqbs6SJCrfV/XdJRB7IG5ojEz3ffm8ehJkn24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ibv9qm6icxWURAzoaB0QRN3WQw5KpT+vRsKQ7JcNQsXZFhK1gy7cOU3sdx0Pl+ZuE
	 h0uG8mWBAuH59EXAjcaeHSPGANOQNeRmyJg3dWeWQ63TmEEzA2/CjA4gkKeqbAjc3R
	 PLxFnOK7PXStph4GDv45BUBxk9XFvb6ofifFEzBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 131/336] vboxsf: explicitly deny setlease attempts
Date: Tue, 14 May 2024 12:15:35 +0200
Message-ID: <20240514101043.547328961@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 1ece2c43b88660ddbdf8ecb772e9c41ed9cda3dd ]

vboxsf does not break leases on its own, so it can't properly handle the
case where the hypervisor changes the data. Don't allow file leases on
vboxsf.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20240319-setlease-v1-1-5997d67e04b3@kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/vboxsf/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/vboxsf/file.c b/fs/vboxsf/file.c
index 2307f8037efc3..118dedef8ebe8 100644
--- a/fs/vboxsf/file.c
+++ b/fs/vboxsf/file.c
@@ -218,6 +218,7 @@ const struct file_operations vboxsf_reg_fops = {
 	.release = vboxsf_file_release,
 	.fsync = noop_fsync,
 	.splice_read = filemap_splice_read,
+	.setlease = simple_nosetlease,
 };
 
 const struct inode_operations vboxsf_reg_iops = {
-- 
2.43.0



