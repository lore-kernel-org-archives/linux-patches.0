Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454E21494BB;
	Tue, 11 Mar 2025 15:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706901; cv=none; b=E6LrowuaY4PhFk4m0yBBTdoM+RioW1JNnYssnoz/YXlUbwKS41JFCyIsNbns2fXjL19aYfEgh6mBdvhBk0KfeBLovVPuM+CNA41N+1mORqP+sDc3bdgJOgyi+kzUqBJ4q3dnvfpaKJFUNrJ/k2aotAJtpamyzL1k0GQI2MQYOlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706901; c=relaxed/simple;
	bh=nYkz5d3OVoX75WchvP428m+RTwV6xUVeYVTfFE94MsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoHp9ipEJ7+scqskpmKfjkqLKK0wxt5tWHbhhv8FmGSoPbziJO82WRtuQdqg233lI0zTTUvXOCCj/PREVxWi5TIitUIMEz8385wtr5pKZZolumhizJw6p2e2vjwwl+KRxDl5/9I7A4Cez1a8lXRic5SvwMEkZK8+xENnB4pybHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Et12Al1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Et12Al1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC21C4CEE9;
	Tue, 11 Mar 2025 15:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706901;
	bh=nYkz5d3OVoX75WchvP428m+RTwV6xUVeYVTfFE94MsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Et12Al1FDI/0uxShG9w2WPeW5KLlP8aycY2oLBOAUJo++4HxCFiUPvT3t5WzoSx0d
	 DW0KY6vuTGopt3b8+Lk3+z32XIUgbioTYkW9/NUPpBebpb9JUe14C83Por8GTeFery
	 fOTvYgSfZ0MwTML3NsG+h/AAlGBlca4kxBgRwyF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Bobrowicz <sam@elite-embedded.com>,
	Michal Simek <michal.simek@amd.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 205/462] media: ov5640: fix get_light_freq on auto
Date: Tue, 11 Mar 2025 15:57:51 +0100
Message-ID: <20250311145806.452003413@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Bobrowicz <sam@elite-embedded.com>

commit 001d3753538d26ddcbef011f5643cfff58a7f672 upstream.

Light frequency was not properly returned when in auto
mode and the detected frequency was 60Hz.

Fixes: 19a81c1426c1 ("[media] add Omnivision OV5640 sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov5640.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1380,6 +1380,7 @@ static int ov5640_get_light_freq(struct
 			light_freq = 50;
 		} else {
 			/* 60Hz */
+			light_freq = 60;
 		}
 	}
 


