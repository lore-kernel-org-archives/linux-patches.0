Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DA8D518;
	Mon, 27 May 2024 19:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836608; cv=none; b=WGCGxDB/f4VfN0O1YpAtNyul5mpSHEi+CC9kEolC1j/c/JKm31o6euiauE3XWCTk3Jstw9n+Jq+kBOh3fGCDDIMd3CCnDYY2TvkllfC9qCWTTEWonwenCBFHEk8gQAId3IH3Phedi2HAv5dqKu76VYh0zZxwDrl02iqp8GVcwNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836608; c=relaxed/simple;
	bh=YGIbcDdbjE6gvDfNOH9l7aY74uMLj45+vxX2uXtei3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/xtd3YlgFTDCex2pGPQ2bplIWkwh8FnKU2CBboLle0NSv+UdVT9An9zCq4iajpNIMM1AQKjrCFcus1gmvXh4yTYoBHpbZGA/Z2uj97dqTXcjvjtFJlFih/0ceu9KuN1/lzg6dulx1xy29jRhuVJbWskzcY0tj0L55qQ0vgJj7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqY/QIzH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqY/QIzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2FDC2BBFC;
	Mon, 27 May 2024 19:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836608;
	bh=YGIbcDdbjE6gvDfNOH9l7aY74uMLj45+vxX2uXtei3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqY/QIzHE0Mq88FnhRdIsAnzcDHhirCjHtHYOT0URS2CVoItWkcIYbWSOcHl8Ssdb
	 GOcvZf4KAIa3S/prjUqYRkLO2bGQyGu//JNXv+PXpE5WZBWKsCr/y2zdPeVR8+Xsws
	 x8ibYj1b18h2UvddcyOeI57JxEZy42mLsN44Zw/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 119/427] bitops: add missing prototype check
Date: Mon, 27 May 2024 20:52:46 +0200
Message-ID: <20240527185612.966547464@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 72cc1980a0ef3ccad0d539e7dace63d0d7d432a4 ]

Commit 8238b4579866 ("wait_on_bit: add an acquire memory barrier") added
a new bitop, test_bit_acquire(), with proper wrapping in order to try to
optimize it at compile-time, but missed the list of bitops used for
checking their prototypes a bit below.
The functions added have consistent prototypes, so that no more changes
are required and no functional changes take place.

Fixes: 8238b4579866 ("wait_on_bit: add an acquire memory barrier")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bitops.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 2ba557e067fe6..f7f5a783da2aa 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -80,6 +80,7 @@ __check_bitop_pr(__test_and_set_bit);
 __check_bitop_pr(__test_and_clear_bit);
 __check_bitop_pr(__test_and_change_bit);
 __check_bitop_pr(test_bit);
+__check_bitop_pr(test_bit_acquire);
 
 #undef __check_bitop_pr
 
-- 
2.43.0



