Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621696;
	b=nERhkXyHEyIKi2/g5/QyCCW9OpZi+oB97QC07OZjVZN832m8XZ+Kgj6y+UYNZQ7HHaOF
	 N2gFEmDIMd/D4KS85m+EeBm1GZm+SV4DjnMqDlS6rMmxAA5JLS0FwLaPJ8ePuaI1bP10E
	 hHqkwiFDdrFh7u1VNQODKtWPU/zUJu2wBkIeaaA0UuGf8x2/nHna2zS/34URM1PzNVNrE
	 +DDKS2sXbS7UQLFDXGN5qP1MCF93ETJemrAExuIpRhoENs1f1qAoQyBAT7rQQlwY2B/fJ
	 dwKFzW2JsWmoMu5k6uXJGfyN88iaHo6pQhpGb/UraR27E7rVHrnHtCJgYYuVPMdarfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pgx3GaCWipigFlxxz3RExy37Wqlm2zmNsHLG2rkOY6M=;
	b=2W5qex9Nccb2vBLN5nVlJ9W/NerCFm62DkgLpW64eywT2wiGLqL0rpQ/s9Vo2Nl0rzNg
	 IH7q/uCVQBkSLY+RGK3YR/kFnWk1qzz1SPPcWD4EcoP595W0NtL3LEMJVVQL9EgZrHLI5
	 vqym/YXUaBVExxMItEBRai3wfMsc/G22IqAo6vj6ipH8AVhNiDbzlAR8pVWI5yqbsYcJR
	 R/zysCGyYe31m3ksjnjo0Em38KB4BP4znIOZRvLowKIZdfyY9I43ECs2rfQpeB+WdOzvB
	 Cjj6INToAAq0u7D3/08BIZoVNWlsTZijl8T09g0xVge3Cx95FovRZHl4Q2l+CYRVqOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vQUplfKY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B03606A33F;
	Wed, 25 Nov 2026 15:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vQUplfKY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665F21F000C4;
	Wed, 25 Nov 2026 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621695;
	bh=Pgx3GaCWipigFlxxz3RExy37Wqlm2zmNsHLG2rkOY6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQUplfKYSZ2fiovz1kGyqa1l1+l/GIoEfmDwC+pSG04/7IBAbJCE/KtNW7+B/qrNZ
	 TYdCTF1JczJoUK5mAQCT+axyeXktgLGRXhWWEdpr5gwgSOTIj/ggqhku4wjdTzXqpr
	 ufsCiOeb3jC0rbpWUpisJpcEBodUTGZ+M6acfhPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 262/990] ACPI: scan: Print the offline failure message in acpi_bus_offline()
Date: Wed, 25 Nov 2026 15:27:09 +0100
Message-ID: <20261125143828.230777347@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit b9ea1e921c2721546f53270cffdc6866e20576dd ]

When a physical node of an ACPI device being hot-removed cannot be
offlined, acpi_bus_offline() passes the physical device back to
acpi_scan_try_to_offline() through ret_p and the latter prints
"Offline failed." for it after the namespace walk.  By then
physical_node_lock is not held anymore, so the device may have been
unbound from its ACPI companion and freed in the meantime.

Print the message in acpi_bus_offline() when device_offline() fails in
the second pass, while physical_node_lock keeps the device bound to its
ACPI companion and so the reference taken by acpi_bind_one() is still
held.  acpi_scan_try_to_offline() only needs to know that something
could not be offlined, so pass the ACPI device back through ret_p
instead, like in the "Offline disabled." case.

Fixes: 303bfdb1a14d ("ACPI / scan: Add second pass of companion offlining to hot-remove code")
Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261029034507.2721580-2-sashal@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 3893e44005f40..e4bca03a4e476 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -165,8 +165,9 @@ static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
 		if (ret >= 0) {
 			pn->put_online = !ret;
 		} else {
-			*ret_p = pn->dev;
+			*ret_p = &device->dev;
 			if (second_pass) {
+				dev_warn(pn->dev, "Offline failed.\n");
 				status = AE_ERROR;
 				break;
 			}
@@ -235,7 +236,6 @@ static int acpi_scan_try_to_offline(struct acpi_device *device)
 					 (void **)&errdev);
 
 		if (errdev) {
-			dev_warn(errdev, "Offline failed.\n");
 			acpi_bus_online(handle, 0, NULL, NULL);
 			acpi_walk_namespace(ACPI_TYPE_ANY, handle,
 					    ACPI_UINT32_MAX, acpi_bus_online,
-- 
2.53.0



