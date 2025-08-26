Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D548635D;
	Tue, 26 Aug 2025 14:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218447; cv=none; b=AZ3KEMVjAveY0pU8ZFp/8YX4k2ufdCu5ygzFLSROjDzjIzAKnwonkYX3ETNEpqXySTHrbLlkN+M/tZErmxFmr7LvIsdcJQKIqiUSy5n1z2WjZC2fheZZdFIRmbH/i/DjIvAcpZQZ2zKVOjwKkvCypV5T+XIuEyqDgVIDcNN4u0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218447; c=relaxed/simple;
	bh=hoIQS54sba+yYZ/psNozBoPTyJ7uLhNH5acyVhzYZmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2T342/to5UJ8LPEmZjHugEGwFHk7UgyzizpD5OQJXKXofdvaQHNU8i3El6vtdS42twjSJa2Qw71Y1n126RSTlnwoEno8l+JuIekghc4qeCHqjHdOwbWgcFMU0zYxqlnt2TFjujK85UjHEC4c/Ezdh88/K/zLmhiWJZDrNQVHE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tipO1mho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tipO1mho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81A2C113D0;
	Tue, 26 Aug 2025 14:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218447;
	bh=hoIQS54sba+yYZ/psNozBoPTyJ7uLhNH5acyVhzYZmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tipO1mhoQlTGoR52PzzYxDIa3hxk224ssZsba1dImSwaiMdCvQrBfB6SfE//362Wl
	 vxRa+vSpXaZ07UZHn0r6ZakEbM/wBE9UcUzhBlqiiirsG59/3nI0FWmL52ZKOkgGX2
	 SzRwwITSw41460UKygDMphRylLEPt0NlH2E2coM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 506/523] iio: light: as73211: Ensure buffer holes are zeroed
Date: Tue, 26 Aug 2025 13:11:56 +0200
Message-ID: <20250826110936.922852429@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -574,7 +574,7 @@ static irqreturn_t as73211_trigger_handl
 	struct {
 		__le16 chan[4];
 		s64 ts __aligned(8);
-	} scan;
+	} scan = { };
 	int data_result, ret;
 
 	mutex_lock(&data->mutex);


