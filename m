Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7175C39A7FD;
	Tue, 21 Jul 2026 19:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661199; cv=none; b=JXj78IXHyc5DqiplTRebf1HJWBK1jMkQkXC5oGPrLYMfKvnpvknDO3c5uui/5K5jZ3fmkPTL9k/QtwcC1DjBWynZbpfx3aPIcn2SPOuHFCGqTkbHTnD+htB1gdea3g3mfE7gAj8aqo/cGAkOKASkIOWYv1e2o9bdJIyTuO705hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661199; c=relaxed/simple;
	bh=x+BKBDBUL6fg+6dYGBiUhVYeGD46wCOlWNVPbg+RmsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsHC47q0xmnzn/r+VGDQH+Cf7DIhnQ71hnXeBuxYv2/mrWSHEfehjwf62k3BCYTZH+g7PNX+bby3FZmEx30OiprpkyY5pcMKe5Lp0KIWbts0dhC9gakhIIivYUSiNVcETQUmzMm6DMFnvUlWqy7QTJy95USc/EA28V6y5DPaqvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vx4lz+nl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vx4lz+nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3321F000E9;
	Tue, 21 Jul 2026 19:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661198;
	bh=tXpvLceE/TqayfgWxPzlMEfzXsTLmMQ91bJLaXocWmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vx4lz+nl5fWek+t3Tomx5QuZ39SvtCkVECaN9Ieeh4I5sUvRq90gReaPRprpFgetC
	 7HQpurxwMuSCzf9EV3cdEvuMxkMgRQBJhWOwLb5sPOg7udmx3AVCxMr6aqFellXuRM
	 mq7YwLwCg98Yq47W08MvA1VDTJ0CEE3QDUdgmL9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1268/2077] ACPICA: Unbreak tools build after switching over to strscpy_pad()
Date: Tue, 21 Jul 2026 17:15:41 +0200
Message-ID: <20260721152622.726914039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 292db66afd20dd0b7a3c9a3dad9b864a64c8bddf ]

Commit 97f7d3f9c9ac ("ACPICA: Replace strncpy() with strscpy_pad() in
acpi_ut_safe_strncpy()") switched over the ACPICA code in the kernel to
using strscpy_pad() instead of a combination of strncpy() and manual
NUL-termination of the destination string, but it overlooked the fact
that tools also use the code in question and strscpy_pad() is not
defined in those builds.

Address that by using the original ACPICA code in non-kernel builds.

Fixes: 97f7d3f9c9ac ("ACPICA: Replace strncpy() with strscpy_pad() in acpi_ut_safe_strncpy()")
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Closes: https://lore.kernel.org/all/79e9e913-0fb1-4110-804b-c3b5d0edafe4@kernel
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Kees Cook <kees@kernel.org>
[ rjw: Fixed up the number of added code lines ]
Link: https://patch.msgid.link/12923581.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/utnonansi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/acpica/utnonansi.c b/drivers/acpi/acpica/utnonansi.c
index 3a7952be654579..93867ad7f3421f 100644
--- a/drivers/acpi/acpica/utnonansi.c
+++ b/drivers/acpi/acpica/utnonansi.c
@@ -168,7 +168,16 @@ void acpi_ut_safe_strncpy(char *dest, char *source, acpi_size dest_size)
 {
 	/* Always terminate destination string */
 
+#ifdef __KERNEL__
 	strscpy_pad(dest, source, dest_size);
+#else
+	/*
+	 * strscpy_pad() is not defined in ACPICA tools builds, so use strncpy()
+	 * and directly NUL-terminate the destination string in that case.
+	 */
+	strncpy(dest, source, dest_size);
+	dest[dest_size - 1] = 0;
+#endif
 }
 
 #endif
-- 
2.53.0



