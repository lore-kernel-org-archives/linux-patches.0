Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064605;
	b=TFjMDE3ujD6eYHFFYPYSL5qzVbl+IxfRiiBsRSwUdaJ3NDAsNBBxyPCCxP6RTLEECqJA
	 5lq1G7mcsuGtKY5niKpcQO9KyXvH58VJ++8OACumOdYKWAMo1BOENqcq/5YTxQlBqgnx8
	 nMX2pB/bqJdQjmRg4gKn9mHzVYv5IQwH/1kK4MDE5a+w4xQdoxo+us1o7omXd4tULPNKR
	 Jf87zoLd/PxXYolDAVNo3HkpXySeuL+QQb++KUg3mntrSG9TR7oflGbbxoq0QVuuuXKRr
	 gR6aSUTzdfy9TRoYojxpqo/zObAYw1jhMP5VaYh7dq22cyHOh6meQH7HEJUAT1MAXGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DEATxnvEAdq4o2MEMpkTMccS1j3lsROc8nHBbWSnUIQ=;
	b=0nZlUrsnO2cfrZUTltze5qzht77rkq2Olv9imdAsO9Mov3vsFvkflXmf+t9Qe/crRdBA
	 4NJIR+z0QUydSbfZUymcVL1d+8bvYu6Y+Edo7LjaE+jhgDo+PNKDQr5NeXFghZxkPNkXO
	 ljW6ZrBtAXphcnTdNVyufBUMxfnHN/X7qu3IUhHUZgS9JF2zJlqaT577oUsCFWyfojkc2
	 dmZAova9E0GtOzHLcYuACvpXmY6HSjT7VBPGJAuUPVIiZa4Ncv4D+NhQpfwVdba+QNNJo
	 +CiqEUHOteDsiiD2TPONVR5cqDxYtmnfZcBX14RQxgDkisR/OSzcs4bJUT5vIFLDZFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7M4Ox4O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902EE606E8F7;
	Sat,  7 Nov 2026 15:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7M4Ox4O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE1E1F0089F;
	Sat,  7 Nov 2026 15:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064605;
	bh=DEATxnvEAdq4o2MEMpkTMccS1j3lsROc8nHBbWSnUIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7M4Ox4Os8UAU7rMuR0sikk1P6ffhF5+DKpuU1x34RUtUuKX0yD7EKLLfIoj0Sxjx
	 L1jdIKkRWo75quQOU9+6mLoCttTnzd5NBd584EXFXxpCObWrn9/VePrH06SJkebWQz
	 irwNhZeLxFOEUAjn7FnYfav3PKIcdHMRcdX9wr3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0617/1257] cxl/acpi: Convert QTG _DSM latencies to picoseconds
Date: Sat,  7 Nov 2026 08:48:33 -0500
Message-ID: <20261107134956.343411985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 2658c66a5efb5f30f5ced708a5de831845b43f6d ]

The QTG _DSM expects read and write latencies in picoseconds, as
specified in CXL 3.0, Table 9-30.

The code base originally kept the latencies passed to the QTG _DSM in
picoseconds in effect. Commit 51293c565cf4 ("cxl: Fix incorrect region
perf data calculation") normalized CDAT and host bridge latencies to
nanoseconds, but did not add a conversion back to picoseconds when
constructing the _DSM input. Firmware can therefore select QTG IDs using
understated latencies.

Convert the latencies to picoseconds when constructing the _DSM input
package. Multiply in 64 bits and reject latencies that cannot fit in the
DWORD inputs defined by the specification.

Fixes: 51293c565cf4 ("cxl: Fix incorrect region perf data calculation")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20261009045452.1107921-4-den@valinux.co.jp
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/acpi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index fb09a5ff48c16..b7ce6b59c680b 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -231,9 +231,10 @@ cxl_acpi_evaluate_qtg_dsm(acpi_handle handle, struct access_coordinate *coord,
 			  int entries, int *qos_class)
 {
 	union acpi_object *out_obj, *out_buf, *obj;
+	/* QTG _DSM expects latencies in picoseconds. */
 	union acpi_object in_array[4] = {
-		[0].integer = { ACPI_TYPE_INTEGER, coord->read_latency },
-		[1].integer = { ACPI_TYPE_INTEGER, coord->write_latency },
+		[0].integer = { ACPI_TYPE_INTEGER, coord->read_latency * 1000ULL },
+		[1].integer = { ACPI_TYPE_INTEGER, coord->write_latency * 1000ULL },
 		[2].integer = { ACPI_TYPE_INTEGER, coord->read_bandwidth },
 		[3].integer = { ACPI_TYPE_INTEGER, coord->write_bandwidth },
 	};
@@ -251,6 +252,11 @@ cxl_acpi_evaluate_qtg_dsm(acpi_handle handle, struct access_coordinate *coord,
 	if (!entries)
 		return -EINVAL;
 
+	/* Latency inputs must fit in the DWORD fields defined by the spec. */
+	if (coord->read_latency > U32_MAX / 1000 ||
+	    coord->write_latency > U32_MAX / 1000)
+		return -ERANGE;
+
 	out_obj = acpi_evaluate_dsm(handle, &acpi_cxl_qtg_id_guid, 1, 1, &in_obj);
 	if (!out_obj)
 		return -ENXIO;
-- 
2.53.0



