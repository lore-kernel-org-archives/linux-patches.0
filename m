Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A6E1D0BBC;
	Wed,  2 Oct 2024 14:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880138; cv=none; b=PonHW/IVfKwDcmXUMQMC5TBGKJ1QfaxgmZxbGfvC6+SdijFHzMMW7bs9oIJziHQ0eEgrrtEvOzgs5d0uOS+5qS5owS2BMaMk+yQ6sqoki0e5bT7vm0QcWJeM1HP8puJPMmcmI2GNWPiRHfQrpl/lIX5kQ6xzH6ilWQlBGXmXLTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880138; c=relaxed/simple;
	bh=Svv0sFwkeUP+gI6UhtJVb165L6fNcpsi0bFZC35Xvmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFZEwJin1vDyDoAMZVIlTwi1XVgeu1J8XJzNkUJ+1c45vlp7UEYolzMGCiUos9O17KlQcadceUfhuJG2D3ODmgW5hKBRxzdaVhiWy3YE00hSwTdgprrC8oaxZ6sxMQ4vmWPjze2R9CS4K73EPvB8P1466qfcna3jr7GnAF0ZeaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3ZqIfYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3ZqIfYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4B0C4CEC2;
	Wed,  2 Oct 2024 14:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880137;
	bh=Svv0sFwkeUP+gI6UhtJVb165L6fNcpsi0bFZC35Xvmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3ZqIfYvl3dMulwx7fcAczSQg7T9Nzs4uf6sAfFR6zLpwdDuA3COH4iUl5IeH/C2R
	 R/0/JaaT20v/sLQT1pwSdwSUq7atQcywYMTYSFhKgM4vwi5QjtM4cTdQc2aw1N1BP7
	 DRcZ++aHWX8zWON6AusifCcs/HbIykO7qjBqCK2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 356/538] ABI: testing: fix admv8818 attr description
Date: Wed,  2 Oct 2024 14:59:55 +0200
Message-ID: <20241002125806.479083027@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 31dbb390573ff..c431f0a13cf50 100644
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



