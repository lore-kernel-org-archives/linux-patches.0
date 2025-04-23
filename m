Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7914528B4EA;
	Wed, 23 Apr 2025 15:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420984; cv=none; b=ihUee4f11EJBUYeKbkByvC9ijHumQmUp+fAwuOBhZBIN8UiUaC4r4lhbT8Ed2W3uniUDhCzMRLWQU1qS1R5rXROwsx7mc7ihSWP7aqaf954xStlKTyiYktvK9VTD0ZBhTNyZtlCjqsg9w4VB0JfctWeEa2863z+er7dZSgCwO44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420984; c=relaxed/simple;
	bh=uVR/b5bL4duoxyRonEqBNOi8Al6v7T/xyFOIrCv2EGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIZPPONSYwJ6aDMa/ttqBTDvI7DAVPylqHAOQ4BE/UMdh2XvyjlM6gxiavDsSU/LWMhvUiwOx0KF4zArRPBwuec/HL8jBx80po3CDlC+q2flPAG3Wkmr96u2bT+YDe++HSX3BLA4car6jvwWZSF5nkLlIFkYp/E6eFdaMN/Ni1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRRCCEQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRRCCEQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F13C4CEE2;
	Wed, 23 Apr 2025 15:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420983;
	bh=uVR/b5bL4duoxyRonEqBNOi8Al6v7T/xyFOIrCv2EGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRRCCEQ2eU6cYLpkCBqUjIAL+oXiz8ygFauByZlzzYOwwgOphVTQ4ZpzE7WeUMzG/
	 IuSubfpfxdg41214IyCc8WwPfa4Je9gf9IMVjgBCnqZUQsbB03nt4entzvai7XpsHb
	 +QwEFTO8OFh6ZlklF0Tr5P+xmw9yvmYhU4T2Jpjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 098/291] media: i2c: ov7251: Introduce 1 ms delay between regulators and en GPIO
Date: Wed, 23 Apr 2025 16:41:27 +0200
Message-ID: <20250423142628.359737944@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 3d391292cdd53984ec1b9a1f6182a62a62751e03 upstream.

Lift the xshutdown (enable) GPIO 1 ms after enabling the regulators, as
required by the sensor's power-up sequence.

Fixes: d30bb512da3d ("media: Add a driver for the ov7251 camera sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov7251.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/ov7251.c
+++ b/drivers/media/i2c/ov7251.c
@@ -922,6 +922,8 @@ static int ov7251_set_power_on(struct de
 		return ret;
 	}
 
+	usleep_range(1000, 1100);
+
 	gpiod_set_value_cansleep(ov7251->enable_gpio, 1);
 
 	/* wait at least 65536 external clock cycles */


