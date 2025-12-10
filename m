Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713E727FB2E;
	Wed, 10 Dec 2025 07:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352063; cv=none; b=MqcSQtNv8DzbxbQizSFNojz76ZEEOiN+e1lGOCLZyREpoZymbsS/qmZylD+k3+omC2OfztFTWm3nO8aVQwpTwwbxve0ki+j/5cQsKor50zbGw//kZZQ5FXG5C0OdnXXD5M9HzF9ia+lMTE905z4k0TLINqR26gMb9/w+xLEkR0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352063; c=relaxed/simple;
	bh=H4JkXgK5DNhb84wfkk4yq8WwJfgvCsOQX+avdPa6HdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ukvfqCxQu4kTDYeUtcAkeg9wJV6vtY8vvnTWy1piYGQCkoIeoa+iVLu1fnPThNb7uwZkxPsm/e6oe1vUSP2KdWuzZe8f9H5LYGrjW+VBWHWakZTNgDcK8ROB51MCYON7ntgvjK6pzAWA2GzxwwgEVKTICH/hUUpJPLh/3WWtd18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrjVLtgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrjVLtgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C571CC4CEF1;
	Wed, 10 Dec 2025 07:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352063;
	bh=H4JkXgK5DNhb84wfkk4yq8WwJfgvCsOQX+avdPa6HdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrjVLtgGcOzFiFCg80nl75TlGp6nkYwv+aSysn4bjmdLIWEo8AgAGKKaQaxCayEk1
	 lIKhjPmP9eVeBmDHx8AXwSMJglom2qz9pbS+YtfMKrHmVea2J9y0B6L1zI0qR2+LPJ
	 m4MS6UcgqeWuoPsOqnPN+8IgNPOw4B63nSlbQu7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 35/60] platform/x86: hp-wmi: mark Victus 16-r0 and 16-s0 for victus_s fan and thermal profile support
Date: Wed, 10 Dec 2025 16:30:05 +0900
Message-ID: <20251210072948.725649051@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edip Hazuri <edip@medip.dev>

[ Upstream commit 54afb047cd7eb40149f3fc42d69fd4ddde2be9f0 ]

This patch adds Victus 16-r0 (8bbe) and Victus 16-s0(8bd4, 8bd5) laptop
DMI board name into existing list

Signed-off-by: Edip Hazuri <edip@medip.dev>
Link: https://patch.msgid.link/20251015181042.23961-3-edip@medip.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 8b3533d6ba091..9a668e2587952 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -92,8 +92,9 @@ static const char * const victus_thermal_profile_boards[] = {
 	"8A25"
 };
 
-/* DMI Board names of Victus 16-r1000 and Victus 16-s1000 laptops */
+/* DMI Board names of Victus 16-r and Victus 16-s laptops */
 static const char * const victus_s_thermal_profile_boards[] = {
+	"8BBE", "8BD4", "8BD5",
 	"8C99", "8C9C"
 };
 
-- 
2.51.0



