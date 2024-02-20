Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6476B14F9DA;
	Tue, 20 Feb 2024 21:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462904; cv=none; b=R0seXWWGJ39MOfavX6p11sATzClulQaVynu4quzaHGN7OwnfBl1loz/b326/jz5qNXj49/QfbiBxh5l5oWwXrSimPRQYfNZY099YrOa7B39O/S8Bac1FagfSpnOYz2oTO6sYyC5cI/qx1tAAWc5+ub3WOCOZlc9hT6lVCkDx4p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462904; c=relaxed/simple;
	bh=Mqv/jVvRistz+SGsBVzQSvy7Lu3yr+2V25TVirawzu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzN70XU/nzg3jap3lP48+50qZahHlNMAuI96AVhMrta2F+Btq7wyl0Ai2Pn+cJNztW0AwC8f1q7xDioWWHIsvlZ0/AnjF2j3hmxQhpMp0ycIBhfryinP05dmaEV+PfRfXWXs//PBAkVVwJiIC5b4K+BYLma2NayKHJXpidLQ+9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4M5LXf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4M5LXf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C518EC433F1;
	Tue, 20 Feb 2024 21:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462904;
	bh=Mqv/jVvRistz+SGsBVzQSvy7Lu3yr+2V25TVirawzu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4M5LXf3iYobB6XiPkyDAYhf2eTAW08PEP8WDt3EGE4rVIL7t3v8zIEhqsV4L3k9t
	 bUUQTgwuLyRZ2umfsOCP/QLMZBGpsuN5FVJvCg5B1bsnPJPjR3lyo3B9YPL4W2MOJ4
	 G5ei+Kyz/h912gD44zP9Kdxqx2v6qcTcSfsKpKPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 044/197] HID: i2c-hid-of: fix NULL-deref on failed power up
Date: Tue, 20 Feb 2024 21:50:03 +0100
Message-ID: <20240220204842.399052607@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

commit 00aab7dcb2267f2aef59447602f34501efe1a07f upstream.

A while back the I2C HID implementation was split in an ACPI and OF
part, but the new OF driver never initialises the client pointer which
is dereferenced on power-up failures.

Fixes: b33752c30023 ("HID: i2c-hid: Reorganize so ACPI and OF are separate modules")
Cc: stable@vger.kernel.org      # 5.12
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/i2c-hid/i2c-hid-of.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/i2c-hid/i2c-hid-of.c
+++ b/drivers/hid/i2c-hid/i2c-hid-of.c
@@ -80,6 +80,7 @@ static int i2c_hid_of_probe(struct i2c_c
 	if (!ihid_of)
 		return -ENOMEM;
 
+	ihid_of->client = client;
 	ihid_of->ops.power_up = i2c_hid_of_power_up;
 	ihid_of->ops.power_down = i2c_hid_of_power_down;
 


