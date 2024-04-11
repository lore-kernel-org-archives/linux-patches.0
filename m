Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D83079FD;
	Thu, 11 Apr 2024 10:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832650; cv=none; b=YhIw71acY0tommtFL3MKGnq00PKssmNwy0jBp0ULbUHA6x5afwojJGYRYGkCrnP9oGLI2AfrGy5tUf85wYKYBIXu221ZKhruCSg6PYJUMdQPgbgMmOXRto3IPTB90EsQRAk0X5hQZTNtdun1bWkCnaLK/Vq98VWWCZfpMB0nVe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832650; c=relaxed/simple;
	bh=Oavl+aukklXJUEE9tfjr1UXq38hFGyBY4LDvL9CGCAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UgDZNctPM8ys3whR4QMvJbUIVKQn/0Dkpz4M6eWkySsvHHJDqVAzQ7klNlkHAbwTJVdEphtUJN6yVp5Gi6QEFfWLQfnkFOn2gcFI+w68rw/aza/Qsl2AWftDsmotdCCxbjWJ8e1voMJlJBUR0y/oF14ICRlpouT6SlFqJr+/g/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkC+4tYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkC+4tYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9905EC43390;
	Thu, 11 Apr 2024 10:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832650;
	bh=Oavl+aukklXJUEE9tfjr1UXq38hFGyBY4LDvL9CGCAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkC+4tYZ98+AXT3HDP26fjNgRZsbMJ/HAsg0B1hQY3tgZE77IVJPGK6X9I4CeyCS/
	 JqgBcAgXRS79BNTVcMnFPf6M6sp5ZXq1h2jJN1vLpfV5D/wbzwumTxNAnqQCiYQkkh
	 6vJlnQmyX/dClx0tfNIx6lC3lF0ogJSAaxZ3mfps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alban=20Boy=C3=A9?= <alban.boye@protonmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/57] platform/x86: touchscreen_dmi: Add an extra entry for a variant of the Chuwi Vi8 tablet
Date: Thu, 11 Apr 2024 11:57:44 +0200
Message-ID: <20240411095409.086043464@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Boyé <alban.boye@protonmail.com>

[ Upstream commit 1266e2efb7512dbf20eac820ca2ed34de6b1c3e7 ]

Signed-off-by: Alban Boyé <alban.boye@protonmail.com>
Link: https://lore.kernel.org/r/20240227223919.11587-1-alban.boye@protonmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 08a9b802be712..161bd19441042 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1153,6 +1153,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VERSION, "CHUWI.D86JLBNR"),
 		},
 	},
+	{
+		/* Chuwi Vi8 dual-boot (CWI506) */
+		.driver_data = (void *)&chuwi_vi8_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "i86"),
+			DMI_MATCH(DMI_BIOS_VERSION, "CHUWI2.D86JHBNR02"),
+		},
+	},
 	{
 		/* Chuwi Vi8 Plus (CWI519) */
 		.driver_data = (void *)&chuwi_vi8_plus_data,
-- 
2.43.0



