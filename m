Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059565;
	b=x+dUtGidT42omk5Zzf/u2TAYqxc5n8VThIkl4SHLJEZW1iivLyq7jQiAu8+vPo1LnhML
	 gJKNaXczjbZqhifGW6mm4ddhrqfxmubhNXzoSW22GdzUJZbMrx4NW4OqqPHRl8uAEme8b
	 hpvfWLE4/4bPNCbX2zhzfrqWq9LsLFveT3YTNvOAQoqkJsGk6WP2O8RN3BmTPXtXyF9ZR
	 RlmVBm8pKAMiStvvVonlZztxaU653zWpbENiQKVi+ZHZ82vf6e1PDSFkEWpFIBJPDmyky
	 C4vglx2T/no7reb56fcHfQl8IPRAx5/7TDyB19rwsKQFpAKKC2LDHep9DWFDVSkmMhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Iz8G2vwdudFIJLrSxa3qTJoL3/6gRAyCYBPAiRu8iYY=;
	b=YCsSeitLLXKNwzRG66DlAylVLzt1EYc0wuMDL0vlGylpjviCFRL+K4lGC/y6cwtC2G2L
	 IAiVoYG+++ut26yQN6R8Zl6M+GRryFlieVBf98gco8juFrVVnF8q4zLe+k5t+kLb1cxk0
	 QXNDnwgDGnrHBF+2djJD76bg1dVn3Zo0jKb+NP6VFW36Yt4vJz5cxHv3mvZYloCLhunrT
	 3MDC27S7N4KrRICOmEml4w8/AHnzc+PYjpEkdj8+AxuR19AbqTS0i8i1leOruyKMFIWPN
	 J4R4qqQgz5lzZCzvzhJ4tAEBy/FGKY+7wR6tAv+jqFwCW8ZTKMwo8VLSlxzVl7EAMyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rqc7a+1t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFED4606A32F;
	Thu, 19 Nov 2026 03:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rqc7a+1t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB9C1F000C5;
	Thu, 19 Nov 2026 03:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059564;
	bh=Iz8G2vwdudFIJLrSxa3qTJoL3/6gRAyCYBPAiRu8iYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rqc7a+1t6lCb2IlEqKZPurZucfsxLBeghR5xSYn1gGesbPDn0Bi4+sQj9c+dsx4S1
	 p/xOmWPvAZAZAKDwZ1I3EOgHYm27EDNIFjSPrr36rrRawVa5gEg3XLwJJ9GmzX4t9q
	 N4DfZbfBX65iIuI7EYo45CLOop62eJxerMCQkwHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0846/1848] platform/x86: hp-wmi: fix heap OOB read and memory corruption in hp_wmi_perform_query()
Date: Wed, 18 Nov 2026 15:48:04 +0100
Message-ID: <20261118145952.018523741@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit 6dea092b261f04d632411c2be52d13190f5f67b1 ]

hp_wmi_perform_query() evaluates an ACPI WMI method and expects a
struct bios_return header in the returned buffer. However, it only
checks that the ACPI object type is ACPI_TYPE_BUFFER without verifying
that obj->buffer.length is at least sizeof(*bios_return) (8 bytes).

If the firmware or ACPI method returns a buffer shorter than 8 bytes:

1. bios_return->return_code at offset 4 reads out of bounds from the
   allocated ACPI buffer slab.

2. If return_code evaluates to 0 and outsize is non-zero,
   (int)(obj->buffer.length - sizeof(*bios_return)) evaluates to a
   negative integer (e.g. -8 for a 0-length buffer). actual_outsize is
   set to this negative value and passed to memcpy(buffer, ...,
   actual_outsize), where the signed negative value is cast to
   size_t (e.g. 0xfffffffffffffff8), attempting to copy ~18 Exabytes
   and triggering an immediate kernel crash. Additionally,
   memset(buffer + actual_outsize, ...) performs an out-of-bounds
   write before buffer.

Fix this by ensuring obj->buffer.length is at least sizeof(*bios_return)
before accessing the return code, and compute actual_outsize safely
using min_t(u32, ...), which is sound specifically because the guard
above already rules out obj->buffer.length being smaller than
sizeof(*bios_return) by the time that subtraction runs.

Fixes: c3021ea1beee ("hp-wmi: allow setting input and output buffer sizes separately")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260826103012.240453-1-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 140a5f797980d..c721fcdd2e43c 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -246,8 +246,9 @@ static int hp_wmi_perform_query(int query, enum hp_wmi_command command,
 		goto out_free;
 	}
 
-	if (obj->type != ACPI_TYPE_BUFFER) {
-		pr_warn("query 0x%x returned an invalid object 0x%x\n", query, ret);
+	if (obj->type != ACPI_TYPE_BUFFER ||
+	    obj->buffer.length < sizeof(*bios_return)) {
+		pr_warn("query 0x%x returned wrong type or too small buffer\n", query);
 		ret = -EINVAL;
 		goto out_free;
 	}
@@ -266,7 +267,7 @@ static int hp_wmi_perform_query(int query, enum hp_wmi_command command,
 	if (!outsize)
 		goto out_free;
 
-	actual_outsize = min(outsize, (int)(obj->buffer.length - sizeof(*bios_return)));
+	actual_outsize = min_t(u32, outsize, obj->buffer.length - sizeof(*bios_return));
 	memcpy(buffer, obj->buffer.pointer + sizeof(*bios_return), actual_outsize);
 	memset(buffer + actual_outsize, 0, outsize - actual_outsize);
 
-- 
2.53.0



