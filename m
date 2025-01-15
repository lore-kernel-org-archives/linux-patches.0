Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF8B248BB5;
	Wed, 15 Jan 2025 10:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938766; cv=none; b=GnYDniOaE2Jj1VRGqiz8IhvAsqy7SsRW7SSDmlFonnUgTtYKkDq0UzNjMguISgT8yC10ExsNpWYLIsueLiu6I0UyDFz04bEBU4jaKGdLLk/BA2M31UrwgcrpDtoxX2FN2CkapjD+KFhtuUwragWciKxw+HMFrnkQ1FaqadmB++g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938766; c=relaxed/simple;
	bh=8cWpgjchkrvgJMYp3HjeqG2ZDseuux3nkowB8MJ6A6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsnI3oRuC52Y9xWh0opnDBOmNghCbRnTApTHYo+iz7woUY3gcW2loVUbH9VwnIJYBP2vKngLgmqD6cgo2yegD7LTy1Ruc8Rx322SBWL6dJwL+k03t5cuD9Xe8WGBrFof0OrGQXOETrwD0mL1SMr/3tghDal+JbTPqT89pe7DsWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BH9RQrwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BH9RQrwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11993C4CEE2;
	Wed, 15 Jan 2025 10:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938766;
	bh=8cWpgjchkrvgJMYp3HjeqG2ZDseuux3nkowB8MJ6A6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BH9RQrwHSaPPy2ReCb+juj9KHV6HyIpsSI/GNL7bjhZNgSgiCZ/Yn1NDlUDwn8UKu
	 lvNqJ+Wi6+wqTwQsmtflPUk9hhqhZemzil5qP/aJMXap0fjFGOtWw/Dl/zMRHUrGBt
	 LDDRN/denWTqqjjmmUfn133Cz0vhXw72aBMH+VhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <quic_prashk@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 092/129] usb: dwc3-am62: Disable autosuspend during remove
Date: Wed, 15 Jan 2025 11:37:47 +0100
Message-ID: <20250115103558.036759514@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

commit 625e70ccb7bbbb2cc912e23c63390946170c085c upstream.

Runtime PM documentation (Section 5) mentions, during remove()
callbacks, drivers should undo the runtime PM changes done in
probe(). Usually this means calling pm_runtime_disable(),
pm_runtime_dont_use_autosuspend() etc. Hence add missing
function to disable autosuspend on dwc3-am62 driver unbind.

Fixes: e8784c0aec03 ("drivers: usb: dwc3: Add AM62 USB wrapper driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20241209105728.3216872-1-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-am62.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/dwc3-am62.c
+++ b/drivers/usb/dwc3/dwc3-am62.c
@@ -284,6 +284,7 @@ static void dwc3_ti_remove(struct platfo
 
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
+	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_set_suspended(dev);
 }
 


