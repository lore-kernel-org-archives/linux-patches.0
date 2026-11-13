Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585929;
	b=texMy48q4IvxGt1MLvPejQL0f3gM65GSxD9n+7qIRSU5ozV71m48pcDCaKAYm/2uYEzD
	 Ds6B+CPFX8FKXRrSfZC4gC01zs4MyKYeibBfIGQM3NHHO65O4GAAzjPhrdxQREiIGu6Rp
	 dyHv2eiUM3bbfOu+95WiyjUfYWQilRevEAew9sFO+lS5hxWwrIFk3w7USc+L69fkrpeMs
	 DfvtUAxucjUNi5V1UKwuxt+5r2r26TV08wMTSuFrGz15asfW1V9Umk3Je6vHo5lpM1jlf
	 YjyNhmSvB9ywVDdoWW+F9PmnwsPdZnXU3jYo0r4MBXYJXqaA1gUQKJhrdtSL4f6Hwvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jv7bqP6TcswAOOJoMyWb5HvE6wM1fxK7PeQ8/yjt8yc=;
	b=vEeS006MaXmufXNbRfej7kS4xiUuOTXLxhYk4Ews+VEzLV4drRW9lWlfB2x22jMPcsV3
	 6JBuIOrH1bIJsg7a1C5xbXlIMp3UdNKqzu3coPKx5HNEAwK7dLxtn+ZbICQDFo5T38Vjr
	 QEjuVvFaqpt9E30z2hwA+VUfrZ49KPvUsfbGlV82haumrtHIMSC/eH/90ebE+b79r/jps
	 /pPE3hh+ymLN8hBnErPHJlrI0MWkhlhBQTOGVf9k7YcXpg62fQh8/baP75yXKap6N+k8r
	 DSf8hlvAsLEjHRHM1+56El2s6cAy+OClP28ILaJgwaPpt5kSw3xQ38FbFrYfv54oiZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HlHm256x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBFF6070235;
	Fri, 13 Nov 2026 16:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HlHm256x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A9C1F000C5;
	Fri, 13 Nov 2026 16:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585928;
	bh=Jv7bqP6TcswAOOJoMyWb5HvE6wM1fxK7PeQ8/yjt8yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HlHm256xQvNdspdNG8SJk6kiWWi/fK54yWxUFpHzIFAYJd5Q004vugFlxsifXlgdq
	 bvgpaKgQQXs6eo2zZSJ9gFgKExO2WYC46EMGJ+y3t/SmwOTwgvyj5AH0iJSdOqwW9R
	 U8NmEBcsWWiC6meMVhOhrxdVINR2efEjEtQ/TYzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 487/507] PCI: cadence: Preserve all error codes in cdns_plat_pcie_probe()
Date: Fri, 13 Nov 2026 10:53:11 -0500
Message-ID: <20261113153813.582720709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit fe108800a865b268eec103e4940c248c85a86e9f ]

The blamed commit functionally changed the error path of
cdns_pcie_host_probe(), now cdns_plat_pcie_probe().

When the old code path executed "goto err_get_sync", the PCIe controller
probe function propagated the pm_runtime_get_sync() error code. The new
code doesn't, and returns 0.

Similarly for the "goto err_init" previously triggered by
cdns_pcie_host_init() errors, and now triggered by
cdns_pcie_host_setup() and cdns_pcie_ep_setup() errors. These are not
propagated and will result in probing success, which is incorrect.

Fixes: bd22885aa188 ("PCI: cadence: Refactor driver to use as a core library")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260810124315.433448-2-vladimir.oltean@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pcie-cadence-plat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-plat.c b/drivers/pci/controller/cadence/pcie-cadence-plat.c
index abda260543c8b..4a24302cc5b2c 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-plat.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-plat.c
@@ -111,7 +111,7 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
 	pm_runtime_disable(dev);
 	cdns_pcie_disable_phy(pcie);
 
-	return 0;
+	return ret;
 }
 
 static void cdns_plat_pcie_shutdown(struct platform_device *pdev)
-- 
2.53.0



