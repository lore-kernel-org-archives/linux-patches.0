Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FD2423149;
	Tue, 31 Mar 2026 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976127; cv=none; b=pSMaTN6Gnwswj9atUcjKUB0wtwjDN9CQbpjVQWMYmx/A1TTXjrEaHGNCkhPfdhRzVz2FhqoERJB56h4ZCoiYgN5lBwVfTNJoJSv1O07HJE0Czd8qGrhvefEk+2hLga+qsYtMh1Uaw0VnqL5ig9LVjfMjHe1qZPMxhr3fqncpz5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976127; c=relaxed/simple;
	bh=aiTtnACWtbBYWy6fgXqUxxxkerb3UjnlYUSEOLINlHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCCWLRIrTu7BOcUii6QvrBs6OsF9PEMB7HnKGSI1Y0qZPqd3uOaivO/8CW+JgoaDzjViGPV9J6sp+HXE/fXagB4Yza1CELSbXDlKVOo2o+iBWELA82ps9uv4XXaJcRuFVm8VouLnfCSMv75yWoovE1ou4LhKZHKbH8I/74sbw/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mr6rbfUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mr6rbfUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200BFC19423;
	Tue, 31 Mar 2026 16:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976127;
	bh=aiTtnACWtbBYWy6fgXqUxxxkerb3UjnlYUSEOLINlHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mr6rbfUXHcayU9hNdiipLk1J3ny1TAsadbQBGGXbN7B7PIHLokeaUxso/ulKiS3Zx
	 AWPW7ADnxQUasnvkZu0VIv/9e0hv3eO2C1/cms/uKJ5mSVs6+R+GiaiMGfPU/gQNZM
	 SYa1wgOAnawg6EiS7GDXJQ9KMoS1qhGBBThyqH2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.12 210/244] ovl: Use str_on_off() helper in ovl_show_options()
Date: Tue, 31 Mar 2026 18:22:40 +0200
Message-ID: <20260331161749.511711261@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 50e638beb67e020a9124d77bd8a88bde3cd380e3 upstream.

Remove hard-coded strings by using the str_on_off() helper function.

Acked-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/params.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -987,17 +987,16 @@ int ovl_show_options(struct seq_file *m,
 		seq_printf(m, ",redirect_dir=%s",
 			   ovl_redirect_mode(&ofs->config));
 	if (ofs->config.index != ovl_index_def)
-		seq_printf(m, ",index=%s", ofs->config.index ? "on" : "off");
+		seq_printf(m, ",index=%s", str_on_off(ofs->config.index));
 	if (ofs->config.uuid != ovl_uuid_def())
 		seq_printf(m, ",uuid=%s", ovl_uuid_mode(&ofs->config));
 	if (ofs->config.nfs_export != ovl_nfs_export_def)
-		seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
-						"on" : "off");
+		seq_printf(m, ",nfs_export=%s",
+			   str_on_off(ofs->config.nfs_export));
 	if (ofs->config.xino != ovl_xino_def() && !ovl_same_fs(ofs))
 		seq_printf(m, ",xino=%s", ovl_xino_mode(&ofs->config));
 	if (ofs->config.metacopy != ovl_metacopy_def)
-		seq_printf(m, ",metacopy=%s",
-			   ofs->config.metacopy ? "on" : "off");
+		seq_printf(m, ",metacopy=%s", str_on_off(ofs->config.metacopy));
 	if (ofs->config.ovl_volatile)
 		seq_puts(m, ",volatile");
 	if (ofs->config.userxattr)


