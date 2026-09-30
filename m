Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75D9A59;
	Wed, 30 Sep 2026 18:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791843; cv=none; b=LPGzimNG5XUyj93TbyUqVy2QAeFi4b/tIVgHFcVF+4H2fNOrIENqP5j/6mk2LHhPxReLx9IJZuElZ3MzmgZY1kGdG628XPGJ34FsrQZAYLN1AFOsFpQEQU1DdZG/3dnSaMLuHY9T3VDI0HF8pqBE+iljw4zrhw3pn8MW7WgzBiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791843; c=relaxed/simple;
	bh=QUhFGTPrQPVDkYIbhZu1ZmyeojeULaVB+ZsnMtEmRrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFY+ncF0kLa4DYdF6eyWu9s/bUOpNk7HE7ahyff4Xn2gdHdqika7N3KgfLILBMYzLwGP8JLwVVx9qYqlya2ww3M0uFYdmdMVk3uT+GCRel9cLLO2qPuS1fnZTIeV9zcSZm0AqBtDwh97XdV9W3bk087xzdZIUqPnVU5sJ+0W+HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOoQyhim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOoQyhim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9131F0089C;
	Wed, 30 Sep 2026 18:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791842;
	bh=fSG8DH/Aqt54s3oRG1tE6y0gnU7wrPTfVRCN5mpoEfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOoQyhimsYUHQfE5ThA7LJYC3trEAclsFt1dnbWxsmVEu6zWQOyHde1fQ+2zq9WpS
	 +QYdMDlP5B3aQwZceTWuMC4n7vtSL1j6nFKtAbNLRIiiTann9O9v7gd0ZXxGuRicUV
	 f9YiZk2jpYujIl4CkuujVYzOy05b/rROv8EYBaeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 444/752] ARM: socfpga: select the PL310 erratum 753970 workaround
Date: Wed, 30 Sep 2026 17:25:14 +0200
Message-ID: <20260930152407.889830816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit cfc1e9a543e3589ba200795b6e7fd8ef4314efdf ]

ARCH_INTEL_SOCFPGA selects CACHE_L2X0 and several PL310 erratum
workarounds. The 753970 workaround is still conditioned on PL310, but that
Kconfig symbol no longer exists, so this one selection is always disabled.

Select PL310_ERRATA_753970 directly, consistently with the other PL310
workarounds required by the platform.

Fixes: fbc125afdc50 ("ARM: socfpga: Turn on ARM errata for L2 cache")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-socfpga/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-socfpga/Kconfig b/arch/arm/mach-socfpga/Kconfig
index 594edf9bbea44..d71730951614d 100644
--- a/arch/arm/mach-socfpga/Kconfig
+++ b/arch/arm/mach-socfpga/Kconfig
@@ -17,7 +17,7 @@ menuconfig ARCH_INTEL_SOCFPGA
 	select ARM_ERRATA_775420
 	select PL310_ERRATA_588369
 	select PL310_ERRATA_727915
-	select PL310_ERRATA_753970 if PL310
+	select PL310_ERRATA_753970
 	select PL310_ERRATA_769419
 	select RESET_CONTROLLER
 
-- 
2.53.0



