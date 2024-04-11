Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4719D143C76;
	Thu, 11 Apr 2024 10:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831252; cv=none; b=WE4myVAo5MFAS2CAjWktmuRj88kSfh15ADSjFCzK/tkrgpilbAIo+GOZN5/V1/nsa/NQi7lNXG1qHxgBuqGVT+aHGG3LQvKkDZ+IE4plivH+4SFgGiHMK1ydHiNgXYOirqCa/0jfceOUPNC+6r0DKTpvmggGYG35NHdL/zvL7dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831252; c=relaxed/simple;
	bh=Z0xz6fymuxSDT8JJR5DyKmhxkwTJms81aiCO1TBP3m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZB3DKe98ItXLLLhAWjjObhfnNKCmicND0feU5STT01E0CYgiiEk87/049iAweIG+2yYU6+FUeR1uSd0k8gHohIItwDhJoq6pAsqjK69Jk0usDcU/Ben2U0aFDP2ZGR+vGX3PTLPlVq/LUvSBNzlK2Bky+93+vzXatL0WGRaQMpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLYo2am2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLYo2am2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E67C433F1;
	Thu, 11 Apr 2024 10:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831251;
	bh=Z0xz6fymuxSDT8JJR5DyKmhxkwTJms81aiCO1TBP3m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLYo2am2Ogbg834cbWB7I8t30P4gQAP4dr6//77POEVbWXcXjS7tp6SkVKKKnG4PF
	 sAmn7fVGkyIV2P2gR9CDezQR6S0lnG0k/Zlj5SgaKgUjDaAbMVQ8OtPxdOBeDP6hkb
	 +XEX4iZr09VRmNmqGZLQ5niJqNd/1c9d0nNUbfV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/114] Julia Lawall reported this null pointer dereference, this should fix it.
Date: Thu, 11 Apr 2024 11:56:25 +0200
Message-ID: <20240411095418.637442350@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit 9bf93dcfc453fae192fe5d7874b89699e8f800ac ]

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index 5254256a224d7..4ca8ed410c3cf 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -527,7 +527,7 @@ struct dentry *orangefs_mount(struct file_system_type *fst,
 	sb->s_fs_info = kzalloc(sizeof(struct orangefs_sb_info_s), GFP_KERNEL);
 	if (!ORANGEFS_SB(sb)) {
 		d = ERR_PTR(-ENOMEM);
-		goto free_sb_and_op;
+		goto free_op;
 	}
 
 	ret = orangefs_fill_sb(sb,
-- 
2.43.0



