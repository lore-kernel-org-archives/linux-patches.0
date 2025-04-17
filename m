Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408471CAA7D;
	Thu, 17 Apr 2025 18:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913175; cv=none; b=E6MYb6ZCbO300CgKal+NH53p9bmYwyLgkcwsKTmzz9vQZLcMoXZMsOSaqFbUXPYI6G/cZlSfNPEW8fm6hojn1AZ1BXbWkOULL6XD+23y7yCJv9CODYqf4XRYu7iNxeWTjGOkcl6zHKvSWqdN4V40U1MhepDT1sYvcBSciKns8ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913175; c=relaxed/simple;
	bh=sBNRPGcjLmrl7As3ynyaC5yMlVlzM7DaKE9UIo/kwI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWYhiDC2AKP8Je2q2wkprvTGislKzfPhsScCVbqI3ac46CdrNvlJLCZ7mCl6v8aEPVNKGZ5AVPjy46jb/7cfv2618zW1x3o4RBo0oygexfGTKBM5+CHpIPOqcAyt5i1V3V0vZqfofjlTtzjnK7YcVmB7AESkvZP6WUN5lKbVZyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3HuCemi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3HuCemi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D31C4CEE4;
	Thu, 17 Apr 2025 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913175;
	bh=sBNRPGcjLmrl7As3ynyaC5yMlVlzM7DaKE9UIo/kwI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3HuCemiusI5Hl+cOj+mtPobjZOx/IlZ4xXAAHzOwyU6iK+ol+KLjd+K34yARYXqe
	 352jxKUIZv3okvbu2vtRo4u1X758moLYG3HO62J+nXyNxzFq+66a6ADcTJfCnH+4IP
	 TDc9pAc41gwFbN3RA35L8+UdWN2M0t1I2b+AUezk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 251/449] Revert "media: imx214: Fix the error handling in imx214_probe()"
Date: Thu, 17 Apr 2025 19:48:59 +0200
Message-ID: <20250417175128.098169070@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit abd88757252c2a2cea7909f3922de1f0e9e04002 upstream.

This reverts commit 9bc92332cc3f06fda3c6e2423995ca2da0a7ec9a.

Revert this "fix" as it's not really helpful but makes backporting a
proper fix harder.

Fixes: 9bc92332cc3f ("media: imx214: Fix the error handling in imx214_probe()")
Cc: stable@vger.kernel.org # for >= v6.12
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx214.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/i2c/imx214.c
+++ b/drivers/media/i2c/imx214.c
@@ -1114,7 +1114,6 @@ free_ctrl:
 	v4l2_ctrl_handler_free(&imx214->ctrls);
 error_power_off:
 	pm_runtime_disable(imx214->dev);
-	regulator_bulk_disable(IMX214_NUM_SUPPLIES, imx214->supplies);
 
 	return ret;
 }


