Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064059;
	b=kxZNMtUcVz4wwVn+a9QMzBQafZkJqN0SqG0kXl3hl0pIIlJc9ZFIma1ZihL18/gJ8qCu
	 O3/LNv3bdZdE8i2mbXUHVaerpH49VPWEnd82EWl08ghz8Jesfl61urqMz/kzGJ8TUx8X0
	 3Rb3eBY59HW09AGVBce7ffisK/kPXupqsELSq7wRoKHOxCirGq7Cp2VkZPFLhWphfKZcg
	 vXGjE2adUY97Dd+0AAEX3jzQ8iNJH62nhCDLNGpbp7/DHCfojgh92gYOGATlT6RZyWExr
	 6V5q1VQ0DxWRpBNpXw1dFDagf/9Q/X+32zvVLXC6eySi7VGofNoEcYErwIBt3qqvlzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GtbFIhOaAEbd1Lq0O6Bwfi6/VrPaxcuwVtHyEsqofq4=;
	b=Mpn+uQSAmViE/eNFGy6/q7yuRfQMkbj+Bxtmh58yqF6txoCbTo4WOChoCp9SN6J6xmoN
	 HRCgwMIjfljvyThmHmW/G3FM1e+pB7ZPEF/s91Dv2JB6ta3zbh3aXWpc94QLPNwi2NDKr
	 w0z9Cnf33JgKG76Hz8uHBS59118wLV9BerYuwntoqwWnJQmvS3ExHIlmlwE17nm0iSkCx
	 Ze5PwOScoV0zk5UiQ923nexNwLcJHJZwiH/aYnzANV9moGuMDHMfplVCL7voAfnQPni6D
	 VgDjiP6vOlIGJMiJWjP1+dSehT9ed63r9ZtMq1HBIXFYjFimF4nARapVgz2Yk1/bkIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBbFuGz2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0823B606A9D4;
	Sat,  7 Nov 2026 15:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBbFuGz2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60C21F008A1;
	Sat,  7 Nov 2026 15:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064058;
	bh=GtbFIhOaAEbd1Lq0O6Bwfi6/VrPaxcuwVtHyEsqofq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBbFuGz2EbWuOkDjG2lshnykoUZioctekeRPZMBrrg4fu+r5e+kziKj8kjjkfkfIc
	 uLY7ZbYXIiJnjBD19wZWTBbQtmqF13FdVhHathl4hiFisFmiTWeZ3/wj5nLfKFp8RE
	 B2SF4p7L5n2qjAYmOuFriexwVz/V1UCwDVkjD6Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0229/1257] media: meson-ir-tx: Prevent divide by zero in meson_irtx_prepare_pulse()
Date: Sat,  7 Nov 2026 08:42:05 -0500
Message-ID: <20261107134945.850093949@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 05d9c515cf13056875abbf73adb4a19dd7ba32eb ]

If an excesively high carrier is set, meson_irtx_prepare_pulse() will
cause a divide by zero if tb_us is 0. Prevent such a carrier from being
set.

Fixes: 49be1c78d575 ("media: rc: introduce Meson IR TX driver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index 1ab898069e67f..a0d07da09f67a 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -219,6 +219,9 @@ static int meson_irtx_set_carrier(struct rc_dev *rc, u32 carrier)
 	if (carrier == 0)
 		return -EINVAL;
 
+	if (!DIV_ROUND_CLOSEST(USEC_PER_SEC, carrier))
+		return -EINVAL;
+
 	ir->carrier = carrier;
 	meson_irtx_set_mod(ir);
 
-- 
2.53.0



