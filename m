Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BFC1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467AAC433C7;
	Mon, 11 Sep 2023 14:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441974;
	bh=+d/jcUWk6XWoDM1IVeTYd05MWBzcbMGfJi72ZMYlBxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZxiPKYaATzMbN4yT+tYEmctlEiHHPa9X9QLgeSMbBKxI8u5EELj5tnVVdHxW9XqlB
	 OJnsTDCxpg1Shc29tqcx2xAVJ/hK0zHebDDSKkhjY2XFhsITlRSLuK6BeNBOW1IEmz
	 VIpF8P67uoyiYHI5DY4l9Aohxy60i/mGT3YscxGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 601/739] leds: aw200xx: Fix error code in probe()
Date: Mon, 11 Sep 2023 15:46:40 +0200
Message-ID: <20230911134707.887482336@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit ad5152b85e8bc7dacb1e6e237553fbe779c938e0 ]

The "ret" variable is zero/success here.  Don't return that, return
-EINVAL instead.

Fixes: 36a87f371b7a ("leds: Add AW20xx driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/4d791b69-01c7-4532-818c-63712d3f63e1@moroto.mountain
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-aw200xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-aw200xx.c b/drivers/leds/leds-aw200xx.c
index 96979b8e09b7d..7b996bc01c469 100644
--- a/drivers/leds/leds-aw200xx.c
+++ b/drivers/leds/leds-aw200xx.c
@@ -368,7 +368,7 @@ static int aw200xx_probe_fw(struct device *dev, struct aw200xx *chip)
 
 	if (!chip->display_rows ||
 	    chip->display_rows > chip->cdef->display_size_rows_max) {
-		return dev_err_probe(dev, ret,
+		return dev_err_probe(dev, -EINVAL,
 				     "Invalid leds display size %u\n",
 				     chip->display_rows);
 	}
-- 
2.40.1



