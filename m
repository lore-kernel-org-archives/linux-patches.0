Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039128;
	b=Lxd1AzapCfyxNHN8wUPCjSebpD8x+TM08OoDJNNpzREVrOZUriZ2ZSR4P96MXY0jO16F
	 cvo52odM0u0jIa/b/62Vj8VxNu8ptTVA+sJICaOg/MXI17zXLzewmRn/I19wPg4jjdK9d
	 q+34DIxWe+IsPYmrogQgXqhn+xSA4s3O5GjoAR+XTkJbirGr7fXtOMgd7O/so9xCjNgh/
	 knuxyQZveF8Rd1jCyadGO0utHd59wszseQIBIJpMOri8ndmG5WbmvnL9T/I6F9ZmnWq+G
	 kEON8cBerMVZjQVCKUTXPjogoQ9UrfKgjuBoorcuHDRaq3OxUou6aOaL6Oh0L1gBYDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=88EuMMZOYH+5Y2ZkGyhdhAkAree3r6Y3VDoky3pD3NA=;
	b=k91EBk4u6wPEUYgjcU0wEqZKAO+q4rb5asCOTttyfUgIHRa6YwF5VriwZkgdMZj3qzwd
	 5k6C+MccF5fVtWlNWUFttV1MnwgnLjWCKbqHPUlS02IZCC+s0NfcGCU0qcDe2UGPcigi2
	 PYsRIbU2KCB93qLU9sXHA7QU7UVgyJKvlxFAg6S37duLbKcQnsDk5iSgfvkpZhPwq6Bx/
	 87Qpf0bm/N3QQUJrzox3sFPC5nTuaZ19YZK6WzJCdHveNXSKFZxeyitpUBGVAjb/e7aLE
	 VxM/Qbua/gC6le2acFUVq3rUEoqzWXcxmMjLc7dItCykXB3BCNH4qLQXsy0V6xMWlcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iq4XeOxo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7BB606A31C;
	Wed, 18 Nov 2026 21:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iq4XeOxo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4C41F000C4;
	Wed, 18 Nov 2026 21:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039128;
	bh=88EuMMZOYH+5Y2ZkGyhdhAkAree3r6Y3VDoky3pD3NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iq4XeOxoOKAVo8BdZ8UpVwjpytXcOYYDGGx4/CoqgMJNzuF/Ke8KNg7oMm5wqlQQY
	 ep4fJDedk6Y6fvQIHVv0dfrlH/vFcdp1SWMV4iUPuasMpFOu6rCmGgKDJsyr1OMk/a
	 sfkRgiV2YeRDS8wYk3LW1SX3icnH35Rqpkfsox/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1989/3318] spi: sh-msiof: propagate setup runtime-PM errors
Date: Wed, 18 Nov 2026 15:43:31 +0100
Message-ID: <20261118150421.734148793@linuxfoundation.org>
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

[ Upstream commit 152867998da9f331d6235d76aae1c7e1650708a9 ]

sh_msiof_spi_setup() ignores pm_runtime_get_sync() before programming
native chip-select registers and marking the configuration initialized.

Use the checked runtime-PM helper and return failure before register
access.

Fixes: 7ff0b53c4051 ("spi: sh-msiof: Avoid writing to registers from spi_master.setup()")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260830140133.24156-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sh-msiof.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index ea94891023da8..e848f40786801 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -558,6 +558,7 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 	struct sh_msiof_spi_priv *p =
 		spi_controller_get_devdata(spi->controller);
 	u32 clr, set, tmp;
+	int ret;
 
 	if (spi_get_csgpiod(spi, 0) || spi_controller_is_target(p->ctlr))
 		return 0;
@@ -573,7 +574,9 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 		clr |= SIMDR1_SYNCAC;
 	else
 		set |= SIMDR1_SYNCAC;
-	pm_runtime_get_sync(&p->pdev->dev);
+	ret = pm_runtime_resume_and_get(&p->pdev->dev);
+	if (ret < 0)
+		return ret;
 	tmp = sh_msiof_read(p, SITMDR1) & ~clr;
 	sh_msiof_write(p, SITMDR1, tmp | set | SIMDR1_TRMD | SITMDR1_PCON);
 	tmp = sh_msiof_read(p, SIRMDR1) & ~clr;
-- 
2.53.0



