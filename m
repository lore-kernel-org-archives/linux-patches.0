Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549EB4ADDAA;
	Sat, 28 Feb 2026 17:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301318; cv=none; b=sjeP40nh4wlMwXqBXVVFQBktnRPMGwFSdxaPzJg1Ke6PAgg0JlnkrP1J/eWrT6kJlNXcMhH96mmp4UeA8t4MS0dQYjiSJWu1hLZhUh4q+mRRUshdt19H9D7c3xbeFm30qTFDLOMYy4ZmJXWD2zQBN1H4I2SpemZA7EazlQ+05MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301318; c=relaxed/simple;
	bh=NhBI4Zw7iljTeIMT/PmDChE4/1t5ww44aTSvxK64uAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oTHEBOR7kWTsSJS1wwJ0Bm1fyvPdx02P1kXP/2s+lG0CTPLZK1UGaj9jwJmIvHC8eUEhTQpAQnTiyKyC1n8xlulL38prP62AD6lLWynqcd/iDgamP4EgLLTVp35tNEJgj/cEvOkrozLelkLUGHHA6MWswuso6WcQqwnTgxtC3VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ovF2xvMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ovF2xvMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98545C19424;
	Sat, 28 Feb 2026 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301318;
	bh=NhBI4Zw7iljTeIMT/PmDChE4/1t5ww44aTSvxK64uAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovF2xvMbnm+NTEHZCG21en+066MevMp2WNEqN7e7IknSc5hzmhUWkWiSh5Sld3pu1
	 0VsBt8dU9BV6lohPWcNV4aylOPBd/rNHwmCWCsBMekwZpdOv3JAhm08bTyNxPW2Nhp
	 i24f9wnF0LdBR+wSek6hV3nhJDW4po2lhFoqq0hD0sN+iim9xqd/l4iOeCVdkFL2FL
	 uHJ7cSbv9sUG1Z5A1E2mFMey9sXEJmY/7xCPXMZqdzMSenaPlKRiT6Qa7+6YlQLXCT
	 qYVkG+pqgYZhEMBdSM51r0iTbuWIsrkU95jlu1H9AqLi4zLqZ5+veWIfKqCBcKji5+
	 XUgM3Kx3oI22A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	stable@vger.kernel.org,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 504/752] HID: logitech-hidpp: Check maxfield in hidpp_get_report_length()
Date: Sat, 28 Feb 2026 12:43:35 -0500
Message-ID: <20260228174750.1542406-504-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Günther Noack <gnoack@google.com>

[ Upstream commit 1547d41f9f19d691c2c9ce4c29f746297baef9e9 ]

Do not crash when a report has no fields.

Fake USB gadgets can send their own HID report descriptors and can define report
structures without valid fields.  This can be used to crash the kernel over USB.

Cc: stable@vger.kernel.org
Signed-off-by: Günther Noack <gnoack@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index d117cf0b6de04..6b463ce112a3c 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4313,7 +4313,7 @@ static int hidpp_get_report_length(struct hid_device *hdev, int id)
 
 	re = &(hdev->report_enum[HID_OUTPUT_REPORT]);
 	report = re->report_id_hash[id];
-	if (!report)
+	if (!report || !report->maxfield)
 		return 0;
 
 	return report->field[0]->report_count + 1;
-- 
2.51.0

