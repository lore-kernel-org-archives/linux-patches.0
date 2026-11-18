Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016721;
	b=osnR9HBABJXGGTp3MgDouvjcsJLKL6SNfHxFDL1pucJKQllyerlB2c2Qkys0vr53TPS+
	 6RxJFBXYZy/i0GqxoDtDaI1UbHZssJfm12UsjELm/XlIMdIsekjtbltBcL/GwT2L0JEMg
	 fhzMMbHoEU8zAP77Nu8zhAIT9y9uoLMgpfuWX5WM5G43DlEBsXWH5FoZSId841J+IANZl
	 4VF3fw9Fusw/wdQ+cqIFuwA9tmzdyHRHHHbSb61xgagdESaa5+JlupRetDMs83wjrT5P2
	 lD6nho0i0+CmbacpgE5ZI6D81tLWt4EYKPQbiII/Ii2S0zg/e+ZyD/rqjCr+UApaBrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HD8RhFND9YDB6HKNxkLWA1Yq+JGekEv4pBSef8ocl1w=;
	b=ogX1mRHjUhNaHjvx24x/N6PPjHu5+MymvBfF5MxAb9UYQchEXBvztPXPUWK5vauhv7LK
	 1zDjf5mi5MxmgfBcGi8omk+el4Lk/Lr1M47MMS2QaktAvl0ufce+a8s+G46zlXqhrZTG7
	 KzkVSQqLgueO9R9m7gQzsGRNNeye8LglRQW2TwNqitrwuCtOdh+DVWwq8LqCUUoSAY+jn
	 zvCEaRXlNdcEwBwheAwb30zb6MpOUx7VQPJynkEco9jahE9IBF9/4o4Hn83NlTGXfrdvr
	 khtySinNce1ryAykVahZ2zAhZvFQ8EA+hyJsObb/IOAPy9ckfn9LsQL2t70l4cx2itg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2dlM6aGd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90507606A33D;
	Wed, 18 Nov 2026 15:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2dlM6aGd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5A81F000C4;
	Wed, 18 Nov 2026 15:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016721;
	bh=HD8RhFND9YDB6HKNxkLWA1Yq+JGekEv4pBSef8ocl1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2dlM6aGd2sD7Wm5dhEMUX95PaJ3rH6nU3oZjMMMMNsGEkfZ9EV9kXamG/9GZI6HNO
	 qNGkkUycLrElQboYf9SmquXk/A1lxw66F0SQikgbgSdLn1VnGdF0UwC3lXjDKTFX/C
	 Gou4QcVTiDe7hmpJC/RpOXx0EtCzOqlhp1ErEJI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Alejandro Lucero <alucerop@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0629/2651] sfc: fix CONFIG_CXL_MEM dependency
Date: Wed, 18 Nov 2026 15:31:09 +0100
Message-ID: <20261118150310.333530958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c6219deaee41bf35f7f04073f9ef99609d58bba4 ]

A recent patch introduced a call to devm_cxl_probe_mem(), which is only
available when CXL_MEM is enabled. If CXL_MEM is in a loadable module,
this causes a link failure for a builtin driver:

s390-linux-ld: drivers/net/ethernet/sfc/efx_cxl.o: in function `efx_cxl_init':
efx_cxl.c:(.text+0x156): undefined reference to `devm_cxl_probe_mem'

Adapt the dependency to require CXL_MEM instead of CXL_BUS, which
we know is available when CXL_MEM is.

Fixes: 0418860ef2ca ("sfc: obtain and map cxl range using devm_cxl_probe_mem")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Alejandro Lucero <alucerop@amd.com>
Link: https://patch.msgid.link/20260917155519.2121486-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index 979f2801e2a8e..e2898ec2e6e92 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -68,7 +68,7 @@ config SFC_MCDI_LOGGING
 	  a sysfs file 'mcdi_logging' under the PCI device.
 config SFC_CXL
 	bool "Solarflare SFC9100-family CXL support"
-	depends on SFC && CXL_BUS >= SFC
+	depends on SFC && CXL_MEM >= SFC
 	default SFC
 	help
 	  This enables SFC CXL support if the kernel is configuring CXL for
-- 
2.53.0



