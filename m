Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208767;
	b=DBZp88MZ5rwvbsVwFVpWw8lpAcritgh/szEcR6NCjHwgHnWZzddqUKu60H+Zngl6j83O
	 Or0Q3bE2kRVus1l2W5izjutgRKGFR3WQadenhG/U3xo4it76imzBbyPQhRXyuhLKCwz+e
	 xtxn+JfN0xDf1GqGEY0D82W0L6GlfqyuOrfyoMWKDg+hJOrFIKlisr0ze0WobdaDkDY5O
	 5DUw4Ia+fD4NSR7rHeO1aUGGFrf37x//uLqjzCVIerddVwFfHap4OyFEP9GbPlckK+GoU
	 YbagIQ6nGC+2Mtnu0KBLmvXpuLx6bv/LGsNy3OT4Asudx9wAwHzLa0caJeUm/cBO1aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQh0TOdUqVaq7b/VCrmDF0raGTM8r/mbTi4483hgZTk=;
	b=pr3CY27JkX/MBdQLcO/nde6puNCDYXN3BCGOqflKF5+uKWsE1BBhcBmNV9OaTTIdiVn8
	 kQNQqRPC/v1RaUp2fO9/cW/6g5m7yeNMxIEm184SXdgeegf000sfxNuaQ5s2NKdG8bE+4
	 LhckQl3fGHCrdaYIBBfSgCp0/emAIuVjNqSqVfWKkGMLXlGdc0jUrVrEOL6UZE8lcR57V
	 OJ9JRnxF9/XXheHYT14u+CJwhOtsgAqveFAkgMcFhiMLg6J6amiARrSoKPJqRJjqfbZCA
	 RL3C4CcGLiGf9p1XF7RgyxDwF15lwH0X6C4qRn2oquR1OnTabBj+mmySqDXf7sj+jbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S7euSpaM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E98606A31E;
	Wed, 28 Oct 2026 17:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S7euSpaM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B504C1F01825;
	Wed, 28 Oct 2026 17:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208767;
	bh=bQh0TOdUqVaq7b/VCrmDF0raGTM8r/mbTi4483hgZTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S7euSpaMo31m7s7U8a9Sg2q/fw4vcBwCQlmDW4uV+v/XYF/Nh3c3k/OfRmGAu+i6G
	 akKLPqMD2mcenki3SmhxMYUN1fCOQqPAM0bVFsHAfM5XI891pdmslZO83V545N9JBb
	 57O2wAGmza0+NB6tPW1lxOF3H0MwtRPo8WLcvxPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 233/516] iio: accel: kxcjk-1013: reject duplicate event disable
Date: Wed, 28 Oct 2026 17:56:25 +0100
Message-ID: <20261028170009.024351402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -934,7 +934,7 @@ static int kxcjk1013_write_event_config(
 	struct kxcjk1013_data *data = iio_priv(indio_dev);
 	int ret;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->mutex);


