Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212198;
	b=rJAxemadu8MYecRnSFh3Ftd8Xvom5LKk1kOCZ7rSut5UeNyNzAmAUPOM9dbO3kXkVzbQ
	 5Wz4pBF8qpHP10xEL/BtaA1uM2/3KHa2IVnzzoWg99O8w5VblngiviXCDnXz8OoJ02yOL
	 bhWOlvtMRv7x+08oLngvTEtNSs5NL6XtlQA3eXZmSDYbSFDNDn5um6LgFXnQ32xfmQAcN
	 Q+NPEwPS1N2hY2Fbb1Vr8FdgICSzGF3C0EdJby0A/GEiEKqXAP82scQwl/OKI8Iw8/Bjh
	 3AEbOuh35Sa9PZhYuKpviuchDxGy+grTcJTQ8Df7Rf2OTy63qYGfKqpyU7yuOLzxEgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SFs/Ib3z2M08QanbFTlP6ELkxKy9EHLprI6w1o3zMkk=;
	b=0SpJa9KXN7i/8SZgu4gbEC08RMVscSN7iN4nKZctecAEo4uDONZ8XX2pCp9f7WGN4hg4
	 eekCdA1iZ2KMJgQcU5zkNiMqUY+Ldedb2VgIXat/H/qbt3+AJF24vovwrbSXQTbnjSA0L
	 WXYcl0WJWLSnMNCf23JsnCHcDYZoKaNUj3hy+l0O5JLIXnOI1rPtH4kSKBCdYlQMZc9y4
	 kdWX1bDm18awHrBMwQs9ayGhLCBE/QuQS2lIb6eIKXaSxKBl2+cHoBU3dL1QZxfw1JWQY
	 BT150FMPLngfvLzElL+w3wBa3Raxuljn4qR+IcZP+t6hnFOtYvqOggh5vibylWkc6ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YOVhwkbO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86E8606A31A;
	Wed, 28 Oct 2026 18:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YOVhwkbO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2208C1F01825;
	Wed, 28 Oct 2026 18:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212197;
	bh=SFs/Ib3z2M08QanbFTlP6ELkxKy9EHLprI6w1o3zMkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOVhwkbO92feOX4Rqciwj8z+tL2V6RQ5obYYSM0QPHdiG3sGHPAsrDuzoUrzbGSdC
	 nbNZ7fbFOZcw6G1DnB3NNG2EbUtGrMBBR1maKerdQDP3jV1ozt6NU4898cg+WavVN3
	 k1sqzijRy2FHjIZC6z0kaRg7lF7+BZvu4cKH455A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0073/1887] ACPI: TAD: Rearrange RT data validation checking
Date: Wed, 28 Oct 2026 17:36:09 +0100
Message-ID: <20261028170500.894818017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 3329a1416c3350449081ca5daaa94802a65b2992 ]

Move RT data validation checks from acpi_tad_set_real_time() to
a separate function called acpi_tad_rt_is_invalid() and use it
also in acpi_tad_get_real_time() to validate data coming from
the platform firmware.

Also make acpi_tad_set_real_time() return -EINVAL when the RT data
passed to it is invalid (instead of -ERANGE which is somewhat
confusing) and introduce ACPI_TAD_TZ_UNSPEC to represent the
"unspecified timezone" value.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3409319.aeNJFYEL58@rafael.j.wysocki
Stable-dep-of: a3df8bbe0a70 ("ACPI: TAD: Add locking around AML evaluations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_tad.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpi_tad.c b/drivers/acpi/acpi_tad.c
index 8383d6329c645..664281d7f4259 100644
--- a/drivers/acpi/acpi_tad.c
+++ b/drivers/acpi/acpi_tad.c
@@ -48,6 +48,9 @@ MODULE_AUTHOR("Rafael J. Wysocki");
 /* Special value for disabled timer or expired timer wake policy. */
 #define ACPI_TAD_WAKE_DISABLED	(~(u32)0)
 
+/* ACPI TAD RTC */
+#define ACPI_TAD_TZ_UNSPEC	2047
+
 struct acpi_tad_driver_data {
 	u32 capabilities;
 };
@@ -66,6 +69,16 @@ struct acpi_tad_rt {
 	u8 padding[3]; /* must be 0 */
 } __packed;
 
+static bool acpi_tad_rt_is_invalid(struct acpi_tad_rt *rt)
+{
+	return rt->year < 1900 || rt->year > 9999 ||
+	    rt->month < 1 || rt->month > 12 ||
+	    rt->hour > 23 || rt->minute > 59 || rt->second > 59 ||
+	    rt->tz < -1440 ||
+	    (rt->tz > 1440 && rt->tz != ACPI_TAD_TZ_UNSPEC) ||
+	    rt->daylight > 3;
+}
+
 static int acpi_tad_set_real_time(struct device *dev, struct acpi_tad_rt *rt)
 {
 	acpi_handle handle = ACPI_HANDLE(dev);
@@ -79,12 +92,8 @@ static int acpi_tad_set_real_time(struct device *dev, struct acpi_tad_rt *rt)
 	unsigned long long retval;
 	acpi_status status;
 
-	if (rt->year < 1900 || rt->year > 9999 ||
-	    rt->month < 1 || rt->month > 12 ||
-	    rt->hour > 23 || rt->minute > 59 || rt->second > 59 ||
-	    rt->tz < -1440 || (rt->tz > 1440 && rt->tz != 2047) ||
-	    rt->daylight > 3)
-		return -ERANGE;
+	if (acpi_tad_rt_is_invalid(rt))
+		return -EINVAL;
 
 	args[0].buffer.pointer = (u8 *)rt;
 	args[0].buffer.length = sizeof(*rt);
@@ -131,6 +140,11 @@ static int acpi_tad_get_real_time(struct device *dev, struct acpi_tad_rt *rt)
 		goto out_free;
 
 	memcpy(rt, data, sizeof(*rt));
+	if (acpi_tad_rt_is_invalid(rt)) {
+		ret = -ENODATA;
+		goto out_free;
+	}
+
 	ret = 0;
 
 out_free:
-- 
2.53.0



