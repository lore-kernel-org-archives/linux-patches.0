Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F701D1F4E;
	Wed,  2 Oct 2024 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878262; cv=none; b=jBsoqqar++8xFMqmd92B0aYZFyCmTtpu5CAmzCToW9Hq03HPAhNg3Ye7mULaElOWJVreCUR3BH3MIIAeYx2/M6b2oYTtGfvKPLDMfkfXW95nIBVfPOUV/CSVdGKVoiArwmZi7K6CZHHYOUJW+XXO7oCWwpf1WtudJXoKurkp+5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878262; c=relaxed/simple;
	bh=/bc+cnrSYAj/bOqfqG4QvRS1cOP+ovQA7ofF6k5L8xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ubqo0m+HqZB1rg+8cYjfFsMg6hZrZBugMUEPN76xHpne/o3pHhJxGWEVaSUXERqmvuj6u1Aey1Xy9EEWLs/i7iXD34U9sZHH9SNicRQ3iX0fOJDuTTSyqJA8MAvIvAlXRCCdGNOxtGdpV4SHNCfSFVEteelkumRQYYfOK4Dm03c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REG9ikRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REG9ikRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C19C4CEC2;
	Wed,  2 Oct 2024 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878262;
	bh=/bc+cnrSYAj/bOqfqG4QvRS1cOP+ovQA7ofF6k5L8xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REG9ikRwV4JWHIXSLurNnlEVfmyB0rgZ9GaG5a0ntoaduugy43vSTFQ7HcnFywg1X
	 3WcGz6Ltp0Tq+krHdMklAt38UMO8ASba7kP2aZhbGJILAO1n/kejRT3W3aXIaK6STv
	 +wnQxEpU+qSLML74EepbZVNBGjQDR/+YEn7x3ltQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 336/634] media: staging: media: starfive: camss: Drop obsolete return value documentation
Date: Wed,  2 Oct 2024 14:57:16 +0200
Message-ID: <20241002125824.366146593@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



