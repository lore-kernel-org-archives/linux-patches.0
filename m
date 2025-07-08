Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0347263B;
	Tue,  8 Jul 2025 17:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994039; cv=none; b=Ucw6gHoLUNifvNPa5/PAu0ldcJ1uG1VsyYmTrcDz01UwIBOAnjFkpLsYhvyzKd7mlFTe9hDZQqhyoX6jxPyWDvGdwZJ2A+12pqNXoQID0Bk7t+AXbwPUp0i/osUDw3jhaoj8pcQNN/yWITx9xYsRQbPo9HJtzYBu0Fea59D0Jms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994039; c=relaxed/simple;
	bh=9OkjcX3Bhr2jMv9Tthe/zKX0EBDdPVuTad7fAm7wezw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vb3KRzgW6DByUsljiYspxNwwxtv71V2yq0Cc0ZmEox2kkXmKYPJAouU30PIlfZDb2KHou+P6iSJLWEb09gO5FSkovQse4dfeKW5qbFC90XQ6sQPEn6TCT8+5RR2ew61BkfGKiQ6mkcZ1idDbkbAud56KkZNnPPqyG4X5YMXJlrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6N1iuHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6N1iuHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7CAC4CEED;
	Tue,  8 Jul 2025 17:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994039;
	bh=9OkjcX3Bhr2jMv9Tthe/zKX0EBDdPVuTad7fAm7wezw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6N1iuHVVGWpMYUiizLraJATW0/3KbgtXIWHaPKGo7VRQAEZhbrafI4N5diKPo8LG
	 a2DqIWCSxYObMYJQYzECfMRS6VLB4r+DcvpwqmNs/VbbWu5yaSMUJtXHKV5OuYG73C
	 0SfdBL6glB7luwIuq/m17BJ3kmgnjM/Y9coddprQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 075/160] dm-raid: fix variable in journal device check
Date: Tue,  8 Jul 2025 18:21:52 +0200
Message-ID: <20250708162233.625540764@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


