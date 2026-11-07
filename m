Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062033;
	b=3TruY8l0SCak2g75cJrFJv1U5Q5OeaTn7AHa4wa7yLTsgLYjFlF37yhOySmeuE/oIdHl
	 dSKhQavO2iIemnZB6Is9fswmMp7aPG0Qg8GGFVYyJBCCYgPq17u+OtPs32+Y5eG4kzpqu
	 jpDidVtft9N71ZQVMdQgdJyAUKgxp+dfvyrYI2SdxNhk/ofGewPGQZD0GtVgAzVNyF1OK
	 EuSe9st0Uls9zbgZGnatNWG6/WJwUrCPQPibHZrUmB+IVA1OYtCtPYtz9H2J+z5u+3+1U
	 3Vbck0cpbJnhj982GIUCaasxtHn0o8RXplZBbYEF+PJijQhwY15QymgdKWfPjwDFh2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o5GF3R8w6a98ukAmgPk6zt2zHZmkYwC9nu3d/VmpaNg=;
	b=nr4bZMgOyScQcxooiJkYVW1ZAiTXRX0EZrihHpE+MN/Am1hm8+77qeRpM/QcEIl88SlE
	 upblqAJUfvSAJpKKnh/soVMMeMSurd93FUJG4CZgM/3rgUdfaK90wAs+8GxIFGItWOZvt
	 mA4MPPBpfKUWT5UJn/xVawVemmKEIpYCJKAVR8TH3RJAshC0bdwxi0k5N7LaFvqf+jmKP
	 +o2OVIgEZMluT5uwkCCykdi9yKXl9RsetBOTygqNs8iSTdDXw6xoxr/3iho2O3kvy5Ukz
	 GhKWO9TfsuRg10FsFVP40w+C5qQb0ZKAR256n+1JiV7LZSNADlorUtSD6CT/CEQBs0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHgvTyIg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37FA606A332;
	Sat,  7 Nov 2026 14:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHgvTyIg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7301F0089F;
	Sat,  7 Nov 2026 14:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062032;
	bh=o5GF3R8w6a98ukAmgPk6zt2zHZmkYwC9nu3d/VmpaNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHgvTyIgNoEEMwlC3kyjJX1dACZCho3gXp6OuAEnSaoPf+OKyP0DAXhF/ugeoaRPc
	 TtisAnTdh1vgUkt0Oc1zx6YOqHznPhnPHHYhAzymNx+nsb0Izt2Hs4TEY+bL0Gf+YW
	 Tu5/ubb0NBO7d0z2VV+Ntzw5YKGjS6DPUjPls49o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1017/1536] media: ir_toy: Validate the maximum tx carrier
Date: Sat,  7 Nov 2026 08:50:33 -0500
Message-ID: <20261107135026.242009784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 27303392aa87b61692faadec8b00e0ca66bf98dd ]

Reject any carrier the hardware cannot generate. This also fixes
a divide by zero if a carrier of U32_MAX/16 is set.

Fixes: 8bff1386d62d ("media: ir_toy: allow tx carrier to be set")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir_toy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index e79de56997a42..ba6c042127078 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -373,7 +373,7 @@ static int irtoy_tx_carrier(struct rc_dev *rc, uint32_t carrier)
 	u8 buf[3];
 	int err;
 
-	if (carrier < 11800)
+	if (carrier < 11800 || carrier > 3000000)
 		return -EINVAL;
 
 	buf[0] = 0x06;
-- 
2.53.0



