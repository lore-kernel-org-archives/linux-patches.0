Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044893;
	b=slISFCjTpMD0b9qu3v11nTjuuZ/V0uNk36c8XEl2EFXi5ujPsfwDTVPZxCpb6L55xq6F
	 Qm1cKbszkiZ1mivggCNvQLRAMxQ389hRDOsdloxRXeqfELCphoKd7Qf/DieHSkJ1gAMGq
	 +Vy0Lb4dp3FYQERR3uK5j0NYs+Au6n3qkrIlJX/dWyubcGCaDIeXNL1AVq/W3mrVmi9Wv
	 M0vL8srGdmlqWrAskzUuRaqphrxJ3thDZraApRegk8y3M8tkl6Oo6RwozgGVi3IlaHYvx
	 pGEyfETAMeBtsXPX551BCdprJRT847/14ag+iGgMkCeVm7Hdl8Gm7/3fCnHFPbCZrpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ABg7vLmqDwpeo4w/WiTvRX0khW9prR+IQta9ID30jxU=;
	b=fTr1fH0NX1O+I2ZdIuL/YKoMEprhfSvFBavvjUiSIyqsocRmv+Kp3VG4KwNQjyi3kBDW
	 CNhrnJYYId9aViqSd1x92k0kR7qZHjk1EqXdq3SywrXAJUDJp+voAlCxEALElB9srO4Jg
	 GqvXrQWC1o2M5TsOzFDusxYGkzl7v7i9WrSU3Ld8Zgpg36LLS8zTHOI663q5T/I+1c3IN
	 +T+9XXFWK5UXFGnp2ICRD/rVrORNMaKPAeKTEa2sLQzFr1gfL7/ZfDMccJPINT6EjX3T5
	 egQH9micp2021yUn8X+4Fhx0RXQNtaPbpFpFI/aNq5nRy0NLe3O8PWacjPGjD/a/24A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZqeWW5j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258D6606A339;
	Wed, 18 Nov 2026 23:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZqeWW5j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6531F000C4;
	Wed, 18 Nov 2026 23:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044893;
	bh=ABg7vLmqDwpeo4w/WiTvRX0khW9prR+IQta9ID30jxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZqeWW5jgBCKge4Spxtu0PpW9G0tyonEdxS6WNoxw45iA0W8pJ51iZjpw4HoyDqLN
	 9BbehT0QiWCvP4xQ4y+DR8MKLpZTbqoQW9zfA+uzISXQZNvRaAwDfovobWze2ZstvH
	 a5y9AWZB/4UwFQUDdTg60QLvQONJu/+GRambmwmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hanzhijian <hanzhijian1991@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0726/2857] clk: mstar: msc313-mpll: fix off-by-one in clock array allocation
Date: Wed, 18 Nov 2026 15:29:20 +0100
Message-ID: <20261118150227.687208090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hanzhijian <hanzhijian1991@gmail.com>

[ Upstream commit 712b75152c00a8ab0c56dbfe34caf88e3870ddde ]

The hws array of mpll->clk_data is allocated with struct_size() using
ARRAY_SIZE(output_dividers) as the element count, giving it 7 elements.
But the probe function stores the MPLL clock at hws[0] and one
fixed-factor clock for each output divider at hws[i + 1] for i in
[0, ARRAY_SIZE(output_dividers)), writing 8 elements in total.  The
final write to hws[7] is past the end of the allocation.

clk_data->num is also set to NUMOUTPUTS (8), so the clock framework
reads hws[0..7], again accessing hws[7] out of bounds.

Use NUMOUTPUTS as the element count so the allocation matches the
number of clocks actually stored and exposed.

Found by smatch:
  drivers/clk/mstar/clk-msc313-mpll.c:134 msc313_mpll_probe()
  error: buffer overflow 'mpll->clk_data->hws' 7 <= 7

Fixes: bef7a78da716 ("clk: mstar: MStar/SigmaStar MPLL driver")
Cc: stable@vger.kernel.org
Signed-off-by: hanzhijian <hanzhijian1991@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mstar/clk-msc313-mpll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/mstar/clk-msc313-mpll.c b/drivers/clk/mstar/clk-msc313-mpll.c
index 61beb4e875250..bd45aa0aec011 100644
--- a/drivers/clk/mstar/clk-msc313-mpll.c
+++ b/drivers/clk/mstar/clk-msc313-mpll.c
@@ -105,7 +105,7 @@ static int msc313_mpll_probe(struct platform_device *pdev)
 		return PTR_ERR(mpll->loop_div_second);
 
 	mpll->clk_data = devm_kzalloc(dev, struct_size(mpll->clk_data, hws,
-			ARRAY_SIZE(output_dividers)), GFP_KERNEL);
+				NUMOUTPUTS), GFP_KERNEL);
 	if (!mpll->clk_data)
 		return -ENOMEM;
 
-- 
2.53.0



