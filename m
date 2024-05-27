Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66523168C4;
	Mon, 27 May 2024 19:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837896; cv=none; b=kie/TleZDt070l6Os8TbCqOGwXsBy3FqRWtYgWYn4uCL9whFRR6t1JgGPW7Saj3HA6dHz5zXfxf3r4ayobFVQbS1oCCF7yYlgu5mg6wwOm62kjmos9z9GZHAmSIZgLShON/dHsBMuOkSOQTlb4kqMQ0nQlsdx0pcxYoHNJF6Vjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837896; c=relaxed/simple;
	bh=hw27nk9rMuH4+E4L2smE+N6xhVnX+F/TFPxbbtDlYrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaD2BWuEzB2+9TqWzpL/74b1A7eNOPNJ0iHtLMo3vnBuu775q9aEn8SmEwNeO5PC3TaLlckcWqWf9gOOLltiKt7AoHP7aZ+mpZDzTn7Gu1oqSy5PrLKcuSpPRfKeZZ1zarJVbB2PRabBEuSmZihO/u2mYJCeFvNdyx3qbR/xIoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4C6drCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4C6drCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F115BC2BBFC;
	Mon, 27 May 2024 19:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837896;
	bh=hw27nk9rMuH4+E4L2smE+N6xhVnX+F/TFPxbbtDlYrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4C6drCiRo/lBTbbssQ55v+qrr+CkPQWy41opyIw0M+ZweAqOf0SL3K+J1kuN7MYz
	 VdC9TSlh3V1sedoaCg+pksQqc8yoKyGDlB80R98DP9aJKFDQoedEp79AbUtPscFuDr
	 I3Tz9uMK5U8lmdS/AET6BzK887o15gHRXWdxGTyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 188/493] bitops: add missing prototype check
Date: Mon, 27 May 2024 20:53:10 +0200
Message-ID: <20240527185636.506043458@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



