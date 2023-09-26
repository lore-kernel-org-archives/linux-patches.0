Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EE630CE0
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 15:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B144AC433C7
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 15:13:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="Bq2dhyIV"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Tue, 26 Sep 2023 17:13:48 +0200
Resent-Message-ID: <ZRL1LBgzHut3Q6bb@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 26 Sep 2023 07:25:08 +0100
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=6xO8=FK=renesas.com=kuninori.morimoto.gx@kernel.org>)
	id 1ql1VK-00Bolg-2p
	for broonie@sirena.co.uk; Tue, 26 Sep 2023 07:25:08 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by ams.source.kernel.org (Postfix) with ESMTP id 1F2D9B80EC9
	for <broonie@sirena.co.uk>; Tue, 26 Sep 2023 06:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 85498C433C8; Tue, 26 Sep 2023 06:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC5F6C433C7
	for <broonie@kernel.org>; Tue, 26 Sep 2023 06:25:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org CC5F6C433C7
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=renesas.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZmz68LDytOFI1lWOGOXYzzLyWn3rVDxM9O+o3UkazYRFRJi8blFMwZ9VT8WW2mVAhtkQWTDWbBTps2AOcgiroAn83OLs9QJ8dxl7fHSd4SLxtTuEAua3RqtnZI0xnHZvtzMIAJDV2Jd+UTZX+Mrsl3Bf0hsM6nb1C3MXnwWmKK9qrt40GX/vHlbYFng/Vz2xXJ2OAvHFgZSkueKbeGgVykIcfk73vqGVcplapCg3ASwlw9ce5Zzp3uwtYMOJRkft4iuU/384Y35E3kysZY4mMjLjFJHGvxhS5XzC1D7h7Kz/6lcyOC6nWVIRfheb/u+xEsp9lvd641s9s05WbItdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tHTbPZSQ3tAuQrpNvUNQTHDJgZS5KjD1PoCKBAToRGk=;
 b=KKyAA0ePr2b+pSdAoMw0FfLAgwzl0O9QwHLM6PgVhVQE9syVHEg1ZqTMKbNvQdSJ9VDF38V5LvJbwgDl5d94lKxlThl9dDh2s/rvTjyeg5mFXhroJDTBhorKus0qm5l6Zi7h1O1Xwe+fvLsEi6k3DPF34b1oDMcBjxtjS9CfZUNW7qFOYYQDn4WJ7Lk3VWGsb3UtxxzlYadjcwhF6Be3hrk6ItRoqnZVYA4n29p5RwHSSBGoNSzAzj1CWGOSwWsKxubkDJjhoYJ6R1ybWytIZ18X8lgsUQ7z6WZB8QXG1dtQvTsWE5KVSeU+w+jYtgMEfiazkPGt5CKwB9KiRhJL3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHTbPZSQ3tAuQrpNvUNQTHDJgZS5KjD1PoCKBAToRGk=;
 b=Bq2dhyIVupNgnmS2N0oX2EoXZ5x9ZHS2fdFWFrZQ2DzJ+irUPS1QYkemnXqoT5VDkqcVhVQ0RSFSAM/eGmJaGAdhUPIQKy1MdlXXltHDQYsiD12ML7J4g3di4wDYWCPiiQ1RtY2vgLt6w2tapOADAD2gdIGuX5bXtgJ4+zm2a/s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com (2603:1096:604:194::10)
 by TYCPR01MB6175.jpnprd01.prod.outlook.com (2603:1096:400:4b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Tue, 26 Sep
 2023 06:25:01 +0000
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::d2a3:45df:a180:595c]) by OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::d2a3:45df:a180:595c%6]) with mapi id 15.20.6813.027; Tue, 26 Sep 2023
 06:25:00 +0000
Message-ID: <87v8bxfo3q.wl-kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
To: Jaroslav Kysela <perex@perex.cz>, Jason Montleon <jmontleo@redhat.com>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Oder Chiou <oder_chiou@realtek.com>, Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
User-Agent: Wanderlust/2.15.9 Emacs/27.1 Mule/6.0
In-Reply-To: <87edilihhg.wl-kuninori.morimoto.gx@renesas.com>
References: <87edilihhg.wl-kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=US-ASCII
Date: Tue, 26 Sep 2023 06:24:57 +0000
X-ClientProxiedBy: TYAPR01CA0213.jpnprd01.prod.outlook.com
 (2603:1096:404:29::33) To OS3PR01MB8426.jpnprd01.prod.outlook.com
 (2603:1096:604:194::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3PR01MB8426:EE_|TYCPR01MB6175:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f256511-e13b-4973-bfdb-08dbbe594ea0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	in4DvmzPb3R+sIezpdiRMw1XwSwWxcJ8EZCQZiV4u7n2b122ZOkLxZ9ziaM6ia80JJbao/TLusoMva/p5erxi2WIqqv12YInXP1Ga4KvJo+1vAvOEfyfvjFE1wn3DrrDZguuUc4pWdrEaHJqaMTBEShoferWHF0rGhrrdqnFciTTZdZBdB1nVUePe603T4h0N7pPzX7RnyJ5oOg5vSc3LpSRGJhLEiPp0SsSt08dqcETs9QVgRZW1+6GA0my0ehrNwkyDvo0SChCT5qL6k9ashkzX7IYWetzKXSIuZwk+qX3tmm6dqYG1QFrLmNNgADY+gdUzV7CAAdwJEzxBIBv56WfT6pxdRBIEexYvdA2PrBxveaQ2xbUFAlkVofdxFRepmX7AfwBWiuBfCxWIFPVB9WjzpB9ZVu2eSQUC2SCAFPi1X8oQtg3LumaWtNE9row3TwT1dO+GXNeTauZgsHukfNPOG4a044a4ucZvzChSrB9BCMijKGYFJ3MLIjU/4AKkoOLwBXGI0Y+q/81yBBeJpd5BpT0eDfxxCiPfkVUtOecLr4tGhbghg2Not6+sYKNb9rbplBxgSqS7uDUilyYmYy+1nEHNGGsS0Nalz5lc3/4ndidZj5YHn+xnNKr6ZLBSUeMICmswofI+xpkjqvxRA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB8426.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(346002)(136003)(39860400002)(230922051799003)(1800799009)(186009)(451199024)(6506007)(6512007)(6666004)(52116002)(26005)(478600001)(66476007)(66556008)(66946007)(86362001)(2616005)(110136005)(6486002)(38100700002)(38350700002)(83380400001)(2906002)(8936002)(8676002)(36756003)(4326008)(5660300002)(316002)(41300700001)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MVr4VP1A0GmMWrXX55Kjn5DQZSDtxBb273VAcfkP11AJcMa6dqc5VM2p2J4C?=
 =?us-ascii?Q?gS8Onz/Ub+AfHaUxKS2dmd1vN1G/mgtcJ27iFV5N8fT9XLDR0cdZ7JVCSggn?=
 =?us-ascii?Q?p9j5UmrgmuTzvExAxfsNlyvXRCVshvQrHGZbaGzjlkT/OouwoPMNt9beQJiH?=
 =?us-ascii?Q?gzZoxD9KuDBcL+fam9YX18pC+ueHkl2vrX75V2z8gIfy3PcIE90dgvidJVTw?=
 =?us-ascii?Q?t+/RudmJvdGnFYI9myfgB2ruLpNt9qq2Q5X0Yr4YPToO3qHRWH5q1/piDJNj?=
 =?us-ascii?Q?1e9QC107UrrtTXx64KC6zXpPL2601Z9HVCkqdA17tsBN3lT+SqSmR7lVzIpl?=
 =?us-ascii?Q?aUc7riwcRfPixzkHgXQQiG6e9moPVOyfUa/QjPrBTS6pbnQUoiBMbvG97/BV?=
 =?us-ascii?Q?MwNutg/9JKMhFXC095yRxXh5fq/yzCLqWCbISq5LxXrLEwLY2QDzZSpfAs55?=
 =?us-ascii?Q?BFM4VEPfnpBCnhXm8victYZMvwoI8P5QZym49ppxwuYl7bG3rAXvE98U1b/m?=
 =?us-ascii?Q?vrQ3V+Su0DrOj2j/7VcX6BIdcjaEYRULHA0ZiD1dit6e6beXja3TzG30vs5g?=
 =?us-ascii?Q?wBM+Y4KCVPgS5txNUq1ic7B4y2lT+6PvhrrlUavKOSp/0C0xEJbPK85fygcM?=
 =?us-ascii?Q?PP1hs91zOZifhGHNFwvVaquSIHH/nrn4ZAAVDHoIS6fqB5n/dEwsg9T1Op5X?=
 =?us-ascii?Q?Py5T7awn7nN1tEAeQ842287Tq1oFzRjh0dm1eixd9uiPury+Qq4vJbTodSr9?=
 =?us-ascii?Q?yInDscnG3kNACWJLYXqZlVf3bVV4q8YYjQyAsCdZmRUkMR0mubH9RGDUHOPE?=
 =?us-ascii?Q?V65hSAYFNg67e6nlt4CJBWfR0t+utDPDmQ5xwvwhdiyGfRHhcL3Otp/LdG7J?=
 =?us-ascii?Q?aoTuzrE0TgnIHHoAnuJwo8tjlwxFn+C/HaUuEtCkd3+pJrO5VaoqKmpqH5eF?=
 =?us-ascii?Q?M0RGPFkK5jf5BC0s2OF0PgauxLhHEGWaPE5cf0iAfuBHnagb3KNQ8sIgs+fA?=
 =?us-ascii?Q?Qlkd0dVxF+L0OCCj5osg6081cjwT8QWCimYm7cQaBcujFc9BVF29WndzwHXK?=
 =?us-ascii?Q?qKXslyEgFMWmjJItoqVHtOGYUJBKXCdQLiszTJL+Lt0DV5SvV81IlWoNYHAw?=
 =?us-ascii?Q?iS3s4x8OAr6sKK0aTeShVVsVeNIMvkhhviysofR7gG7q4HxXiZN0ifU2oTha?=
 =?us-ascii?Q?H8Zb4uRy4STQ6NnA/2bQZASs8E2IZr3EGeduHmMkkIUSxw+8XgtRrth6viRK?=
 =?us-ascii?Q?ggpTrN4VCAIzr1lUNnlV4nQCFgYPvcic3SNN1me/WYZk1YOmunSKhW2vhKDq?=
 =?us-ascii?Q?kAsgYmYpvH5ChCS05/q93dY4fBmfr9mQCdz9WoupnePj5nOZ1jRJV+mHYyh7?=
 =?us-ascii?Q?XOzbzmvIjY+YbOhK9IxjLmIUdjF2XmXCaQn8iSsQGgadga507ivTE4wvqInM?=
 =?us-ascii?Q?VaJXeuagiYXAkvYctn9fd6xqlR4D+c5Ilkoj2ZMIx5oT9wTCYFdvZFhebF5Q?=
 =?us-ascii?Q?gZ6rhHhwLlRVPAQHF2qLYi6iokL90ZlkOV1V0o1Qoc4lI5sdx3gE/vyNVPD9?=
 =?us-ascii?Q?5u3GusArr5xBhugZQxpLSnlzIUm25rjsVzFWUVVBGZOzHUHuH8eJ4hgysQoR?=
 =?us-ascii?Q?8p7hYi4e1la3W4WPj3StyUc=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f256511-e13b-4973-bfdb-08dbbe594ea0
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB8426.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 06:25:00.0265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uxZpayIj8rTP/GB/T2cGq6a+dWWO2TxTgxNQUx/uZuZylBDQEvPlFyPSGI5GbRBid/F5Ma3A9JhMsQEMwAfoofLQcgd1MU2SSauBDV2AdUDn67rq7nZCsYTAHS0Ts/AV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6175
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=6xO8=FK=renesas.com=kuninori.morimoto.gx@kernel.org
Subject: [PATCH v2 38/54] ASoC: codec: rt5677: convert not to use asoc_xxx()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: yvz/6eRnazOH

ASoC is now unified asoc_xxx() into snd_soc_xxx().
This patch convert asoc_xxx() to snd_soc_xxx().

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
 sound/soc/codecs/rt5677-spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5677-spi.c b/sound/soc/codecs/rt5677-spi.c
index d25703dd7499..d91a2184f67c 100644
--- a/sound/soc/codecs/rt5677-spi.c
+++ b/sound/soc/codecs/rt5677-spi.c
@@ -112,7 +112,7 @@ static int rt5677_spi_pcm_close(
 		struct snd_soc_component *component,
 		struct snd_pcm_substream *substream)
 {
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_soc_component *codec_component =
 			snd_soc_rtdcom_lookup(rtd, "rt5677");
 	struct rt5677_priv *rt5677 =
@@ -158,7 +158,7 @@ static int rt5677_spi_prepare(
 		struct snd_soc_component *component,
 		struct snd_pcm_substream *substream)
 {
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_soc_component *rt5677_component =
 			snd_soc_rtdcom_lookup(rtd, "rt5677");
 	struct rt5677_priv *rt5677 =
-- 
2.25.1

