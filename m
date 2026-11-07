Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064602;
	b=tFNFaG3hW0TJRah0LAuonkM2na/sfVud+KpJqoYbOyWTvqjgJKWMrUBw11qOf2wAiSvd
	 rcuwlDkZLbDCOcsSbC5bGECm5bczQtiQAPPFdRAiAyArvUtyY1QNZyE+6HgEPzQkAzXn1
	 b53sJKYGaThYNjKcXh1IbNxeH9yQxnz+Ld6xizu8nxo21AxwuJU97XcK3l9n56OHy4SRK
	 SHE/nUbAFzD8kJxEApiKalz5a6ut7LL0Ri1z+jBelKwDyuyyQFswpKi6HMdbilcNxlck/
	 bgKFUmVfNNgj9d/oMA5u3PmtJwuVqWIUjUiWk1PGqkebpWU7eJfV/iPU6hGVtbwb0Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gU3DM+V6KIbt92OS733/cS247gMkdpDOYhuiNAioBLE=;
	b=Ybcg/0RX1Y7v0q+2KI40X3Wsstlzvdr3w9H3eKt9GdPNKK//lXYlJjlWe1Juen+CEQYv
	 4h3k0v7bFX3aPCXnaDXe/fVYLfbuJv48e40wsmKQbaQdyRkBP7p71xRwy7RBHkGhvmOJB
	 G/PFR3xA9oX//TRpbIUSfo614biaBBlDeewo40iGn1mHZJ5XH+mD3Sj7oZQfG1D77fKIg
	 UG2e/D3535KEnRpEaqITZ1o297UN0lf/7FasBPMx+MHiIpLNpasualUtYoKR08ZZI3MqO
	 8d2kRbM7oJ1fE+4+O8zqqCRxOgmi+6NGDokXmG+Mojxw5m5H4FbWUWKlu2C6LYBCz7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5t2rH8u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30D6606A9D3;
	Sat,  7 Nov 2026 15:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5t2rH8u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6F61F0089F;
	Sat,  7 Nov 2026 15:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064601;
	bh=gU3DM+V6KIbt92OS733/cS247gMkdpDOYhuiNAioBLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5t2rH8ufkZ5WmrlWxOeekXG/FjsuhB43tQ+Ivuwnq92gfxP82svu+OiL0E+c9mW7
	 26+/5cfSdq0cB8EvZPJ0VehPp11A9uCBXorFnqahqxMzmZnSs/mA7N+gEkQCG5aM+K
	 JjGQVOXvxgi2BhkEEkMXOh7xtRbXI4IU53J68wVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0614/1257] cxl/pci: Program the Port GPF timeouts before caching the DVSEC
Date: Sat,  7 Nov 2026 08:48:30 -0500
Message-ID: <20261107134956.262995852@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit ec2e30a682945616d194d7999cf96606b7ee5a88 ]

cxl_gpf_port_setup() caches the Port GPF DVSEC offset in the dport
before programming the phase timeouts, and ignores the return value
of both update_gpf_port_dvsec() calls: the function always reports
success.

A failing config write is therefore not only silent, it is also
permanent: the timeouts stay at the hardware defaults instead of the
maximum flush window the kernel is asking for, and the cached offset
keeps any later endpoint attach from retrying the update.

Propagate the errors and cache the offset only after both phases are
programmed, so the next endpoint attach retries the setup.

Fixes: 6af941db6a60 ("cxl/pci: Update Port GPF timeout only when the first EP attaching")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20261008034619.28059-3-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index e31aad7a525a2..1f470ab0df3b7 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -840,7 +840,7 @@ static int update_gpf_port_dvsec(struct pci_dev *pdev, int dvsec, int phase)
 
 	rc = pci_read_config_word(pdev, dvsec + offset, &ctrl);
 	if (rc)
-		return rc;
+		return pcibios_err_to_errno(rc);
 
 	if (FIELD_GET(base, ctrl) == GPF_TIMEOUT_BASE_MAX &&
 	    FIELD_GET(scale, ctrl) == GPF_TIMEOUT_SCALE_MAX)
@@ -850,11 +850,17 @@ static int update_gpf_port_dvsec(struct pci_dev *pdev, int dvsec, int phase)
 	ctrl |= FIELD_PREP(scale, GPF_TIMEOUT_SCALE_MAX);
 
 	rc = pci_write_config_word(pdev, dvsec + offset, ctrl);
-	if (!rc)
-		pci_dbg(pdev, "Port GPF phase %d timeout: %d0 secs\n",
-			phase, GPF_TIMEOUT_BASE_MAX);
+	if (rc) {
+		rc = pcibios_err_to_errno(rc);
+		pci_warn(pdev, "Port GPF phase %d timeout write failed: %d\n",
+			 phase, rc);
+		return rc;
+	}
 
-	return rc;
+	pci_dbg(pdev, "Port GPF phase %d timeout: %d0 secs\n",
+		phase, GPF_TIMEOUT_BASE_MAX);
+
+	return 0;
 }
 
 int cxl_gpf_port_setup(struct cxl_dport *dport)
@@ -864,16 +870,22 @@ int cxl_gpf_port_setup(struct cxl_dport *dport)
 
 	if (!dport->gpf_dvsec) {
 		struct pci_dev *pdev;
-		int dvsec;
+		int dvsec, rc;
 
 		dvsec = cxl_gpf_get_dvsec(dport->dport_dev);
 		if (!dvsec)
 			return -EINVAL;
 
-		dport->gpf_dvsec = dvsec;
 		pdev = to_pci_dev(dport->dport_dev);
-		update_gpf_port_dvsec(pdev, dport->gpf_dvsec, 1);
-		update_gpf_port_dvsec(pdev, dport->gpf_dvsec, 2);
+		rc = update_gpf_port_dvsec(pdev, dvsec, 1);
+		if (rc)
+			return rc;
+
+		rc = update_gpf_port_dvsec(pdev, dvsec, 2);
+		if (rc)
+			return rc;
+
+		dport->gpf_dvsec = dvsec;
 	}
 
 	return 0;
-- 
2.53.0



