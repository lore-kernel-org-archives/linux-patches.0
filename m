Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063803;
	b=irG7HulRr664ZelMKzgiNwyFHCfvnFxOJ6wKOyTdeH3aRJh2Enk0SRJz+a8GKDGCakAs
	 JL7QL2g45MReEtTJ6kjzPEHCS/dOMrgmPDO8ViERMomTUeLEsmxB/GXusJDCZy2spPVvx
	 BE3uEyOZ4fT42e/CpuDAoUPgSY5XHqMOeIelYPXzAr88w27p2+a3Yp+C67K362LPoq1Uy
	 NB4tBfSAG3YriYcyZniq8eYsTgWb6rB4pwYYJTm+OUt8k9eG4BF1n4aFtl1gAtcEUsa66
	 AT6adYUHdN56RksfbQQGVJwHnd+Q38lw5J6+4W5SKYjs/U7cToe+gEkkl2TEERJJ4Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x1YrFLPSlh9mUsz/gmgXv0zmqBlMCkwnqM6KeoVfLqY=;
	b=dXgAYsc2USL2z7/NC6WTBYjUehUO1jKgD3pR5MGV80jhFRXjF26Y4fym6yir+7jmujt8
	 gL/Q6TKg0rsiR5wJDlCF/ANZy/9Se43rAjSSZTvvCEUubE3YQW5X2XLVhop+oEqdHl/uO
	 oZs+d8tt5JVwIeDHpavNjff0QXIqiWN1ylJ2+aPnNa1Kn5mg+4mEhGi57w0/rTvIz7XGI
	 wBZtnK0PTQ0+Bnjezn3P0seH4jEhG+JHA57Yr567BdN/iFl0EhnkvhoBscYqc9/8JhRDN
	 LOJ5eNJLp2l8UxI4vsqM/jUKHBu31Y+51Bpe0y/9l1YkRwlWPOrs2ZrdltPYYolzbIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SyzvnvoB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE14606D82B;
	Sat,  7 Nov 2026 15:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SyzvnvoB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF25B1F0089F;
	Sat,  7 Nov 2026 15:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063803;
	bh=x1YrFLPSlh9mUsz/gmgXv0zmqBlMCkwnqM6KeoVfLqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SyzvnvoBk6frthrOI27nBiysqXJqP+CmXawrM1Fmyr3GTH/3mxaltc9JtJNgllGFM
	 IEjfakVeEI0IKCTLS7466D8x7P4JVLKVaW7PP228SrasrseV+TkkNRjzMOJsM8UogP
	 wmfUlfZgCLc4jLwCY8+45XJnBExjMF4WNkxel1hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0023/1257] iio: light: ltr501: Power down chip if request irq fails
Date: Sat,  7 Nov 2026 08:38:39 -0500
Message-ID: <20261107134940.051536306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 8a9bcd587d7d768e6c8e9fff88bb89645e412731 ]

In case devm_request_threaded_irq() failed, we were leaving the chip
powered instead of powering it down again. Power down the chip switching
ALS and PS modes to standby.

Fixes: 7ac702b3144b ("iio: ltr501: Add interrupt support")
Cc: stable@vger.kernel.org
Acked-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/ltr501.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index fa0d16890c8bf..b36bd10a02624 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1538,7 +1538,7 @@ static int ltr501_probe(struct i2c_client *client)
 						"ltr501_thresh_event",
 						indio_dev);
 		if (ret)
-			return ret;
+			goto powerdown_on_error;
 	} else {
 		indio_dev->info = data->chip_info->info_no_irq;
 	}
-- 
2.53.0



