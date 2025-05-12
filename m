Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336DE24DFF3;
	Mon, 12 May 2025 17:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071960; cv=none; b=cxj+fPP2oWotZDs118nt34GBHJq/cn9/8rRK4weKwlUZKvPUPeDLlE4n6Oh68wNWHOfdM0m8EO3cTHXUCogk/1T3HxKallPEN/hbsomxZxpYeBI+txf2OEaDvqm3Nq+b05v9oX9xOsF4IrcdZkHwWecK/RkJ2U8S7vAcfx1bC9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071960; c=relaxed/simple;
	bh=eAE/GT6d8qswbowOoEsjd/4NZlmIEdtuY4VRfPX3iQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X9TGhamJN2s3LByVBGd1yH88uRFzeahyHgNZyTPlyoFvEHP9o3FLzQ4du5CXEwyHlxEDacSnVvVhsyu4AS78/uVEdyoM72ESa58FZJ6wdhcDgH/YlJ79+PEtMihtKk7KUDNxC4/wAajFcYkPRQc0brwj1o/Eb11LCc50deMdrpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSnoXx2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSnoXx2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F3AC4CEEF;
	Mon, 12 May 2025 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071960;
	bh=eAE/GT6d8qswbowOoEsjd/4NZlmIEdtuY4VRfPX3iQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSnoXx2cMlDdVR1sdh08qNeXYMmRGYsIXxD28rE5U2lXGJfy25b+ghuCkfrMPXhfn
	 CWkNXCIAAs6OiuAwbIE8G/pkfpZk7RUpqWVILw6Ledspfw+RBiGhXygpwosToQxdri
	 QnaVg5MEXLPImJOkK44JmIo3qseDf+5Y98Xvill4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.14 091/197] iio: chemical: sps30: use aligned_s64 for timestamp
Date: Mon, 12 May 2025 19:39:01 +0200
Message-ID: <20250512172048.090489540@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit bb49d940344bcb8e2b19e69d7ac86f567887ea9a upstream.

Follow the pattern of other drivers and use aligned_s64 for the
timestamp. This will ensure that the timestamp is correctly aligned on
all architectures.

Fixes: a5bf6fdd19c3 ("iio:chemical:sps30: Fix timestamp alignment")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250417-iio-more-timestamp-alignment-v1-5-eafac1e22318@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/sps30.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/sps30.c
+++ b/drivers/iio/chemical/sps30.c
@@ -108,7 +108,7 @@ static irqreturn_t sps30_trigger_handler
 	int ret;
 	struct {
 		s32 data[4]; /* PM1, PM2P5, PM4, PM10 */
-		s64 ts;
+		aligned_s64 ts;
 	} scan;
 
 	mutex_lock(&state->lock);


