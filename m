Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033928;
	b=sjuLgYS5pQBana0CE5ZbcdP0v9OZCWLQ09JpskcDEF+bhpawszj/Zj+3ctPED5i4VcNN
	 /sN3g8HZfmil1pKuw82iDmaGzqpEXmdrAAmT6E6T2MLU9d5xTgqQ+cFY5AVyj+AUcIVTe
	 4Opx5xjmlfJXzIbkDvrVvnGMKoTKuNmV3bGU0ANuroYlW4UNy/iafHFdQ26T6d0G4Zdrn
	 67bo6TPfKzECtxyzmfU/JJLnVViapXpsI7N3sn7nK8YoEFq9ASEyZs0XWNlUDB41/aS7w
	 m8/mlDAlPNtlzooTJg4swPFZ+4jynns0+0sr8/+ItzfICv3U1Se4MHnyJ6EH5NUM56g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mXBpXz4RPH7d9vdDn66mTIyXeaPrbYPrgY3jXxJRPRo=;
	b=gin10fjOxoa9d+F1o7RCwRi6fkJ5rWHE36+98dR+fe8x3euR+XuiNFLFFPfsyApcVFuO
	 2RCP9kj4jkCS1PPAyo5yJCESpMafnhOqmTvUqQZrkpOvOXsjzvERHP+26fCmHSA0iB2pg
	 RkFsC6w1U6hsyCrMIyWX4f1ngkww60C4nX0UEGVjYbRpgWS8bgsAXwFpwAdqAqmeR1tFW
	 CE+osfDjCZMz6+kgmaDRL+ipfIWCJE1Xrzlk7aOSDWXTcoeeb75GSTw+V50wakpXQ4d/O
	 QbM84onhZcSG50q2wymib1I/+Hz31aNGwmwXVyYnmedMHNCssfna+nIiCg1bPsFU9lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vxVHyCVx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9184606A32A;
	Wed, 18 Nov 2026 20:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vxVHyCVx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FF81F000C4;
	Wed, 18 Nov 2026 20:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033928;
	bh=mXBpXz4RPH7d9vdDn66mTIyXeaPrbYPrgY3jXxJRPRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vxVHyCVxpM4gPYgAqjgkmXZte6ZkYChvdphKS36i6KQRqzffTMHTcB9bt2o6+oB2R
	 3OVAsQwMAa6eRRKRLS8GD84jkb5nDsrwIHbtUESYsaY5Vju2HvZleAUf1SBpgGCVlm
	 DrzSK3Uojv6V3U5m+kMgDtNHDWEb4WFW9cTOoNWY=
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
Subject: [PATCH 6.6 0188/3318] clk: tegra: support 48MHz clock for pll_p_out1
Date: Wed, 18 Nov 2026 15:13:30 +0100
Message-ID: <20261118150320.415697386@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 100b5d9b7e26e..976feb8f41277 100644
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



