Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062284;
	b=Gi/i5KttwJcKJKb8Kzsyx+/62pAhcOxuTaYPpGPhQUl3Kv0P6k4NUvvK4ddujlDaPQxr
	 Fq777aRS6pf6YTB/HAH9qGX4GcMr82CGsZow7ii1nVbWsIBy1WJj3rwsD8estXtC0kSdE
	 ab3BGPC5yAWeN6kmy39WBVZMHjgMZKiFjjDHnr1gJcm8bPPeufAOaxNAy4tC0u1iExHDj
	 W5Z4a09Tdg7/fGIq0Tw0Xg9I3H95ZK+RF8qynBdXtRDQR3dironKLIxDcGc8jXUPVwEqe
	 WjwsuW9vrcoe17XvyfZLBdmEh5S4Pk70xntxgt/3eSK17i4gNQZbaV1/jnTPhR7cKMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7tiMmIvFT3M3CQl2Y92tPs5ixeY9UX5ebf2UkfKvwTI=;
	b=hYyKQQQEc845/oHz8C3q6zeEuJlYoxFNtP3ELQ3ILp4QeDHYapeqEnrMFann59GC0wfl
	 go0/iaG+WGJo+eJzZ2Gd++9K5779483j+lAfAvwDGby8xHe/JE/SUt1zt3B+GviQl/PPs
	 2ll8AySOY3euKV2NishZA3OzM8IDg9tzI7gJwDAM3r2Q88Ox+R6CaS0FWKgIHfifM3KvG
	 ckR5qJET8/FVSPiUbNBQ5VrKgFoeXqmnrpTX3BaziUHfvUifdWKfQpOMxzyHq/cjOT9yz
	 6VAhA8jJxdappY1r1BC9u9qhe5i5jiKhlmdUpmCdZniSy5BNvT6PJTwRBO4S+XkSajw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=biGV6m3n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7C5606EEA0;
	Sat,  7 Nov 2026 14:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=biGV6m3n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC741F0089F;
	Sat,  7 Nov 2026 14:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062284;
	bh=7tiMmIvFT3M3CQl2Y92tPs5ixeY9UX5ebf2UkfKvwTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=biGV6m3ngiYSIrjW61XLdlPP+AL9fsLVkfqLbX5wZtMn5BZJuBARUcqZNhyu+a1U1
	 Y2Svea7WfTxGBlxXLQ9tdGM8kGbCY8V1VO0BBP0zuFBmC8tZd1PcSyFy510NJbpzeH
	 x/EBPnrVGw8yi3inV9RxwJ31SQRXn+BBdce11tUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1223/1536] cxl/acpi: Convert QTG _DSM latencies to picoseconds
Date: Sat,  7 Nov 2026 08:53:59 -0500
Message-ID: <20261107135032.106463647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0b0937c09f2be..01cc06a75e111 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -204,9 +204,10 @@ cxl_acpi_evaluate_qtg_dsm(acpi_handle handle, struct access_coordinate *coord,
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
@@ -224,6 +225,11 @@ cxl_acpi_evaluate_qtg_dsm(acpi_handle handle, struct access_coordinate *coord,
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



