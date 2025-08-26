Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAB0225390;
	Tue, 26 Aug 2025 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216987; cv=none; b=pv2y8nTPpQkNq+p2hJcfdMZ2HC9Vd0HLPJ9Tx9+uQ0Xk0FuP0frIF96UAGL1+fH2TuwGjGEqwUV3+6CB+sVSEeU1hwvgE4LjBC8jW2iH6zLbCKy4LgYXqz4YHXKpsQs4aVpofFs/AFnkXPQdhW8QOWTJGsN15in3h715Nrvw658=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216987; c=relaxed/simple;
	bh=dzg+QoJDBBTvZep2bZxf3eBw+QdzvPLzGRiBuXSTYJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbLpFJKQh+/dptsveS57vRQPlz9cj+ZYyLZOxVfova+SaFBLk+NxeMBmJbLWTJGxapXjiZlcY51GpkQhNbPFTtDTYCKMTTXyuV/bLaXhb1+xCIBrl38BU1oR1kWWqOSlrCmLIKbmvIVdslnQSkox4Rn/Mo2XJInazs7w1Y85pdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtKgO4To; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtKgO4To"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317ECC4CEF1;
	Tue, 26 Aug 2025 14:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216987;
	bh=dzg+QoJDBBTvZep2bZxf3eBw+QdzvPLzGRiBuXSTYJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtKgO4TofDTb/7yC562GLg/O2yCyGSz0jh6iLCe8EtsXdSCAClsmVhzNg7EhDb3lj
	 15z6/cBQdecAE2iTz8WLJMc/3ZALUjAdJNUvRuXkeuZquXBBxS8a0uObzwKTUGfO7X
	 k7UhXBDspbqGsPrQMSiGuLLgc3ZDqzPVqYiO9K7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 617/644] iio: light: as73211: Ensure buffer holes are zeroed
Date: Tue, 26 Aug 2025 13:11:48 +0200
Message-ID: <20250826111001.843552123@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 433b99e922943efdfd62b9a8e3ad1604838181f2 ]

Given that the buffer is copied to a kfifo that ultimately user space
can read, ensure we zero it.

Fixes: 403e5586b52e ("iio: light: as73211: New driver")
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20250802164436.515988-2-jic23@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/as73211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/as73211.c
+++ b/drivers/iio/light/as73211.c
@@ -573,7 +573,7 @@ static irqreturn_t as73211_trigger_handl
 	struct {
 		__le16 chan[4];
 		s64 ts __aligned(8);
-	} scan;
+	} scan = { };
 	int data_result, ret;
 
 	mutex_lock(&data->mutex);


