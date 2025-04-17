Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1D22571AD;
	Thu, 17 Apr 2025 18:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914481; cv=none; b=gQCmtxh0mExqB+2m2LFyze0PObb+901ZfK0lV0L0OrMqq6NGRe6+GaHd1qxUafrZxnJUkHYoKUNp9HEUJSyRddm24Rjkbcfhv4vEYzDcMi7xIAIwDkuyQPMQnqF9pOpPsx3rzvSAjqQJLaHFk5uNMqIbjXdcH4qygDxTOS/Q3/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914481; c=relaxed/simple;
	bh=5Qc+8Xwj8662ly7ujtHpcJWGr+9KYmoFrba85vBYCYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcnMUw81aN3rq1Q6huvtg2yaw0LPaDf82EjOiIAxr+BWisvvkYqwlHJFcywlf7cQAdUORBZ0MKspeN16dja2Dmu2WvSvB16sRysPT9RjowQ7t/z6exE2PRdbqUTqaP/EuYvwKcD46MDk9myykjVbUKF70oPenNDhi8MMJ7pHaoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjSrn9u8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjSrn9u8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0D9C4CEE4;
	Thu, 17 Apr 2025 18:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914481;
	bh=5Qc+8Xwj8662ly7ujtHpcJWGr+9KYmoFrba85vBYCYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjSrn9u8P9V1fw4CrJiIIDSP0I35D1YIFdMNoO712iSR0rf4800GNa4iOriNekgzB
	 t5NtAcbYWOd0jE+hAeRFI0aI6sRnSwKrKkfNVJN3jfGipm8UxMIxfXUqyu1rbo0o7Q
	 sWA1ivLYo2H+mRNUNIurSScPGjYtwRDoEEaWO4ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 229/414] Revert "media: imx214: Fix the error handling in imx214_probe()"
Date: Thu, 17 Apr 2025 19:49:47 +0200
Message-ID: <20250417175120.643964866@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit abd88757252c2a2cea7909f3922de1f0e9e04002 upstream.

This reverts commit 9bc92332cc3f06fda3c6e2423995ca2da0a7ec9a.

Revert this "fix" as it's not really helpful but makes backporting a
proper fix harder.

Fixes: 9bc92332cc3f ("media: imx214: Fix the error handling in imx214_probe()")
Cc: stable@vger.kernel.org # for >= v6.12
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx214.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/i2c/imx214.c
+++ b/drivers/media/i2c/imx214.c
@@ -1114,7 +1114,6 @@ free_ctrl:
 	v4l2_ctrl_handler_free(&imx214->ctrls);
 error_power_off:
 	pm_runtime_disable(imx214->dev);
-	regulator_bulk_disable(IMX214_NUM_SUPPLIES, imx214->supplies);
 
 	return ret;
 }


