Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064686;
	b=v0MgtJpc7UeXwfK0eMZBR7WFDFGely/BXq6k2KjlrbLSDi2GdK57jnQGribgNwbdJiUn
	 KgoIvih40BnqUSbnVaHxYknNOKnKKfAEZpycTbLV5ELKitwaZQ+84YjFpm+kt0bS8GKfB
	 JsPhnhP8xIPKIL3D2dq/Ek2BsAdO4JYKjMb4dO80lfQakZQ9gwvRUvY/XbT0s69qEE8Ok
	 D0UOdgCNrrHMk0Hc+K6mt5OmEMmwkV1Y9+N7ir4ctSI8DTlMCNxVEWM0oR/J6nroguCLo
	 2+KmkTbd9cOqbbyAIPd07F6OnT2SZWOi8STsWZuAMNEI8GQLc/4PHUMCHr7eRWfMuFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9Yqy8ekK09FcHpV5vexjgKC2dVXxxZ8EvTPdzDM4V6k=;
	b=p4GqYKZJGUIgT++I5hwJp/8uAMuBx+LGUT3KXYlI22X2BfoKgquhorlEkjmx4pvHV6qc
	 jxsRKPi43lNRuccQnAwobPoK9NwyLj7hknhapF0QZeeB/nzR9Z+3N9rzN8rPe8ymaqZdh
	 nRtGiI0Xs70gWBxzrvLrspFSLfXyzxTDakaotVbGY9afSBthWH+c+aLy1zRUieB1Watyh
	 Eb5PD/0A8rIQ/4L1d0Cr8dAEvChl5mhMa7zPmgNn7NWRX3OUEbw6ZNlEifptU+iQhRg0v
	 IR8UADKVJuPQe59PHRgDpyOHtht4KS82iRh1qvr2gkjo7Q7gxTVd2+pW5jNXliXnlhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p35dDcBt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C186606B8AE;
	Sat,  7 Nov 2026 15:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p35dDcBt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDF41F0089F;
	Sat,  7 Nov 2026 15:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064685;
	bh=9Yqy8ekK09FcHpV5vexjgKC2dVXxxZ8EvTPdzDM4V6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p35dDcBt+SSOONU4U/u2LZYO38VqAi9UDlnoLzs0eWjxVedJvVNUjT1My6cjyZrmZ
	 4JuabnyXew0i3s84RBARmH/JgaIYzSxHlfnFMzHyMRFMGW7cVLaOQQtJSeq3uY4P8Y
	 S61DwHwVzXXx2s2MgwkiVOkftgapIkuDJmB5pOeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0680/1257] platform/x86/intel/vsec: Fix inverted walk_header() test in get_features()
Date: Sat,  7 Nov 2026 08:49:36 -0500
Message-ID: <20261107134958.047023333@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit 3678e39c6aaeb9aa380c7357b24f7d55955543f8 ]

intel_vsec_walk_header() used to return a bool that was true when devices
were found. It was converted to return 0 on success and a negative errno
on failure, but the boolean test in intel_vsec_get_features() was left
unchanged, so its meaning is now inverted.

A successful walk returns 0 and leaves found set to false, while a failed
walk returns an error that evaluates to true. When no other capabilities
are present, intel_vsec_pci_init() then returns -ENODEV even though the
auxiliary devices were created, and the driver core tears them back down.

This affects platforms that have no DVSEC or VSEC capabilities and
describe their features through device_data instead, which today means
DG1. Test the return value for success explicitly.

Fixes: a6ce8bf3c993 ("platform/x86/intel/vsec: Return real error codes from registration path")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://patch.msgid.link/20261001220351.1592138-3-david.e.box@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 5ab2215fdd7fa..7d51f27f09bc9 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -641,7 +641,7 @@ static bool intel_vsec_get_features(struct pci_dev *pdev,
 		found = true;
 
 	if (info && (info->quirks & VSEC_QUIRK_NO_DVSEC) &&
-	    intel_vsec_walk_header(&pdev->dev, info))
+	    !intel_vsec_walk_header(&pdev->dev, info))
 		found = true;
 
 	return found;
-- 
2.53.0



