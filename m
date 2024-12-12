Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01D8223E62;
	Thu, 12 Dec 2024 16:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020325; cv=none; b=IA5JjwvKBhtEEUbUt2Tdxw3OgfrJ0R4er40rJAsMqjmM3HsUZ2gSscxDOK13RuYvGlaCOK76lS/KKQ8/7iKshduSY4OKnqruwleI1zUqeTBm22LetastSzYDX9PiT0JTe2gdfEguWKPg30G94m6OIRQqlwOfezI+k1uXS5TCir4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020325; c=relaxed/simple;
	bh=PccT+95dxrx/baZTIyVjdkp5gQiY13JFdI0E4QymdO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZLm/WM3CoYHDI9gsXOVPtSWEb3iGBRr59vBvxKoTRUY1fT/Q0JiH/HlpMoTonIH+LRZcT4imLHt4jJsVI6N0CIKCriPceAKhW9Hvf5MB4V2XjZCavQfkUBCkHIwEgsigszYjprqMJ6Riwy6OQJrKJxAaRhTmqUk/GRw6aME9QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkpDEfiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkpDEfiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662FAC4CECE;
	Thu, 12 Dec 2024 16:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020324;
	bh=PccT+95dxrx/baZTIyVjdkp5gQiY13JFdI0E4QymdO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkpDEfiCysVc1L8JFDotJ9lQAdBy0FNvjcdd4CBjMNMDWw+5PfoIb670mqF+GJml6
	 C8XHv/S5HnR4HAeFvS90HrnV/D4bokR5cp8oeAeiHsi1VkWFcA1RlviU7NLt/EHSmg
	 8kqNeK+pmRcsOoz5QIgokIZQYGc7Bv7KjxFVJNR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 421/772] ublk: fix error code for unsupported command
Date: Thu, 12 Dec 2024 15:56:06 +0100
Message-ID: <20241212144407.312023455@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

commit 34c1227035b3ab930a1ae6ab6f22fec1af8ab09e upstream.

ENOTSUPP is for kernel use only, and shouldn't be sent to userspace.

Fix it by replacing it with EOPNOTSUPP.

Cc: stable@vger.kernel.org
Fixes: bfbcef036396 ("ublk_drv: move ublk_get_device_from_id into ublk_ctrl_uring_cmd")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241119030646.2319030-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2055,7 +2055,7 @@ static int ublk_ctrl_uring_cmd(struct io
 		ret = ublk_ctrl_end_recovery(ub, cmd);
 		break;
 	default:
-		ret = -ENOTSUPP;
+		ret = -EOPNOTSUPP;
 		break;
 	}
 	if (ub)


