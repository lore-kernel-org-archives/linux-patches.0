Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE6A81E;
	Mon, 10 Mar 2025 17:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627838; cv=none; b=B/mivt2GPZTUsnw01hpu0fDy/ar2Wlt3I4VeF7baosRKeV46mYAPAoLgbbN4DRnvqXeIi7V4LF50f1iJI4gGPm143kjJ43RdnKq3+uRocuSgQOyQtuW6PCs2ZUxAawoAhT9mwatfq1Src40B38qTuSEdjFppY/An89x3FyENq1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627838; c=relaxed/simple;
	bh=/1CPqAySQfFTlh9pu9FBEwJKjwF4PXfnmp1TPrjUh0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pJ2S8E7NppCVkqsXZOur0PHBV/B93/CYYbn5xaXIgC4QJMi+luiQoL5PFtGxRupH6G+8JNWRnccvZGtk6cfRKY7OUyNZsCF7QlnbqyqDZf9MM0wxAWQHUzUmvsOvyyr099fw9IB+OJHt9dNktjxOPgx/wPlbhqNctutPtn6hcV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+681yAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+681yAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF2EC4CEE5;
	Mon, 10 Mar 2025 17:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627838;
	bh=/1CPqAySQfFTlh9pu9FBEwJKjwF4PXfnmp1TPrjUh0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+681yAzuEGJ6yFUwz07gEetApO8RzGQRe75oGc+vGGBxR9XzeEHBc6zO0A8HmgL+
	 zSYkeqynjVqefIkGp5Z6mmgfyyljnLpzO5np3xq3et7xZynvk1ltYc7cRGFIpTEt7+
	 QGApeeGVec19g9a+s/KqDyot6xv6nbwNxuWDiAOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	subhajit.ghosh@tweaklogic.com,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 250/269] iio: light: apds9306: fix max_scale_nano values
Date: Mon, 10 Mar 2025 18:06:43 +0100
Message-ID: <20250310170507.761284572@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit a96d3e2beca0e51c8444d0a3b6b3ec484c4c5a8f upstream.

The two provided max_scale_nano values must be multiplied by 100 and 10
respectively to achieve nano units. According to the comments:

Max scale for apds0306 is 16.326432 → the fractional part is 0.326432,
which is 326432000 in NANO. The current value is 3264320.

Max scale for apds0306-065 is 14.09721 → the fractional part is 0.09712,
which is 97120000 in NANO. The current value is 9712000.

Update max_scale_nano initialization to use the right NANO fractional
parts.

Cc: stable@vger.kernel.org
Fixes: 620d1e6c7a3f ("iio: light: Add support for APDS9306 Light Sensor")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Tested-by: subhajit.ghosh@tweaklogic.com
Link: https://patch.msgid.link/20250112-apds9306_nano_vals-v1-1-82fb145d0b16@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/apds9306.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/apds9306.c
+++ b/drivers/iio/light/apds9306.c
@@ -108,11 +108,11 @@ static const struct part_id_gts_multipli
 	{
 		.part_id = 0xB1,
 		.max_scale_int = 16,
-		.max_scale_nano = 3264320,
+		.max_scale_nano = 326432000,
 	}, {
 		.part_id = 0xB3,
 		.max_scale_int = 14,
-		.max_scale_nano = 9712000,
+		.max_scale_nano = 97120000,
 	},
 };
 


