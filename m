Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54E3EEBA;
	Thu,  3 Jul 2025 15:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556250; cv=none; b=XfdhtZ07hgfdmFuKI3e8brHu4vWRocV+4VFTUWL/vcxExUtao4jIiWIcWyqKJzt9l+K9HFZAruohSvTpeJrY+aJUXZD+Kusdz5wUyqt0dDKRxSOLDo5rSrsT4n52z9SCBdvwBrDIiiDj+NL1Tl/PEMFz5ojsxlyRM+kgoQHhFJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556250; c=relaxed/simple;
	bh=4brq7RxdhJgHT5dWOhH4ODEuNgIAJtvT1cnfJzWE/nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFaSA4xd7Uu77Kt88Lait30Zsaq2ExLv2IVq56ZSGEfoije8hNVJ4YRwDrUTWxYppzQEdD1fnrmYW5UuJav+iL2Sab9X02/vVmnk25XKZOFIKyuzNSysICp93a6pfdIm6M1JclHdJQEEcxIwLWRNpsmLj/r8pYIepUE/GonAILE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsjL3LcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsjL3LcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370F7C4CEE3;
	Thu,  3 Jul 2025 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556250;
	bh=4brq7RxdhJgHT5dWOhH4ODEuNgIAJtvT1cnfJzWE/nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsjL3LcZMKSQWOL6VlblTLV1TKSwhjUP8ivZ42TMZv23Hh5iU8Nz4xzz7azCFUYCF
	 ec5LrR1iEx+E4lusN6Xnd16PqCqz1acRtRWdU+8ldwHXX834hLSwuzH15VWLopee1Z
	 /siS0F9ROhaMnYlvlnY+k5/57gEdIwOHxTgmgMFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 094/132] dm-raid: fix variable in journal device check
Date: Thu,  3 Jul 2025 16:43:03 +0200
Message-ID: <20250703143943.089016616@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


