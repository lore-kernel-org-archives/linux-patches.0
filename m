Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033513;
	b=IMnN6SUZcS48v1iJpacv/1xM9b6Ud1KfF1HXOUd8yC99ve0m7z1TljM98ebk8+ijPU3o
	 RDn0o2hrGmAH11Q1SDX/xUo4GySH2M84vPzlYgRKzndJoASKcmeyX9NfkX98w98n6Etpp
	 vSVeXmNjTKPiSgFZE6NhcOMncQeuU26sHAyeDTzeXEFeNmKuhhDtXDqUkcmsz1CzWiaKt
	 loCXaifjoU/A+J3urlr5gsDUgAY9lj1kbFI6zCsR313KGUbJlXEvR0Jd933Kf4U2pr1V9
	 gno3a5dCfEBKkD5TcLVrWef6gKPlz9lYSn59fwpQjefZ3wokciDl/eaI3lhiTiN5RRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DosVjhSjAf2Ef8amq6V4Mi97JEV05PoZ5MyTFOo6/iU=;
	b=x+v9YY7mUSirFPEXQ+d7NFFp+44PWs5QwmV2D2HPF8Q5xSenXRdCZGr36NVnrD/CDOML
	 9pOnHNcWxENr2XOz5GqqF44HvNjNN44j652DQQB2nXdxK4S2K+/FpU/pZWyfkWN7328B7
	 OOlQpgOV6kQsTRNNcLgqLk5zmEzCqyJxhAKACI6R+gU9JR+zUeLSmnwv9f960CVkt0tmp
	 c791hGngP63GUmuamqiBvm2D1oz9owQFCgA+pCnIT8EBjXyUbVUe0hi4ois2452GG1Ql7
	 u+c6JiFLgwWQLdByqms9RWEbY3P0ZK++pK7GWQzDZWONSgPpsL2Vx9f55Dif0LT3JOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CU0Ndxpu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7CB606A325;
	Wed, 18 Nov 2026 20:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CU0Ndxpu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22BE1F000C4;
	Wed, 18 Nov 2026 20:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033513;
	bh=DosVjhSjAf2Ef8amq6V4Mi97JEV05PoZ5MyTFOo6/iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CU0NdxpuEf4CZJE7gh/uGTCWP3oeUxCazs/CjporFXX5A4FRESEGAcaAVoP226SwM
	 CqxTCW8fmBe0xv1r8NksO4R4vkUsBgWmEjnumJbmdwcpfTMipOTeQydWbHMFRF6snQ
	 4DVjV9ikm0RM0QLjjOpuhfmi/0JEUwokBeDLshwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0042/3318] spi: bcmbca-hsspi: return error from failed controller suspend
Date: Wed, 18 Nov 2026 15:11:04 +0100
Message-ID: <20261118150315.134443317@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit faa878d4805ca375738294bc52eae310eb287b16 ]

spi_controller_suspend() can fail if pending transfers cannot stop.
bcmbca_hsspi_suspend() ignored the error and still disabled the
PLL and core clocks.

Return the error before disabling the clocks.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_54F5634545908FBA724E758054BF03953808@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcmbca-hsspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcmbca-hsspi.c b/drivers/spi/spi-bcmbca-hsspi.c
index 81826692d4df6..5e0a928616dd8 100644
--- a/drivers/spi/spi-bcmbca-hsspi.c
+++ b/drivers/spi/spi-bcmbca-hsspi.c
@@ -595,8 +595,12 @@ static int bcmbca_hsspi_suspend(struct device *dev)
 {
 	struct spi_controller *host = dev_get_drvdata(dev);
 	struct bcmbca_hsspi *bs = spi_controller_get_devdata(host);
+	int ret;
+
+	ret = spi_controller_suspend(host);
+	if (ret)
+		return ret;
 
-	spi_controller_suspend(host);
 	clk_disable_unprepare(bs->pll_clk);
 	clk_disable_unprepare(bs->clk);
 
-- 
2.53.0



