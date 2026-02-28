Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4266383C86
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302116; cv=none; b=n+VGAfGU11WfjOQ1py+KMHpPNyu/0sQqYnPLIsBR7V2Y3gOcL5yeGUo45/t9r6yowbWMeGMWMEqNMAde2fG++WFeqNKGjyKguu5DzZ2nnJRXQiBBIH7lBVa4RBLtoejnHAxLOaB+5oIPv7+ERXV1P/mbFBvDv4nmaHJ1Xlxe8zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302116; c=relaxed/simple;
	bh=84XuOJBX5ixFB5dY8gadeLiy28oWLo8dKX3MMmHeGfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNmupuRzB6fj/OLuXXgvhV6jfwuBSCYhx55v2625zm4xBxkRMjEhzCWwYWx5JYzzguAjYzG7jBdRBmn8B54zWpkiGdBriPrZSv8xZtK29zWYE2+BJx7VAlOVZkpvYPTeg2C/MbCvTntph1dV0PqgzFOR2xo6SzF//If9nUn9E7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TyxeoVw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TyxeoVw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F50C116D0;
	Sat, 28 Feb 2026 18:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302116;
	bh=84XuOJBX5ixFB5dY8gadeLiy28oWLo8dKX3MMmHeGfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyxeoVw7I5ZdMblHq1T002RaJyLRftv1KCGc4UIqPYlXfHYlVYaXMGMrKHqJjMSS3
	 L0lMb50RkIFPMMmrAcF5ZZj6HMHH1V0NrqQs9VHAjECUOKx0RDUMV1Fi5JFZM+orsK
	 Y2/jkhomiqTntQSMDM63OOYndpN1yfUyRzneyFSvRZe48DjntT6ydKmzNs0WTd1vjJ
	 2uMvD97PXKEwb/7npoFqYShKioV2BzDvZhlWZ7xcn2VX7GhQL10+tTzTM3KxB4w9o1
	 CK2YC+UcsJJRU8cttWdvBajaadxr9OZ/zUegX8xJVubpnssStYMOlR84G9W+Wg+g+2
	 cBWnMp+J0o/QQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: SurajSonawane2415 <surajsonawane0215@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/283] docs: fix WARNING document not included in any toctree
Date: Sat, 28 Feb 2026 13:04:08 -0500
Message-ID: <20260228180709.1583486-106-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: SurajSonawane2415 <surajsonawane0215@gmail.com>

[ Upstream commit 998bece1d22bf2cbc819cb3a492148932d4e12a8 ]

Add debugging.rst to the relevant toctree to fix warning
about missing documentation inclusion in toctree.

Signed-off-by: SurajSonawane2415 <surajsonawane0215@gmail.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20241002195817.22972-1-surajsonawane0215@gmail.com
Stable-dep-of: 8236fc613d44 ("Documentation: tracing: Add PCI tracepoint documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/trace/index.rst b/Documentation/trace/index.rst
index 0b300901fd750..2c991dc96ace6 100644
--- a/Documentation/trace/index.rst
+++ b/Documentation/trace/index.rst
@@ -24,6 +24,7 @@ Linux Tracing Technologies
    histogram
    histogram-design
    boottime-trace
+   debugging
    hwlat_detector
    osnoise-tracer
    timerlat-tracer
-- 
2.51.0

