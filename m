Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020101;
	b=SbZs5BaG5BP2l6LT+kCiK9kHSjm8x6S9NUHY699/xHiijJk+tElR+P4FIb6YsSsE7i1O
	 M1WBrpw8aGRxkl9iNY0rdegyAQQpmEXFw7kUgONNVEW6AjVPgbWakO2duePWp8so1E08A
	 XhXhZoAKIucVb3L6d7z5qn5GH+kaka0JibzAqQYXcJXejIsZaT0L5mzg1uCnpwxzlc/8g
	 hrqeCljne1eb+1+kOD2I5eJbfylsPee8jsYTBZ1bmp4N6d1lrI5GV7eBycpM6GddqpJ9M
	 jfnRr2QU1UAyy/IznKhdHkt+Pu9Yw++avj+aekrW1uxRqVKrcOYnC1qNCJmTPqJoN/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p4W7Ce89aI+rMa9mPi792xzaliSNZds7xKgrGFaqCYE=;
	b=4UTdNK/ti/+Kdabkv5DJ4fEiqnLmuWhTu5Ol4WsI+6hSPMZ/tAel/MInKqG24skMWY7u
	 qQzEfmylZCm47wnokHt+WtoMSTgwH2EqhSSX28/I6XGjS6OnYBtd+nCxVH9loKQ7LF3Gy
	 q/S9C+RLFTOHKc+77Rdp5D9HpfTrrBf9fzCOXmP9zY6Ecp01s67JeJe1Bc6OO02Qpf2Qx
	 cJWvuDZYO/wzlpyg+mYy6P5e84el9fmjlQEbJ95E24ULeEGToV/lHVWq0XW311n3NYqyj
	 mz5ofcNNdf9H1yo9p9XRf9ls8JLyh5zsPHili/UXAbd2fsufS+kEbDwfjM0MtyMBodg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGQk6GnD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6A0606A31C;
	Wed, 18 Nov 2026 16:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGQk6GnD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E811F000C4;
	Wed, 18 Nov 2026 16:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020101;
	bh=p4W7Ce89aI+rMa9mPi792xzaliSNZds7xKgrGFaqCYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGQk6GnDdsIMrP1mPNRxuNuabk7L/O5nnzFDvOLp6Tyj5P8cL5xjXJ90m0jnJKPAh
	 /OOwVt/KDTADHZyClHSBNBNaJyyg/PG1inX5mTcTZszBednPeni1VH1Q0m3pYmXDbO
	 I1O8yW8TgdOYQJJe+Lzxd3cTyLWvkW3GearC9hko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1830/2651] thermal: ti-soc-thermal: Fix the return value in ti_bandgap_get_sensor_data() kernel-doc
Date: Wed, 18 Nov 2026 15:51:10 +0100
Message-ID: <20261118150353.010630791@linuxfoundation.org>
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
index 507fe67eaffae..815ca0786c545 100644
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



