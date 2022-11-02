Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D6C7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD4DC433C1;
	Wed,  2 Nov 2022 02:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357099;
	bh=iJ8EtD98C3Ll4eZDM8JbU1z5twsSVrPWQWEskaR037w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdXN0ktfzT2Pdq5RA4DX04PQ5XFz2mdrHILdyGzlQ825DxdXHMiy8/YjEk/3ZxpL3
	 1X8/0NS2rX+WZT14/z5LL/PV5N1/G+CgjpBssgU7U5xYK4ois+6NY37mG8vauz1Rcc
	 w7JK+vukOnLbpexwoaqSAgxeByiMM/erjaQx83kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.0 112/240] media: ar0521: Fix return value check in writing initial registers
Date: Wed,  2 Nov 2022 03:31:27 +0100
Message-Id: <20221102022113.921869824@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 54bb7671ca6de58929b3994468c330bedb9a3b7e upstream.

The return value from register writes is ignored apart from the last
value. Fix this.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ar0521.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/i2c/ar0521.c
+++ b/drivers/media/i2c/ar0521.c
@@ -756,11 +756,12 @@ static int ar0521_power_on(struct device
 		gpiod_set_value(sensor->reset_gpio, 0);
 	usleep_range(4500, 5000); /* min 45000 clocks */
 
-	for (cnt = 0; cnt < ARRAY_SIZE(initial_regs); cnt++)
+	for (cnt = 0; cnt < ARRAY_SIZE(initial_regs); cnt++) {
 		ret = ar0521_write_regs(sensor, initial_regs[cnt].data,
 					initial_regs[cnt].count);
 		if (ret)
 			goto off;
+	}
 
 	ret = ar0521_write_reg(sensor, AR0521_REG_SERIAL_FORMAT,
 			       AR0521_REG_SERIAL_FORMAT_MIPI |


