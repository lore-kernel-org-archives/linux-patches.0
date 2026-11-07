Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063880;
	b=onrwX7j4byR+34zoa73PoJrfiYjZwdKd+fVEeUgNEKy0gb4CcJuzbOtFYhFFcklxjpWp
	 fbFPmSGnJA7QUraztuiySx/av/Wd1fpe5eTzrSBeuQSuLVsPseBO4gyHeKINq4lleaWWq
	 +qETno3yJCwV7GRMXlZ/F3wgJtotQjC/gnvvK/cxkSSSxZu/wBAzvT9Rmda6JPVYRXesp
	 nWHOptN1fbwuBP2QafdJgiNF4OImY43X2bashPx75tWO7YwIKYdZedi2FsRlrltybA/qa
	 TteQZgvTFCc5JE0VNTM228HHfl6c20aQsCp3TtCT3c/6k/HM0e76U+AMWZ8OkZHf9UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5YdndtTa8Pr23BzRp++zXaCGyhS0/Hq7grSvXp/0be8=;
	b=yh1mzzogDe/N2TwOLqumD7HPXbCM1lco9lYswGmpOMaEZQzEi1ZFMMY4c+5OA+CAg2lw
	 ZRde0tPdi+xMUyS6gz0J+I7ENORAjbW17OwkAryweCnH5SPTOGPaGoz2Dcu3rG1rD2CSm
	 vTIefY6dLgx/05koSi0RNbVM8KOhNlbCWzfiHeeU5DqQsWiUyxUHm0HRsY+JAb5OBv4Y2
	 HM/FDPtlk8XABgE5TZNGAumrq+WKaUfPmhDvPVLCa9eAPO5f7j8waylXkPBboyEFhU2rT
	 I1NTUPZefFFCFRM60z/kg1xmi+j9MgebB6cSwMTA7m3yndEQ9UD8RkMxk2qH3XfI/4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDqq0Usj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D2B606A32F;
	Sat,  7 Nov 2026 15:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDqq0Usj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0F71F008A2;
	Sat,  7 Nov 2026 15:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063880;
	bh=5YdndtTa8Pr23BzRp++zXaCGyhS0/Hq7grSvXp/0be8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDqq0UsjxrXCTFEUC9LdTzY3F4C7d/znVtg4wVKkKuta8yZpIdnZPAw7VVD6OxyI2
	 BzalKSnl4U6yXGQw/BzG0OxsYqMmRwHvODY4HIgApSu2+lQPAWYnmaecyvnZJWOQrl
	 qs0sf6lQgRK8MpmbVzpABbv2teRna2Hzv+Uz+H4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guodong Xu <docular.xu@gmail.com>,
	Yixun Lan <dlan@kernel.org>,
	"GUO Ren (XuanTie)" <guoren@kernel.org>,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0082/1257] riscv: dts: spacemit: k3: fix IMSIC num-guest-ids
Date: Sat,  7 Nov 2026 08:39:38 -0500
Message-ID: <20261107134941.639616619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: GUO Ren (XuanTie) <guoren@kernel.org>

[ Upstream commit 69f95409f0053f787ad60175944080621a8b7d95 ]

The initial K3 device tree used generic/placeholder values for the
IMSIC guest configuration:

  riscv,num-guest-ids    = <511>;

According to the SpacemiT K3 User Manual this values is incorrect
for the X100 cores:

 - Advanced Interrupt Architecture (AIA):
    - M-mode MSI: 512
    - S-mode MSI: 512
    - VS-mode MSI: 64

Therefore, S-mode IMSIC (simsic) needs num-guest-ids = 63.

Fixes: 56f37e391a62 ("riscv: dts: spacemit: add initial support for K3 SoC")
Cc: stable@vger.kernel.org
Cc: Guodong Xu <docular.xu@gmail.com>
Cc: Yixun Lan <dlan@kernel.org>
Signed-off-by: GUO Ren (XuanTie) <guoren@kernel.org>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Reviewed-by: Junhui Liu <junhui.liu@pigmoral.tech>
Link: https://patch.msgid.link/20260817033038.2286436-1-guoren@kernel.org
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k3.dtsi b/arch/riscv/boot/dts/spacemit/k3.dtsi
index c3f2dce0969c0..f9c2ffedeae80 100644
--- a/arch/riscv/boot/dts/spacemit/k3.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3.dtsi
@@ -1248,7 +1248,7 @@ simsic: interrupt-controller@e0400000 {
 			msi-controller;
 			riscv,guest-index-bits = <6>;
 			riscv,hart-index-bits = <4>;
-			riscv,num-guest-ids = <511>;
+			riscv,num-guest-ids = <63>;
 			riscv,num-ids = <511>;
 		};
 
-- 
2.53.0



