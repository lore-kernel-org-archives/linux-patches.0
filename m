Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97DB1D0164;
	Wed,  2 Oct 2024 13:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876223; cv=none; b=gL+yGO/xOmG9n2NlAltEDkPWrq1BuMz1yWkRDrqux7Ce+2+5gE+a6GtF/iGMCP3Bi59hGkpWUvZj63IDcXe5RskXm+lKgs0UeGyYPLJnzAUfqWRihinwG4+xpd4/m49yN/bEVOxuFTnfpSOgqcHePYwMk5yz+8tBRuTZqwUo/To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876223; c=relaxed/simple;
	bh=STjUjWCMYkuK7X8nJgS8eaA4ZIw9LwqPFnwpzFoanOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oMY+mbJLjLDamny0mrDgq6OQ0lgPLCl9PEEftRL/5Z1hCG65JnTetSIZHBk8cWZih4swplJSkwA/VrdncZoxkUnE1DhL0l2JQLT6/CnnRmeffpstjd20FQPnvCvUEdamOOGo8Zc4hB7uYP5mNam41L63CKwK2twnCi5TZVf/x6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQWsjiFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQWsjiFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F72C4CEC5;
	Wed,  2 Oct 2024 13:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876223;
	bh=STjUjWCMYkuK7X8nJgS8eaA4ZIw9LwqPFnwpzFoanOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQWsjiFlindTHcvNTRMQbYJMPdjSv8oN5bKwBD4u8IeXLErk6MhahQifED6hsbRP1
	 laA+G1KSa9ntQEtlmSQntyrlmqmjtXOU5Fks8Nuum4lsY3gCC2fIcopSBCWs6acZSt
	 XnKClj8j9kZe5KIviLfO9+FqO5hO/7Xv1ABdfOl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 371/695] media: staging: media: starfive: camss: Drop obsolete return value documentation
Date: Wed,  2 Oct 2024 14:56:09 +0200
Message-ID: <20241002125837.268727511@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 044fcf738a56d915514e2d651333395b3f8daa62 ]

Recently the function stfcamss_remove() was changed to not return a
value. Drop the documentation of the return value in the kernel doc.

Fixes: b1f3677aebe5 ("media: staging: media: starfive: camss: Convert to platform remove callback returning void")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/starfive/camss/stf-camss.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/media/starfive/camss/stf-camss.c b/drivers/staging/media/starfive/camss/stf-camss.c
index fecd3e67c7a1d..b6d34145bc191 100644
--- a/drivers/staging/media/starfive/camss/stf-camss.c
+++ b/drivers/staging/media/starfive/camss/stf-camss.c
@@ -358,8 +358,6 @@ static int stfcamss_probe(struct platform_device *pdev)
 /*
  * stfcamss_remove - Remove STFCAMSS platform device
  * @pdev: Pointer to STFCAMSS platform device
- *
- * Always returns 0.
  */
 static void stfcamss_remove(struct platform_device *pdev)
 {
-- 
2.43.0



