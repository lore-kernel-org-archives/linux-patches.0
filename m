Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580D52DEA96;
	Tue, 15 Jul 2025 13:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587564; cv=none; b=UeHWbhEV4EUgv7Hu5mlDLWBw1xqQPaYV5GPjJ2QHub+iVWcQdhLJnRLfx6QR+YKDDcNU6XnuhePtNkG8iIl48ZnoC+/N2XHOVp+s01g/b7W3zYUj+6nb6lnghsOve91mrKOwqDg9fvjexxsrGK5Ph8vzmLsmRS0BRe0iATUe3OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587564; c=relaxed/simple;
	bh=9ebXGudCzmxSnj4nMIXb52leKAhKUQAgetT5Zqzy7vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVECuxjxBPoXvMf6+caJOc9OcPoCxaNqjJPd1TmmpYl9vIb/nD0603gv7Gf2QV/99f2wGzgSAWRUAbvMOkab/TqZxpdB6TPl3O3ywlbSb5GXOM6IUDotDaUQ6qUkhb6fyLDJNY1A4lZMf6aZChLkJMd9lbNJy2GtB7Pw/BhaFPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBQFpzGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBQFpzGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93EFC4CEE3;
	Tue, 15 Jul 2025 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587564;
	bh=9ebXGudCzmxSnj4nMIXb52leKAhKUQAgetT5Zqzy7vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBQFpzGLp1tXpXWSnZbvLuGj8oPGjWgnSQIrx/t1lXoRnutT4w6sOdZWgFpPUBYpG
	 3fqhbEidVeFubySkCibGdzx4iB2PlHX/Ht3TTzP62rUBgZtopwo1pWcd5VlSf+A+x5
	 xy08/WdCv6ycGT/eWHcdWN6GqSbKNzxJBxupSOp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 058/208] dm-raid: fix variable in journal device check
Date: Tue, 15 Jul 2025 15:12:47 +0200
Message-ID: <20250715130813.274380533@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heinz Mauelshagen <heinzm@redhat.com>

commit db53805156f1e0aa6d059c0d3f9ac660d4ef3eb4 upstream.

Replace "rdev" with correct loop variable name "r".

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 63c32ed4afc2 ("dm raid: add raid4/5/6 journaling support")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2381,7 +2381,7 @@ static int super_init_validation(struct
 	 */
 	sb_retrieve_failed_devices(sb, failed_devices);
 	rdev_for_each(r, mddev) {
-		if (test_bit(Journal, &rdev->flags) ||
+		if (test_bit(Journal, &r->flags) ||
 		    !r->sb_page)
 			continue;
 		sb2 = page_address(r->sb_page);


