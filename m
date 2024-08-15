Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD1F1ABEAB;
	Thu, 15 Aug 2024 13:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728821; cv=none; b=HR8nv8opHqXGHrPAMY5wh1MfbzrfU5MUBsZtPg65Rfj7fS3cCsjUR5hrKdlK4/nNoTBq03bw2fe4H6MqZ1IHX9I9TILr84ObI7GK4QJHN+UT8NN5uDR39dcM2LNDtOd1lD9KIMpHf8aMoOujBzxEqraWDDOgVmRzliNxnYcdfJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728821; c=relaxed/simple;
	bh=uV3CMouF1OtWZVIU6s2+4N33Und/wgWmgPcvHKigsjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoKqS5HHTDmyf9e+7mN3owYdGDSH3Fl/SoWJXHWsdNDxSdb7Y2/yp9KbdPJIeydPV9AvfTNXM7PCaadRkokCNJLglrn6YVF/4lKKPh7Le5Ww27ho+Vc7tXGWjm0rVF7iIosFbj7UFJqu9cx6coXkYB487WZLNqgTeDXjaykxql8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZZTAVcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZZTAVcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F006C32786;
	Thu, 15 Aug 2024 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728820;
	bh=uV3CMouF1OtWZVIU6s2+4N33Und/wgWmgPcvHKigsjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZZTAVcOeid2G9oQ1Fjdd55+tAdzcNftf7G1viWuOUQpB6D+KMAUpguuqefor98dJ
	 10yCU8KJHPZ7I+vSsEGMAYTRYmt6T/P5VSiOtcupAdP5xoonMa7xSmFLH8TJ2Ov+QP
	 VOdR/UJ6zeHzyONyyYlAJFhhfYQ1SqiZaSdvA2Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dong Aisheng <aisheng.dong@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/196] remoteproc: imx_rproc: Fix ignoring mapping vdev regions
Date: Thu, 15 Aug 2024 15:23:58 +0200
Message-ID: <20240815131856.705735045@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dong Aisheng <aisheng.dong@nxp.com>

[ Upstream commit afe670e23af91d8a74a8d7049f6e0984bbf6ea11 ]

vdev regions are typically named vdev0buffer, vdev0ring0, vdev0ring1 and
etc. Change to strncmp to cover them all.

Fixes: 8f2d8961640f ("remoteproc: imx_rproc: ignore mapping vdev regions")
Reviewed-and-tested-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210910090621.3073540-5-peng.fan@oss.nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: 2fa26ca8b786 ("remoteproc: imx_rproc: Skip over memory region when node value is NULL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 99d1a90ea084a..4eec6b380f11c 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -289,8 +289,8 @@ static int imx_rproc_addr_init(struct imx_rproc *priv,
 		struct resource res;
 
 		node = of_parse_phandle(np, "memory-region", a);
-		/* Not map vdev region */
-		if (!strcmp(node->name, "vdev"))
+		/* Not map vdevbuffer, vdevring region */
+		if (!strncmp(node->name, "vdev", strlen("vdev")))
 			continue;
 		err = of_address_to_resource(node, 0, &res);
 		if (err) {
-- 
2.43.0



