Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21463FA5EB;
	Wed, 20 May 2026 18:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301767; cv=none; b=AMEfDIQJCbnl04ww3KA8c68I99e6lUWU4dyYgzM66k4sp9lAEJ3l/6MPef0wu7S6od1aYqTT88lJw3IwXWaVBl/OJSykn9vHJY0aKhXpcdav5M/ide80TSDwp+BYOW25/MYb0QY7ZJn3lLJb/ACDd3IiGwc9HqlWOPmdjlJGriI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301767; c=relaxed/simple;
	bh=2qJ23WQAhiqbv4pjA2RI37WM06m4oqK57lhlXv0CoDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbu2a54mJoOh6S+DITb6ZYYhCUAvXus7CYMgio7XbRgOwpEGsPGfVYgnsmhv4LPlUHkyAysdxbyAInlhBJY2MEFfO/BrLVrmOYR2bTEMWK3G5iv0P36Mkg1dr9iSW9fePZE2O4Om6zjtCeiaGAVmfsUv858q8u46FYX7290xZss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWm9Isfy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWm9Isfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446F41F000E9;
	Wed, 20 May 2026 18:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301765;
	bh=FH0bX5BvN+K4WF0cBVrJd2YpZ3xdyh83NBoP1Rk8yWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWm9IsfykfnCa+PTW9NOIvCMaZ/KfJOUlGjffky2ZVP8N58JU3/LgUJcDQLEYEGMO
	 wybV/oyZ8X8IyviQdSfB6BM1OCgbCb99VxkPquZZLVUzJd8gD9lZphWRmDj9ytRpiv
	 XfwjhLsSYUMLEomlVVpyOXBXhndb+mGtmJwQi+FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/508] debugfs: fix placement of EXPORT_SYMBOL_GPL for debugfs_create_str()
Date: Wed, 20 May 2026 18:17:16 +0200
Message-ID: <20260520162058.872575013@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 4afc929c0f74c4f22b055a82b371d50586da58ca ]

The EXPORT_SYMBOL_GPL() for debugfs_create_str was placed incorrectly
away from the function definition. Move it immediately below the
debugfs_create_str() function where it belongs.

Fixes: d60b59b96795 ("debugfs: Export debugfs_create_str symbol")
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://patch.msgid.link/20260323085930.88894-3-hanguidong02@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 3089d7146f366..a9097a6c7b5a3 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -907,7 +907,6 @@ ssize_t debugfs_read_file_str(struct file *file, char __user *user_buf,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(debugfs_create_str);
 
 static ssize_t debugfs_write_file_str(struct file *file, const char __user *user_buf,
 				      size_t count, loff_t *ppos)
@@ -1002,6 +1001,7 @@ void debugfs_create_str(const char *name, umode_t mode,
 	debugfs_create_mode_unsafe(name, mode, parent, value, &fops_str,
 				   &fops_str_ro, &fops_str_wo);
 }
+EXPORT_SYMBOL_GPL(debugfs_create_str);
 
 static ssize_t read_file_blob(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
-- 
2.53.0



