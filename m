Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C38F30CE0
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 15:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F996C433C8
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 15:13:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="T4TZtvhT"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Tue, 26 Sep 2023 17:13:34 +0200
Resent-Message-ID: <ZRL1HrIxC+gkRbpe@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 26 Sep 2023 07:24:12 +0100
Received: from sin.source.kernel.org ([2604:1380:40e1:4800::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=6xO8=FK=renesas.com=kuninori.morimoto.gx@kernel.org>)
	id 1ql1UP-00BokY-Rp
	for broonie@sirena.co.uk; Tue, 26 Sep 2023 07:24:12 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 64BCDCE08D1
	for <broonie@sirena.co.uk>; Tue, 26 Sep 2023 06:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id B94E2C433C9; Tue, 26 Sep 2023 06:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21538C433C7;
	Tue, 26 Sep 2023 06:24:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 21538C433C7
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=renesas.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vq7hQMlSPzPDGuXpw98g1gpPbYfxoEDB7vbrUgK11Ub5BAK/uXuXsDMxOzIg2CMBduQEVNK1RR7WX8G3cNsWsCj+TnqapNRbJ/pLeN4aqqa3Wt/+M6BFi+1WWCvkc+m5r5YlKLFGuwU2Tjd1lScUuSn0TRHsb+u4bOmQKjBSA+8KOYgK42nWNI8kLKk5uZ2QigwK0E8EP12BnFY8n8UlGz27oWGVAZSulvO/qyXVYUKwZg17/l0gfh29enoqVaFW413heUrmkdxgmICnevMomI0YlCpO/2bl0Qv0d4GQsFCPKOmjD8/pzGCBkgQg9APUw0m62frdvUMx/cBfvahWTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2kcnjPGUbBVhOLAAYUiQc6GMPOwV1kPDA951QDgKZ0=;
 b=M2yb6Qzokw+m4uGJaKmR2c9S4SusrVjLrw0T84FdFGJbTJ6ko9l4J6/Am5I3VOKuUg7Al1k2qtFn+5x4U4rmvkx6tM55knpLHRKO01PxsjTXIwTOv6IbleLogCTd3yBfA5DdmI9WeuJha5LC6ATcchW/ABdbIoyIIiyZchUv/1JI7tb7yg8y/4FjK+UIiQfcwWCwERzPboVrUWFAC8c34NxdFabTYmYW0Iu9LzERczCvid/+p/+aIgVirkceCmpwrRTEQjt2cHBQneDDgKU7dumaXX12Ia0DDtAbIvxZSQ8jbAQdTGzmmpomEwc5HQRaKwSyKGveHsyRXnQnrKB1yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2kcnjPGUbBVhOLAAYUiQc6GMPOwV1kPDA951QDgKZ0=;
 b=T4TZtvhTt7PJ0RKdbgclIdejNz0+dHBWLvyUWyM7HSDGoi+VrdJXgzWXCX9/mp3hNpsLAMCY/eHu8JY+9BrDXFSqseW/8qX8TD8focA2Vu5UYkBgbAIK4Ln+tCkvHfOCt3sCPCEW/1rdTV6Tqbe/rUdTWyhJ2AjaG9qwAFnK0BA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com (2603:1096:604:194::10)
 by TYCPR01MB6175.jpnprd01.prod.outlook.com (2603:1096:400:4b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Tue, 26 Sep
 2023 06:24:03 +0000
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::d2a3:45df:a180:595c]) by OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::d2a3:45df:a180:595c%6]) with mapi id 15.20.6813.027; Tue, 26 Sep 2023
 06:24:03 +0000
Message-ID: <8734z1h2pp.wl-kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
To: Jaroslav Kysela <perex@perex.cz>, Kunihiko Hayashi <hayashi.kunihiko@socionext.com>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
User-Agent: Wanderlust/2.15.9 Emacs/27.1 Mule/6.0
In-Reply-To: <87edilihhg.wl-kuninori.morimoto.gx@renesas.com>
References: <87edilihhg.wl-kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=US-ASCII
Date: Tue, 26 Sep 2023 06:24:03 +0000
X-ClientProxiedBy: TYCP286CA0157.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:383::12) To OS3PR01MB8426.jpnprd01.prod.outlook.com
 (2603:1096:604:194::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3PR01MB8426:EE_|TYCPR01MB6175:EE_
X-MS-Office365-Filtering-Correlation-Id: fbe15b2b-5539-4f08-45f9-08dbbe592dfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8XiqoEdyRJJyfEPtuKc+qHNVCqdV8enSQy1+SKMQfUxHxQZTjEdnq7ti7CLnVqAp0QG6MtVgoWTQjIKXJfMOvkD+DURN79ca5P+WZJvjUYC/ltb/973AqHDEnT+Yv2QhUkdXApRzjkxMzdIXJJGHkKVNtIjobI0TmwARdx+KUbjVWCEkpa/TFCvMNkXSDaF6qv2/q1t3JS+udhhbEmJOFmmCHTjUeyO+m6R9Wd8mfPWI4F+t+Eesnw/WeHYs7uhVcFIrE43axmSi2QZFPiX3L/+iIvBoELoPNfK4P+2BIzoNEJQB2rcLOXdQp1LlpXZ07EhV1ke6Eb9y8Cpn0o/jPupOtYJQgSAW8/TRbqKR+L2pAfTFLHmWopn1A74M/VzSi5AUu7E/NPbu19t1hZrIwtefsA6DNuZNG9idJDcSkZKh/ZOWYX7CV2+21ONx8AW+MlFV+NaDPY8Vk7beOJi7BjWUjr9u3uhb9wgH5uUkmmHhv7wFMpDP5Qz9xy/7hLKVIvn7DgLNcNHgL7rBVbcgjIJauxFIu5gB+z4F9xwbbWxiq0yr9Z4IR5C5gCZiV5aLyJKF4Nyn1DK0DdZJbn9eoibMq1jfoSJbxx1+gfXxTvsYr/loAQ+flrBs+LPf+0TjBDEj6gJepfr/fI0L4l6mrQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB8426.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(346002)(136003)(39860400002)(230922051799003)(1800799009)(186009)(451199024)(6506007)(6512007)(52116002)(26005)(478600001)(66476007)(66556008)(66946007)(86362001)(2616005)(110136005)(6486002)(38100700002)(38350700002)(83380400001)(2906002)(8936002)(8676002)(36756003)(4326008)(5660300002)(316002)(41300700001)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FC5h5BK2dK90iTvbNQrvdooFtmDcAd4AtdwAm24/42+az687MinpcurDJHnm?=
 =?us-ascii?Q?eyHTSFuU+GqIM8cYeU3ritppYTPZrijoSvZMtD6XcocMAN138ddvfFKBE9kP?=
 =?us-ascii?Q?T9yKXpngm9K3NwSD6RuCyXnFnHpWFpjRmCjzadR97PGoSKrxGKI5dm1sJHpT?=
 =?us-ascii?Q?/04GyOos/rNIWFs9ikt/LvLuLCF1wR55N25uQDZDFE642Ny62asFUjQK3TPX?=
 =?us-ascii?Q?o7Bo4K3Jc/WTvWZ1fxwAm2ZGWrxw1iIfXeJDwNjbISgacBGSNBy33Cy2OWIi?=
 =?us-ascii?Q?LtMe535zgQVmYvkHOhzqAHqr32haRhKKz/73QOtqpJ/eZclGRCDyeys152NT?=
 =?us-ascii?Q?AnbuvTD7V7LHWqgwIPYJEtxAUJIie1r2yEZ5ikh+fq+4jbkKU3lXgbZKAby+?=
 =?us-ascii?Q?hxZjNTinbhwJFU2UmB30/lodn+tCF3ffsDg7tPUe4LemxNMF+353AVE+W9QM?=
 =?us-ascii?Q?qgCRvhvZgImYMYdSB5TyksaUBaZnWoe3awIkQB0WKqhcxinJGjuiPXoQM8dV?=
 =?us-ascii?Q?DnrFBH3gWH8QpHNqxYBxUCaYiyyMUHgfLUyvmdifOu+voCxUb7Ww1AzTcN91?=
 =?us-ascii?Q?+/lxwr6Zd4vHusIB/ZqpfHj7MuJa5r1ftukFnWCvgGVfIFx5vHrK3MNXnTXo?=
 =?us-ascii?Q?dNirrpFg9OL6pQsgDU+FlCKv61NALpCu8PvaTWaliEJ5/RFpoy4RbPUocJrO?=
 =?us-ascii?Q?s5C6QFc6VfSL3L0gqWADEz5zMHvQHVuxyt2k+lJKo0UrVDb90IMH/nNtAHnR?=
 =?us-ascii?Q?95Ih/w8AmbGkbetdr8RyQqTpDrgrmNdbs4DUoimksfK8OFooL2VZWdOt82B7?=
 =?us-ascii?Q?da4RGn2PXWKng+B/o7UQDGpZBOFsMKR6uKFPnPknsEr3qXdpklMAqzyg2nv4?=
 =?us-ascii?Q?iXL93bJAJkaX+ugPdOO+/xt87MyPV9ZDS/Knqr4xcakfdDmy1G74RC70Tbnm?=
 =?us-ascii?Q?+ohGfOLOVvMEZy/y26rP2EngiRuvKSo/2Ijw7eLJqWHXzgj89Ji51GHjiytF?=
 =?us-ascii?Q?u2wOVSaiQyZg23VJ5U4uViwYVt1OSY2Mc+1AtGo649gAc2/7vW8Rsgavfr3G?=
 =?us-ascii?Q?R2jdP7zo631qelJonoLExf3ojgAumA61IntwIJa/LxA5LRaG8oQWh140kaqJ?=
 =?us-ascii?Q?j7p1uEgFDllKsoKBIWiOiQASSHiM2V+uc2wp2wi0ao/5qF/ATwkHGyQ/sZSY?=
 =?us-ascii?Q?1Omlyo/9mD0nUcUSFOd3KExR/ocPkNOTwbudE4MJsLI+fRnn3gntJ6kz+i8C?=
 =?us-ascii?Q?d93QUyHxXh8Ba+HRCC9ZNw9ona6u5HxaWUkz7CjlN3YNNr3s+5riHMpIoQkZ?=
 =?us-ascii?Q?Qipv0TQbRFre+8bZCnqDDIt9OF2yEX/8A96h3gNvQTHwvOvTlqLfuGB7z3tP?=
 =?us-ascii?Q?DmFE568QpAlI4WAQ4T71D4YG9er8dAZL7MQNWtWYcUYvAW1YhCyBX/HdqQ74?=
 =?us-ascii?Q?uVw4m9C9dzD23wnrPj15CAUY+wwGaAYxPUnDmxy8Lw5VaiaIUrE1VpUM8A7g?=
 =?us-ascii?Q?fqRQrfHNbzwXwlrgtIRCnzsfXRpCx/WZKxzQBX+IFZe/ucZk21XsxW8xOWsf?=
 =?us-ascii?Q?3fABoG7F55xdkTNNLrUG8XwsI6gtjDji4ZZTWJTFn6whMbozqFRlj3Jb2OgY?=
 =?us-ascii?Q?cJMJRr+yqmMRmCYLGF0oArg=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe15b2b-5539-4f08-45f9-08dbbe592dfb
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB8426.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 06:24:03.6954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrH0foz8XoRLi7D1vJ0hHSt1QmchcVQavmkWy9Rphb7UTICZkWUo6VD2QogVfQ4D/0fUro3bAOcvd8CfHtW34ylQ5F6uxb7rzSHv2WSgWQXbxNK/1ejgz4UYFTTgluL+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6175
X-SA-Exim-Connect-IP: 2604:1380:40e1:4800::1
X-SA-Exim-Mail-From: SRS0=6xO8=FK=renesas.com=kuninori.morimoto.gx@kernel.org
Subject: [PATCH v2 33/54] ASoC: uniphier: convert not to use asoc_xxx()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: j0JFybE5jtYk

ASoC is now unified asoc_xxx() into snd_soc_xxx().
This patch convert asoc_xxx() to snd_soc_xxx().

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
 sound/soc/uniphier/aio-compress.c | 22 +++++++++++-----------
 sound/soc/uniphier/aio-dma.c      | 12 ++++++------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/sound/soc/uniphier/aio-compress.c b/sound/soc/uniphier/aio-compress.c
index 7d1492c15b57..4a19d4908ffd 100644
--- a/sound/soc/uniphier/aio-compress.c
+++ b/sound/soc/uniphier/aio-compress.c
@@ -25,7 +25,7 @@ static int uniphier_aio_comprdma_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_compr *compr = rtd->compr;
 	struct device *dev = compr->card->dev;
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[compr->direction];
 	size_t size = AUD_RING_SIZE;
 	int dma_dir = DMA_FROM_DEVICE, ret;
@@ -58,7 +58,7 @@ static int uniphier_aio_comprdma_free(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_compr *compr = rtd->compr;
 	struct device *dev = compr->card->dev;
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[compr->direction];
 	int dma_dir = DMA_FROM_DEVICE;
 
@@ -76,7 +76,7 @@ static int uniphier_aio_compr_open(struct snd_soc_component *component,
 				   struct snd_compr_stream *cstream)
 {
 	struct snd_soc_pcm_runtime *rtd = cstream->private_data;
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[cstream->direction];
 	int ret;
 
@@ -102,7 +102,7 @@ static int uniphier_aio_compr_free(struct snd_soc_component *component,
 				   struct snd_compr_stream *cstream)
 {
 	struct snd_soc_pcm_runtime *rtd = cstream->private_data;
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[cstream->direction];
 	int ret;
 
@@ -123,7 +123,7 @@ static int uniphier_aio_compr_get_params(struct snd_soc_component *component,
 					 struct snd_codec *params)
 {
 	struct snd_soc_pcm_runtime *rtd = cstream->private_data;
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[cstream->direction];
 
 	*params = sub->cparams.codec;
@@ -136,7 +136,7 @@ static int uniphier_aio_compr_set_params(struct snd_soc_component *component,
 					 struct snd_compr_params *params)
 {
 	struct snd_soc_pcm_runtime *rtd = cstream->private_data;
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[cstream->direction];
 	struct device *dev = &aio->chip->pdev->dev;
 
@@ -167,7 +167,7 @@ static int uniphier_aio_compr_hw_free(struct snd_soc_component *component,
 				      struct snd_compr_stream *cstream)
 {
 	struct snd_soc_pcm_runtime *rtd = cstream->private_data;
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[cstream->direction];
 
 	sub->setting = 0;
@@ -180,7 +180,7 @@ static int uniphier_aio_compr_prepare(struct snd_soc_component *component,
 {
 	struct snd_soc_pcm_runtime *rtd = cstream->private_data;
 	struct snd_compr_runtime *runtime = cstream->runtime;
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[cstream->direction];
 	int bytes = runtime->fragment_size;
 	unsigned long flags;
@@ -219,7 +219,7 @@ static int uniphier_aio_compr_trigger(struct snd_soc_component *component,
 {
 	struct snd_soc_pcm_runtime *rtd = cstream->private_data;
 	struct snd_compr_runtime *runtime = cstream->runtime;
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[cstream->direction];
 	struct device *dev = &aio->chip->pdev->dev;
 	int bytes = runtime->fragment_size, ret = 0;
@@ -253,7 +253,7 @@ static int uniphier_aio_compr_pointer(struct snd_soc_component *component,
 {
 	struct snd_soc_pcm_runtime *rtd = cstream->private_data;
 	struct snd_compr_runtime *runtime = cstream->runtime;
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[cstream->direction];
 	int bytes = runtime->fragment_size;
 	unsigned long flags;
@@ -328,7 +328,7 @@ static int uniphier_aio_compr_copy(struct snd_soc_component *component,
 	struct snd_soc_pcm_runtime *rtd = cstream->private_data;
 	struct snd_compr_runtime *runtime = cstream->runtime;
 	struct device *carddev = rtd->compr->card->dev;
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[cstream->direction];
 	size_t cnt = min_t(size_t, count, aio_rb_space_to_end(sub) / 2);
 	int bytes = runtime->fragment_size;
diff --git a/sound/soc/uniphier/aio-dma.c b/sound/soc/uniphier/aio-dma.c
index 3d9736e7381f..fe272befd967 100644
--- a/sound/soc/uniphier/aio-dma.c
+++ b/sound/soc/uniphier/aio-dma.c
@@ -108,8 +108,8 @@ static int uniphier_aiodma_prepare(struct snd_soc_component *component,
 				   struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[substream->stream];
 	int bytes = runtime->period_size *
 		runtime->channels * samples_to_bytes(runtime, 1);
@@ -135,8 +135,8 @@ static int uniphier_aiodma_trigger(struct snd_soc_component *component,
 				   struct snd_pcm_substream *substream, int cmd)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[substream->stream];
 	struct device *dev = &aio->chip->pdev->dev;
 	int bytes = runtime->period_size *
@@ -171,8 +171,8 @@ static snd_pcm_uframes_t uniphier_aiodma_pointer(
 					struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
-	struct uniphier_aio *aio = uniphier_priv(asoc_rtd_to_cpu(rtd, 0));
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
+	struct uniphier_aio *aio = uniphier_priv(snd_soc_rtd_to_cpu(rtd, 0));
 	struct uniphier_aio_sub *sub = &aio->sub[substream->stream];
 	int bytes = runtime->period_size *
 		runtime->channels * samples_to_bytes(runtime, 1);
-- 
2.25.1

