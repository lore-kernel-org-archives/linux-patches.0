Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85BC26B0BC;
	Thu, 13 Feb 2025 15:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459929; cv=none; b=Czg+CiKmgMG6Pf3GU2y08OOG6SvjDvsS0+C4/jX3tk9ZF9cEInMtN/+DYFzHzoo+OwjNH40bG1KiDq2C5Hd6rBPneiAJb45ln9bRcuLKddbNZAC2xoQJefj3IY3fMURACGSfUPLQ52/RtnFBfEv1Im5yjvwAMYDuKLC+x/l5XZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459929; c=relaxed/simple;
	bh=gYKs1A8v1La+MZE7KEh7ENuE81wLIdvDqMP2pKfAHcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZgndcbGaqOR973sEBiLsuR89PotP2owHvo63usVGB9kFCVe3g1ZeSW7g/tULjj6JPlGe8gSvtnOWj6kD0ELM1DNqT19cb7OQ0yrmlYJBnfg+G0UXZ2TZqdceWOdluE4eIbS24kI4TDDIjYOti5bLYGCJ7XAwFXKccuOcrIR1oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NN5+8fuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NN5+8fuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94D6C4CED1;
	Thu, 13 Feb 2025 15:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459929;
	bh=gYKs1A8v1La+MZE7KEh7ENuE81wLIdvDqMP2pKfAHcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NN5+8fuL6+1yD0E4/DLhMNpOvRz8vbyaatJs1MqYDsBCZJlVXBss3TcaX4c1gxs4N
	 JjPUw+dj01DhmZC6hvkKwJhNE+mgmSC1gpBk5e6KbeUTQSoidkjOpbx3MRYjpCMGjW
	 Ol3aQGzR9eR8P5dKihXWuB3Ed2JJKhEBBXO84Wi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Michal Simek <michal.simek@amd.com>,
	Tanmay Shah <tanmay.shah@amd.com>,
	Jassi Brar <jassisinghbrar@gmail.com>
Subject: [PATCH 6.13 405/443] mailbox: zynqmp: Remove invalid __percpu annotation in zynqmp_ipi_probe()
Date: Thu, 13 Feb 2025 15:29:30 +0100
Message-ID: <20250213142456.237231333@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

commit 170a264d2611a0bfa96b7818730473db5e7546fc upstream.

struct zynqmp_ipi_pdata __percpu *pdata is not a per-cpu variable,
so it should not be annotated with __percpu annotation.

Remove invalid __percpu annotation to fix several

zynqmp-ipi-mailbox.c:920:15: warning: incorrect type in assignment (different address spaces)
zynqmp-ipi-mailbox.c:920:15:    expected struct zynqmp_ipi_pdata [noderef] __percpu *pdata
zynqmp-ipi-mailbox.c:920:15:    got void *
zynqmp-ipi-mailbox.c:927:56: warning: incorrect type in argument 3 (different address spaces)
zynqmp-ipi-mailbox.c:927:56:    expected unsigned int [usertype] *out_value
zynqmp-ipi-mailbox.c:927:56:    got unsigned int [noderef] __percpu *
...

and several

drivers/mailbox/zynqmp-ipi-mailbox.c:924:9: warning: dereference of noderef expression
...

sparse warnings.

There were no changes in the resulting object file.

Cc: stable@vger.kernel.org
Fixes: 6ffb1635341b ("mailbox: zynqmp: handle SGI for shared IPI")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Reviewed-by: Tanmay Shah <tanmay.shah@amd.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -905,7 +905,7 @@ static int zynqmp_ipi_probe(struct platf
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *nc, *np = pdev->dev.of_node;
-	struct zynqmp_ipi_pdata __percpu *pdata;
+	struct zynqmp_ipi_pdata *pdata;
 	struct of_phandle_args out_irq;
 	struct zynqmp_ipi_mbox *mbox;
 	int num_mboxes, ret = -EINVAL;


