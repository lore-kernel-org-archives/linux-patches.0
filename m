Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E124230CE0
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 15:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F53C433C7
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 15:13:58 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="PRkFO2/9"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Tue, 26 Sep 2023 17:13:56 +0200
Resent-Message-ID: <ZRL1NLP/ywevWO/1@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 26 Sep 2023 07:25:40 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=6xO8=FK=renesas.com=kuninori.morimoto.gx@kernel.org>)
	id 1ql1Vp-00BomB-CH
	for broonie@sirena.co.uk; Tue, 26 Sep 2023 07:25:40 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by ams.source.kernel.org (Postfix) with ESMTP id 6B0E7B80EBE
	for <broonie@sirena.co.uk>; Tue, 26 Sep 2023 06:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D1C20C433C9; Tue, 26 Sep 2023 06:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 741A3C433C8
	for <broonie@kernel.org>; Tue, 26 Sep 2023 06:25:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 741A3C433C8
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=renesas.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWulCmxCyridUDY8WnKYbXmT9MfEUc6DgS02iGEu1mbwr2csnqYedMDwcAGkuz6te9YNGFIVYKHR8zbNARz1UiSxS3kZzJnonVZAAwqxO73pUE3EPdOOt8StI7NzdiKqO22tYJEgb6vqs8hqofw0y0C8+snBbgCXUZTMLkpyMslLGfSAD+ug96I7d3tMkNcldZaLUjkTUXaY2jCdS5/NKtaEbtBQRuAHNc7a7NYairIY8ZLzAR4th8s/TxrTjdKESgCwcSLOeEe+9Lcm5pLNsWcVx5VQyb9fceYaGYPdGDnL5ObHV23pYf+UNd0Wl4c1lYiv364B36RJ+F/j1L5sKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mxew44fvwtOurbHt8+DnJZfyQMaAHfeNPFFAIJE36uY=;
 b=hwTwAeJSPEfMYkiwj81pVqk7O8DuHgy2UzgSJGpwhyH81geFx9FW06B+RzFf4fUMqPouHb/jwLUzw+yDBEp9ZI737N7lnZ3NhOlh4eJD2Z6MNTTvg117nXaDCerHPH6QSMG8br2LxoM9ds+Qg+/yclFWNFwAJr4h27A6xjl1eCpM9mWpfaa3L/Iy2R4xXoMrjsJbuQtiRmzchI6StJ9QlS23+rlso5kYV+kYqeihm3VeJimTiHVN04Tv0x2Caj/npndrLVllNKJqLDtz6mZxIT9+3SBhLM8LMS6B3y8ywXFih5eCgRRkO8vhkxp9xFICd4dlb7L9sV062thTyj1K7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxew44fvwtOurbHt8+DnJZfyQMaAHfeNPFFAIJE36uY=;
 b=PRkFO2/9QDdwOvFNFyXKSTmvptfVrANi7iwInEh7fup/MR0ew1jSRFN90K5O6z7F+4QbOND8aeRFl7vE2AEaOyl4TrelF2Jpt1ryNARN/uOR2DWyBw4H6Aqqy/YsPHtbE8IyxnCJTCJpnE7SSovhF8zOyatIRp6fWpUFbIeF2Lk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com (2603:1096:604:194::10)
 by OS3PR01MB10043.jpnprd01.prod.outlook.com (2603:1096:604:1e6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Tue, 26 Sep
 2023 06:25:33 +0000
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::d2a3:45df:a180:595c]) by OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::d2a3:45df:a180:595c%6]) with mapi id 15.20.6813.027; Tue, 26 Sep 2023
 06:25:33 +0000
Message-ID: <87r0mlfo2s.wl-kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
To: Bard Liao <yung-chuan.liao@linux.intel.com>, Daniel Baluta <daniel.baluta@nxp.com>, Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Peter Ujfalusi <peter.ujfalusi@linux.intel.com>, Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>, Ranjani Sridharan <ranjani.sridharan@linux.intel.com>, Takashi Iwai <tiwai@suse.com>, V sujith kumar Reddy <Vsujithkumar.Reddy@amd.com>
Cc: Kai Vehmanen <kai.vehmanen@linux.intel.com>, alsa-devel@alsa-project.org
User-Agent: Wanderlust/2.15.9 Emacs/27.1 Mule/6.0
In-Reply-To: <87edilihhg.wl-kuninori.morimoto.gx@renesas.com>
References: <87edilihhg.wl-kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=US-ASCII
Date: Tue, 26 Sep 2023 06:25:32 +0000
X-ClientProxiedBy: TYCP286CA0322.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3b7::11) To OS3PR01MB8426.jpnprd01.prod.outlook.com
 (2603:1096:604:194::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3PR01MB8426:EE_|OS3PR01MB10043:EE_
X-MS-Office365-Filtering-Correlation-Id: f7c37523-2306-4b3c-5d7c-08dbbe59639b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KFueN7O1X8TfTz7zAEjvneQ1lB46GWCqYoTKbM7OqJ74fgL338/X84Kjmasbl5HS9SsP6iAKRdtIcASUFZ+RcC3Y0lcoPOmHbIVeKwQZD17K2YZqT+6Fu9+Zvyd9GsUCe8oR+PQ588psK+mPDTAt3kwe3Op+jes8d3mD722HuvPHdWtYJbI0lUzUAuAZ1/5Y4AoshzUcOOGqAuo9DZui/2evs5WisfW5i6HnX2/CgfshFF0khiJgZOqZpd1+XkBZduV1eHc5F7J3JXXeeflZCBJs6dYCUK42mxN+nNlqSaLBa+8wCpMcqTn5YZ8Cd0rjI0N7I2RoSqARIhqHVTd4MUeQoqzquplFJSzTfRCYdHPSFLwhdyyA8tmz+dJZtTqv/XfcHu8ykyzwUgLC/22EBUrJM5cZifJCG/uhrGyh91KxNnSz+KgDGXCv2OTgaksJ9zyAD+rvsOQE2aIItAZvCghWz73xhITwnp7OPIC9XKEGW6XyMJstosHZWAYWxhCWMOZi1JrXBZFvXAkjjMXAmjClDPp0NCXUTJfQA8yqeXMK84pQofhtzwqSSeu4NA+c02CnVeMn3INse5OXibRv3mv+UEGuJQSIEUrp/eupxdVnMF2UJnZjZxuEe+TlUua6e3UrrDMkKUedv32FpAvP7wLKClGdMl/aNRXGkHFAm3I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB8426.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(376002)(346002)(136003)(230922051799003)(451199024)(1800799009)(186009)(4744005)(2906002)(110136005)(66556008)(66946007)(66476007)(316002)(7416002)(4326008)(8936002)(8676002)(41300700001)(5660300002)(2616005)(26005)(83380400001)(36756003)(86362001)(38100700002)(921005)(38350700002)(6506007)(6486002)(6512007)(52116002)(478600001)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o80V7oQyucy/ahgkzRZzpDgUZr2A00oxvzWGFeJ6NulpQK2C2QU+8IcBJmhr?=
 =?us-ascii?Q?rFLXRKCKEfH8AO68npJI1+eEMznGhuxk1jVzhUPG2+omPHzoYMSmrbLQhmxg?=
 =?us-ascii?Q?uny+l5H2uesI/J+mojUzr0RmSYCb2b+THhcNMRi+wwMvaurTHf+3AWHMTLg0?=
 =?us-ascii?Q?blb3B0xjkdXneXfZ84NumIzByY/lyv3lY+2MGLoqHKY9vb6uOBikt3APkbYk?=
 =?us-ascii?Q?kAEoBkplWk2kwYWBuNZDb9WwjUM6LLWp6GpGwmInCUZIor8+s5oBC1+AhiCR?=
 =?us-ascii?Q?35rWkUC1C+NCaFQzgTzvKRQ4+ePnl35kw+1ANFquW1u+sE2firX/7w5AFzlz?=
 =?us-ascii?Q?Txco2RrEQx0gVrjI6nIciV6y4ExKgA4PRibNDG9sf1UljBEPgXY//7ucMlDZ?=
 =?us-ascii?Q?CdWjzOrpRkgU1EYdd6OKWe/W7rE5dA1fzJ2+reUsccLk4tD/EOZ7lEdAUYHy?=
 =?us-ascii?Q?xN04yx1dTDqZLjsaX/6PZmo+PrNXszzbwhBmOwZSJIrQlC7sUOWc+wjgpi73?=
 =?us-ascii?Q?IKchAZo6xGeVDnp2OTmJBKb3dK7UcOkDpvz5+Co6XXCZU26hMFQlN5pqw1FN?=
 =?us-ascii?Q?nl3NujqIBOSeBSQRYrTbLu+EgK15xlhcRhRy2rj6YmR1tJlFepquSntGLJG7?=
 =?us-ascii?Q?mcsRPWYsSy4sPotfszNmz2tLf0PDaS2R4U768dA/rJ+yuCXuWRB/Sl+SBND4?=
 =?us-ascii?Q?SDo1hs9/PE86tXK1grgQM2z9eTp4kt6kdowoDKvUQgPet5bZd/UNbkV2Qoos?=
 =?us-ascii?Q?teCi1yIZICkwfwGYicGtI1uB4KbrPjLQMu18jpqmn0DEoEa+LZ3t7Tndhjp1?=
 =?us-ascii?Q?WavJ71wV61zA8AGQzIOuCjOQG6+KE4n5Qlq3f1A2xhRpLzKrF6ZrTNXQonFy?=
 =?us-ascii?Q?9DJ7m0ISm4NNnZBeppaz9S+qyGTOugLfrJsmZEA4Nvnw0l3GhYeZI5eybYuC?=
 =?us-ascii?Q?CBPMN3NNAY9SQzmqE0VHbxYKaPzcVe7/z0WKSUvWsSWvE44vYhBz9zwgvEGT?=
 =?us-ascii?Q?mQn6MIyIaMuUq/KznwmNUEAH89OanLqOB1jkmSk6sKtey7Mn5iEyISSArs+U?=
 =?us-ascii?Q?kU21ozYBVxDkTV8he7p7/QEx0GrQ8PhvG9VheOMTrqGK+WSXl9lEZMbF/QFB?=
 =?us-ascii?Q?anhqf5h0tZeOekmzAfjysxYbtxMWBvlD9KCCApKyiHkwb4DsSyIkyec/Ydsh?=
 =?us-ascii?Q?WGYpamA+3g5N+NPhPFHiaUhBZDL8z+t3oROzfI1NuE6IW+PUBQjVc8Y98BuD?=
 =?us-ascii?Q?/18QvIKfLiv1SUJ/aBs84kMM8X0EmVzLp3cgecI/HR/WURzRcHb9ssPBlZbf?=
 =?us-ascii?Q?LgaThfIe7nAsTDpvw5wTEoTRVRI/6LoYqnyvM3y4KFII6g908HJcub7/K1BR?=
 =?us-ascii?Q?uDf2/njoEbmKxlvw26mt53tOLsiU9A3H6QG/ZhZTVXuT+pKGGNNMumVO6HN/?=
 =?us-ascii?Q?PdnXRGI2QBqL76LqXnpdQuc+23v2jqgkjsoAXnr0gMZyYRnwnO35zuI5Amsi?=
 =?us-ascii?Q?2AKkMclCEYhJVVfdGHZy/tvk/mMkfciYucIsq8RTo506THJxD1ka56k1T2Oc?=
 =?us-ascii?Q?2Plu01gBDOVPnA53MzyHhk7J8JGZ6c4KxcRYMAAYv1C6M6+zJU9xSaQ3p+1g?=
 =?us-ascii?Q?P84QRMBxCbUgX7br0UzE0Yo=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c37523-2306-4b3c-5d7c-08dbbe59639b
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB8426.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 06:25:33.6614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RAoH5dVTzsy+X4gOpGMoIkGuqt1vZNseS+sY3cMpSsDmoT2yyWPKGIOwP4xUfWAy85mFi39iA2lFEs6weodfVxWQeqZmpykXwsI4HciaiNoA8IWjeco9ITiwDv4WjkMN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB10043
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=6xO8=FK=renesas.com=kuninori.morimoto.gx@kernel.org
Subject: [PATCH v2 41/54] ASoC: sof: amd: convert not to use asoc_xxx()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: w0nbci4f9GbS

ASoC is now unified asoc_xxx() into snd_soc_xxx().
This patch convert asoc_xxx() to snd_soc_xxx().

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
 sound/soc/sof/amd/acp-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/amd/acp-pcm.c b/sound/soc/sof/amd/acp-pcm.c
index 0828245bbb99..cee0b1154874 100644
--- a/sound/soc/sof/amd/acp-pcm.c
+++ b/sound/soc/sof/amd/acp-pcm.c
@@ -89,7 +89,7 @@ EXPORT_SYMBOL_NS(acp_pcm_close, SND_SOC_SOF_AMD_COMMON);
 snd_pcm_uframes_t acp_pcm_pointer(struct snd_sof_dev *sdev,
 				  struct snd_pcm_substream *substream)
 {
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_soc_component *scomp = sdev->component;
 	struct snd_sof_pcm_stream *stream;
 	struct sof_ipc_stream_posn posn;
-- 
2.25.1

