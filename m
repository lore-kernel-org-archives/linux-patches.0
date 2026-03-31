Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF3A3FADF9;
	Tue, 31 Mar 2026 16:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974304; cv=none; b=YB/pN9Re4O4hjTftNYyYRvFRWq47aY+WBJo9SVpF16AjxRcl8gV4XmcBoONu3Oy8Je3V0VibrsM35wWO7mi0LUe960I1LF2PropQrvFodzne6llGNSzjuDijs532XFrmsVWOMQNBhcoTk9xx0kMgSVB8cWImALoWFoXej8HUI2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974304; c=relaxed/simple;
	bh=SESgMhkFm7kHovOuPO9XXVUZaxtSkgVcI6WyuWQeNlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c3WX7jVE2Y/ziDUgL1m0lKHENTdkYSYOFuwEwN/uaj4kDqnxQLB4ASNZ2Apvz/pKBCd/BQ8pBNW8FBq8O9mT0rB9nTR+ZYdTK8cVKCNksBIk2bmOZPpWcPApKTSiWinh+EOjkyIrfsBYO4xjsE46wX8Z05SevH3V7iiVxXo3Y9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhZhFepz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhZhFepz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40142C19423;
	Tue, 31 Mar 2026 16:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974304;
	bh=SESgMhkFm7kHovOuPO9XXVUZaxtSkgVcI6WyuWQeNlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhZhFepz9ndslVbj5E7gZ8upcaQataNvtkpU9I+YiUmZUN8Lm2S1umMbTRYFaPEyF
	 UFW/uOfC/bL+fFmOV5KrWNgu9CvvjclmyvsaqfzIYYqCVdFUOcprGIy8UrNqdwIuLL
	 DLq8raO9UhAu7Ipq9C+9RSiMT/e9K1Wim7TfQNaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/175] hwmon: axi-fan: dont use driver_override as IRQ name
Date: Tue, 31 Mar 2026 18:19:50 +0200
Message-ID: <20260331161730.017651713@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 813bbc4d33d2ca5b0da63e70ae13b60874f20d37 ]

Do not use driver_override as IRQ name, as it is not guaranteed to point
to a valid string; use NULL instead (which makes the devm IRQ helpers
use dev_name()).

Fixes: 8412b410fa5e ("hwmon: Support ADI Fan Control IP")
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260303115720.48783-4-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/axi-fan-control.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/axi-fan-control.c b/drivers/hwmon/axi-fan-control.c
index df99cad16b208..641cc06c77aff 100644
--- a/drivers/hwmon/axi-fan-control.c
+++ b/drivers/hwmon/axi-fan-control.c
@@ -507,7 +507,7 @@ static int axi_fan_control_probe(struct platform_device *pdev)
 	ret = devm_request_threaded_irq(&pdev->dev, ctl->irq, NULL,
 					axi_fan_control_irq_handler,
 					IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
-					pdev->driver_override, ctl);
+					NULL, ctl);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret,
 				     "failed to request an irq\n");
-- 
2.51.0



