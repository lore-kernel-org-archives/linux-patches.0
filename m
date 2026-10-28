Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212948;
	b=x8Ndiy6V2+5UiU/EQUdckuJT80yMO/Hv+2ce8PE0SH0hmaaNU6wgwRzBTtTAnDWLBV0D
	 zPQaGkps5D0F7/PqITGcW5KXIpMbw60pTu3O+5PxscExJzq6GSX+sGPd4RvbWJfsIDp9w
	 7guSdcAUUgAX2cq1gamQoPq6qenR9Egf41D/d2P3Vh4oKB/dEmlC+V0sNUT70G14/C9KZ
	 0sUPgWShixiL2ZN2KRyaiU+rAl/d9GevikVybCxZ37OFE39HgKAh6Qor3rbApppwmbDUq
	 Cj8dL8Vjxvp9Sipg4qtoM2rQ5kYFBGscTk/kCDxo8WDeLAsrWjvTqrMqqRF05oO8ZfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2m8ZMsAve8s8DlZ6jiEwTBm/Cp2RobmOBU2B9k7etfY=;
	b=2eUkdLhWdTTw2lCfhdCeiD7kVbBItkW+8ilG9og45Nd0ZD8udy6IiGgaZTosy+dkoqjP
	 cxA3a3ySXVT9pnLdcXrOIaTZVxFASgmmIrCvpJYONdXtIiWyeWWNd5Wx3Q2C17WD1ZCkr
	 jvNLSXGIa545Tm7bHSgi/U53CmQDhRXPlrQpfvvklgeAS3RSiOaBxxA6q5VPiCjzauv8B
	 RWhm9nf7uhuViqr1Xf7P82FZdHWLS6oH+tXlBbnoTga3md+ugyqEDfqTGUSwSuHk9bol6
	 kpDUgCTbrRYpSAwlMoRCkDP2qCnhcLkFf2/VMnXKUtzeYlcKigoBN7T88yTv4DL3Pjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stKOS54Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02EA606A31A;
	Wed, 28 Oct 2026 18:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stKOS54Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3301F01825;
	Wed, 28 Oct 2026 18:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212947;
	bh=2m8ZMsAve8s8DlZ6jiEwTBm/Cp2RobmOBU2B9k7etfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stKOS54QRBlT7rJdeOPho7VaKh1UoxIjjInyOf453mGsYvfzIB7+EH1FjP16os8Yz
	 ZuiwvJZQhDQLGCHKrOLDwmUtdZ1O1K60gtVBVPEZ2GlEqGaMeolo3DoSKwgZoF0cxD
	 V5H6f0dH15y+1n+Pq6SE6g1hbTFHRPzQVcLTXW8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0332/1887] iio: accel: kxcjk-1013: reject duplicate event disable
Date: Wed, 28 Oct 2026 17:40:28 +0100
Message-ID: <20261028170506.784940971@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit dd30c10ff60d2b30386c23bb7c61cc97f2385c97 upstream.

The IIO core does not filter duplicate writes to the event enable
attribute. kxcjk1013_write_event_config() already ignores repeated
enable requests, but a repeated disable request still calls
kxcjk1013_set_power_state(data, false), dropping a runtime PM reference
that was not acquired for this request. This can underflow the runtime
PM usage count and trigger a "Runtime PM usage count underflow" warning.

Return early when the requested state already matches ev_enable_state.

Fixes: b4b491c0832e ("iio: accel: kxcjk-1013: Support thresholds")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kxcjk-1013.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1051,7 +1051,7 @@ static int kxcjk1013_write_event_config(
 	struct kxcjk1013_data *data = iio_priv(indio_dev);
 	int ret;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->mutex);


