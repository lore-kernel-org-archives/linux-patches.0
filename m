Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED3330CE0
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 15:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E9DC433C7
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 15:12:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="gEIRMHVT"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Tue, 26 Sep 2023 17:12:37 +0200
Resent-Message-ID: <ZRL05XPElqlu9DJF@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 26 Sep 2023 07:21:54 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=6xO8=FK=renesas.com=kuninori.morimoto.gx@kernel.org>)
	id 1ql1SB-00Bogx-MZ
	for broonie@sirena.co.uk; Tue, 26 Sep 2023 07:21:54 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id E43D5612BB
	for <broonie@sirena.co.uk>; Tue, 26 Sep 2023 06:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id A94F9C433CA; Tue, 26 Sep 2023 06:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1195EC433C9
	for <broonie@kernel.org>; Tue, 26 Sep 2023 06:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 1195EC433C9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=renesas.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgcoS/40gc3MoN2yAv7I8UekcesfsLrIdrKPo6mz/FsSUpVmDjPARQsMn4qTBkEq/BWDHpZKlayV6pnIyUFTme7hJGV0Xz4Rn08mdIMw0pCUKu9U98MSAzkESH0X9TMQWFHONse5+CwaTkRdSxBColZ8cPfByTvTnpCLWCMDpJJrpE4Tk+8KfkGDzx652L33ke9LoMcpCVVRy9B2Ker2/hs/IIRoB09w7vREWAXX++WsQTbavV5qFaM7NR1Z8Piuv+0vsSY0QaQsjuRas79n35D2bJpZxDhvmQLcdfRF3LF49GS0Vjrznzf3bD1xxOWR0fQUjJ1iQVQDSsqSVwIgSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+qXuJbi/RQ+sUPbeR3VdxtysTfw8xOU/K8ymi3pT2I=;
 b=VwRM+vXzLM2vPLKiKGM3qBi+LQmKrzCC7s4M3eySUQl/u5T7QbClUZy1IW+gCuR9e56zg3TKC2ZmKmMjmiA4dRfM1adVnpnyZxe8pOoXwefmC2cMt7PiHRHXjknuRBi4kh3eqPRv1NdE8yBq3JwDSRJM/qOoHsceLolih7x9GX22lGuSFDVM/Xb5OKrLBBzon/khHDyR2B4JaStWkbN+txyAsljd2UlAbcEHlv1oINMZYutMMjHfniN3ZFJWogOi3n5J/Y6XgNjwFOEzSFsN5o3PKV6bui8mL7xtgiI0ijUOV3CZiVuMoslM8jrUjpJEaocQCzZ7Y/YMy4j0MeRFzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+qXuJbi/RQ+sUPbeR3VdxtysTfw8xOU/K8ymi3pT2I=;
 b=gEIRMHVTZwR0NSnVKoIQzoth8mNVtMwOPFXWTCsp8TqMF3lcwh4sbn6IKMm6TkcavjHsgYGS03ETjxUOfJXs3rgIL+eVpRoRbFcaZfmBfjXJl0a731Rs8C0f7hlp981DzjclnNE0T+En/mgSLhXzv0d0uMrFaLDRBnvd1m/pW+A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com (2603:1096:604:194::10)
 by TYWPR01MB10426.jpnprd01.prod.outlook.com (2603:1096:400:24e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Tue, 26 Sep
 2023 06:21:46 +0000
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::d2a3:45df:a180:595c]) by OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::d2a3:45df:a180:595c%6]) with mapi id 15.20.6813.027; Tue, 26 Sep 2023
 06:21:46 +0000
Message-ID: <87v8bxh2ti.wl-kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
To: Alexandre Torgue <alexandre.torgue@foss.st.com>, Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>, Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, Olivier Moysan <olivier.moysan@foss.st.com>, Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
User-Agent: Wanderlust/2.15.9 Emacs/27.1 Mule/6.0
In-Reply-To: <87edilihhg.wl-kuninori.morimoto.gx@renesas.com>
References: <87edilihhg.wl-kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=US-ASCII
Date: Tue, 26 Sep 2023 06:21:46 +0000
X-ClientProxiedBy: TYCP286CA0056.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b5::17) To OS3PR01MB8426.jpnprd01.prod.outlook.com
 (2603:1096:604:194::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3PR01MB8426:EE_|TYWPR01MB10426:EE_
X-MS-Office365-Filtering-Correlation-Id: 315b738c-5fce-4578-214c-08dbbe58dc29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kyNZUzMCxJmFhHc4oGZNWVxQLtEi5pYHP/X4ij7+PbOHm4AE0ko0tj3XZ4/ViruAGW06Fsd2EY7K8gi+rc94Zf1KMsoll8UPnEkhFyOQwG9sQV0Bbxljsmo1vrGFW6WXGNoSprdmBAF0FPJuZPgO2vnfCuCdhy8eCzeJsOS2SK8XBjY3Y68OBeD38Upw01xss8KQrZTu0ezquR+KdyEQ0B4d/MPqD7S0dS4WEtZE/K91q/Uz32dIMC0L0NJ8kSTZRFndJmkpvmwMBQ5OXeQo67tCa0V1blcG+RT1GEH3D31EDKwiHujKOgGQRAElLhOJU4+Nk8uMVaTavzqAMx1EBuSkyfWAfF0G9iRVI3VT77iWKuh82/kR4RUVO8Cug+fPFMY033O7eyYXnnLsN8MtmdU14IHUWjDT831+GoEbYOpFgHkKovAK4Xb6hTLUMmKCQ3IFc9tD7YnBm00rfN6tqe8Uaj3quG0TSqyl0GWSrgTt1m9xlcQkEo6vd93PSBuORzkm1QYkFrVnwdnQO7pFTp5dYX8wjTDlFN6tGY8acO029JTeyQ1jfq2mlB2dZkmXDXWXmEHsJU+OoDVvtbeEwR87xrGaSuq/V2Npz9w31QpEyNzbttsAdbAgQN0wqcOoomRMT+9sdnTcCDXgDyVSqQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB8426.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(376002)(396003)(346002)(230922051799003)(1800799009)(186009)(451199024)(6506007)(6512007)(52116002)(26005)(478600001)(66476007)(66556008)(66946007)(86362001)(2616005)(110136005)(6486002)(38100700002)(38350700002)(83380400001)(2906002)(8936002)(8676002)(36756003)(4326008)(5660300002)(316002)(41300700001)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nrhBdxtJARAOu42nLzo0q1zto47Z77AApMDyJp8MWPRUroyOpFhla5hPiWU8?=
 =?us-ascii?Q?ADkObSmzbeBi53TnHW6VwB+YA53OcGSCwZyrbd406wpdN00FmfbhhBIwe8uE?=
 =?us-ascii?Q?OrrAvNVcSDbntTmG+Ha1k707BY+1XMfz5Me2COTVawkY+jVl5oxNfICC19wA?=
 =?us-ascii?Q?3U9SI+you8LZ87FyLC8f8+X8ir7IQ5xWlLcACpyT1+FiKiJk4HoXDwECEIor?=
 =?us-ascii?Q?0ZbNQdE6ealweNz0wjkNqAF3Rsww9RgEBz7Kib6y5fRlUoKHpxWsKH0MjtqX?=
 =?us-ascii?Q?ifoQx+E4mnoSGKuHjUp4CqNOYRzmTcJBldYFhC22Bcuo4zS3EUeQAqiCjQnl?=
 =?us-ascii?Q?BZXTvOn2OwFJG744Yzd3HyfXHRIoC0JGtxBufYJqa6+QnFWEAgDs4yFlG9P9?=
 =?us-ascii?Q?zk5J/24bNuh5eBcR3/mVfmZB2Iufo04kLZoaW28N/zQxlqOfefIFBwzOWEY6?=
 =?us-ascii?Q?00IZA5M6V6HO/6PkIezKrdJy7dwlhpClX7ZaObxIbSDfdnBgjiKHmTb6APUa?=
 =?us-ascii?Q?15+LltldxMnO/d+A0oYk/QTGn5iUmlHyDYzMKeBOo0nUldY/Ar41alIrSTvb?=
 =?us-ascii?Q?tqTqX9NQqSUn+slMGvU4L+c4i2VZjHNdCXVd3c1RehzZZ974TSe7wec5SXLo?=
 =?us-ascii?Q?a2unz9nRlyPZIz03UUGTNdGBJo/q/V1Y9puIPNCXsfPVsgyqZEvFxTIg44cu?=
 =?us-ascii?Q?13w2MpCSyVRcho431I0whn6cjiqT3D9RWnyXcdRfxazi+0lG3vCMsqilPOvb?=
 =?us-ascii?Q?vhR3sdPD64CV0Pb9LfeXfN204nt2oJULJCLm0zStWnXG/cZSyOExzuUsXQp6?=
 =?us-ascii?Q?f4o9unEBMdsQqSKoMPFQq/KL+RGgkuvm4H4sqZqIbc2tIUqWZu3yTRWD3b1Q?=
 =?us-ascii?Q?N+vntJuH3x5mnbOTRAhkDIY0K25Mg3wZuBqOl4KqCjZPA1JjBOv7qUJRfhj7?=
 =?us-ascii?Q?mDel4Y340h8pgAAv+wH80UrY7kudCDlNr+xE6hi5jG5+OFHl3CDjUtfD4Yl5?=
 =?us-ascii?Q?1dDKJH3zhnrE2Mb/q/cOvrfQ+BryiTh864Qfxlrkjl594VeQgb/3RPKIW0r0?=
 =?us-ascii?Q?DOdVf3lEHE7iflXCJ5K2+jcu7J3+qlOUZ+P2Zg6IrC82v+vlYFrO03cUs8uU?=
 =?us-ascii?Q?o7LfQYJcYMZoC1gutsusfxFOR466QpHQWOcIQcBo+EIiPJzVQHRkNesJUDBp?=
 =?us-ascii?Q?N1vQD/3/eH5h2K5S47DHzPO6QiTWPNcOXqtXMuQKtYTKv5JQRADJn7ikGORr?=
 =?us-ascii?Q?LWHlX673nCr6iA+gxptNzcseG/0fFU9yh/uughKP+xvARre4/VhwAT8wI7nV?=
 =?us-ascii?Q?lczdgfpAoILqGy/EIYtaiiRx6VlvHZxEzmoBkOZH4hxBDgPPrTuZtszfsq+9?=
 =?us-ascii?Q?idjgttEMJJj1L4r970Cg3KcEcmwGuPgRueTGQyTgxE7msye5F50fPH6ROlCH?=
 =?us-ascii?Q?a4b4dc7pg1DReqW548XUls9shPpnEmJRtn5++L3+/G76TIB4IqXjlhAseqAQ?=
 =?us-ascii?Q?dSrK1odpq0EEoyMEPssoLYSHHH3c8UfZEyFH4quSHBNuhDzGL9fFAdyOIkn4?=
 =?us-ascii?Q?bEj3dhSYzo3M8+FzJIYfVOngjvpjdXcb8xC8HJVglrJmPBluq6FkSA1t6HqS?=
 =?us-ascii?Q?lVOs+YRW2znNADpTOL8jP/M=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 315b738c-5fce-4578-214c-08dbbe58dc29
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB8426.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 06:21:46.4388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: alV3OOzTlDSFwZMLPY4++yZGFjGUuOOtMmnrJE+e5z8g+920qg2rqmUvqH3SW3/0H2s0OYE5pTERGCcHUHgmNN9u2EfjHME+NvKbeuk5HTMzWh7NU+qZloLQAjO63Fzc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10426
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=6xO8=FK=renesas.com=kuninori.morimoto.gx@kernel.org
Subject: [PATCH v2 13/54] ASoC: stm: convert not to use asoc_xxx()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: vWgxMp3L+8UR

ASoC is now unified asoc_xxx() into snd_soc_xxx().
This patch convert asoc_xxx() to snd_soc_xxx().

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
 sound/soc/stm/stm32_adfsdm.c  | 24 ++++++++++++------------
 sound/soc/stm/stm32_sai_sub.c |  4 ++--
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/sound/soc/stm/stm32_adfsdm.c b/sound/soc/stm/stm32_adfsdm.c
index a8fff7378641..fb5dd9a68bea 100644
--- a/sound/soc/stm/stm32_adfsdm.c
+++ b/sound/soc/stm/stm32_adfsdm.c
@@ -167,7 +167,7 @@ static void stm32_memcpy_32to16(void *dest, const void *src, size_t n)
 static int stm32_afsdm_pcm_cb(const void *data, size_t size, void *private)
 {
 	struct stm32_adfsdm_priv *priv = private;
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(priv->substream);
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(priv->substream);
 	u8 *pcm_buff = priv->pcm_buff;
 	u8 *src_buff = (u8 *)data;
 	unsigned int old_pos = priv->pos;
@@ -212,9 +212,9 @@ static int stm32_afsdm_pcm_cb(const void *data, size_t size, void *private)
 static int stm32_adfsdm_trigger(struct snd_soc_component *component,
 				struct snd_pcm_substream *substream, int cmd)
 {
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct stm32_adfsdm_priv *priv =
-		snd_soc_dai_get_drvdata(asoc_rtd_to_cpu(rtd, 0));
+		snd_soc_dai_get_drvdata(snd_soc_rtd_to_cpu(rtd, 0));
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
@@ -233,8 +233,8 @@ static int stm32_adfsdm_trigger(struct snd_soc_component *component,
 static int stm32_adfsdm_pcm_open(struct snd_soc_component *component,
 				 struct snd_pcm_substream *substream)
 {
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
-	struct stm32_adfsdm_priv *priv = snd_soc_dai_get_drvdata(asoc_rtd_to_cpu(rtd, 0));
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
+	struct stm32_adfsdm_priv *priv = snd_soc_dai_get_drvdata(snd_soc_rtd_to_cpu(rtd, 0));
 	int ret;
 
 	ret =  snd_soc_set_runtime_hwparams(substream, &stm32_adfsdm_pcm_hw);
@@ -247,9 +247,9 @@ static int stm32_adfsdm_pcm_open(struct snd_soc_component *component,
 static int stm32_adfsdm_pcm_close(struct snd_soc_component *component,
 				  struct snd_pcm_substream *substream)
 {
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct stm32_adfsdm_priv *priv =
-		snd_soc_dai_get_drvdata(asoc_rtd_to_cpu(rtd, 0));
+		snd_soc_dai_get_drvdata(snd_soc_rtd_to_cpu(rtd, 0));
 
 	priv->substream = NULL;
 
@@ -260,9 +260,9 @@ static snd_pcm_uframes_t stm32_adfsdm_pcm_pointer(
 					    struct snd_soc_component *component,
 					    struct snd_pcm_substream *substream)
 {
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct stm32_adfsdm_priv *priv =
-		snd_soc_dai_get_drvdata(asoc_rtd_to_cpu(rtd, 0));
+		snd_soc_dai_get_drvdata(snd_soc_rtd_to_cpu(rtd, 0));
 
 	return bytes_to_frames(substream->runtime, priv->pos);
 }
@@ -271,9 +271,9 @@ static int stm32_adfsdm_pcm_hw_params(struct snd_soc_component *component,
 				      struct snd_pcm_substream *substream,
 				      struct snd_pcm_hw_params *params)
 {
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct stm32_adfsdm_priv *priv =
-		snd_soc_dai_get_drvdata(asoc_rtd_to_cpu(rtd, 0));
+		snd_soc_dai_get_drvdata(snd_soc_rtd_to_cpu(rtd, 0));
 
 	priv->pcm_buff = substream->runtime->dma_area;
 
@@ -286,7 +286,7 @@ static int stm32_adfsdm_pcm_new(struct snd_soc_component *component,
 {
 	struct snd_pcm *pcm = rtd->pcm;
 	struct stm32_adfsdm_priv *priv =
-		snd_soc_dai_get_drvdata(asoc_rtd_to_cpu(rtd, 0));
+		snd_soc_dai_get_drvdata(snd_soc_rtd_to_cpu(rtd, 0));
 	unsigned int size = DFSDM_MAX_PERIODS * DFSDM_MAX_PERIOD_SIZE;
 
 	snd_pcm_set_managed_buffer_all(pcm, SNDRV_DMA_TYPE_DEV,
diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index 0acc848c1f00..8bcb98d9b64e 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -1249,8 +1249,8 @@ static int stm32_sai_pcm_process_spdif(struct snd_pcm_substream *substream,
 				       unsigned long bytes)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
-	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
+	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
 	struct stm32_sai_sub_data *sai = dev_get_drvdata(cpu_dai->dev);
 	int *ptr = (int *)(runtime->dma_area + hwoff +
 			   channel * (runtime->dma_bytes / runtime->channels));
-- 
2.25.1

