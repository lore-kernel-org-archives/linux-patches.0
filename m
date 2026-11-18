Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058315;
	b=Xhhk0qGodzUy697v+65npP1LWzN1yArFQcgpTzmWGMKEiYoQVlHRjbOuLn1B3KgwQTxW
	 Jwgt8exdBqbMlgO2OCxRrlDGVDYv17lMDn/iu6yI5+VMFzefD5Ir1qwMXGRi9vXK9hzMX
	 SmetkHLzYzqx2ALBCtdbMrSPJc7k5Yod1N26847OJTDphGe8uDuHiAWCfjbRhHmWSGg2v
	 sm3uYuKdkmNBGhykwcld7SmmqctNHLqGZAFiKlL+4tO5A4IBIRZ9bk4dG1t4dZInNjkN9
	 sTPdZZXdBZOkmdajp29i/u5162Uba/4TftZYGHrNI7Gp+9R4ZA2XITWnjpywGl5tw9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QzGzBzETJV2srv/9JeiUlle32UO6MxFP+YyR2jz6qYQ=;
	b=ZcYzpW6Rj2ik5Evkj69s69Aa26mZE9l+EN72MKwQcuRRewiqaMxmicJMjYGGKocnZGNB
	 F+mlaVytfU/mreaksQzwi2icfzby07ivipgQKBUxyEDv2+y/HGdrBPGTeygXoXQCvPiFy
	 tEAvJJ7ZTOgNA2IzNBo+vfEjfDvU4Y6sW4BTjtjsocGpzrZMQCxoYNOeYIfnwW2T7pHCE
	 SFANjbUU2aJhG/NEpKd37wnoKt5VNGOKaEhK/8d/EhtySlxcF4LAWV9gkdm1cWkp6/yLB
	 5dPToRZ6JdZnmZlQEsAidOdSKhL6/cTLxuQrYoEG9ixWaxmtDXAEIoLGfu+u0DdZnHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+tLGeew;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F6F606A325;
	Thu, 19 Nov 2026 03:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+tLGeew
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C671F000C4;
	Thu, 19 Nov 2026 03:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058315;
	bh=QzGzBzETJV2srv/9JeiUlle32UO6MxFP+YyR2jz6qYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+tLGeewwcDvnenXUDR3kZjQ/dbndDlcD/ziXUqgj1ilF5Wde0D2VvNwDO8K8Y7Rs
	 W73CPz9e/EjFN7sxxaDLNwt/Pz0+l3fVc0VgWKne/9Qg+KVyrCviEzQxyoTbvja1xq
	 lLclW113QKwqqSUfvPjlUVKY6f7d8fIoL8/tIZVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0400/1848] ASoC: arizona-jack: Fix runtime PM imbalance in arizona_start_hpdet_acc_id()
Date: Wed, 18 Nov 2026 15:40:38 +0100
Message-ID: <20261118145930.589849499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e04dcb895b4622d67164e218a1179785e2c75999 ]

In arizona_start_hpdet_acc_id(), pm_runtime_get_sync() is called to keep
the device powered during headphone detection. If setting the HPDET mode
or starting the measurement fails and the function jumps to err,
pm_runtime_put_autosuspend() was not called while info->hpdet_active was
set to false, resulting in a runtime PM usage count leak.

Add pm_runtime_put_autosuspend() in the err error path to keep runtime PM
balanced.

Fixes: 9dd5e53d9d2f ("extcon: arizona: Retry HPDET identification for high impedance")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260916072900.1971595-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-arizona.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 76aacbac5869d..5fb9943bdd563 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -785,6 +785,7 @@ static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info)
 	if (ret != 0)
 		dev_err(arizona->dev, "Failed to report headphone: %d\n", ret);
 
+	pm_runtime_put_autosuspend(arizona->dev);
 	info->hpdet_active = false;
 }
 
-- 
2.53.0



