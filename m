Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AA82E7BDA;
	Tue, 15 Jul 2025 13:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586383; cv=none; b=Ihgkgqr2kEMBiJ5SymndQT4ofuiPjpr9QWKv7rdTx6qBEbAO+V1JxCxX86u6I7hFzveNjHCkBLEXA1QlDcWPooQf7fnNohY6TcDo1WSucjHhn44PdM1ZyoTzcsgRKo4d/68aCLWh4OUf1zqY5Mw7gI68J8T0XwbqM2YhrdZRSWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586383; c=relaxed/simple;
	bh=St2KN2y+nMkXRFpxKnFHNGEDZuqq7RVa6oLGMBj9SKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmG9FDv8Uu4VYoe7uneCKAHC7O023QQ47r2azuSwEoQeqEoBWwdN95cZrWe/s9L7KxwhBWYOTWuIgOQqw5ZM+x0ZQYH8kilmvBbV6BWLLECONQ6p2UXqgafWgxn7sYhDRJMxOo/GuhNOhMVc4NGijc7vuAAcXpiM9T9ylAr+cPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8IP7ZTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8IP7ZTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDD7C4CEE3;
	Tue, 15 Jul 2025 13:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586383;
	bh=St2KN2y+nMkXRFpxKnFHNGEDZuqq7RVa6oLGMBj9SKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8IP7ZTpsylkqxIr95hQnl5IsF7Ows2r6arhRjj1uQ/gb6a+C4r3WSN57ljDy2wi0
	 fDRTi8vJr3F9mjIwt5+U8fxScx0OuraT9iK0IyIOYe//M4ZJH7CdENWn/eNsZXP+JI
	 DcMz7QyCqh37kHKt7D1l9Q+eSKDiQO9w0/OrHNbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.4 045/148] dm-raid: fix variable in journal device check
Date: Tue, 15 Jul 2025 15:12:47 +0200
Message-ID: <20250715130802.121003757@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2406,7 +2406,7 @@ static int super_init_validation(struct
 	 */
 	sb_retrieve_failed_devices(sb, failed_devices);
 	rdev_for_each(r, mddev) {
-		if (test_bit(Journal, &rdev->flags) ||
+		if (test_bit(Journal, &r->flags) ||
 		    !r->sb_page)
 			continue;
 		sb2 = page_address(r->sb_page);


