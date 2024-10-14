Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4321AB508;
	Mon, 14 Oct 2024 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918189; cv=none; b=Vpnh+vP0LUkpZpKxi/Z1Bc0r59RXjk8mME7HrIShHJgwxQ8Y447YwCGSEBD+1LYM6cAPVwRagUttkDjD1u9IZ4HjWIoGSCmazpT0fhr8BVkqqbXZtGVCClT6KxzxPEyq00Vea/jP/zd/pgg/RGhMvP6WaOyw1sxYHUDmZhcU2VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918189; c=relaxed/simple;
	bh=ZqDzTBdcEnQ0OMDoTjwOes9++MZt2+RoRBkzHQMGgN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3LURPTEA2/DO4rH/1HxUwdl1aQJ6SSq0M0ultO3RhY/LyRuQJIPrFy/i9AU/Zme1e/BR/00Wz9vSl5Id+y8YE/KIXTHjP5TNT74V0COzbEdegtT/MOeYpTNPktqL9B7zEw8zFmZB22WfhxpNnLnS8D/hLsnJf9oSTE/H1cYy0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4AfnFLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4AfnFLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1001BC4CECF;
	Mon, 14 Oct 2024 15:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918189;
	bh=ZqDzTBdcEnQ0OMDoTjwOes9++MZt2+RoRBkzHQMGgN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4AfnFLP+moo31jWm5oe9Xnz5UxmnBbHSAi2EVuUoVkDZXgCPhTbnkl8jU2eegme8
	 hbWng9TvYotQDUGDA6EYL9Ou4RDHE1oQhkUN1TkPshfX+//W6wVLk+hKeaZ+Z9yVxJ
	 4sro/2E3vdmEdSb79vSGcqxclBT3HoTZbQO/gPGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 249/798] ABI: testing: fix admv8818 attr description
Date: Mon, 14 Oct 2024 16:13:23 +0200
Message-ID: <20241014141227.719652457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit 7d34b4ad8cd2867b130b5b8d7d76d0d6092bd019 ]

Fix description of the filter_mode_available attribute by pointing to
the correct name of the attribute that can be written with valid values.

Fixes: bf92d87d7c67 ("iio:filter:admv8818: Add sysfs ABI documentation")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Link: https://patch.msgid.link/20240702081851.4663-1-antoniu.miclaus@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-iio-filter-admv8818 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio-filter-admv8818 b/Documentation/ABI/testing/sysfs-bus-iio-filter-admv8818
index f6c0357526397..bc9bb4d834272 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-filter-admv8818
+++ b/Documentation/ABI/testing/sysfs-bus-iio-filter-admv8818
@@ -3,7 +3,7 @@ KernelVersion:
 Contact:	linux-iio@vger.kernel.org
 Description:
 		Reading this returns the valid values that can be written to the
-		on_altvoltage0_mode attribute:
+		filter_mode attribute:
 
 		- auto -> Adjust bandpass filter to track changes in input clock rate.
 		- manual -> disable/unregister the clock rate notifier / input clock tracking.
-- 
2.43.0



