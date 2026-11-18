Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033597;
	b=1888zzyw1/Va8kQQ5d9RabNb7eQZctK/qzM+tR/8SdVdRF3hONj0ROo42gPTZTPMk2Pt
	 v62CmtBTLBegAkZHujl5BMNNh6slqBbCLCG9Jn72n9r8Kt0Tj/ZzmxuIdmJRVoKlcsmRX
	 NlZ70Lo+sVvrj/JZJqELP8G7rzaRbDB16bDOiYjWCxNcO73+3IgdnC9cop+iqhEz+XEJd
	 gQI/gVwq0I+mI+fesGSaVhHiy8x+9WmIghWWj/xLUP0Tj6KK41zkLj14EM0YBotwh6cnQ
	 Tx0XzVFTCSLmcplIEj3S/NrIZ5t0MUOabEbTvCOONsgi4f3mi4COe5M3GN8r4uJSD0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aRwhcvf7K2Mr+Kn+9I5xdsEtJ7me2hLeXvAQTWtmnHM=;
	b=sP6ScTFYhTinzDUR7QX2CCn92TE1ahWye9byljTDTvH65rTgk6sh8C2xFiFXojSqrFha
	 qfLVKAzyaPcbeahEjhNWAC8t8V6/LUvzITNYposB35XjTwIxLUnrdwkIaRwxhyReilxP+
	 kRPCdDkQtv2A191DrO8ptJJMVEWPiw+r15fiVzj7ftQWTbX91TdT5NoDmbBly2Ncsw7O2
	 acAK2OfOGuquJ5butP+WDudyhftamlxD6fmK/qoHtcvB5Qlt3bAwh/Om4ZU7G+faqOHPz
	 9Eg4c8kcTsn4L/znpRfkegV5kK4UnGVwBYOVgQEUxYHTtwF9C5YV8DwuIMHvHq3f9IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WwX9pFlI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B2B606A31C;
	Wed, 18 Nov 2026 20:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WwX9pFlI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC701F000C4;
	Wed, 18 Nov 2026 20:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033597;
	bh=aRwhcvf7K2Mr+Kn+9I5xdsEtJ7me2hLeXvAQTWtmnHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WwX9pFlILZpTTFLrT4Yk/LTkQjg33DAKO9QA95P+hv6W+7nsGT8urvpDblhEz6DC/
	 d66wu79pbbj8zmUBTfo31BpOjGQkbkUr3zHCzyL2GbAbLEJ0JEAqh7ibXVQbOhasaS
	 oHTQwb3oiyTYL5BNoP/unQc0J0dHA146Kw20dukg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0029/3318] ASoC: sma1303: remove fault-check sysfs group on remove
Date: Wed, 18 Nov 2026 15:10:51 +0100
Message-ID: <20261118150314.657224723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit ce3733792d38ade8df8ce288a96ff0c6ad858bf3 ]

sma1303_i2c_probe() creates a sysfs group that exposes the fault-check
controls. The check_fault_status store callback can queue
check_fault_work.

sma1303_i2c_remove() only cancels the delayed work. It does not remove
the sysfs group, so the controls can remain published after remove while
their callbacks still use the driver data and can queue the work again.

Remove the sysfs group before cancelling the delayed work.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260615064456.28615-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sma1303.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/sma1303.c b/sound/soc/codecs/sma1303.c
index 7b9abbc1bd945..5cd9e0d32dc43 100644
--- a/sound/soc/codecs/sma1303.c
+++ b/sound/soc/codecs/sma1303.c
@@ -1787,6 +1787,8 @@ static void sma1303_i2c_remove(struct i2c_client *client)
 	struct sma1303_priv *sma1303 =
 		(struct sma1303_priv *) i2c_get_clientdata(client);
 
+	if (sma1303->attr_grp)
+		sysfs_remove_group(sma1303->kobj, sma1303->attr_grp);
 	cancel_delayed_work_sync(&sma1303->check_fault_work);
 }
 
-- 
2.53.0



