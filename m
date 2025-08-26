Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1992EE296;
	Tue, 26 Aug 2025 11:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207745; cv=none; b=vAtZO8YMHwsazoMRQb5AFpdNpcfbo6SiGZcwBmqLHd6dXZGbVhhpQmk49G9rXUZRO+nBkR8uDaCMn2spfDOhFcvtfKZq40P5UrnZyMR/mfb+FLHEhwm0aI4u3Ad+FBVvs7hNX5JAFvH5zi+btylAAarRKCCOo3W8b5FoVQOd278=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207745; c=relaxed/simple;
	bh=QWdJxuZukKz1CgkdrMemI0MlkUbVsTOqa7r1KvxouL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO1it11PULPpI/I5u1UeXOzBzFYwWB4dmDqhUGEsiNo29PS8BTgdoxFOUDITvfK9vIVoEO3QMRFEoXZq54crCT8WgISAEKo/A7nJnM8G/VHeOQbZ9zTyl98zL937pEoQ7Tu5RkA3T24gwwHOt71IBrZ8RXU+KB15gqHTeGon7H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LE3KLG0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LE3KLG0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1086C4CEF1;
	Tue, 26 Aug 2025 11:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207745;
	bh=QWdJxuZukKz1CgkdrMemI0MlkUbVsTOqa7r1KvxouL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LE3KLG0CjLN7cFZxDdEMMEWo4bFBaWvbbVbKdtnr3rFuJBfsvwWZK06Zf6ySXbaIs
	 7qJpyCYyywOCChuGGyR2saCFPr1KDSPcCvHmIjDgFeP9kOHVwrT+7UtCS4tRdV3mtU
	 enr3SO07KRzNyEI0MPlu+4ph/3fn+Rl4ap3gBj3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.16 300/457] iio: light: as73211: Ensure buffer holes are zeroed
Date: Tue, 26 Aug 2025 13:09:44 +0200
Message-ID: <20250826110944.788863313@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 433b99e922943efdfd62b9a8e3ad1604838181f2 upstream.

Given that the buffer is copied to a kfifo that ultimately user space
can read, ensure we zero it.

Fixes: 403e5586b52e ("iio: light: as73211: New driver")
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20250802164436.515988-2-jic23@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/as73211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/as73211.c
+++ b/drivers/iio/light/as73211.c
@@ -639,7 +639,7 @@ static irqreturn_t as73211_trigger_handl
 	struct {
 		__le16 chan[4];
 		aligned_s64 ts;
-	} scan;
+	} scan = { };
 	int data_result, ret;
 
 	mutex_lock(&data->mutex);


