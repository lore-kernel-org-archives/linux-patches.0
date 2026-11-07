Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063255;
	b=KOX25jF63MDUA0zClj4CIYmiXantZhHdBVXFOeiRcoPd5G1sI/+h5ycmcbzYBncalDt+
	 M50ItRlLH5n7cgy0Ryp1tpQ+UESuh+Zh/dJd8CTWdBEwqt2weOEB4F3JMun+x+0wT4/YD
	 xOGJMY6sTh6Kt7G8RnZPpy7VISDo6i37hvnn+UVEyMUvClRa2Vpm3kECS/6Ofba2/VZvi
	 vaLBItZCsjM7e6hOuu+1NpGcBRvtmqa10D1NP6AnvJeJS3Gd92xO9GDmLlTv2kVObs6M/
	 JnQPaL2WqSICN7kNXnkngIdr0nUBoQ9GCSTr4HH+c2eTLrcjELfu5VuZy1IvnwIZBwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RALelNtMec2oruk/e2MDkBk5AwjSYhKuSYQwvL5Hh5A=;
	b=OmWNCQSH65XItzWU3axVSNfof9UArNCFxvuKMWA5ghcxiDCv8fjS+iyowVziyhi5h9ie
	 ywq4AZEWxK5WkqnkEdwrPPOsfx2xBLBun9j3HJFRTh6V7wbm+AMR1CBN1YshQ/63Q8slB
	 XuIydciMcc4uHUCs+fc6yjmScM5pPHh9+ynkNCfe3tE33wlHvUJDqRiHs8Y3BvP5u3vpo
	 9BgHeyo+kzUbRJPwyRojy/ETckCm/DiNMmH+F9M5+lNjgFhAkrjr4atjDN4MO0c2HdprA
	 B6rc62dWnPhu8Ra+maO/Jvzg6/QJKlMBBgHD8gGcOmkhsOINtQ0TdjivXs1RUZBGjOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XYnkYJzu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11969606A330;
	Sat,  7 Nov 2026 14:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XYnkYJzu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78B61F0089F;
	Sat,  7 Nov 2026 14:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063254;
	bh=RALelNtMec2oruk/e2MDkBk5AwjSYhKuSYQwvL5Hh5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XYnkYJzufPylziF0agTMIoyYNYyAGWz9YkYDlXKAhgHXsY7y1bNI7TVSl2UuF6Bd1
	 T1U3gHCDm026WhLbAqpiDSqLmo0g3ZOlSzDa1Pz84ANhC6FLkGsCmUR06qKlox0HWR
	 H9nbNbZeBS1DvlyjLXwUvgw5wqPEYvb8n0+3kqsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 456/869] cxl/acpi: Convert QTG _DSM latencies to picoseconds
Date: Sat,  7 Nov 2026 08:52:18 -0500
Message-ID: <20261107134909.159052377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5e9bb0df46dd8..eeb6921950fc2 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -205,9 +205,10 @@ cxl_acpi_evaluate_qtg_dsm(acpi_handle handle, struct access_coordinate *coord,
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
@@ -225,6 +226,11 @@ cxl_acpi_evaluate_qtg_dsm(acpi_handle handle, struct access_coordinate *coord,
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



