Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585533;
	b=ZZTVbkKPW9IesQqX1+rEaSjMmYeHTHpjnvwlCsj/c4AUyD+s1QibabEsCh39s6GThXwV
	 CDTYawpqm+/haud/t8bi5VkPw/eNYnNOEYDSLNUqUyrtc+psj1s9k4LMgy16rQByLkXWL
	 KN6aUEx32hzhCLV/EX6rc7NqHwYsC9X8ow6BdnJwjNswB5tZAYOdZIoBo3yMRbxY3Hj/O
	 cdtNPqPKOeJxrko26aEhITK0g8pPS8o0WmBObTwVQyfxTighkjZ3q+oaC819Fq+mTsIhJ
	 1VGwGaI5dr6Y629VlqCgxsz6l8JYJ7V4lSRO/IishqsLtLrqKegwZY2FlWqLEbcV2IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9P7aLMHJniN6fTrVvUEiR/BWpnbbRMumoway5ZTQ61E=;
	b=0n/m2vVuupFpYLDYAq/bRdKbgLXMi4r81/Ej066lXNvrIvMmCTM3a5pir+tC/0e+cU0k
	 1+X3twrS6BNrlDHR+F5K2i77Ju5U2BWgJRPJIHusZIekHCK3eDeTbjsusCB9S0NVc6kEO
	 qO0Azsu+TLe0sCyUCr23wPYZqCL/jMgOOFd8sX5DS1dcuDHgW0P8RRgEvWuhu1Ej3Yv2f
	 ycO8yuoCYpSvlq8YS7PuSCADq8v7tGxlqisVYv2tnQgR7RBquN/ZieSt8yYBJ3d7y02Xq
	 M8djAzC60qWO5/P8bQINM/lDNixdQ1mUb4xvgi7iSUSFUTJm/SvusM6aXDU8+DTk7HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jImvu2up;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D7F606AE39;
	Fri, 13 Nov 2026 15:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jImvu2up
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A871F000C5;
	Fri, 13 Nov 2026 15:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585533;
	bh=9P7aLMHJniN6fTrVvUEiR/BWpnbbRMumoway5ZTQ61E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jImvu2upOgcfUVD0d5vqjfER7L8Bj3Lmitipf+WUAT3Yj1CgGWQ4ApxG0F1MP9zKX
	 RQp6lcCtvYAwzwqdsQ2EKLTjAstuXKFnymLE7XerXN5xURImvyqgQMc10ofAneBquq
	 AiR2iBhvNJ0clGl9MNb6VS9Mlsc4lEAbU2vNgmKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 173/507] hwmon: chipcap2: fix command error diagnostics
Date: Fri, 13 Nov 2026 10:47:57 -0500
Message-ID: <20261113153800.345560204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit d0a03e1a2d9bd53b94fe6dff7a1a8058d25be82d ]

The command response field only contains bits 1:0, while the
error flags are stored in bits 2:5. The existing diagnostic
checks test the extracted response field, so they can never report
an error flag.

Test the full status byte for the error flags, and check the
configuration-load flag instead of RAM parity for the last diagnostic.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-1-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 9bef767b589ee..8550578928523 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -167,13 +167,13 @@ static int cc2_cmd_response_diagnostic(struct device *dev, u8 status)
 	case CC2_RESPONSE_BUSY:
 		return -EBUSY;
 	case CC2_RESPONSE_NACK:
-		if (resp & CC2_ERR_CORR_EEPROM)
+		if (status & CC2_ERR_CORR_EEPROM)
 			dev_dbg(dev, "Command failed: corrected EEPROM\n");
-		if (resp & CC2_ERR_UNCORR_EEPROM)
+		if (status & CC2_ERR_UNCORR_EEPROM)
 			dev_dbg(dev, "Command failed: uncorrected EEPROM\n");
-		if (resp & CC2_ERR_RAM_PARITY)
+		if (status & CC2_ERR_RAM_PARITY)
 			dev_dbg(dev, "Command failed: RAM parity\n");
-		if (resp & CC2_ERR_RAM_PARITY)
+		if (status & CC2_ERR_CONFIG_LOAD)
 			dev_dbg(dev, "Command failed: configuration error\n");
 		return -ENODATA;
 	default:
-- 
2.53.0



