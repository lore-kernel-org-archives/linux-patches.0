Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048437;
	b=n/bxo0LpbwM9iEdsPQd/0wQTjznexVGWCFe3d6x7kS73NmFfE4hsy89UGr6uNizLI9gT
	 cFZ+bZCjVGcx+ibFdrFJjzbTj5cLr447znZYdKzBMjumY8hoxkiu+V/EKhNezrMWLiRdM
	 BqMFbq5h84WIzoEwkfHtvZJDNDWwCT282AggJ2LaarD7W9pqTJjirrq70BDmytEMNpW9f
	 HrMf7D+Ubnyf4t1psLg1Wsy+1unjIMDnjkd7hDQ79f4KUSF0rqqyn7eKFDDMt/ObeJpIS
	 9kD5uAb/AcPSgJqavQ2ghasM702xKYoiwkMnSuD5/b/BCtoP/abA++bLQS1dqFFmx+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Djy7uZxnH9t9MMTuV/WI880tLcOqaHhBfWxUR5r0wys=;
	b=3T8eGKHOB53sE1GNRwVdNwZ0JjI3zhcOS5y8JTnFd85FlnF7Iz/C6tgfesxQy/zZRPX/
	 p98zjdzxdcWarR3Uw9l28UWB+UryiNkwvKHPt5/P8PCNW40jgJptAkdz+t+O7XaSANaiQ
	 Ud/T2WTlgDNknPzqy0FRcM02RQiY2eoiE05XlNAxCwaqBj3USn6KirR93oLIHBs9njfiS
	 u0bkj69PWW+gJ4tb1FK6xj9N5BIfDR3xReiUYgQ3Kj5SdF9l0sU28tS2N5IFDzek/NgBd
	 MjMkscLSvYGaBewC5Tj2VR9jk6c/2IlH2Z1jBo97zbEn8+40C+egGk0CkHFecxF8mEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HcJ2BTEs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A49560A260F;
	Thu, 19 Nov 2026 00:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HcJ2BTEs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09C41F000C6;
	Thu, 19 Nov 2026 00:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048437;
	bh=Djy7uZxnH9t9MMTuV/WI880tLcOqaHhBfWxUR5r0wys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcJ2BTEsTd9sXkOxECMjI2T3bKZ9pojbC56iAJmDN0AQLMl2yKw+6ImHwFtzTLll3
	 Bsv6ICHlGuQ1EF5v3HClO9OGsbqO4Hs67uT+Jm25cjwZDcfOtg25WAPCsl1zszDy3z
	 YO1xz9PV66kTfBvv/g+Drncq+qe29CyV9BMPoJYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1943/2857] media: i2c: ar0521: remove duplicate media entity cleanup
Date: Wed, 18 Nov 2026 15:49:37 +0100
Message-ID: <20261118150311.173671818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 069a0343581bfcaee44bc598e2b95be2e2789807 ]

The error path taken when ar0521_power_on() fails calls
media_entity_cleanup() at the disable label and then falls through to
the entity_cleanup label, where media_entity_cleanup() is called again.

There is no need to clean up the media entity twice. Remove the first
call and let all error paths converge on the common entity_cleanup
label.

This issue was found by manual code inspection.

Fixes: 852b50aeed15 ("media: On Semi AR0521 sensor driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ar0521.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/ar0521.c b/drivers/media/i2c/ar0521.c
index 1ede57958410c..e10b15ae397fd 100644
--- a/drivers/media/i2c/ar0521.c
+++ b/drivers/media/i2c/ar0521.c
@@ -1011,7 +1011,6 @@ static int ar0521_probe(struct i2c_client *client)
 
 disable:
 	v4l2_async_unregister_subdev(&sensor->sd);
-	media_entity_cleanup(&sensor->sd.entity);
 free_ctrls:
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 entity_cleanup:
-- 
2.53.0



