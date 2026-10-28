Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214374;
	b=STG5trVlMb6IPQJmXLVSbt+SQSvhFvcmKNMlaw92y9YCc3MYDttEFgNntYgR9GFJWr6w
	 T9u2W9avVkf4wVfciCUIjZWEgsifoBoaORiAbmGYG7tGr4VrG/6HO/aU+psTbJsoyfsJI
	 awqHkcSbFYWkcQSJxurYt0SJ2IP0+Q63GEORfB+bFXxrDz1f+rVfzYo15dmopgV37+2pT
	 u8sHYs2ALQ3cXKK+BqXCMS0JdCiLwSgDi8kmoNBehwJH3CvceoTEl4yJ1wmE7q7+6uwMe
	 cPUCuZodSUNLFIHW8joSi3s2tZZAn6fXxVjWwKvMPYNGzEi2kaCDw/xe9sOnGIijPEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M91/G/RpHfc9dlcj7Z0umq2vMUkeB8Fy8rYqt9ap05U=;
	b=Lds6OxTZeXJMQ/Uk4YJAdq65gKThimViEjzgkPbfdmrgMork78gw1/qSrb8iX3g3X+1y
	 +vd7sVKi8cgnx/Cgw4dST7HIC+G6Ud+S1P5UPkDvPTW0HIIIHipkR2AG8yWZqsQA7FyNE
	 /V0IvpDqzwCi2mCm6AFISJZYisKYi3x7+f6y7jkvt68cy9x1ZhRl7DPaRG+HlNMqHg3L1
	 xcr8kmGWte4tdGxzXEJqoCyoFGZvKe+STwDNa/gaIAh8sGpARrv/Z4TLHn14O0IosfNoc
	 6cmVG/PaEcdY3DQIUKQ+a+RGWkUBewpM/mKYM4BeeT11vbguKSO7Gg4L6bKtJAdTVlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QBPorbfV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C76260A381D;
	Wed, 28 Oct 2026 19:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QBPorbfV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9388C1F01829;
	Wed, 28 Oct 2026 19:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214374;
	bh=M91/G/RpHfc9dlcj7Z0umq2vMUkeB8Fy8rYqt9ap05U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBPorbfVgpMiMd9REQgWv5JM9Ig/Iy9wSIaNh1TIg1XRSGryKR0ZYZTgPZhwKbaA+
	 s7+tVflXXKQWut6cnLDn2EdpuJlJCS3IMC7PNcSaZXBZjRqDThLv/9a5Tmz+kuXOT0
	 gaFp+NqMvDrf6n1Ry2aeXYvgSdluheGp/ukRd+sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aliaksei Makarau <Aliaksei.Makarau@ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0836/1887] s390/ism: fix concurrency management in ism_cmd()
Date: Wed, 28 Oct 2026 17:48:52 +0100
Message-ID: <20261028170518.451492614@linuxfoundation.org>
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

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit 897e8601b9cff1d054cdd53047f568b0e1995726 ]

The s390x ISM device data sheet clearly states that only one
request-response sequence is allowable per ISM function at any point in
time.  Unfortunately as of today the s390/ism driver in Linux does not
honor that requirement. This patch aims to rectify that.

This problem was discovered based on Aliaksei's bug report which states
that for certain workloads the ISM functions end up entering error state
(with PEC 2 as seen from the logs) after a while and as a consequence
connections handled by the respective function break, and for future
connection requests the ISM device is not considered -- given it is in a
dysfunctional state. During further debugging PEC 3A was observed as
well.

A kernel message like
[ 1211.244319] zpci: 061a:00:00.0: Event 0x2 reports an error for PCI function 0x61a
is a reliable indicator of the stated function entering error state
with PEC 2. Let me also point out that a kernel message like
[ 1211.244325] zpci: 061a:00:00.0: The ism driver bound to the device does not support error recovery
is a reliable indicator that the ISM function won't be auto-recovered
because the ISM driver currently lacks support for it.

On a technical level, without this synchronization, commands (inputs to
the FW) may be partially or fully overwritten (corrupted) by another CPU
trying to issue commands on the same function. There is hard evidence that
this can lead to DMB token values being used as DMB IOVAs, leading to
PEC 2 PCI events indicating invalid DMA. But this is only one of the
failure modes imaginable. In theory even completely losing one command
and executing another one twice and then trying to interpret the outputs
as if the command we intended to execute was actually executed and not
the other one is also possible.  Frankly, I don't feel confident about
providing an exhaustive list of possible consequences.

Fixes: 684b89bc39ce ("s390/ism: add device driver for internal shared memory")
Reported-by: Aliaksei Makarau <Aliaksei.Makarau@ibm.com>
Tested-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Tested-by: Aliaksei Makarau <Aliaksei.Makarau@ibm.com>
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250722161817.1298473-1-wintera@linux.ibm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism.h     | 1 +
 drivers/s390/net/ism_drv.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/s390/net/ism.h b/drivers/s390/net/ism.h
index 90af513701836..6f21e05b9c6c9 100644
--- a/drivers/s390/net/ism.h
+++ b/drivers/s390/net/ism.h
@@ -192,6 +192,7 @@ struct ism_sba {
 
 struct ism_dev {
 	spinlock_t lock;
+	spinlock_t cmd_lock; /* serializes cmds */
 	struct pci_dev *pdev;
 	struct smcd_dev *smcd;
 
diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index cae64eccead9b..9576e3975c721 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -40,6 +40,7 @@ static int ism_cmd(struct ism_dev *ism, void *cmd)
 	struct ism_req_hdr *req = cmd;
 	struct ism_resp_hdr *resp = cmd;
 
+	spin_lock(&ism->cmd_lock);
 	__ism_write_cmd(ism, req + 1, sizeof(*req), req->len - sizeof(*req));
 	__ism_write_cmd(ism, req, 0, sizeof(*req));
 
@@ -53,6 +54,7 @@ static int ism_cmd(struct ism_dev *ism, void *cmd)
 	}
 	__ism_read_cmd(ism, resp + 1, sizeof(*resp), resp->len - sizeof(*resp));
 out:
+	spin_unlock(&ism->cmd_lock);
 	return resp->ret;
 }
 
@@ -555,6 +557,7 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOMEM;
 
 	spin_lock_init(&ism->lock);
+	spin_lock_init(&ism->cmd_lock);
 	dev_set_drvdata(&pdev->dev, ism);
 	ism->pdev = pdev;
 
-- 
2.53.0



