Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02ED1350CA;
	Tue, 23 Jan 2024 01:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971972; cv=none; b=XqOq0HXbOSd4eXku1dyIYxEvWj63WKlFMp8haubp5K5cDNFatsuGUI6b4XYIBMHCJWUS59Q68eJUizwARuMDhZSLdV8rQ/pubf+RNBL44ZQXS5HRACPeVekVjA8PvcOEpWGM9CFt7jfkJTAZLR0mDciBeFgvnuETYSWpI952cWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971972; c=relaxed/simple;
	bh=Nqcwc2vJDbf7boSZmSCQ9jzXxhKJThbcj2iBXy6LCYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvWgFG5iToie71O1U/GWWtZZ4Unyy1zYp23GzCE7AggkGRRjmErpIiDrmUa7Ljxzp4Y2jh58+XY3tzoINfCCg3LXyri6FhS6iS748bJCVdJf6CbTGEPdnVd4f6oBLiDXjzm9gSGF8FEBL+/ud27HiSLJy/Q9AkxwxpP3xd455EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uW+ODIlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uW+ODIlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EADC433C7;
	Tue, 23 Jan 2024 01:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971972;
	bh=Nqcwc2vJDbf7boSZmSCQ9jzXxhKJThbcj2iBXy6LCYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uW+ODIlGsMlvr0CzSvLOjZCv7FhdqcvHIFhX/2ATUJC8bra++juKlL3HFTtptuaZB
	 X0LSWorr9LjZya2ka/BV+8cDzrBy6PKAulcWHwCIYNReQa7F9mDW86uIp8Jvk34qX8
	 /Xg+PHRfVZrhejoljZVE+iwp96u3B4N7TgY90Ah0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Harris <jim.harris@samsung.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 367/417] cxl/region: fix x9 interleave typo
Date: Mon, 22 Jan 2024 15:58:55 -0800
Message-ID: <20240122235804.531553215@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Harris <jim.harris@samsung.com>

[ Upstream commit c7ad3dc3649730af483ee1e78be5d0362da25bfe ]

CXL supports x3, x6 and x12 - not x9.

Fixes: 80d10a6cee050 ("cxl/region: Add interleave geometry attributes")
Signed-off-by: Jim Harris <jim.harris@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Link: https://lore.kernel.org/r/169904271254.204936.8580772404462743630.stgit@ubuntu
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index ebc1b028555c..2f7187dbfa2d 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -331,7 +331,7 @@ static ssize_t interleave_ways_store(struct device *dev,
 		return rc;
 
 	/*
-	 * Even for x3, x9, and x12 interleaves the region interleave must be a
+	 * Even for x3, x6, and x12 interleaves the region interleave must be a
 	 * power of 2 multiple of the host bridge interleave.
 	 */
 	if (!is_power_of_2(val / cxld->interleave_ways) ||
-- 
2.43.0



