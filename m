Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E3917CA12;
	Mon, 10 Mar 2025 17:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627021; cv=none; b=Lwqng6Mz4OB/8MHC0kQi6z5w7WwteT1NbNrr5db2ix7zDJ15qyBZ+prXdfrjpiXVIxxD235/QH61x/Y7KY4qyIJUuMNE81uT2nBZ0RQvb88lfytiT7M2PcSD3Tjw3f9323f0vt2c7BTiBJoXutF29zU2j0efMCdeYEWQ1Z1V1PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627021; c=relaxed/simple;
	bh=QshtwsELMhizDpbE72k0/82ViF3W0zon5X6sCHtbN4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WMBX4ty/R/0K7l68S8wAo1VBAhRDyykaISFHf3XxLISBbE6rFov0tlNU9B/BIHMHEG/aYP8G1FpBzqPJtbuNa2Q5YdDorKcsVngyrGN2CIf5f36kUZAmSfOsQgZ4VtDy/5zBqjky8pELBHVqN3LwiNwLmojn0xZGmHW1G2z55Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMHRdDM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMHRdDM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E752C4CEE5;
	Mon, 10 Mar 2025 17:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627020;
	bh=QshtwsELMhizDpbE72k0/82ViF3W0zon5X6sCHtbN4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMHRdDM/d1hglO8cdBGQb5bjOe5F+UpxxFHkEf+1jO6mY0l4Pd1+uS4g1oWEHycvI
	 1dgV9rGGEeKnvzP9tfMaMTBFd46vvaYTNh6zeXZUZCpH1yyTqjQo8W7Qx3syXKsuNb
	 IcE7HckMIVXcS4MxZL17LlJ0dPKIbjL1trRZ/weM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	subhajit.ghosh@tweaklogic.com,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.13 193/207] iio: light: apds9306: fix max_scale_nano values
Date: Mon, 10 Mar 2025 18:06:26 +0100
Message-ID: <20250310170455.453844799@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


