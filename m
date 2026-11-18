Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061651;
	b=es55RiGDmfrg1CdIBc+0l6jdTQwO/bMSWnpkvmmrkTCcSSD6n3dJ4+LJToHI6Bbc1UoH
	 7BiXw6UV8Q8UdHqm2RA0McXYdQhcoNABgDr5Y2WDK+sUKmjFdinDwsuUXuBRy2aXwVT0p
	 dPOoDOBWk2VUHY71jcxYsN7v3hXz6BcaiQkVJ1NDqu0esCWC48XYQTXrDCA4xc0wYvQYu
	 W84L+sdoN+DZJt9UiPh7HYrSRi/PPuUz+tn6DgGUzZTH2Qjs5Fq0LmEJHPWAqKhMBY+xd
	 M11AvfWfgsy6KVanXugkjKCQjLrFR9pFwomqlxgfd9I3cNk7BH6UDTObQFVKJnNrIrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XDpjRYBd4VX7Dm74uen8DtgLotbveLuCpbARYHR7DUM=;
	b=1IzStuuUUK8uHh0XCHTmxMa4FJcPqlARmUBt6L6SiYBfuHB0WYGJccRVSwqY8297vsLx
	 09Za5EZ80VOO7keZW/cokOK9QVbhEExeVnXYK0J/2O6mb5xbW/N/DwauH5sENdLm7MGaQ
	 iuUiOGyzdCTjo/e0PNkqssZkVR334u9eIYSTP1gXchSeeo/jawN42Vs8qtqdiOCdy5kqV
	 2Zjdtd6AhnTU6jQJppNw9ZYgMToP8hDffj4OlL9GCyTZfj1XtXL7gr1v/6gyv4uOEd9ex
	 xB4g4Fo0laeCM+gVMyfdAHWlEqq6rcPGQtj1pjapB/rcrS0FZ1gxaqs6G7YuNV2RvAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=arbu1bG4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D16606A325;
	Thu, 19 Nov 2026 04:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=arbu1bG4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BD41F000C5;
	Thu, 19 Nov 2026 04:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061651;
	bh=XDpjRYBd4VX7Dm74uen8DtgLotbveLuCpbARYHR7DUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arbu1bG4b8OMfrU4orLXhJYsd/jxMiuwlObGUJL5yPeEvt4jZHARipwJGej/o9z4H
	 /Rm7dX90EgZuB49ZKDkfJ5uxdxZwCkORY/s0N0lMN7jzWxaSpWeTxGJJHXtIy26SeI
	 ckLeNRA7aBJYbyVvJCvPlWzDeFd6FB+zp7j8zr5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1628/1848] thermal: ti-soc-thermal: Fix the return value in ti_bandgap_get_sensor_data() kernel-doc
Date: Wed, 18 Nov 2026 16:01:06 +0100
Message-ID: <20261118150027.713520448@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 82bb005cd9cf5a9df4cfe4a52db90346ac5fd17a ]

ti_bandgap_get_sensor_data() returns an ERR_PTR() if the bandgap
instance or sensor ID is invalid. Otherwise it returns the stored sensor
data, which can be NULL if no data has been set or the stored value has
been cleared.

This mismatch was already present in omap_bandgap_get_sensor_data() when
the driver was introduced in staging.

Document the validation errors while retaining NULL as a possible stored
value.

Fixes: 8feaf0ce1a04 ("staging: OMAP4+: thermal: introduce bandgap temperature sensor")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260912062252.42762-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/ti-soc-thermal/ti-bandgap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 24aa2160d2a6c..0df9abec524b1 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -576,7 +576,8 @@ int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data)
  * @bgp: pointer to bandgap instance
  * @id: sensor id
  *
- * Return: data stored by set function with sensor id on success or NULL
+ * Return: the stored sensor data, which may be %NULL, or an ERR_PTR()
+ * if @bgp or @id is invalid.
  */
 void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id)
 {
-- 
2.53.0



