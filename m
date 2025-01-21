Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FC61F63CF;
	Tue, 21 Jan 2025 17:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482217; cv=none; b=Dv1Up0EwAnFfobBRkb4h5tIuIaHul49D/Qz6Fe23+MlOeA1iABfX6j42LUMsSMQ5zSNCcJagIxVn7tm8pOsVGGz6jv8LFPOv6D1a2dU8xQzypkyjjyhwJhQNROA6K5w9KD85MHT7NA0/4DPEXkQ00o9fl+dymoFNuDuG96Wrn0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482217; c=relaxed/simple;
	bh=AbO53n0scCZuKIQjF45P8pHB7ymhHMZ0RwMhXSF7GsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUt1qnJ2DmVRESv3egwoQ99OO4nNWMRXQHwcqjWDlIXTIh5Td1RgVQpku8v8STBfcay2blc1SvCCvSB2yWEl+jolIbuokC0yIgiwAB1izP91S7lC7bihanJZIaikYQZds6fp8Q433KGGRMIOZ9O9KX7R+dLsxzqXz53olJDQ3KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uA6cR0w4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uA6cR0w4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1B3C4CEE1;
	Tue, 21 Jan 2025 17:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482216;
	bh=AbO53n0scCZuKIQjF45P8pHB7ymhHMZ0RwMhXSF7GsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uA6cR0w4k786wCI0Oz5udfr9dWFYdPb2XI2GgtBRXuDH9Q3W12g++it0NmdOzrKZ+
	 iQSCZf47mlf62WMIyiXcyk3yvX90Q/4wMguMTdsosexJkWI3crsn1uCWZI3VoTZTS3
	 XfyifBSwSlWaekTzqGusM3B+i+t7Gsd81aoEEXzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 54/72] pmdomain: imx8mp-blk-ctrl: add missing loop break condition
Date: Tue, 21 Jan 2025 18:52:20 +0100
Message-ID: <20250121174525.508668811@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit 726efa92e02b460811e8bc6990dd742f03b645ea upstream.

Currently imx8mp_blk_ctrl_remove() will continue the for loop
until an out-of-bounds exception occurs.

pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : dev_pm_domain_detach+0x8/0x48
lr : imx8mp_blk_ctrl_shutdown+0x58/0x90
sp : ffffffc084f8bbf0
x29: ffffffc084f8bbf0 x28: ffffff80daf32ac0 x27: 0000000000000000
x26: ffffffc081658d78 x25: 0000000000000001 x24: ffffffc08201b028
x23: ffffff80d0db9490 x22: ffffffc082340a78 x21: 00000000000005b0
x20: ffffff80d19bc180 x19: 000000000000000a x18: ffffffffffffffff
x17: ffffffc080a39e08 x16: ffffffc080a39c98 x15: 4f435f464f006c72
x14: 0000000000000004 x13: ffffff80d0172110 x12: 0000000000000000
x11: ffffff80d0537740 x10: ffffff80d05376c0 x9 : ffffffc0808ed2d8
x8 : ffffffc084f8bab0 x7 : 0000000000000000 x6 : 0000000000000000
x5 : ffffff80d19b9420 x4 : fffffffe03466e60 x3 : 0000000080800077
x2 : 0000000000000000 x1 : 0000000000000001 x0 : 0000000000000000
Call trace:
 dev_pm_domain_detach+0x8/0x48
 platform_shutdown+0x2c/0x48
 device_shutdown+0x158/0x268
 kernel_restart_prepare+0x40/0x58
 kernel_kexec+0x58/0xe8
 __do_sys_reboot+0x198/0x258
 __arm64_sys_reboot+0x2c/0x40
 invoke_syscall+0x5c/0x138
 el0_svc_common.constprop.0+0x48/0xf0
 do_el0_svc+0x24/0x38
 el0_svc+0x38/0xc8
 el0t_64_sync_handler+0x120/0x130
 el0t_64_sync+0x190/0x198
Code: 8128c2d0 ffffffc0 aa1e03e9 d503201f

Fixes: 556f5cf9568a ("soc: imx: add i.MX8MP HSIO blk-ctrl")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250115014118.4086729-1-xiaolei.wang@windriver.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx8mp-blk-ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/imx/imx8mp-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx8mp-blk-ctrl.c
@@ -767,7 +767,7 @@ static int imx8mp_blk_ctrl_remove(struct
 
 	of_genpd_del_provider(pdev->dev.of_node);
 
-	for (i = 0; bc->onecell_data.num_domains; i++) {
+	for (i = 0; i < bc->onecell_data.num_domains; i++) {
 		struct imx8mp_blk_ctrl_domain *domain = &bc->domains[i];
 
 		pm_genpd_remove(&domain->genpd);


