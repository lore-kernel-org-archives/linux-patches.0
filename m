Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA8214F6A
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJPryWCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B038AC433C7;
	Mon, 23 Oct 2023 11:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060092;
	bh=tLupdmBeiR28xtA3L+BbwkL3eWItcOxoUONOH+xWYp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJPryWCwmum5IAIp/q770EEYmPyT+mUH/eDr6PuPKZl7+vAKk1dY6D/Pw8Wr1tI6F
	 2Pn4K9eF7rKgQowIa98ERw4yKHvWQPk4oxldA4luvIsLD4ArTwbdi3+9/1HPEAUjsk
	 6+zwLVmuEHuKBjyl2OU/0G0A6mu8AlepyfRD+tSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 019/196] regmap: fix NULL deref on lookup
Date: Mon, 23 Oct 2023 12:54:44 +0200
Message-ID: <20231023104829.031149949@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit c6df843348d6b71ea986266c12831cb60c2cf325 upstream.

Not all regmaps have a name so make sure to check for that to avoid
dereferencing a NULL pointer when dev_get_regmap() is used to lookup a
named regmap.

Fixes: e84861fec32d ("regmap: dev_get_regmap_match(): fix string comparison")
Cc: stable@vger.kernel.org      # 5.8
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231006082104.16707-1-johan+linaro@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1572,7 +1572,7 @@ static int dev_get_regmap_match(struct d
 
 	/* If the user didn't specify a name match any */
 	if (data)
-		return !strcmp((*r)->name, data);
+		return (*r)->name && !strcmp((*r)->name, data);
 	else
 		return 1;
 }


