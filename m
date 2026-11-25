Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623205;
	b=b8skccd55PEp1yTxrWvClLeP5nWjckfV7iGMR4fTPr58Ff6DWirE+id0938PNAdmss4T
	 sUiJP+VrnOso8fCHYFUBUocrLxPo0gLtpSI8Z9bxm2AVIEmoDUKzVO6OueSG8AaB4fdL5
	 BMTz0u6pdn78AC2V/GBSAJcswMfCPqJYZTOlVNxcoOqPTvA3ki0tMr0YCSLxbMGVPVmFy
	 +an2Wa0c6CSpLDaWx+ho5Lui0smFYL+oVM/yp89Fixo4ppEvrNIjs8Zy2+5uHvspXriux
	 S5nPJ7rxkeuWQ+nzFhjLWxpPpd3veDbnXB6aCuVfFD3ULXfSUEwF0gs5SDQcN3FICRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zLhB4A0fXfLVsnEPdd2kLxPMTO8beScl9MRVfWBSAd8=;
	b=xa/WrCH6mgnVIFf5d3VDkTlM6FD3bPWCul4FdNYfpgMZXeOn55MHZhWVILP0VEfCBQx2
	 KrQyIKg1gT4IHZcTwHetl2n+ZgOWawVQ61k3jK4NiJT26+ldLc3wYjlB9xpxK85DVAD6q
	 98a/tZ4zPp1hWCrfTpAMN0m1AGoaZbHoq1tpouvXlTIIQ/v2dXWYkdcqzv+3q0S4zPqKy
	 XDv/LzRimhFi/gAinVY0Y4StonZX35gqPqfgLzZG6+8ZW6nIOWjSoAuMUm36RQd9uVe6z
	 8/IKOaCBvD2HGfeon/0ADt7wQLmQ8+TTjqUNTp59i0JSefqvRsQfQWL7l/k16WtCUcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="km0K/MC5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D87606A321;
	Wed, 25 Nov 2026 16:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=km0K/MC5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECDC1F000CF;
	Wed, 25 Nov 2026 16:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623205;
	bh=zLhB4A0fXfLVsnEPdd2kLxPMTO8beScl9MRVfWBSAd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=km0K/MC55y4iyK8G6p11dqVqryRX0m0CxxUqKte7m5UmxTC0MXxhVzE0NUYUNM4YB
	 1pXHtNORf79hjbQA7mp8vBa5fiTPkwpIL44825rIpshgPvZ4bdYU+ACIsASQnIEuy6
	 NlvFpKevpZ5qEfPVo22679p2+Wq2okBqScb3M/7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Aleksandrov <lightofmysoul@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 782/990] hwmon: (max31760) Leave standby mode at probe
Date: Wed, 25 Nov 2026 15:35:49 +0100
Message-ID: <20261125143840.365513872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Aleksandrov <lightofmysoul@gmail.com>

commit 95bddc5252a4c0a2ed9d62e7e53a3461265d9603 upstream.

The driver never clears the standby bit (CR2_STBY) during probe.
While max31760_resume() clears this bit on resume, probe only
configured CR2_ALERTS.

If the chip was left in standby (for example, by boot firmware or a
previously running OS before a warm reboot), it remains in standby:
temperature sensing, fan speed counting, and PWM output are halted.
This occurs on the Samsung Galaxy XR, where the bootloader places the
chip in standby during boot.

Clear CR2_STBY alongside setting CR2_ALERTS in probe.

Fixes: 38b04ad02d0d ("drivers: hwmon: Add max31760 fan speed controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Link: https://patch.msgid.link/20261108-max31760-fixes-v1-2-a61450463059@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/max31760.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/max31760.c
+++ b/drivers/hwmon/max31760.c
@@ -533,8 +533,9 @@ static int max31760_probe(struct i2c_cli
 
 	dev_set_drvdata(dev, state);
 
-	/* Set alert output to comparator mode */
-	ret = regmap_set_bits(state->regmap, REG_CR2, CR2_ALERTS);
+	/* Leave standby mode, set alert output to comparator mode */
+	ret = regmap_update_bits(state->regmap, REG_CR2, CR2_STBY | CR2_ALERTS,
+				 CR2_ALERTS);
 	if (ret)
 		return dev_err_probe(dev, ret, "cannot write register\n");
 


