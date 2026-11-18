Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041671;
	b=tbcGkq5nZ2HncZpkaW2moloZgas+GVWSyXWa5JTQNhDCA1GS+aiOqFjCioULqEvon1Gm
	 HuYtYNiuVuXfX0SkDQVMEd6bbLWbOxRGDGWw5DzBWryrxvDpMq7ebJF4+AulFROAVkMhP
	 B2Uinae8033YqBx4C0DlStdwnHOGVfcOBrkuh0Khre6ToHwDDe5Ma1uCUZJIvJ9ZAepki
	 s8qQiVXl7DLdh2ahJ4j2w4HT90YkZ8Z024zjjnjLkyMk3eaf7Ku+6IsLF9wTG/u84WI9z
	 9Cw9ufo2WZ6bihOibm/ddqukJQXqueApwtZuClB48QOtb3QjP74iGiQZ0t5Uy+i1G5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tBc07jiFMzKYuo4QnBkbl6GxfrCMaARGLicichAs+Uk=;
	b=m4urZOvDqBx8DwDqWKS4B0A1+XeGno4lyeY0CPzU+TZLzQajFigZoGJRvUOoBO4AktPo
	 Im3fEwO7+sE6Ogr1SjnGaMJBN8JMsTfP2GNiPHqoMm8P32VsVCryAK3gpYVLn0+/GWx5J
	 FMepv0ViLnfHTreyKljwMLdXvJ6IFP5MmsWrPpqGEMdSGa05XysB+/38OXXNMxosGbMIK
	 ZfIZkUYXXk2iyDqzOHG57dYTK2FZPp4ktP5BaZ0Kr0kJjXsA3+nqOpdspuiuckgB/gpPX
	 sYtsvMMpKF3d5qdXZ+VD9Ei6Jki5TTNyauU+W1Cz/w2aEftOe3ia2h67/nQ2neOHmHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhmx4Am5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C552E606A320;
	Wed, 18 Nov 2026 22:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhmx4Am5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D171F000C5;
	Wed, 18 Nov 2026 22:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041671;
	bh=tBc07jiFMzKYuo4QnBkbl6GxfrCMaARGLicichAs+Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhmx4Am5jijyojnTHDW2bGRchTJub8CasJhufsvpilBc6NtGAg6l7hdZ8TJjCbbYZ
	 fjr+2dZ/nO9U1ZtuVTAaKLWllf352NcaeyW8ZQrTfxDvIIkqQ3WNvXK6+EfUEmtE1r
	 ofAVA1JwSvurVxOCYsApH7YnkWO/jj3KMZlm549A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2845/3318] thermal: ti-soc-thermal: Fix the return value in ti_bandgap_get_sensor_data() kernel-doc
Date: Wed, 18 Nov 2026 15:57:47 +0100
Message-ID: <20261118150445.959600948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 84f8258c11dcb..8655252077fbc 100644
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



