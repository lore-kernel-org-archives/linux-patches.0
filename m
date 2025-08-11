Received: from sender4-pp-o95.zoho.com (sender4-pp-o95.zoho.com [136.143.188.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFFB2E3718
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 04:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754888113; cv=pass; b=KpKfqUVlkWOkjP3jLvR+z/Tqcorip2cR/b7k/osuaL4o9sioYwDNJMr+432I2Hd4zHldvVX8gQavZud0co7GFfgoYBadyyPDAAE/aG9p1cYWGKimjN/IpU32Sxgla4KsCsShhg4PkbfyDs80qi3Z5A1XDYny1xbgcZqITSkIoL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754888113; c=relaxed/simple;
	bh=iITz7QylY4ZjPZ7tL3v/HhstGn14ci0ejmT9frTByO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JafH+hCMEYnWvhgvQpKvdYDHLiR0Z/WvyZWB2pmMJf1gQKNdBaO35wJriqGwFMcZNTkgdGTc3f+HhGyl5U/3d/PL9/kmXqFmKRvUqlvpqVQkxvh9QJrJBsM6srQCe3g8E/oFdXCxk/0DycHUT4HUdf/dcsO/FK6cWVIGVdd+QMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b=aoPm2mxZ; arc=pass smtp.client-ip=136.143.188.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b="aoPm2mxZ"
ARC-Seal: i=1; a=rsa-sha256; t=1754888106; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=mhIDAuKCKEnoCbWMkbE2fH/AYF27pxxYUbE8ZN296ueVE86MzDXp2H3LltS8Y/G85iTWt4c3jyce5DXenNRL6CYAZkG2NVOEC1Gub2lIQu9LPDO60QFcd4E33aGFkkyCPPHHUQirjCE2AhdGMf3LoX+WrDbQFKm3yjxALa42lMw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1754888106; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=01ljkBsOaenlB8KL2Ax+hoaCPfwywP7/IkV8mFhtY9U=; 
	b=CSgsUsIBlBlnXllQqYUgp8c0WtIPuNE22ZxU3Pwng6sDdb7rAyDiXlEQXjlTF7VTwgBNRVxJ1xjkcYrV0c0ThD9YJZOb4uNQIegIGmbRCW0hYTD3XAcRY0jamLRgrH5RW2x+cDURk3CIJ4IBmUvFvxfWLWkp/ELuck18j7qjDz0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=safinaskar@zohomail.com;
	dmarc=pass header.from=<safinaskar@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1754888106;
	s=zm2022; d=zohomail.com; i=safinaskar@zohomail.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=01ljkBsOaenlB8KL2Ax+hoaCPfwywP7/IkV8mFhtY9U=;
	b=aoPm2mxZeNOIvPua9AnwtufLqnGMe4cER1tOEy2KRjDLloHDoblHGwVlGW7C2y7z
	y5himB2dljptz2R0V4zOodsuL7ZiHIErbZC9XvDFfWoUhOIyfUkd3HnLi8qSNExdaxD
	kxV0BWhK1eTcPTr4/WM8x3uAh9hJDi0+uEnzC6ok=
Received: by mx.zohomail.com with SMTPS id 1754888103228185.8244194885384;
	Sun, 10 Aug 2025 21:55:03 -0700 (PDT)
From: Askar Safin <safinaskar@zohomail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	patches@lists.linux.dev
Subject: [PATCH] vfs: fs/namespace.c: remove ms_flags argument from do_remount
Date: Mon, 11 Aug 2025 04:52:23 +0000
Message-ID: <20250811045444.1813009-1-safinaskar@zohomail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: rr080112277302660ec9043eeaaf4111350000f90744bcd3139453096ead3195ca382ca647d724acb6e68412:zu080112272aa6d3018171a76df79478430000e5dfa6c0840f708152a2a560b8bdea9e3fc24829ff13631037:rf0801122cc7cb08dbc6be82c8043e520c00001855383ec7e0d11b5b8a5a8290e5ace3ea563b5ebf11fe741184bb37b2b3:ZohoMail
X-ZohoMailClient: External

...because it is not used

Signed-off-by: Askar Safin <safinaskar@zohomail.com>
---
 fs/namespace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ddfd4457d338..dbc773b36d49 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3279,7 +3279,7 @@ static int do_reconfigure_mnt(struct path *path, unsigned int mnt_flags)
  * If you've mounted a non-root directory somewhere and want to do remount
  * on it - tough luck.
  */
-static int do_remount(struct path *path, int ms_flags, int sb_flags,
+static int do_remount(struct path *path, int sb_flags,
 		      int mnt_flags, void *data)
 {
 	int err;
@@ -4109,7 +4109,7 @@ int path_mount(const char *dev_name, struct path *path,
 	if ((flags & (MS_REMOUNT | MS_BIND)) == (MS_REMOUNT | MS_BIND))
 		return do_reconfigure_mnt(path, mnt_flags);
 	if (flags & MS_REMOUNT)
-		return do_remount(path, flags, sb_flags, mnt_flags, data_page);
+		return do_remount(path, sb_flags, mnt_flags, data_page);
 	if (flags & MS_BIND)
 		return do_loopback(path, dev_name, flags & MS_REC);
 	if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
-- 
2.47.2

