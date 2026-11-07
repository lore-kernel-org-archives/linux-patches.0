Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063251;
	b=tj9Zbt2XkD86Kn0t5kZpNWPSXmISHTOo6inxqKs5Qn8n77Io+A+zC4NUBHEQMNdH5TId
	 DXsL5Qbybln7rPyGZIpoJz+RSxEeXl0e9RaoJZwxO2ccILoTygAirKpzBk3ChG0EqhlgY
	 B659cOBNpqExeEDmgqnoLYCS+IE8yoAxWASHBfpyVQTTYOFYPge4YtbMWo/mocdSpC8ue
	 3gSx5okO2iOhMIwApg/NVZljvCbWw0iuKAVmV0sg27B7fOuC7O00kwMaCzSmAxYFRTCpE
	 y37LXDNl0UCWmQnByEnKJ8T72Z2cUE7+hps/PYiolBFt6IjzFzj0fyW6xzr57V316rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xk3K44q0uynTd8J11SmcnXlBjd0mD916Yj1LFmAwjdo=;
	b=ju3UPxlIjqLpxzT7zUTUI00GoJPA8W1R232r2EuDskVdFiT+pwEwHWB2G24SboWBCnUy
	 CnnoOQm1EXEAtnBMhI1XIzJeaRJ8PT9H9EoxGXI3qwuudLzoDtjloC5A1zj3OfWRwViQv
	 +PXidq6pKJGQYsfSUHUq1jP3bb3q2bCFwj1Vv1YzrXPqVObBUff5IwZ0QSxf0M19WEF4N
	 h8rS8YgxIixdHiBGbbEWI+YHUBz/IKr7h/+N86NqGLjsbOrpXCI8rJ3b2CLFrNJxuaGHp
	 vEgbCKX7kLUSvRnr3TmW9O8Ul1q/t2wL3Ye2AFlDrrhLNGJnJdNXSolC2o9JtLrOFSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJcSOQKv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C8F606A336;
	Sat,  7 Nov 2026 14:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJcSOQKv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10431F0089F;
	Sat,  7 Nov 2026 14:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063251;
	bh=xk3K44q0uynTd8J11SmcnXlBjd0mD916Yj1LFmAwjdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJcSOQKv9z523N/IGTD4pJUyx7+FazqAW3p+Fba8XQqYEV+Yfv5nW09Q5gQCpyBq0
	 q5GNejRJia1AczPjkU9BEIGYzxRP6Rbz5a/qKcQEDeCZQWDd/iu8UIgkn/KBk+et6k
	 AnIjq6rWKcEshnhahc424+0JeONtx54dCN25RH2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 453/869] cxl/pci: Program the Port GPF timeouts before caching the DVSEC
Date: Sat,  7 Nov 2026 08:52:15 -0500
Message-ID: <20261107134909.074781252@linuxfoundation.org>
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
index 68859eba30db3..3e88c2e3304a3 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -860,7 +860,7 @@ static int update_gpf_port_dvsec(struct pci_dev *pdev, int dvsec, int phase)
 
 	rc = pci_read_config_word(pdev, dvsec + offset, &ctrl);
 	if (rc)
-		return rc;
+		return pcibios_err_to_errno(rc);
 
 	if (FIELD_GET(base, ctrl) == GPF_TIMEOUT_BASE_MAX &&
 	    FIELD_GET(scale, ctrl) == GPF_TIMEOUT_SCALE_MAX)
@@ -870,11 +870,17 @@ static int update_gpf_port_dvsec(struct pci_dev *pdev, int dvsec, int phase)
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
+
+	pci_dbg(pdev, "Port GPF phase %d timeout: %d0 secs\n",
+		phase, GPF_TIMEOUT_BASE_MAX);
 
-	return rc;
+	return 0;
 }
 
 int cxl_gpf_port_setup(struct cxl_dport *dport)
@@ -884,16 +890,22 @@ int cxl_gpf_port_setup(struct cxl_dport *dport)
 
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



