Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024915;
	b=ORMweaSKI9FFOJnsNOz5dgXTYtZ3tFP9tX+5LTwcDAH4C3bCBtm4yM867u2SEZo4HxO+
	 pVkeNgxK9O9IBVntNrYZ9RdSYtrE5TUPbM7V5bN2YepfHRcKuLl1ddsA4TumvhdSOoMHZ
	 bfmBThw+9zdOBE9bIl2KkyAW6qJ/1SaUBenrzQM28qUAcRtT8z703YPWMcHn8ZnYmrETi
	 WTM4neu/X3LBZnc0O2A7O1PnroZrV/6C6ndFYfXVPJo+4283gGq3LT6psqtA7GlNjXnD+
	 KiBr+i5xIfkpAw7M4WvISjBd1bMQ9uxH67mqEByjhha7Pd8+45MQ/z/l5SJOVghRlAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4FcFmsal7u895IT/SrUMq1lcty+NAk15mD0nJqcPjWk=;
	b=1PDBBj9Mn2WZP6u7oSd2XoFgLRqZyn/AxC3Ib7bJ40kIKoDPWv2es5Riv9xpJWJUD6e3
	 VmKdyRE3Xa0cOk1aJtyjqgxCL9tTT8KFUiHHcsMBclUzWuv0oFNxuz+avezr5JKVoBdRg
	 0GBo8t9YZ/cSNmZr619i+zHjNULM5yJRz6z3iBcPp3JnTadm/5OLimUbA8R8eSklJSAD+
	 y/la5zUnQbc23DK9WUsgsMiae9lkDurauDl7laIOFJCK5vFJ7Fgq1CYVxKq79A/baif4Z
	 7nUfpDAqgTZCHX64FzFHLWJwGmoAfNmgj10ywAhysMB1qm2/e0Z3gtYW6+EyRlVkxfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=riPre7Im;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C87606A31C;
	Wed, 18 Nov 2026 18:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=riPre7Im
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74971F000C4;
	Wed, 18 Nov 2026 18:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024915;
	bh=4FcFmsal7u895IT/SrUMq1lcty+NAk15mD0nJqcPjWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=riPre7ImzLjJlWnEG0zcw32pRJ7lFdVI/G0ZwsUxURM883UKXRI6ckggdv14lTknx
	 CxHC1PhOU1hDceXfbX/xgSwmH33K+tK08UIqyHVRzbkDNT1sFIMTL3cz9r+GHU2lfb
	 oILrwzndrvCJaPt2/cgEg/JQpG5LR1FwznfY3/Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0894/2151] RDMA/hfi1: shut down the trap timer before unregistering
Date: Wed, 18 Nov 2026 15:43:49 +0100
Message-ID: <20261118150154.864595775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit a1c9d476c2316685f85fffb6450ad88d01836357 ]

MAD processing arms a trap timer embedded in each hfi1_ibport. Device
unregistration does not stop the timer, so its callback can run after
the port and its containing hfi1_devdata have been released.

Shut down every port timer before unregistering the IB device. The
shutdown form also prevents a concurrent path from rearming the timer.

Fixes: bf90aadd630c ("IB/hfi1: Send MAD traps until repressed")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134151.1213-1-getshell@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/verbs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 3cbbfccdd8cdd..eae2b8904467c 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1890,6 +1890,10 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 {
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
+	int i;
+
+	for (i = 0; i < dd->num_pports; i++)
+		timer_shutdown_sync(&dd->pport[i].ibport_data.rvp.trap_timer);
 
 	hfi1_verbs_unregister_sysfs(dd);
 
-- 
2.53.0



