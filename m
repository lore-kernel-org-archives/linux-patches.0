Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060576;
	b=xZrpPdA1vV203e6egRAj2TcSHxhtw5Mnf/+SEQ744emV0yVnb3AzXygq2D9rm8Pm8894
	 ETTsiTEg3UD5thTVAZW0wZHq+GZZ0VbJjDPtuq4qqCVtKt47ytmMhNPCycayZQhDW37Uj
	 zJMJhzhr+fGzQdoHyEJZyvpBpkRWAWrZvNdtLGhDJ4jrWXdvJgFNp8D9LNoNVCuX5lsWB
	 yCGB8cu+cfWXFV6dLTwxGyI2OotdVt6xIHf2Nr8b9F43r3jb+J0wPoaGvYs7kz6J0aLqo
	 pcHZNJjfeQs3z2WRrg4QuSyFa0NnxGVV2AIAuDTpkb+MKTKvWQCJ6EXBzK0Tr8S1wmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xDnqgvUTUFD5G8BU7QPlG1U11lQCP8trAeNk6czxEpQ=;
	b=G5+7UmK2XxJp+a5oMKCoFsFu8mbWHYWApho3ljke7Zr1YRFi5Ue0m4CW9YnWswMjvm73
	 HjnsxWj0JVexd4Y3ZNMb+sLMgEWoicSUUCv4sMNv2HU2UbChFGsZsEz18P+sua5TAvPgX
	 CwDvzJaH87aTxCHkJW/oDlauUDbUh3o0hFBABEq+eKROHmLEIV+qiIbnzGb55Xnr2YmKH
	 cIvGSERZ12w60MD6AHKcNcIEtD2LoCOfHxJDb49CW9/L4wv+FX2VKkndcCr7cv1KvtsgS
	 izQ9VUBBkyeiFjmsxO+fBm4+I4bhYI+NkaztThUyIoRQVYaH2po1GTxy3ACBqPtibiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0/aFWlpu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC1C606A32C;
	Sat,  7 Nov 2026 14:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0/aFWlpu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778F31F008A1;
	Sat,  7 Nov 2026 14:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060575;
	bh=xDnqgvUTUFD5G8BU7QPlG1U11lQCP8trAeNk6czxEpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/aFWlpuaze0RPvVGfYsKLqZq5y0q/iaVQvGJE6adgPyO8xi0n2qkctm/YF4TeZ7B
	 KQ30Wa9ODH29mSRtf5R3k7/7tvPTnsWj2CBKm/pAzaWeqMq5o+1fbO0bty4qvFbVJo
	 J5UzfyCTIG+KefmiSTMYhCU4l+xI88cYGaM3zaa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0035/1536] ASoC: sma1303: remove fault-check sysfs group on remove
Date: Sat,  7 Nov 2026 08:34:11 -0500
Message-ID: <20261107134958.651632680@linuxfoundation.org>
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



