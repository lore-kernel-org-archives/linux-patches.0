Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620375;
	b=AWMqN3+abH1/NFyyZTwbm8rAWb9A0hN9sxOD2RuoE5CxQCVpub1/Wf0a568dCoDni+QC
	 RykFZHPUZjcTTVXdi57vKGpGm1uaHK9ot6sB9QIHG9QvT3MY4idrJ5ojqBffoCtKAgJeH
	 CT76TjlyL3hRWsdPHW2hAPC3e51eZ/fZhMYnVoSW8Nb6LVh7RoJ1IU7roCNK60Exdr1Ht
	 BTu3RxxGDWpxqZAHyd+/vTO/RSGerMVSAgJ9bN0e2KLoVtIC5nQ+jeg9Jio9oLBHsOoyr
	 f0reh9CfgUrjcLxWYNXu7VpqmcMRTWSCjVZOjq9Ag69MuvBjedQGhdcIkwhUbW7MuVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=auXnsghxMLDSFTGwaPye4T8FMw5eDKMjFt+ME+tSgqc=;
	b=QFwoUca2ostXXzhXKwURyZpCFr0zJ18cgYBl/0vPhQFO+Xq3OMVKLpiNpjZPNt1HGOKo
	 G7QSIhAIsZfbk6i3OnSLzxADdRXExMcrq2F3N+I+21Bysst8U0EILkt7+wmd+xcoyMvW7
	 B7XaiHDVidQKa8AbXzTaPMbNjBoSboMRb7LezbU0omPEtXlmcH6gUE5XDBOrNoLpJ7l7e
	 b5Mi7WBzVmoEmXlHW6e328hUnWtVPsCu8MhlDPxDN7euxd2ylwC1R/FubVc5MxVgnx0s8
	 sUzOdsKyyCIRmdvGD8Az8Q9FgwUxStAiAVyLdjRpGBxB3DHrCsSmrJkvWv7iRBiVPrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bJxCMNTh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E186606A31E;
	Wed, 25 Nov 2026 15:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bJxCMNTh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7EE1F000C6;
	Wed, 25 Nov 2026 15:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620375;
	bh=auXnsghxMLDSFTGwaPye4T8FMw5eDKMjFt+ME+tSgqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJxCMNThGMTWfms+rMPlT8Vnq1y3RhEbi+klt8BESZWM5V+ra1mdUWKRI7DPayoRx
	 YfbfwY5v9mOeq+RxLhQ95tSUS0qzSFGQ2tkye2QxEahbVojNIiY9MotKEmgIa3VqoF
	 PFqvJSCP7yWgmoznzEGrFflEmPpYQExTC5q8uNHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0897/1005] iio: sx9310: use the data of the I2C table
Date: Wed, 25 Nov 2026 15:37:15 +0100
Message-ID: <20261125143842.708388585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit f3fc8718af9189aad13a2ad7f5b256475bb14b21 upstream.

sx9310_check_whoami() takes the chip information from
device_get_match_data(), which only looks at the OF and ACPI tables, and
dereferences it. For a client which was bound through the i2c_device_id
table, for instance one created with

  echo sx9310 0x28 > /sys/bus/i2c/devices/i2c-1/new_device

it returns NULL, and the kernel oopses as soon as something at that address
answers the read of the WHOAMI register.

The I2C table has the same pointers. Use i2c_get_match_data(), which falls
back to it.

Fixes: 21fd3b1373f6 ("iio: proximity: sx9310: Convert enum->pointer for match data table")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/sx9310.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/proximity/sx9310.c
+++ b/drivers/iio/proximity/sx9310.c
@@ -891,7 +891,7 @@ static int sx9310_check_whoami(struct de
 	if (ret)
 		return ret;
 
-	ddata = device_get_match_data(dev);
+	ddata = i2c_get_match_data(data->client);
 	if (ddata->whoami != whoami)
 		return -ENODEV;
 


