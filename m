Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0768A46D2BF;
	Tue, 21 Jul 2026 18:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660271; cv=none; b=jplTU+JQrDpJ8wtbPAxxTe0CFD2NWQfWWF2EmN5XlM38kK6GXQpDVBG4C5WwPyolAo7fpEHZS/93kkPIkigALDzLlyHjzXXpJGVEeVE0z0Ob+GQkZSiTgNT3mlq4ViwxW/34isU/PycUUlWOXWR2UY39ZJYT/Qoy70rm91rMx3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660271; c=relaxed/simple;
	bh=2yEuDT25wumeoCJ7tdKinvaG6G30rs2G5lKUW7jBTyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RATOg7ogoJzV0K11mp7Q3ot7SEuoEnoI11FL46O9BoqmvqcNPHkzzvqq7k9LI0iQQmegRKeY9UsRRrLkB2qRQt8mTvk+XgnFZ1/7CjjzVa2c6yfsKvz1KBB58VsbY+HLmEWMkQILtyjAO9FofIHC2zPGYYKqRPNJqIgVB9lgw8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqLa0u3k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqLa0u3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BF01F00A3A;
	Tue, 21 Jul 2026 18:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660266;
	bh=aVKY8vISHUgaRHUa48qxx2S70K+gH/UJ9xQcFe7t+Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zqLa0u3kPidNg/MVzK7s0TfJk4izwAg3G83PWj4VDnD+m+OFo5Ud5tBJWQdcaEbBN
	 zdPujJdtwnKWF87z0IWB38XAqF4fWm1mqosyACqvMShxJ+LezPKZ92X7pVACl3P67V
	 vWpheWKFW2EDmpFM91TIo3Ks92xhYQAf1CMbfep8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0913/2077] HID: logitech-hidpp: remove excess kernel-doc member in hidpp_scroll_counter
Date: Tue, 21 Jul 2026 17:09:46 +0200
Message-ID: <20260721152614.349496647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit f22a5db8a7d38152556f230d6d68e59dbc27971b ]

The @dev member described in the kernel-doc does not exist in the
struct. Remove the stale entry.

Fixes: 0610430e3dea ("HID: logitech-hidpp: add input_device ptr to struct hidpp_device")
Assisted-by: opencode:big-pickle

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index ccbf28869a968d..1990ba5b26ea67 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -164,7 +164,6 @@ struct hidpp_battery {
 /**
  * struct hidpp_scroll_counter - Utility class for processing high-resolution
  *                             scroll events.
- * @dev: the input device for which events should be reported.
  * @wheel_multiplier: the scalar multiplier to be applied to each wheel event
  * @remainder: counts the number of high-resolution units moved since the last
  *             low-resolution event (REL_WHEEL or REL_HWHEEL) was sent. Should
-- 
2.53.0



