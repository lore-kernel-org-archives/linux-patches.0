Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060238;
	b=4oJefrPukTkjG4E1KoPVwkdHOz3WePtepld7MuCHf8SZSXfO00dhp9RA9cZqxXjcXixp
	 FklovyEt6drMobulOB8CjQku3GAPR4Lt/ezgBxpsws3rhqx1B9z2yLi6aQNORmb3anfCT
	 XNDWe6TySbwnMNFeWEw0+6+3bX9IaIJE2IdujnxRQ2THpse1TJt6eb4e8v2foxXuvuKjk
	 h7QrKuHMZ6Zhm/BrUsY+tJWLFijpRB/YKN+dFYrgBi48mIlcNlgV4rh4AleyAjG4RsFVq
	 n5rFFXgDrMV8nbYBvdJ9vcIC2yRn9+/qDnxafHL/4Koz8uFecMijst+RLhtPCaCjqOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7pf/Qo2pFUSYJKxMMKiSx3YKxQpG309DXaL2eVp0X8I=;
	b=s0UhurH9SEzBFrCnA3UJUZv9MAn6rhpmDPtHwTwQ/qrmBRnob7MXbSa2/PYoeyBT87/e
	 jkOs1SWzecB3CQZUMOol/0/PBrUPQpLI+mSsngJuAvKw0/ChDKG3QuVROszIpt/2f9nay
	 rXu7KeY3KgiqvH9QzabubZEm9uymWGJ9XCGJtCgkK/LeCYGmjUPocr39+zF1fR3LVQsV1
	 oAfq84PuYJpTpHFYU2hKf3OtkRXcLSWdMFIu4l8nMR/MSoNvG/MPhJyh668f1CRwWzF89
	 KTLmY49YIxSdoBUGImKIXZam/KljyGmlCWTBJD7Rjqy7FxaKpHyXxbTpk46KcSxgufg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWrmXrw0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8144606A325;
	Thu, 19 Nov 2026 03:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWrmXrw0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1061F000C4;
	Thu, 19 Nov 2026 03:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060238;
	bh=7pf/Qo2pFUSYJKxMMKiSx3YKxQpG309DXaL2eVp0X8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWrmXrw0dE4S/3sExOBCPsgul2ILdVjZrOpbsxJvE3dO/LyOonCrWkrtvvamcP+ME
	 W/TPsC0cAcGjf4/my6NvnK1xoV0gbFFJues0tlhm82j0VgqBuSpb3C6LGsaQ7FFNIO
	 qe79y+BGq9duw6FmNY61DrT6XtXUjsTI7qO2SYJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1127/1848] ARM: dts: armada-385-clearfog-gtr: fix vmmc property name
Date: Wed, 18 Nov 2026 15:52:45 +0100
Message-ID: <20261118150006.466306914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 337d10963f601d5a3dfb4b7aa273ca8c0b4d5172 ]

The SDHCI node references the 3.3V regulator through a bare "vmmc"
property, which is not part of the mmc controller DT binding; the
correct property is "vmmc-supply".

Fixes: aecc313490ae ("ARM: dts: mvebu: add support for SolidRun Clearfog GTR")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi b/arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi
index 624bbcae68c09..b64645b0aea60 100644
--- a/arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi
+++ b/arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi
@@ -202,7 +202,7 @@ sdhci@d8000 {
 				pinctrl-0 = <&cf_gtr_sdhci_pins>;
 				pinctrl-names = "default";
 				status = "okay";
-				vmmc = <&reg_3p3v>;
+				vmmc-supply = <&reg_3p3v>;
 				wp-inverted;
 			};
 
-- 
2.53.0



