Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4279149C51;
	Fri,  6 Dec 2024 15:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498672; cv=none; b=APqCykeMeaf0upB1mHU5bKbH9yCClC2iJKiWP9kUujvuaOC5pUssXAB2lGkH1ZjBJ3dBGdd5mGbGnVUpiD0NDGX1EJvrThn1NP6fdkRm4d+2zBwTm77OzyUOzMCVJ73WAL8u5eBp3HKqIpZ6uSho52I9U2FcCRta3H//4t4QkP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498672; c=relaxed/simple;
	bh=NLkvdJs+bA+zkTv6vpmSHCZCwXyNnDRWhgy3Xnx0E64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdDsDtUQhyS04fiWdkgUxo+vbqKGT7q2f5k+ujLQZeDXdQ8moQVDGAKUpWimA/W0HrIs9w6v+koCsVcdRzl7mDY8FF31JUe3ATctggqA8bAZo4q8mMldIiX4xLECD3gFJ+1bwCh8NFzBG931jWRUcIGEvg1Lj3b004i00aVNJTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IEWQyDEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IEWQyDEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A47CC4CED1;
	Fri,  6 Dec 2024 15:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498671;
	bh=NLkvdJs+bA+zkTv6vpmSHCZCwXyNnDRWhgy3Xnx0E64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IEWQyDEOKJzJGRit7nNlIMVeQc8aMcC+lQKdYlJ7Du7FCHhX+M8BhKAnkThf08L5J
	 +W0GQO1d45ljCcMMX5a9+WW0UFd/e0JRb1DlNVFJ6CaFoppkxa4m+2Yh4wCfW3J7GK
	 JnYMmdL1tpJo/4U+hmPN3r5JYZBPlWKa5Q175t7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ssuhung Yeh <ssuhung@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 652/676] dm: Fix typo in error message
Date: Fri,  6 Dec 2024 15:37:51 +0100
Message-ID: <20241206143718.837643154@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Ssuhung Yeh <ssuhung@gmail.com>

commit 2deb70d3e66d538404d9e71bff236e6d260da66e upstream.

Remove the redundant "i" at the beginning of the error message. This "i"
came from commit 1c1318866928 ("dm: prefer
'"%s...", __func__'"), the "i" is accidentally left.

Signed-off-by: Ssuhung Yeh <ssuhung@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 1c1318866928 ("dm: prefer '"%s...", __func__'")
Cc: stable@vger.kernel.org	# v6.3+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-space-map-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index 3a19124ee279..22a551c407da 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -51,7 +51,7 @@ static int index_check(const struct dm_block_validator *v,
 					       block_size - sizeof(__le32),
 					       INDEX_CSUM_XOR));
 	if (csum_disk != mi_le->csum) {
-		DMERR_LIMIT("i%s failed: csum %u != wanted %u", __func__,
+		DMERR_LIMIT("%s failed: csum %u != wanted %u", __func__,
 			    le32_to_cpu(csum_disk), le32_to_cpu(mi_le->csum));
 		return -EILSEQ;
 	}
-- 
2.47.1



