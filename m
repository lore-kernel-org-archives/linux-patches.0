Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E912B4684
	for <patches@lists.linux.dev>; Tue, 12 Apr 2022 12:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CDBC385A1
	for <patches@lists.linux.dev>; Tue, 12 Apr 2022 12:32:16 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 12 Apr 2022 13:32:13 +0100
Resent-Message-ID: <YlVxTVLMWbF804Ef@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 12 Apr 2022 13:28:09 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=qkSS=UW=mediatek.com=rex-bc.chen@kernel.org>)
	id 1neFct-008fRQ-Lf
	for broonie@sirena.co.uk; Tue, 12 Apr 2022 13:28:09 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 5A6E161699
	for <broonie@sirena.co.uk>; Tue, 12 Apr 2022 12:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D4141C385A6; Tue, 12 Apr 2022 12:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45DFFC385A1
	for <broonie@kernel.org>; Tue, 12 Apr 2022 12:28:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 45DFFC385A1
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=mediatek.com
X-UUID: c52d90e3ce51492aa708dae783fdfe10-20220412
X-UUID: c52d90e3ce51492aa708dae783fdfe10-20220412
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
	(envelope-from <rex-bc.chen@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
	with ESMTP id 851005236; Tue, 12 Apr 2022 20:27:57 +0800
Received: from mtkexhb01.mediatek.inc (172.21.101.102) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 12 Apr 2022 20:27:56 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Apr
 2022 20:27:55 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Apr 2022 20:27:55 +0800
Message-ID: <29a0d0e1f9ad2f14be56410e5a9e123d6a35dfe3.camel@mediatek.com>
From: Rex-BC Chen <rex-bc.chen@mediatek.com>
To: Allen-KH Cheng <allen-kh.cheng@mediatek.com>, Mark Brown
	<broonie@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>, "Ikjoon
 Jang" <ikjn@chromium.org>
CC: <linux-spi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<Project_Global_Chrome_Upstream_Group@mediatek.com>
Date: Tue, 12 Apr 2022 20:27:55 +0800
In-Reply-To: <20220412115743.22641-1-allen-kh.cheng@mediatek.com>
References: <20220412115743.22641-1-allen-kh.cheng@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK: N
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=qkSS=UW=mediatek.com=rex-bc.chen@kernel.org
Subject: Re: [PATCH] spi: spi-mtk-nor: initialize spi controller after resume
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 5kPHMVfJ2DaN

On Tue, 2022-04-12 at 19:57 +0800, Allen-KH Cheng wrote:
> After system resumes, the registers of nor controller are
> initialized with default values. The nor controller will
> not function properly.
> 
> To handle both issues above, we add mtk_nor_init() in
> mtk_nor_resume after pm_runtime_force_resume().
> 
> Fixes: 3bfd9103c7af ("spi: spi-mtk-nor: Add power management
> support")
> 
> Signed-off-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
> ---

Reviewed-by: Rex-BC Chen <rex-bc.chen@mediatek.com>

