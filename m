Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9E12E7BBE;
	Thu,  3 Jul 2025 14:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554673; cv=none; b=NGtoFgVKaPbrLuvYIjl/UtSKC/R0yI8BXLaNOD/1ZdvFdDEOxwzN65xZm0Cg2YWVwXoMxFBctdoX6Upjw5tSMsWyESqx0WBDX9CRvobDkMGATqEg7Ix8/LdjZ5FjQvzxtPoDp5JWLHsKsHB3+zFTU0QpdNomenh57IcqbniTZVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554673; c=relaxed/simple;
	bh=wLMtB8CKBVwc+ZkXCpFBijnJgqEamdMTuX1kVU5if8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDUx65OAH6JWmrGlW1kAiOtwD6xcuFuOYUYepiOGyAbCs02Gn/4QsoAdgzIELeD8/42ucD9DQrr7w56nvKH+w7br2VS296be4CnH8YB/CJcQ+LIWAJ8h8DbdbP2e/3UoRBIbev0l41RNOSHZnaSBdssL3UnASBahbvrLQ77We8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5sDAesl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5sDAesl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FBFC4CEE3;
	Thu,  3 Jul 2025 14:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554673;
	bh=wLMtB8CKBVwc+ZkXCpFBijnJgqEamdMTuX1kVU5if8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5sDAesloKRHUqnyseTHMYLXe9OhcY6bU4Z6TVJ4XXuGPC3q5LnLQ/xA/bhH66qDG
	 htvfW+3oSUeI3PnwhjiI7qWk7SLmENZlDv/sj0PvBPBC34BK7UJHzVymeKdxJLoGTA
	 xyuagX6JsRQkTHeUA7/yQgBvGMH/4v/1vzl45v+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 044/263] iio: pressure: zpa2326: Use aligned_s64 for the timestamp
Date: Thu,  3 Jul 2025 16:39:24 +0200
Message-ID: <20250703144006.074464492@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 886a446b76afddfad307488e95e87f23a08ffd51 ]

On x86_32 s64 fields are only 32-bit aligned.  Hence force the alignment of
the field and padding in the structure by using aligned_s64 instead.

Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-19-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/zpa2326.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/zpa2326.c b/drivers/iio/pressure/zpa2326.c
index 9db1c94dfc188..b2e04368532a0 100644
--- a/drivers/iio/pressure/zpa2326.c
+++ b/drivers/iio/pressure/zpa2326.c
@@ -582,7 +582,7 @@ static int zpa2326_fill_sample_buffer(struct iio_dev               *indio_dev,
 	struct {
 		u32 pressure;
 		u16 temperature;
-		u64 timestamp;
+		aligned_s64 timestamp;
 	}   sample;
 	int err;
 
-- 
2.39.5



