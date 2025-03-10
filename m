Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0FE17C225;
	Mon, 10 Mar 2025 17:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627044; cv=none; b=iXaPzMEgK09D83OSQGuVzC4lRGoEGEjexFe+Ppb9EE+VEP43KZDwSLUBC3Hba6dW4lSQ1pmjLlafZMlGqb/1UJfeoHPWsPpk92twDRddZLRW/kkgQBuy9FZcrcSVjgbFerj1xu+4cYOymLkjMRt4dNvpvtPlkKHWYEcIqTx8O9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627044; c=relaxed/simple;
	bh=PDRbe/vVs6OHFJ+8vUp08TGRBn/Y4r4BS4iIJy1/w2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+AvDuNwqrkUJiHIwIF8byf5Pwi4vaE8vBXUTwAYZ7vGWOoa3ETawPdZGD0sdBggUijeXK87GZTr/oQIHX72lCD3J7VLAR/NuG5JIbp2sDnmwPw1OnmEmxyPPBlMrHPJX+6KzS8FbvwRqbY0mvHJYKqeAJc71mrVmz4q4VN2V+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlj1qBw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlj1qBw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BBCC4CEED;
	Mon, 10 Mar 2025 17:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627043;
	bh=PDRbe/vVs6OHFJ+8vUp08TGRBn/Y4r4BS4iIJy1/w2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlj1qBw9Tqt6upU6DKskdnioH+WYP8iFTfOIt2A2vwAB9Xpk0ZzRL0CjVgykSyMqD
	 OH/nnvysp/FXlFkaRsZjf3a/BtFQxFnRjKzMDrcoHwsQMJxe6sKBDT8dlftldu/p53
	 J/8UF+q3NtBgJ3ayj96V/S8uAOqwXNN8LvDZi+kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 201/207] iio: adc: ad7606: fix wrong scale available
Date: Mon, 10 Mar 2025 18:06:34 +0100
Message-ID: <20250310170455.771922551@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Angelo Dureghello <adureghello@baylibre.com>

[ Upstream commit bead181694df16de464ca2392d0cec2cf15fb978 ]

Fix wrong scale available list since only one value is returned:

...
iio:device1: ad7606b (buffer capable)
    8 channels found:
           voltage0:  (input, index: 0, format: le:S16/16>>0)
           2 channel-specific attributes found:
                 attr  0: scale value: 0.305176
                 attr  1: scale_available value: 0.076293
Fix as:
           voltage0:  (input, index: 0, format: le:S16/16>>0)
           2 channel-specific attributes found:
                 attr  0: scale value: 0.305176
                 attr  1: scale_available value: 0.076293 0.152588 0.305176

Fixes: 97c6d857041d ("iio: adc: ad7606: rework scale-available to be static")
Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Link: https://patch.msgid.link/20250129-wip-bl-ad7606_add_backend_sw_mode-v3-3-c3aec77c0ab7@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7606.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7606.c b/drivers/iio/adc/ad7606.c
index e35d55d03d86a..b60be98f877d6 100644
--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -1039,7 +1039,7 @@ static int ad7606_read_avail(struct iio_dev *indio_dev,
 
 		cs = &st->chan_scales[ch];
 		*vals = (int *)cs->scale_avail;
-		*length = cs->num_scales;
+		*length = cs->num_scales * 2;
 		*type = IIO_VAL_INT_PLUS_MICRO;
 
 		return IIO_AVAIL_LIST;
-- 
2.39.5



