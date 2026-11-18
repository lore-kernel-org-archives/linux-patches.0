Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029621;
	b=FUKtKopu4sNtrr65njOeqFL2mEDmZZHXsFHQk8B2ni+jQzsw7jpbXbSfQCEa4stL1Pf7
	 Uux79Awo3qPWDt40F5fL15Pw8TiyoVNMy97rDFoO3lvNdBrzMabqVTk5ixDI0ttm0YsJC
	 sexayVmaMuGqnM9PIOznLCzisoY1BzPJMw0fxAn/iXqrQ8YihyJqCKA/c5+CycL8t1iS3
	 vci8PiZLUOVmrzuMcMeZxgEmpdkT6LQjTLV55QoJCbApEAMW247sSNcqRRLFFUvljon6F
	 0FqwFchYUmVAB79XvUJ7kAQ4XShy68RBBZAGF3Z8/LcT3XiZ8TNm+an9CCgPIasgK7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZnvjAIjWJXbtJzRoW7gGPrZ/Ij7p2MzACsMOsj0ojzI=;
	b=I5bJCu1WyU7OzUn1q5eEc9Azep1UUPBeYOnosn5lI7dPQ4Kfy9YJ5Wr2vgQwqc0GtDu0
	 GlzHxwiWKf57i+4urGFvu+Lcb2p5Nn+XgV8F3YHnWlVFfmboPTvFcLKJKj1zyhdynW9Ef
	 FC2PkQOg5waUZeQ6Agz08q6V5j426aqNjrJcv2FW5N72aksVYC+spxPvnSnX2e5WYE7TK
	 0Kd/BD1WX+oT4P7YDCn3KsdlZVOfcWIVSitW0DA35ALsHHGIgXLVWBSt6a9qgZy67kzZv
	 M0QrrsbK9wd/15o07JQolZMQxxIAgmFsc7QTOVqj+IXx8Daw5vZ0Y+O7ywywOeYXoRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=frwwXhhB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8F5606A31C;
	Wed, 18 Nov 2026 19:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=frwwXhhB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA071F000C4;
	Wed, 18 Nov 2026 19:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029621;
	bh=ZnvjAIjWJXbtJzRoW7gGPrZ/Ij7p2MzACsMOsj0ojzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frwwXhhBwdU/aeRYBBE7Bk1vpobWljbQj2tVyfnWGafSeeIF1Rk528rrS+D2mBrex
	 CazvambtNv4zLovtLd6Z4roJasAPbAzJuO5ZWbXHNy1TfkEo9IoAZ2CXhwtcah9yDu
	 berSfVAKqU/e39Xz54X4tJRzTE0PCTLeinKgKl50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0413/1756] media: i2c: ar0521: remove duplicate media entity cleanup
Date: Wed, 18 Nov 2026 15:42:20 +0100
Message-ID: <20261118150025.181120514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 24873149096c1..ca5bc1894bc40 100644
--- a/drivers/media/i2c/ar0521.c
+++ b/drivers/media/i2c/ar0521.c
@@ -1140,7 +1140,6 @@ static int ar0521_probe(struct i2c_client *client)
 
 disable:
 	v4l2_async_unregister_subdev(&sensor->sd);
-	media_entity_cleanup(&sensor->sd.entity);
 free_ctrls:
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 entity_cleanup:
-- 
2.53.0



