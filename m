Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060786;
	b=Zp9JFAgHT5+/XE6OxXqsqf45dzKOiKTeCUrceftGi/zNVrQ8Dy3aK+nynFSHpFR9MzbA
	 7/wZyYRFp+0rt8KLf53poMGaYEyHTLNkBEtm5ZSFGRVWcXfduiCbe9r2tmCgOQUAsaVi9
	 EIC1Xb+p8oGEApswtiieXTBSetE52rSJLoaMyvxBCMk37uslWcJdWXdGzNdumWI7Lx6yY
	 IZUf1xW/FISe/BK4mI2bv93Y1EX4hnpFouW/h79c0G9Hh/oRaR9pGBpw/Cg26S9rIqG6v
	 SRYxeBKIPSjiBB60yjtgdWpMe2twF4TePhUJqboa9FTMzH9fsg8jfB7zX3vjXOqZGpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WO4flPg2ceyEetTolxRAjcUXIlqjwdlhxlAVU1DYa6k=;
	b=jPzzJ14Je/AjdnhoOOG34X+iYQbL7BqSaFr7fpLDmITRcKVQdZJQOb1TCaapQfKtCQxJ
	 xGDlLKig3L+HefyticUYvaQoOIUnz0WmSH4gOsSMBY4SfO39tmLOfXbr4SHKIMm1lacSb
	 IePTapucM+eW1p+wPh4HG2H6DP/qGvwJSjaXBNheqMBINQgDdrrcGG9ecJo8xTrryLOqr
	 eLGgD2DeAzoALdClTglvw7EgXv5FTEO/TBWvFQse2mxX4Jcc42O/WbI71ZenNtFP7csL3
	 pBnF5OGJCeuNUHsQiaDF+AeZe95HntWSJqPcertQxrPvMr236qbPGMVeDtXaCYE5DPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfYWW+Fm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E346606A326;
	Sat,  7 Nov 2026 14:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfYWW+Fm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7851F0089F;
	Sat,  7 Nov 2026 14:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060786;
	bh=WO4flPg2ceyEetTolxRAjcUXIlqjwdlhxlAVU1DYa6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zfYWW+FmoD9El8A3Z/quwUlEKdAIdjR/QUXeZB9rPc0wIhdIbjo5Mx3N39xnBCQIh
	 e6Jo1ySapw1AryLk2znvRZdiJes1KzxESdyGOz9ZzIJ+1DmZLVO0FgMlSqyed9wHnz
	 kCUJWaAxNC/h+yWVWox2/Z6XNaTPq1bdcRj/BNXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0191/1536] thermal: intel: int340x: clean up RFIM groups on DVFS failure
Date: Sat,  7 Nov 2026 08:36:47 -0500
Message-ID: <20261107135003.029208305@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 28f34d7dafa6dfa657efd6760b7c78e98c9b2f6a ]

proc_thermal_rfim_add() can create the FIVR and DLVR sysfs groups
before creating the DVFS group.

If DVFS group creation fails while both earlier groups are enabled, the
current error handling removes only one group: the FIVR branch returns
before the DLVR cleanup branch can run.  This leaves the DLVR group
behind even though RFIM setup fails.

Use one DVFS failure path that removes all previously created RFIM
groups before returning the error.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260615065245.84252-1-pengpeng@iscas.ac.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/int340x_thermal/processor_thermal_rfim.c    | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
index c9c7451c34d7e..abff73fef369e 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -458,12 +458,11 @@ int proc_thermal_rfim_add(struct pci_dev *pdev, struct proc_thermal_device *proc
 
 	if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DVFS) {
 		ret = sysfs_create_group(&pdev->dev.kobj, &dvfs_attribute_group);
-		if (ret && proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_FIVR) {
-			sysfs_remove_group(&pdev->dev.kobj, &fivr_attribute_group);
-			return ret;
-		}
-		if (ret && proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DLVR) {
-			sysfs_remove_group(&pdev->dev.kobj, &dlvr_attribute_group);
+		if (ret) {
+			if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DLVR)
+				sysfs_remove_group(&pdev->dev.kobj, &dlvr_attribute_group);
+			if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_FIVR)
+				sysfs_remove_group(&pdev->dev.kobj, &fivr_attribute_group);
 			return ret;
 		}
 	}
-- 
2.53.0



