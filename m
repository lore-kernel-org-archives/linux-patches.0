Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA6426E09
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 15:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1311C433C7
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 15:12:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="JB09rH4E"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Tue, 26 Sep 2023 17:12:20 +0200
Resent-Message-ID: <ZRL01DnSmYITDKSa@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 26 Sep 2023 07:21:22 +0100
Received: from sin.source.kernel.org ([145.40.73.55])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=6xO8=FK=renesas.com=kuninori.morimoto.gx@kernel.org>)
	id 1ql1Rg-00Bog8-5m
	for broonie@sirena.co.uk; Tue, 26 Sep 2023 07:21:22 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 8F7A0CE1048
	for <broonie@sirena.co.uk>; Tue, 26 Sep 2023 06:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id E88F0C433C9; Tue, 26 Sep 2023 06:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54801C433C8
	for <broonie@kernel.org>; Tue, 26 Sep 2023 06:21:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 54801C433C8
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=renesas.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7uLVIXKnD6umyvM6JVTFyT7Gh6dzVKbS0fgzX7/0bDZGhO+Y+eC3J7zPfnub1lP1UTWr/jMvaFjnb65/guZTZicJlVgJMj5vutRuPwHDaEMxt+R4EeL9g4vw2Lt/qwZuMNJmwR8PNB6gvsBahdlzNe4MSgz5nunrHuOZ1Rzyiw16x0c/DPwg6thMMorMKsx6P4HuUPJLAlnw/YEGLQ8eMXNzX8+w+qcGUjKaPnKKlC4/4/hb4sBKp4bTFfBmTPU8IHNcEIOWBGbo4fujr3N5cwA9Bqa5Dwr/x5kwztT6cEIK78cyaazfXfXkWccFETmkvOmROGw7VtjxFiIOjDIDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1AmmrThevE/c2Tti9o6Hge+7KYCu0udMgkKq8fIwe58=;
 b=b/lzvDQ7/86q50X8WmR16bJaQ4yty214drPIs3ngp0QXL2Smo3JtjrQ/KOHFy4npeUEtVlXgPlwJErnf0wYKOAaXIzPiLy679fnPBJBbDrkTbBr4GENmgtaJLEoYOWRCLqGkW0fZcwNoKc41qdDZvatRRbLZZzvexNLwqG5ViArFSa40JlY0+2uM+jVsti/GwmnaOyOyokJb8/rT6fDtI9T660TT+xMI2Zp8kz6qVOfSPoHBSqdpPv8R0EB2VunyPLd2bgPDdaZR9J6/fZyOpJ0oVWMCgpwMkw6i9CO9eYR+BPbN16HxvbF/h2TclsM2M2O0d+OQ+mV0h5tZguAY3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1AmmrThevE/c2Tti9o6Hge+7KYCu0udMgkKq8fIwe58=;
 b=JB09rH4E6FxPaGAXwBZbXU44Luxr6NR/8s/55y047Bfg12Cjocw2bZxXykUjnYnkZhSW1zW8hDzVkyHLvUFpizf5sBPgDJliUXoy1PZrWXcSQu7pGs7TScyXXUaLutaTYLdLoEY6bXBX3vF+wVRJVX6azZklPHNdUl1LjGHgYT8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com (2603:1096:604:194::10)
 by TYWPR01MB10426.jpnprd01.prod.outlook.com (2603:1096:400:24e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Tue, 26 Sep
 2023 06:21:14 +0000
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::d2a3:45df:a180:595c]) by OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::d2a3:45df:a180:595c%6]) with mapi id 15.20.6813.027; Tue, 26 Sep 2023
 06:21:14 +0000
Message-ID: <8734z1iheu.wl-kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
To: Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
User-Agent: Wanderlust/2.15.9 Emacs/27.1 Mule/6.0
In-Reply-To: <87edilihhg.wl-kuninori.morimoto.gx@renesas.com>
References: <87edilihhg.wl-kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=US-ASCII
Date: Tue, 26 Sep 2023 06:21:13 +0000
X-ClientProxiedBy: TYCP286CA0214.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c5::10) To OS3PR01MB8426.jpnprd01.prod.outlook.com
 (2603:1096:604:194::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3PR01MB8426:EE_|TYWPR01MB10426:EE_
X-MS-Office365-Filtering-Correlation-Id: 046e8508-9a55-495c-aeba-08dbbe58c8ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/nCfi3fa2ozzZwsGD6ePu/7i7W7YVJPt3ZQ/+kBaKAmXUQXuA0rObayFInRLBbxE0pAbcCas/rOOmLetY0mYQBOwO/KgA+ObKt3Dl0OH3mqonjqs1dDwW6OB26+q/BnKpz/PiTbQasyMW/OGrr171XIwFooChkJuqbb9a6Vx0lhc+DrJa7SZDEsxLc2nrLeGkFiP4rr9zfAyu4yHQ58yVDddoObtqbI4euhe8Iq4UeQt27etXKH/g2DlKuOkl5QyOXbc3PZM5dBOSKzZNwPrpD/ZL3OJBHaf6Frs7uUwhuMIop4hnO109wiUcv+GrdQwBRl0VOe3IIGCQM4h5x7GFxjLajk8ixI7fyDC8VtlEn7k8Vd3tKDafIFZvp718mwujKtPSDoLl7qpQDuAJnF9z6sD2eXc0Vb9pO26reJPGUyHwbz5RvJFr+JKOpDeug9LOJ0oOzlMJE9k2tQnmPAHNF5BgmFyui/STbDfgGECQiFLjU3YbtnY1wQR7j3j5W/eqx6VwW8t4EYyCQj/HeWi1ib/Zh7zzDuKBU2JjaB7gLI8bwCJa1Gzt6EXgaOX5Go7F6DHnrwFDcLxjHcIsM7vmY9nmslr5JNPK4eiEPvIlvaQnozZl7nyjiF5RQOd86rHnS6BK8cZ/LkYxDgKoqCgNA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB8426.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(376002)(396003)(346002)(230922051799003)(1800799009)(186009)(451199024)(6506007)(6512007)(52116002)(26005)(478600001)(66476007)(66556008)(66946007)(86362001)(2616005)(110136005)(6486002)(38100700002)(38350700002)(83380400001)(2906002)(8936002)(8676002)(36756003)(4326008)(5660300002)(316002)(41300700001)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gNNruB3uX5m8x/TSoowGx47D8mcv/hnrQ2pLc56AhH0FcdzVH1q/9SxoTt32?=
 =?us-ascii?Q?VDqBp8jntO2wU6kJd8JskiT9qN4EMpgf2BMTr4KVFxPW83kktc/e/lOTjNe6?=
 =?us-ascii?Q?tANOEyjGOaYrQTDVgTmes7TQmIUnx5ZwzOx1+jsrucWEo4y3rwdFLF7KetnS?=
 =?us-ascii?Q?+7uUJ0wBqwtTKxxOK1LDOWOhsJ3lNwxcptNedK2/oVnoIOMagSWoqjDMEwFe?=
 =?us-ascii?Q?eVuJbqws83ThcCwwwe07rQBLGQ7Nha0FsUTSGD9KektUTiwuxvNmEbzJv0rz?=
 =?us-ascii?Q?Y9aYrTqBv5wH9esriP2C+Dy5WaMEPpI8KFjaTVFXd5icWdpd8A6ppJ8J6Fzu?=
 =?us-ascii?Q?GpU/EpE2/4AF5XS300Wld/9IGLPtx9tBEi4TgZsnpRUcH68CdeHrhW83fjpA?=
 =?us-ascii?Q?uA0D8qSiC6lbd/tm34wLLdXY3YqAtf1Vv2QfVoITt2Uj0uxQuI8keZdqZXpw?=
 =?us-ascii?Q?zzzNcwj0DqKZ0OEcHHiX26dagtOWoGSQkDm6n2efhtk9338uLqTc/JTMHQ9K?=
 =?us-ascii?Q?6/l8e1mqiUGnXk5DZj2+TrPrzOEst8uI5xOZUglX3ZdeUJlkozPvetE3DoHG?=
 =?us-ascii?Q?4mYwVJR7NurwYHEPpLBicOXTs6YqoOX4zqqraGxd0pDlI1pmGwrYXM27Gp64?=
 =?us-ascii?Q?1b8ogniyYOiCJXo4KXrtVshS7nSYDpnUiKZtHyeP7QCdYRSf+47bez+scgOJ?=
 =?us-ascii?Q?qhMFM/Xuj1IGcrquzJxrMmBQh43Xf1js3FhroVbXwSNy0LPTFjmdk28OMglo?=
 =?us-ascii?Q?OPYIXanTPXan/M/q5wRttlI7zgGxxajVXOWIo4LrxaUQxtWDLutwfDIMSf3E?=
 =?us-ascii?Q?hz6K+F7xxGdS7Kpu6ojlyg6DpZDmee8YnrD91kEfN0kHj/JBTauYyi8HJ8pA?=
 =?us-ascii?Q?yS2ph34fhyqY+waZG+NILAaAokZPABrf0fgAureqNRHFl+T1pNN8AgXaaHcA?=
 =?us-ascii?Q?4SLgKIa4RlJStCxbISy2n66tbRnm0OI7MqGJw2iWShY1vnNW+GjMeknniM5x?=
 =?us-ascii?Q?TnR5gK7cu41E8SRMm8CCAFCwU8umLgV4y7Ev7avzwpTOPPwrD1OJZKHYe78w?=
 =?us-ascii?Q?E6Syieaz/eE+oyUp2ItoIRdzlc+yaECwoLyKW0OBwcsmIEoiM15sCiIPmDqy?=
 =?us-ascii?Q?+gP2YQ2WHxnUUZukhYjlCVsseTZF6UBBnF/5Nl3nrGah2VV76bkpClgRP+uo?=
 =?us-ascii?Q?QTwzzeW6Rg2oUuueofWkOV7FoAikiNGh0RPbi6SOKPsT0VOdbCWKTlDm7YgQ?=
 =?us-ascii?Q?AAnU/wcadNJ/08KSd6jq6PPkD5J7iZ9vhoHyciblwAMyDIKRXPgIZZLU+G4h?=
 =?us-ascii?Q?dldRCgifDz2i+mKZx3QQHuobOzgz/NYnAX9xnmyphQ65fCp7gXzvz1J4b7X1?=
 =?us-ascii?Q?PjYQazPjRvoGXYcpdjKGYW/ErXzWqVAGG53wqaJSRU8QuXMXXiEAWoYNjKWF?=
 =?us-ascii?Q?wWT/6aSeKlgjZ16CdCSTIA9FfrHC9DcHat+SIUGvrLdQS4kfFhMRUAmVlZtE?=
 =?us-ascii?Q?lr+t7uC6zyDTBAavhUIn3uEX8C2RUGzRQYfx6cmeDl5l73RxHNguiXyJbzCR?=
 =?us-ascii?Q?XPUTvSWOftol7rhCQWz5h/l1NfNsJ+kBC2Ch2vXLKBdrgMv817Pk/Gs9+e9W?=
 =?us-ascii?Q?I98kTgFw3kI9UIG4tu/CS84=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 046e8508-9a55-495c-aeba-08dbbe58c8ee
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB8426.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 06:21:14.1527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +An4QBk0O4HWVkk11Q3jwdvFHv5G9ZXh5WqCfzIPcr/k+VlLVLJJ2wBAUnPTUZVsj1vHKFHLlmu8mbBGnXZr/+qNvuD9z1e03HkPG7f4OIZ773ZsS0CxkNKP637Zf9l9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10426
X-SA-Exim-Connect-IP: 145.40.73.55
X-SA-Exim-Mail-From: SRS0=6xO8=FK=renesas.com=kuninori.morimoto.gx@kernel.org
Subject: [PATCH v2 08/54] ASoC: dwc: convert not to use asoc_xxx()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: g8qj/TrdXdAU

ASoC is now unified asoc_xxx() into snd_soc_xxx().
This patch convert asoc_xxx() to snd_soc_xxx().

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
 sound/soc/dwc/dwc-i2s.c | 2 +-
 sound/soc/dwc/dwc-pcm.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/dwc/dwc-i2s.c b/sound/soc/dwc/dwc-i2s.c
index 22c004179214..2ff619a29655 100644
--- a/sound/soc/dwc/dwc-i2s.c
+++ b/sound/soc/dwc/dwc-i2s.c
@@ -235,7 +235,7 @@ static int dw_i2s_startup(struct snd_pcm_substream *substream,
 	struct dw_i2s_dev *dev = snd_soc_dai_get_drvdata(cpu_dai);
 
 	if (dev->is_jh7110) {
-		struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
+		struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 		struct snd_soc_dai_link *dai_link = rtd->dai_link;
 
 		dai_link->trigger_stop = SND_SOC_TRIGGER_ORDER_LDC;
diff --git a/sound/soc/dwc/dwc-pcm.c b/sound/soc/dwc/dwc-pcm.c
index f99262b89008..a418265c030a 100644
--- a/sound/soc/dwc/dwc-pcm.c
+++ b/sound/soc/dwc/dwc-pcm.c
@@ -139,8 +139,8 @@ static int dw_pcm_open(struct snd_soc_component *component,
 		       struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
-	struct dw_i2s_dev *dev = snd_soc_dai_get_drvdata(asoc_rtd_to_cpu(rtd, 0));
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
+	struct dw_i2s_dev *dev = snd_soc_dai_get_drvdata(snd_soc_rtd_to_cpu(rtd, 0));
 
 	snd_soc_set_runtime_hwparams(substream, &dw_pcm_hardware);
 	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
-- 
2.25.1

