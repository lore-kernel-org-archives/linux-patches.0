Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCAE1D0B91;
	Wed,  2 Oct 2024 14:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878449; cv=none; b=np+HeIO3M36loc81yo2B5ZN3spk/okOG11srqOr139Yen2mNdIMmJnyHLyH0iUSFyRXQjpGFTbA3jBa1Q8SF4+k+oYFWaGtIEB3bF/GEmLe7xPtXCbcwO+7RPPJ+9CsJF33QqvH5sgElXitgrW8VGaoSJm3sa/iD6r5vfVoB+zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878449; c=relaxed/simple;
	bh=04GwO/k5i37F7uzrGrDY7Yxw5FUuCkr5ezjGrTJg/PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqgOhan7YoL2qrpugVG/dU3jyBGyAL0CYtFHTtgDqGTlCjFklNBV6xQBrJFv9+DlwP81OgJYW7T+yx9oaFQjs02YOratBb+WmlEQ9pAUMBALogQptREIMMBHX7xcPtKOhnbXOKxAHDIj7pc5eD7OcV6tJ8E+m9hSwaBpcq5syLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0foBUvCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0foBUvCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643F3C4CECD;
	Wed,  2 Oct 2024 14:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878449;
	bh=04GwO/k5i37F7uzrGrDY7Yxw5FUuCkr5ezjGrTJg/PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0foBUvCAftbfM5MMRvZD8WsetOwqny38+VjQ2uI90UOp4a01QgPXk15XAwgEwHbD/
	 HZy+OiMsHFRZa6JXnCXkCuy/+y6ZgVte+jYUc2/NQED4WkEdGjyuDYCcx2T2VV0REF
	 bMu6u6Kl3KYN11ewHos+odq9revTQovg/v3RQCmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 418/634] ABI: testing: fix admv8818 attr description
Date: Wed,  2 Oct 2024 14:58:38 +0200
Message-ID: <20241002125827.603441903@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



