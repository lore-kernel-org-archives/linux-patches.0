Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016318;
	b=ymyLda3/J9YlGRhaXi/w0tOvovc2EJdNUyr6dIAEgJCW86Nj54nQvTwrO5RyzsTeByF9
	 2G3NyOxTDwafuXUBhnksMiG5uRl0emJY/77dYK2BCS4oPqZWqnnhvdOjMmhwAu1pXYW5u
	 WsHQoSrn+x2EqnVTYTNCph/AWE2QdnVBD79rlqe5fF+QzyhnTzbW7HcS5ZazQ+x3zuZS7
	 7Lfo5UVENg6g168w7VTrvduSPIkoQf4meZiKHFKp0EVvB1V+aoAUjauF+MQQZ48+bvLg0
	 wx0i9FdVPVyYNSvgdCBizBTC+vt+s+7qniU3Bp6ktlX2NZCnysSvBm7KxsI+EF907+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nkgXAjniqhq9fVRafsP/tauONyRC+1VuEWwTFfPSuQA=;
	b=hVo/tOEwPdY6RiCwPEm1OkJ1sspwnKAz/1skDAIP5FeyW+Qm84UtNlsOFN0s+VEFRC5i
	 BNlodsRUaoNh2qOTZKrPw+nb5UxJ5SFDMCZupOOIXzobA/sp4p5LJJIlOZZ/PdPDstEtI
	 jRZbUO8olgdphHD6Uf9qA9srxDjJ0MdV4P5ONB0G+SxZ/pzNoPABckCVGS+ZAxvH6Qx/e
	 1SVnRTayoIaBVIN6iAkSC2kxAm9KwUnjuh3j6Ny3JJXSaNKNpH1TIgEsSRICMUe8jj4nE
	 wk8vfz6xAEAEaVf3gT8V2soyNzK9c6NXvw71RLHbakj7AE7LOldDTmo77ORNXXBLNqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iTHlUnvY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EEE60A261D;
	Wed, 18 Nov 2026 15:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iTHlUnvY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E5D1F000C4;
	Wed, 18 Nov 2026 15:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016317;
	bh=nkgXAjniqhq9fVRafsP/tauONyRC+1VuEWwTFfPSuQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTHlUnvYA1aOA3fKoR+5Q6uwP54nBHZmIPYrJ0SXhKHk8FktYgOeKzZrv9WsOoNZA
	 HqxO8k0kYPeajiei+VjWuA8FaObjblp0qi7BsoGd+02oNq85GXRdWVwnOnEAkewznx
	 4dG+hwmfoJOWKxTGjCwLFAEeJI8BxrZQJWbHolvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0487/2651] platform/x86: Add ACPI_COMPANION() NULL check in topstar_acpi_probe
Date: Wed, 18 Nov 2026 15:28:47 +0100
Message-ID: <20261118150305.312411387@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit 17d0f874b1f8774c61ad495a4ad20ed8c829dfae ]

Add NULL check for ACPI_COMPANION() in topstar_acpi_probe() to prevent
NULL pointer dereference when driver_override matches a device without
ACPI companion.

Fixes: 3471415c8186 ("platform/x86: topstar-laptop: Convert ACPI driver to a platform one")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/20260811022115.338595-1-luoxueqin@kylinos.cn
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/topstar-laptop.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/topstar-laptop.c b/drivers/platform/x86/topstar-laptop.c
index 0e842c55dcc52..730a599abf0f7 100644
--- a/drivers/platform/x86/topstar-laptop.c
+++ b/drivers/platform/x86/topstar-laptop.c
@@ -287,10 +287,14 @@ static const struct dmi_system_id topstar_dmi_ids[] = {
 
 static int topstar_acpi_probe(struct platform_device *pdev)
 {
-	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
+	struct acpi_device *device;
 	struct topstar_laptop *topstar;
 	int err;
 
+	device = ACPI_COMPANION(&pdev->dev);
+	if (!device)
+		return -ENODEV;
+
 	dmi_check_system(topstar_dmi_ids);
 
 	topstar = kzalloc_obj(struct topstar_laptop);
-- 
2.53.0



