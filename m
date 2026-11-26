Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705128;
	b=qamQ75X2S3DTBqaFROU8RUttzuQzSBQvkI97fZ+C0BoncDZvYQ00u2jZKfOte85Sb8cH
	 JTvuroklIQbyl7ZwfK6rLQfr8l4Q7MF/8Pxe9S9oR9Z7B+qWbOAfUTkd3kPVb6fwTT/nT
	 cTwTWcAb0RZ/nCDUrp86U4y1yqX4T/xxia4ENlf1VBTJpkrSdMYRVeh+Pvx5EW/lHXMYZ
	 gEsB+WzrSGoufv+QZjgl7K4/6snLeW9Cwk+QgKdlnjeTvfl3yTh1qMpakogmqcUCRJ1zQ
	 CfNJmLPGAhXs7HzgNg5iSt94FUvuUTZkNNcHf7HGWl/90NDhUMOLX/9glZaD062sAlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vt2EvQFntjhyU13fmkl2Du/rMB/TNauR1YG4xwgORjc=;
	b=1udJm45m202bYHm0lI3xENXQYWqOKcwXNdrhkEL++rk9Pfdxmf0YSWbNeLopb/4uT4Ui
	 1kwvNhAUAC50I9QTdAMpo7o2pTMPbxhkEh5nL/i8FVD16byz43gNzbQwCVZwXkmyiAK7U
	 rcWMU6MnfoHS1iA4W51E2t/m41MamXzXLzzcA725PohxyRyQ+3DN45+27Zn6lInm3cCgs
	 ly7LGD2kWicTNxO8Sta8WtQZrSESQWL6sykeD69+qRlZSKd6en5tILR4IEwfuUUxE1upk
	 jZHP560xbVF6C/UfJRuHxwj9i6tn7qiVxX0Knj0fdyXAqufa0R6g8m6RwTIYNKS05kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fKsClbjC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BCF606A31E;
	Thu, 26 Nov 2026 14:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fKsClbjC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79971F000C4;
	Thu, 26 Nov 2026 14:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705127;
	bh=Vt2EvQFntjhyU13fmkl2Du/rMB/TNauR1YG4xwgORjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fKsClbjCaeCxSzJ7vKu12u6C/Rr1Gjp8HSwG38YrWMV3FlygizeikvV8aFi+5HHy0
	 653BKExGh4sLl5ol/cuog3thm/RmXGSnQuW2t/mm8EmN6M44LOMKm2ILRDfkr7Y1si
	 lgroDsKqD1JmwMtYw3BSdceMGxlzytv2KmZcpVj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 093/319] ACPI: scan: Print the offline failure message in acpi_bus_offline()
Date: Thu, 26 Nov 2026 15:37:41 +0100
Message-ID: <20261126144008.843926133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 389457772ded9..05b0b7fbbb740 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -164,8 +164,9 @@ static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
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
@@ -234,7 +235,6 @@ static int acpi_scan_try_to_offline(struct acpi_device *device)
 					 (void **)&errdev);
 
 		if (errdev) {
-			dev_warn(errdev, "Offline failed.\n");
 			acpi_bus_online(handle, 0, NULL, NULL);
 			acpi_walk_namespace(ACPI_TYPE_ANY, handle,
 					    ACPI_UINT32_MAX, acpi_bus_online,
-- 
2.53.0



