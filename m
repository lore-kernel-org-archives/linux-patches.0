Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060589;
	b=QyrM3RQRUx+iPn/CsvFrKNT4W2mgjCbeb/AKEGshdpI9bwLh1gvk/XnRH5Zj3hBgh3Hc
	 Ss3Tkp4sOVpY9B1YWU412Wm7DMaq/swispREEQVgxmPApWwbHLFzS8iM5AeEruIuJFYna
	 aGaDul6iDXVbySnNx7Kg02Mk0JypszT3LqcQ3fEo6gW46yXo8hKoq0pJwMQh15lI02b+T
	 sALh47EmdMrD6SD5L+cMQKe/DcZyNw436dJyVIMmyTRJf8Ah7uqpZ54Mxu+NnQ5G1jl2S
	 qKKKzwkmz+RODHI56uP0xMhgR72aniUPqUUm8Oe+8EYT3M2PlQDfOmZzptAOmriD63w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nxt8FVrqzmr0w+1uSMbjm/emoOn+FiVXRHSQUC2ww3U=;
	b=5fDqWbNFZAUsktZrM0q96Lr/pvkO847QrbrAKDl0fNIhno29aXeKQP6AzrYQe0QrfP5v
	 JWrEjiU91lXNramnnfFDSXRYWbgxuYB96/BtCepuj5L/OC6SwCt2jKdd5s8SISBkEHMDd
	 RAluiQ9cBqY9+rkjrKoDMhl0QgQg0T2IoZSoVuE2aMnLqPTt3VndMLeTrw78O+I63U71k
	 gC14yVpFB5LcQF5vknRAZdCGrEQPQN9ndS15KLNZDLndujBlDoAOOWIDyXgvMW6PdrI8b
	 14kZKWiH3iQ8KEdDIAy5rd4gFVVjEChzXK72nziRuWohRd0+uRr9RqFiFqcQZEnOT7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpRq2kjc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DF0606A32C;
	Sat,  7 Nov 2026 14:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpRq2kjc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6675F1F0089F;
	Sat,  7 Nov 2026 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060588;
	bh=nxt8FVrqzmr0w+1uSMbjm/emoOn+FiVXRHSQUC2ww3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpRq2kjcPCItsBrzjyMxFi3K7oVhRqjrEmlJ4rqdGxZGSiqwKYIxo9CRDyuSrXMmf
	 ELCI7u3EaiQvtQA0VBs0Ds5XsC4Xq3QBKf1lCBLd1CAT0QrI38jgFhIpOySyTYsg3j
	 XFGugXGiIaIf4g0zROi55lxCkcA/NWx3LOc7kGEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0046/1536] spi: bcm63xx: return error from failed controller suspend
Date: Sat,  7 Nov 2026 08:34:22 -0500
Message-ID: <20261107134958.951968225@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit bbbc1ef5b35341c5122418a14f8924688a4bb954 ]

spi_controller_suspend() can fail if the SPI core cannot stop the
controller. bcm63xx_spi_suspend() ignored that error, disabled the
controller clock, and returned success.

Return the suspend error before tearing down the clock.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_0BD7D4091B90EC17A8B2BA5EBA8803725905@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 6f7c4ab0057de..3d3a4a8804579 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -643,8 +643,11 @@ static int bcm63xx_spi_suspend(struct device *dev)
 {
 	struct spi_controller *host = dev_get_drvdata(dev);
 	struct bcm63xx_spi *bs = spi_controller_get_devdata(host);
+	int ret;
 
-	spi_controller_suspend(host);
+	ret = spi_controller_suspend(host);
+	if (ret)
+		return ret;
 
 	clk_disable_unprepare(bs->clk);
 
-- 
2.53.0



