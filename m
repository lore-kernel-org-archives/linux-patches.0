Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A8835083A;
	Tue, 26 Aug 2025 14:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216931; cv=none; b=MmA/Pc7IuEKdQXSFlN5YmZ1lgbFvMYOLNRlAMQuxmrM38iMyhYF7Tgow6lTWf6UsSQBI5A8Rk4Z03wGi4qDemIAYyMlEVTlk7AxWdLW/pjG/zWRf2ktCtPqPTDLBKEcH3TCWAW/ehfMAgegeK6Cy1BVOz10pB2L6W2vhNeXDLGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216931; c=relaxed/simple;
	bh=Q+TGISCWWRlvVp1zZnaCZ6BoUTfkwwifgAOi68JCzoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ADFE/a+3qM9Og7jCBZhWhizhX9OcKScJrSTZ2tC4WOoe2ztTR5/wrO72BHYxVOzHehmkkBsC61JRbpesElzQPgIKD8qGbKYFIPOiLkMOyKcnqUJ5FqCkOD137xr+4dULIaDKAvxAghWFuOk2X1d2iiZHw7VGJ034eLuF1O6Zmdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ti2IyluY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ti2IyluY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3A2C4CEF1;
	Tue, 26 Aug 2025 14:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216930;
	bh=Q+TGISCWWRlvVp1zZnaCZ6BoUTfkwwifgAOi68JCzoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ti2IyluYSjLPVxOe3J6NOyhhnEmghFa13AbQTsH5jmUWU+nkw7wTjf+LgumnOtzgA
	 /evAqvdZFuyIVXEUmM+r2DRTi2Htt8/2nKMK8hccaU9UmmEvJLQ+Q3xXgMROEIHpgF
	 qIFTwNCejat5tVoj9l6sIad04OGDoFIIPSdpbdn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 596/644] media: camss: Convert to platform remove callback returning void
Date: Tue, 26 Aug 2025 13:11:27 +0200
Message-ID: <20250826111001.310414654@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 428bbf4be4018aefa26e4d6531779fa8925ecaaf ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 69080ec3d0da ("media: qcom: camss: cleanup media device allocated resource on error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -1477,7 +1477,7 @@ void camss_delete(struct camss *camss)
  *
  * Always returns 0.
  */
-static int camss_remove(struct platform_device *pdev)
+static void camss_remove(struct platform_device *pdev)
 {
 	struct camss *camss = platform_get_drvdata(pdev);
 
@@ -1487,8 +1487,6 @@ static int camss_remove(struct platform_
 
 	if (atomic_read(&camss->ref_count) == 0)
 		camss_delete(camss);
-
-	return 0;
 }
 
 static const struct of_device_id camss_dt_match[] = {
@@ -1519,7 +1517,7 @@ static const struct dev_pm_ops camss_pm_
 
 static struct platform_driver qcom_camss_driver = {
 	.probe = camss_probe,
-	.remove = camss_remove,
+	.remove_new = camss_remove,
 	.driver = {
 		.name = "qcom-camss",
 		.of_match_table = camss_dt_match,


