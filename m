Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4259518026;
	Tue, 14 May 2024 11:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685315; cv=none; b=qE/E51OZ/BOk1b4gNLXaqpSHpz95JBN9eTEM9hup3oTFdnYozZz2onYD1hEjE/xcydNvu+IgogEPsuC/aOAwL53w4SlsWe43Xj/J2fPwDbiWV11xp/0hHohXPYe2X6PGN+wfLJa3q1/ce+8bJGEhaynzepO8YTs4JFBOJSqBcK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685315; c=relaxed/simple;
	bh=98EhZK/YkPw8fyonihg13fIt12BVzEDsQOsTBgwmKSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAyCyojYIzYY1p8hlKK2WLfkKKbkIgpcasaDPMtYx+JmM8W9BbtDqUcja1UWjCiVyT3ztu0wY5NtggSOPJLsFqx15B8RplI0Gy0jt/ud/AcvakVIhN8LlqfmmrShno6n++I22hy0px9Gji4iE+TX2TIV7jAcJObMq4HNDWp1FgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BgijDRYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BgijDRYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62626C2BD10;
	Tue, 14 May 2024 11:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685315;
	bh=98EhZK/YkPw8fyonihg13fIt12BVzEDsQOsTBgwmKSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgijDRYmz44+lFYWU/aPdvRA2lXDxX8TqMk/lKznWYyFPN6Mdo4rdWPsspBcMpIHp
	 NtOR06vBpEDSQR3u20iMJrXG1lKGKYlzJy7jwGEKQRsadTE6rp4CsXX/zfrMAIezPT
	 olmiZn7EaPC9UHV1JB3WUtBIAOe2r5kMZGO17K9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/301] vboxsf: explicitly deny setlease attempts
Date: Tue, 14 May 2024 12:16:37 +0200
Message-ID: <20240514101037.006851566@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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



