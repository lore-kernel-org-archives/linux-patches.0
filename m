Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496C11CDFBC;
	Wed,  2 Oct 2024 13:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876527; cv=none; b=MyqxNa7HTV01TlMXKvCb1I6P+zKQ0QwYD3GivJAUSigTNbhS7OpIO1yfIPqppRz73UuaPFEnfG/6PkCVftSvGvUlRfyPgGqbwy2SXKllba3MJquplJQIEbGLNLRSmitptTWNcRoihAIxpBb/xuU8+aBWdr3MUiZjxCbnBkKNukU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876527; c=relaxed/simple;
	bh=iqFk93x/rq122Ajk4Q5c+Ye7CC0LlIyQ8dtPIc/s82I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQTFWTUoyos35T3eI/RsI6KCylldMbwEX1Bs+5C5ocKWkaKziql5Y3MMhbDXOhhZcmT8+xDIeY86xpvHSu+BVnh++hhSqDrMc4ZyjfW+k/HFD034pzD2j2XpJbdmorcks1opjsU/KqyWU7X6WnWu+uvlOKybpBUTFD38Kz5Cy3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUJRw8z0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUJRw8z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6114C4CEC5;
	Wed,  2 Oct 2024 13:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876527;
	bh=iqFk93x/rq122Ajk4Q5c+Ye7CC0LlIyQ8dtPIc/s82I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUJRw8z0BMPaa6EHw8tbSZCWsmZBsXkAwxYWr/rf2BagqTp6NQNooDvIQNrW3A59k
	 IqcKhxH1Dnr2ydlz3LZMahU2FGmiJB+q54AubC1Km44lBoTobYFSwtQ5QsL2hLapfu
	 cVxvatInZeS9hzlvXiaLejvvdfXf60VAP3GQyp7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 457/695] ABI: testing: fix admv8818 attr description
Date: Wed,  2 Oct 2024 14:57:35 +0200
Message-ID: <20241002125840.698159707@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



