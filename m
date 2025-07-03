Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339622EF9DD;
	Thu,  3 Jul 2025 15:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555807; cv=none; b=bBrLGHnHURlFfaXnUlHZMuY792QFsN4xLuoSj9asf476rmVDkKStbHOVP8vugLZovJTQiLQEc0LWDXeHpAl/oj+Xmi8gsd4Rl1yXfhyawPVaoLBpdFlUME5zvE+nDtVhdu/BtZV1UrNm1o/l2aeZTaNQcHJPOP6xardMyvH6hdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555807; c=relaxed/simple;
	bh=AmifA3hTNDet2gN98VGq3avytEjF6h2Q1GXOQ7b3pE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJaTvKoubpaJcNRA0I9KR96Vxb+aEidWm55RAO6/If0MvOVbnezTAmvjYSZ+T2bkZGd8kRM6zbu2ZG4U8kRzpJoZT+pjql75OqRDZvUdbBh9vFGht4Y8yx1J1N8mg42dQRGVnGDayOjdHxmanOOeDdlUcPap/3so/rvKqwBTj/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcCEb0aY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcCEb0aY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EF1C4CEE3;
	Thu,  3 Jul 2025 15:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555807;
	bh=AmifA3hTNDet2gN98VGq3avytEjF6h2Q1GXOQ7b3pE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcCEb0aYrIvq0eNR6SdUfM11LmABLIAL5jq22UXcAIXe/E65FNwNAhUR3x9/eEHt4
	 YMiqJd9KLfIH2kZVLJZgSVARZlbC22zc7BkbZvG8mqCBssxK8cBu8nB6UwU4NIb9Y1
	 STFp+vPZ7LiN1HuJJ8PhkDKshBWby8s3HQ5r2XOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 100/139] dm-raid: fix variable in journal device check
Date: Thu,  3 Jul 2025 16:42:43 +0200
Message-ID: <20250703143945.081594194@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2378,7 +2378,7 @@ static int super_init_validation(struct
 	 */
 	sb_retrieve_failed_devices(sb, failed_devices);
 	rdev_for_each(r, mddev) {
-		if (test_bit(Journal, &rdev->flags) ||
+		if (test_bit(Journal, &r->flags) ||
 		    !r->sb_page)
 			continue;
 		sb2 = page_address(r->sb_page);


