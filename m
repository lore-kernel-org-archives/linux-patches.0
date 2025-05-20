Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD581922ED;
	Tue, 20 May 2025 13:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749363; cv=none; b=bUA1LAoWcc5ouI79akI8YvQQEE1/ksswSvOIQXB9a/aNZSQAR9TDVC3Pug44j0gvYwn4AQ4L+2ClqL4/rff7ROFOobKXZPnVGhSmZLq+ysWfKzWB1mMr40d4hSbrrXE3pF0Spid9uyC77nBxTo5hggRmQsOuIF2xabtbhb0ICgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749363; c=relaxed/simple;
	bh=IL8G3VQYO7XP0cKFU4qhb+69+/tc0b1rBm2XtgSAwSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kTpiJiazzVB1BlcuReKVXYhEVhfIcoJsFUcM5IS+lFTRlLrM2lze3tkTflJBgOoOZPAPVwxYLbdhhlkouFbj411f3mWrvcH6vWbZU74CtFx0Hw89ttuyU4khPs/YPcjFntMRM+E0zpzeCi/1IGZtoI1LatJX0qZ97oLQCuCer8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOUI+Gk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOUI+Gk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33193C4CEE9;
	Tue, 20 May 2025 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749363;
	bh=IL8G3VQYO7XP0cKFU4qhb+69+/tc0b1rBm2XtgSAwSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOUI+Gk/kYqo1+Vx5sRdZ4sG1PqiRrION8212vib9gT/M7Kfindcljw1VTJm7gZuM
	 IjA0kSeQYiC4Pj2JXaaa3UXiChYdxnF5JlMOd2ZnPWFoE9g/rOVc/jFV2dAkN25MGj
	 BOr8P8mlde6+rdxL6TE561M54FTFCpPwsEWohbqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 20/97] iio: chemical: sps30: use aligned_s64 for timestamp
Date: Tue, 20 May 2025 15:49:45 +0200
Message-ID: <20250520125801.460805883@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit bb49d940344bcb8e2b19e69d7ac86f567887ea9a ]

Follow the pattern of other drivers and use aligned_s64 for the
timestamp. This will ensure that the timestamp is correctly aligned on
all architectures.

Fixes: a5bf6fdd19c3 ("iio:chemical:sps30: Fix timestamp alignment")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250417-iio-more-timestamp-alignment-v1-5-eafac1e22318@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/chemical/sps30.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/chemical/sps30.c b/drivers/iio/chemical/sps30.c
index 814ce0aad1ccc..4085a36cd1db7 100644
--- a/drivers/iio/chemical/sps30.c
+++ b/drivers/iio/chemical/sps30.c
@@ -108,7 +108,7 @@ static irqreturn_t sps30_trigger_handler(int irq, void *p)
 	int ret;
 	struct {
 		s32 data[4]; /* PM1, PM2P5, PM4, PM10 */
-		s64 ts;
+		aligned_s64 ts;
 	} scan;
 
 	mutex_lock(&state->lock);
-- 
2.39.5



