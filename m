Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212971;
	b=rHpGnkMdK0eC0xZN0Ckv7mw6WP4yaUU30eAbUK2US26w7MFSthxBI0kMVx5B9XBcMFoR
	 Hb/Bb3K27paVWrp8NiXRyb3/rASmWC2zS5uKC6sGwBi/WwWdccuQH3CPC2jO+2u+U/6Rm
	 C1koALTLceMohsqoP/zoP7yV9WWMAwfTNb0cABHErNr+5iuOkDUMntpsqeG45lLM4omgZ
	 Oc0/ARLcjSwWRNUX+tsSya5He+DmJ5nIpELdMFrd0KpR522zuSnu2Ds+SoSQl+lrwsbIH
	 3CNYMUaePFVFfm8WfAgLtCkKD2Rd7/MPw9zml/QKHdRyjR4PUEVNdunnCzhonLymkqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LTVq1g+1JkmgYbFGG7DGf1X94nnqP3QFhH4yDLdCg/M=;
	b=dcyU2ND/earYB76S6dfN0AiAsEM+ZZuNLxGrteickh7DAXfc5vRZpQEi43nlAzIltkAN
	 lHTJnVSmfo9LQO55KNFi0EkRp4k66DtFwJyc3kyagSoapFR35eDJ3Qa0NxfHdSmolN+hG
	 OKtj0MqxvvQE5QDp5z+HIG0HT0TP5yF0o/CvVKiIQ3pdXRqFntlEuzP/YdB82sPD4BSlP
	 +0bLzi6e0wB5WVnlKW7nGq8VWmybIsT3u/lY0Eq4jY1fvRVOy1SR7/NyV3pu9mN9sR9u9
	 mLBXb9k70jcKzEg6qUVJlwfF2b0Vfl2//tzox3USbWHQMK4ARmeqgOlKzw93RAit33A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MDUVIm99;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B087E606A31D;
	Wed, 28 Oct 2026 18:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MDUVIm99
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9E21F01825;
	Wed, 28 Oct 2026 18:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212970;
	bh=LTVq1g+1JkmgYbFGG7DGf1X94nnqP3QFhH4yDLdCg/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDUVIm99KYD0rf1k4OvngmdUriGvk9ArYlgMCYe8N+OkW9/3bGdI2CrMGXwKqCi1m
	 wkTJ3gwf1JHbkiSFSIO3oPmKGamUoPPss81sMGQ/ndU3G1OK3F3BVYdR4vp72nkij9
	 J53KlbyJd0AqjlWriDTtfa9vV0sHtMn7gIUrdES0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0339/1887] iio: gyro: adis16136: fix unprotected debugfs reads
Date: Wed, 28 Oct 2026 17:40:35 +0100
Message-ID: <20261028170506.941599335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arkamondalofficial@gmail.com>

commit 2b498df75d6c29aa3e760127ae0f0003df598b53 upstream.

The serial_number file operations are open coded and never call
debugfs_file_get(), which debugfs_create_file_unsafe() requires.
debugfs_remove_recursive() therefore does not wait for a read in
progress, and unbind frees the iio_dev underneath it.

Use debugfs_create_file() instead.

Fixes: 9aaea09b4cbd ("gyro:adis16136: fix debugfs_simple_attr.cocci warnings")
Signed-off-by: Arka Mondal <arkamondalofficial@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/adis16136.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/gyro/adis16136.c
+++ b/drivers/iio/gyro/adis16136.c
@@ -145,7 +145,7 @@ static int adis16136_debugfs_init(struct
 	struct adis16136 *adis16136 = iio_priv(indio_dev);
 	struct dentry *d = iio_get_debugfs_dentry(indio_dev);
 
-	debugfs_create_file_unsafe("serial_number", 0400,
+	debugfs_create_file("serial_number", 0400,
 		d, adis16136, &adis16136_serial_fops);
 	debugfs_create_file_unsafe("product_id", 0400,
 		d, adis16136, &adis16136_product_id_fops);


