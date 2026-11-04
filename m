Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829293;
	b=4rDTIwfgbyIfcEG/5EIYfet65qkP14hGLnTA6dv8PO4JNRBdQylP38UMv6Lt0gWLcvg5
	 V+R0b1SD6hfHCgPGLi0hxrgRsI42EtsPSObmRsJVDvtMdk+aMVdaQG+SRGVzpQQ+MsJm9
	 V8ZmPOUzGEWdTxErbU8imJ49GMxWapR0hDNSRzDHqsJqsVBt/EONUc/bHuECOGf3t6fYN
	 i1IJl5VoK4DVpHHXv47g0BA8BSTQ2ITootYONnEW2HCQs0ypa4Fxz6L9g6r1SVQifhYYe
	 PCcRlKR7J8S+MuVUNSJccYr2B+PxqznoajQFmtJGf95T1HVs4ja6X9JgdVcVXUuVFYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pTAqc9u1bgaAcbJLu7qklA5mKNP+Ic0tiMHXb7tgiDU=;
	b=kHibUYNF6Jkajn03kY08yh2jrzSsBX6hFRIu3uGiPeWRWvKVEfqVv+yavdXNyBG90T0C
	 8+4MeONGzE0nz/yKoqcAJPoK2409Eb5LSFd60d5XqOgYQSIoSy7i07YD1f50fuuCMSiIM
	 CzJYzSNvqsFtjOdBLBt/wX9ETTyM97hq2FfjvEL3QZ3ZUqu4jcQKaA4NugHPWWjlVOTZ+
	 Wo8bNveZgJdGhAxNxjr72pkseXL+Wh3/svs96tbzL7OJHIyngFsywN3elhcBsZsWuud8D
	 ZSGC24gZwp5+ggY4KOikWVJiI+tVZmay683tE82PyvxOFyNdzYl9fksQ/iR/AgjCztw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yeDkaTyr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0CB60A3808;
	Wed,  4 Nov 2026 21:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yeDkaTyr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345301F00919;
	Wed,  4 Nov 2026 21:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829293;
	bh=pTAqc9u1bgaAcbJLu7qklA5mKNP+Ic0tiMHXb7tgiDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeDkaTyr8yY/DxwpZNZKoBSrsG+mp5K33dj2ceentlwdIp9ESDNqQFuo+ATPm6LSN
	 Iuadi/u3Bw7jwfxXL7Y5FCz7M93C1jrnmuD5KW4Ym5udkYudP5iYi2Sxl/orfP4soE
	 ryuUXkyQ8ZzBepd5S82U+8amgR39TRyJUuQkts5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0034/1005] ASoC: sma1303: remove fault-check sysfs group on remove
Date: Wed,  4 Nov 2026 15:56:07 -0500
Message-ID: <20261104211044.522036222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 980c48cbc3482..e07ec1bbf2d50 100644
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



