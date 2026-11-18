Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051264;
	b=Bjhqb+VM3UEPys84N9B0ogl41dRbXs3RqvEl5oRf4oBkcPHAsxkb0IT+XoxBRIpFIH0D
	 SJ2zd+JpOqXfLvjjm222DyCqerHJ/iYiPZNEEmyHSD2JnRSyQ1+4yTumf1g3eHbxnZyGa
	 v3YlcuQR8dzZwSn5s+ANUPOvtN4u7xsVyruQ+vMBUe01Uj7pygz9eLrijuRuUDgEUXXrp
	 qKywl6oD+a2TtggPajplVuv/ELf0/JUnDyxKeHMyKgnmXcmbuP6Icg+W20lZa/QLUAdY/
	 uudblVup8bcPVJd5PSBltqVoF4f+x+l+EAxbsAJqPLG2XwW6Vu5WUyYJfWhpPJSIBJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6VyfNCXaLWGIoWYz6IlKzWMRKltyTFd6C6p1lhMLhO8=;
	b=o3Q8qXLcPC2M6QCpQQVxw4pOtEN4GPW29v526C7LfYW22bnFRKeZwozkPW6W90OSG+G0
	 Q6p9epmUrfJK/x5uyBCHfmLPU7pYr3JnY1lSZm+/gC3pcJ80Zuic6PYZ8GmKfMhy2rsjI
	 T50pR6F9dmqCaV7GkuJTI9j012riqYcwJ2EwanR2L0AEsa4po2lk9nrJvYcn7LvoIV0es
	 Qs/Sm3c0swsVYA0oWl8I13CDUOT7TyVVQo+BWyAjGYrnlWGyOlQqFqKTIyfZgvqKMYyhP
	 LKrPt61dhNm4dFBuzZ6fYgX80E8+7/2L8jEy1dsInPiZliQpmE4b4E5dGUY1DkKYr+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+myT2Uw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E939606A32A;
	Thu, 19 Nov 2026 01:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+myT2Uw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26431F000C5;
	Thu, 19 Nov 2026 01:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051264;
	bh=6VyfNCXaLWGIoWYz6IlKzWMRKltyTFd6C6p1lhMLhO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+myT2UwTz8IQYTu86Kvl5wSLbeRyy0S5IN7E/khalntgnNeWEgWBWT+UT8uqXbc+
	 erYnVnu7A9ZVLFUDizWZNp37h2Bsg3tWpwPex80b6BGRSQYRWhetr4W38XG/FCDLGJ
	 nNht8voMCWUoEQkhRXUw8tYo8nrLzaWxbeFEgHhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Dmitry Osipenko <digetx@gmail.com>,
	=?UTF-8?q?Jonas=20Schw=C3=B6bel?= <jonasschwoebel@yahoo.de>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0147/2214] clk: tegra: support 48MHz clock for pll_p_out1
Date: Wed, 18 Nov 2026 15:30:23 +0100
Message-ID: <20261118150016.050003251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 46e31d69a547530fbef499bde888b6bb45a1deac ]

UEFI on Surface2 sets pll_p_out1 to 48MHz which is not supported by kernel
and causes BUG() early on. Add 48MHz clock support for pll_p_out1.

Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Jonas Schwöbel <jonasschwoebel@yahoo.de>
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-pll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index eaa079c177c33..83561b1de5a7d 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -575,6 +575,7 @@ static int _calc_rate(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
 		break;
 	case 9600000:
 	case 28800000:
+	case 48000000:
 		/*
 		 * PLL_P_OUT1 rate is not listed in PLLA table
 		 */
-- 
2.53.0



