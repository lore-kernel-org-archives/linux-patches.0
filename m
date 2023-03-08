Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437B86ADE
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 13:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E43AC433EF
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 13:49:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=bang-olufsen.dk header.i=@bang-olufsen.dk header.b="ZSQcJLNg"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 8 Mar 2023 13:49:29 +0000
Resent-Message-ID: <ZAiSaXSt+HTa8e/d@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 08 Mar 2023 12:56:21 +0000
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=PO25=7A=bang-olufsen.dk=EMAS@kernel.org>)
	id 1pZtL8-00609O-Kp
	for broonie@sirena.co.uk; Wed, 08 Mar 2023 12:56:21 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id DF6DB61758
	for <broonie@sirena.co.uk>; Wed,  8 Mar 2023 12:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 67FB5C4339B; Wed,  8 Mar 2023 12:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0951BC433EF
	for <broonie@kernel.org>; Wed,  8 Mar 2023 12:56:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 0951BC433EF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=bang-olufsen.dk
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=bang-olufsen.dk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRqbpbGSKho310tp42C9QAxlrG+OAI6F3X2YGvmUtjcxD06X6McZlzClC9QVIm/6whYunMMVZV61KTcyNbM549/WGm1s6Lc5oODmq77Z/xajJovnD9N0RrvfTn/12lqUff1mMucdUpxEINj7AnRGENnwpWPZkyGZqMg1kJS/XrBx/hN5xXI+STfLOcsywb8Dn9nc5gZ2o9dN/YppaBvnHF2mZz8SPWPDpGh9+feitXK87Qh0zkC8URnqGCfRiwSip50xacyHn8U0+k59Vt6pvUy1CEKP09YZph/dlbi8ITbkzTKjI674vyHG9rhDe8K5ILvX0U5yrNS9vRE2WctLNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ktRpb3JwHd34NrTpnWNlFogS474NKwJpSSI5Ty+7GCg=;
 b=i5vV4I3UadnZhucMjjnDPo1HIaNPj14145qqToyvBvMDIr5W9hNY6aiHr3PoTLIhd5It33vAjjldxIn3bAk5HBSZ1Q+ZgqDqL32Xo7DpXx79Tp3qZZ1SpJItyVPgTprlMW2SbcXR6I1qUPHP5Gc+A5AqM3i001HrKm/EHoB6iSw79kn6jk3TeKdYz5m20qbbbS3BpfIl7Ro7jac5oC4k0L+1MXfWHQDB3m0cxz3BuR0aZp4kXLdQEq71EFD2c7W783jur5nJjxGkRmu68+Ms5YYOg0iqFqgc30aypieXWD5XFiJmv7NlA+3EitE5ZY7TR65yDQ+kjyhAWv/dz6H8RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktRpb3JwHd34NrTpnWNlFogS474NKwJpSSI5Ty+7GCg=;
 b=ZSQcJLNg7oj4uVlS66vWIHKTWqd04X/Q5T9W0X7p+B32IZEQJuPu6imwNGYtB0VshW8zBfs6n3G1f02kbwSITVBwiZPY3LWuSWahAm1JihsvmERopWwc3wpwWMMQdxxdDjHZZgCJ8VEolntgzgoQp7BkbGi43r3TVbcF5enMTEo=
Received: from VI1PR03MB4942.eurprd03.prod.outlook.com (2603:10a6:803:b6::20)
 by VI1PR03MB6541.eurprd03.prod.outlook.com (2603:10a6:800:19b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Wed, 8 Mar
 2023 12:56:12 +0000
Received: from VI1PR03MB4942.eurprd03.prod.outlook.com
 ([fe80::7ccd:3294:6981:aef7]) by VI1PR03MB4942.eurprd03.prod.outlook.com
 ([fe80::7ccd:3294:6981:aef7%3]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 12:56:12 +0000
From: Emil Abildgaard Svendsen <EMAS@bang-olufsen.dk>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
CC: =?Windows-1252?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>,
	"linux-patches@vger.kernel.org" <linux-patches@vger.kernel.org>, Emil
 Abildgaard Svendsen <EMAS@bang-olufsen.dk>, "alsa-devel@alsa-project.org"
	<alsa-devel@alsa-project.org>
Thread-Topic: [PATCH RFC] ASoC: hdmi-codec: only startup/shutdown on supported
 streams
Thread-Index: AQHZUb1cPfbvxzEpSEC6JSyEyPaHPw==
Date: Wed, 8 Mar 2023 12:56:12 +0000
Message-ID: <20230308125503.3917903-1-emas@bang-olufsen.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR03MB4942:EE_|VI1PR03MB6541:EE_
x-ms-office365-filtering-correlation-id: 4f4b2b96-c30f-4197-b09c-08db1fd47eac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 +8U2q+PZ/DR+ZX9jYk4NCkLZl1FEk9DegNhGM8VwXnuT2YOsDapEQxRUpa/MwSGzxYxIowhz0o+/kNLa0BXp4fe75cvAYCnffQvo6llCxv47Ia4jcw46sSt0+h9y82tDnInmmRw/dDBBIJ5abbKAVUfhKxKm5RrcNPdgcjg+7yVbmVyLBF9NRl2Z38PKcC7ckgpj07KoPRp7V30OHbniHCFQoEJxn3ApRRnQr7ZBQk+98gebTAmsDe896FRGJWelezqBoVi4hQrxcCMxweY8N9AfTarj8pd0QRn1M+q40Nr3aFIWnFpGrfWResDIKST8xL6CPJ/vkrdbZWQqmpSQ8OQiXG+HZg3IXEFtiFQfbFIQUNdgL1yJWIIXYT914KZAOVx6laWC0qCbUs25XfBvSWlVD5YTeRA7hIQbVitLNyjL1tYdP6pHVwFR7kd2NNY0VBWzFt1ZWqJqT35UavsQ3NgKBh7RwColemo+4dCIPPEUgKVjCmK24wx/HyyRRirKLTdFna7c2fggaQiILCgnjsK0w7zPu1jHKFqDiLhVjWB7oIProZhpieY0KWcRU3ywoBPd7dptaLoDeGwLKyLoeVkN9+/pFzx9TFwr77Qfb6wIcDUh8zmipReXpmxP46nY7dD9UdLwqhVOxWo08BIkkZT3GoVSxAL3hLG4bV6tCk/Nhe3C90PXRIHUJsOSK1DYE9AGD6wOoosPrx2lpHldKA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4942.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(39850400004)(136003)(366004)(451199018)(71200400001)(4326008)(6486002)(1076003)(83380400001)(478600001)(6506007)(6512007)(38100700002)(2616005)(66476007)(66946007)(54906003)(26005)(66556008)(91956017)(66446008)(186003)(316002)(64756008)(110136005)(8676002)(76116006)(8936002)(8976002)(5660300002)(122000001)(41300700001)(86362001)(2906002)(38070700005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?clR98CBqXqSuNaR3PUVI1V9Jt2ZM3fCsjowdaUKtwxtatjOQVHPQQ7I6?=
 =?Windows-1252?Q?4FhwRXeXwG+ZBPOSg/Ans6RPRsi3XOQGaaAp3pzwcAWOW9nOuEnV+TLf?=
 =?Windows-1252?Q?4ebOtuxNBmtltO5MAQ1dlaGttsAPET3RiGmFWgp9VCfkiMMm2WJFbA09?=
 =?Windows-1252?Q?IlqLAaYce9Y0tQjNuAsXlw2k02YKeugIwYSCkaTXqsuAodHLD2Vel9I6?=
 =?Windows-1252?Q?sGcCfuJ4UUXbQan5FlloONj2KrLLPpK6xIUV20M1Th5T3xCzMPi1cQUB?=
 =?Windows-1252?Q?bJS+OquJrZfc24I/z5ucF1SnHKUgC0q/5V+mf4Z2jQFrrdWukmFI+lcb?=
 =?Windows-1252?Q?UFT5fEwSKK0dCJASTDSD5FEhV7t1GONKQoaovKwYjwnNTNImjIgM6Cde?=
 =?Windows-1252?Q?lQ5jp/iiH8ftocDA9/PyB0zWU8+Glr+kvztLFbC3710SsoQ7GKeanQ/9?=
 =?Windows-1252?Q?86pwjM5yxTUqSvNIezeLhR+f2cwZGDzs+AVS/N7rglTF/PQ2bsuC9zmv?=
 =?Windows-1252?Q?sPdojxPNKQxwRGNby3Wopza0M9n/fF5rfbbISH6LqMqNStS84EToLA0+?=
 =?Windows-1252?Q?5q0oT8afvWVExA2kst8Rz9mkHwXUkHy0XFU3HDxAYsuZt61TkfPfBe44?=
 =?Windows-1252?Q?cyLbV++KTYiSJkj8MDYgshtkAqVYz+7iJE9FZz9bOeCKPxdWc7wyhETe?=
 =?Windows-1252?Q?KaFLtEO5eHxqDLVSS1lieic4ncVxSZVBwu237qWlpCHpReFbwwAnmHgj?=
 =?Windows-1252?Q?/S4SckGbxwVxvkGAuVNN7kf8lZN72Eoxo54BLgRvghQrONL0VXHnii5Q?=
 =?Windows-1252?Q?1bm9KEodemaEYbpFcZNxKPD9+LchUM97RZ4XavY8qsM/kn4nt5jKTt4t?=
 =?Windows-1252?Q?JWDmWQcU5ffCmYTs6+ZDzDarjVCt2QJvGJPk69vkgISvcDDaRPdm8LSu?=
 =?Windows-1252?Q?kec0RUFBoeqdA8rTPXAoUhgoDW4qAjA+BWLCctvEbNpYmMhm4amY2rNl?=
 =?Windows-1252?Q?0A14f8IJ0GIbdGlC4LqpKvQVNEE2M2TR7dFeioKThIKyGxqAKGSf8LHp?=
 =?Windows-1252?Q?0T4Cat7SIPOu/NOAWVtDwFyRPZ8D5o2XzN8YsGEDqGAa8pEeOi/gW2P+?=
 =?Windows-1252?Q?iNUxomJ5tYoJ9lxMsnCqDj7Ka1EWr8Q9zdor9uA93NGmTzmfMsIhWGdE?=
 =?Windows-1252?Q?r5y2hzu20VGD8wDBcqQoKFDMLlf5zbufxIfPBu6kjHK8Q3PxI1Q6UxTk?=
 =?Windows-1252?Q?I5wbqriByce+SG5Jnfx6M/9RIAVeCUudlt9kHzHU6RhTmFvkx+OCGYDD?=
 =?Windows-1252?Q?G+sOecllcdFrHYkZTklxDGdEHL454Zl9R/Ptp0BkgETYjWEHm7DOrbN7?=
 =?Windows-1252?Q?IJcV3mYsaFjD7bLHmIEGkoqVKCAvIDV6TpO50xIByWD9Z93eVZfkhKDy?=
 =?Windows-1252?Q?brCWXhakidH7cRdZiDIUdz0qUH/8cqP1sMp/LQN8VMz+FNCCebb1dDTb?=
 =?Windows-1252?Q?aSKRxgLpMX1pJ1/TT0vJYV0DgM2h03U+2fHRqntad0TUIPyYD+cWpGEv?=
 =?Windows-1252?Q?uIoYWjzecDmnFg4K2xWeMqNpJtbsv2tD6uCN1HIAWf5xF4lpKM/snRa3?=
 =?Windows-1252?Q?dOjd//Hu4XKdyMWQZAkZ81rYw4pPubyHrvZkeMMlxt3HzXhnFhN9ZfgK?=
 =?Windows-1252?Q?m6xChNlu+Hmm0n8/W5eeRTWDCn4SUTUo1bEIONlKskTzxUt63XBnYg?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4942.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f4b2b96-c30f-4197-b09c-08db1fd47eac
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 12:56:12.1362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WqQpVVnIVMXqXZWYD8/eCRY9dNn17LuI5N4QNRMr0mx50qY8WqWAKv0Vb/qZFzWy3GtD1oKnsWD4XnsGK2iqbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6541
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=PO25=7A=bang-olufsen.dk=EMAS@kernel.org
Subject: [PATCH RFC] ASoC: hdmi-codec: only startup/shutdown on supported
 streams
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: elvXp1NzUfYn

Currently only one stream is supported. This isn't usally a problem
until you have a multi codec audio card. Because the audio card will run
startup and shutdown on both capture and playback streams. So if your
hdmi-codec only support either playback or capture. Then ALSA can't open
for playback and capture.

This patch will ignore if startup and shutdown are called with a non
supported stream. Thus, allowing an audio card like this:

           +-+
 cpu1 <--@-| |-> codec1 (HDMI-CODEC)
           | |<- codec2 (NOT HDMI-CODEC)
           +-+

Signed-off-by: Emil Svendsen <emas@bang-olufsen.dk>
---
 sound/soc/codecs/hdmi-codec.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/codecs/hdmi-codec.c b/sound/soc/codecs/hdmi-codec.c
index 74cbbe16f9ae..07ad7e5083ae 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -428,8 +428,13 @@ static int hdmi_codec_startup(struct snd_pcm_substream=
 *substream,
 {
 	struct hdmi_codec_priv *hcp =3D snd_soc_dai_get_drvdata(dai);
 	bool tx =3D substream->stream =3D=3D SNDRV_PCM_STREAM_PLAYBACK;
+	bool has_capture =3D !hcp->hcd.no_i2s_capture;
+	bool has_playback =3D !hcp->hcd.no_i2s_playback;
 	int ret =3D 0;
=20
+	if (!((has_playback && !tx) || (has_capture && tx)))
+		return 0;
+
 	mutex_lock(&hcp->lock);
 	if (hcp->busy) {
 		dev_err(dai->dev, "Only one simultaneous stream supported!\n");
@@ -468,6 +473,12 @@ static void hdmi_codec_shutdown(struct snd_pcm_substre=
am *substream,
 				struct snd_soc_dai *dai)
 {
 	struct hdmi_codec_priv *hcp =3D snd_soc_dai_get_drvdata(dai);
+	bool tx =3D substream->stream =3D=3D SNDRV_PCM_STREAM_PLAYBACK;
+	bool has_capture =3D !hcp->hcd.no_i2s_capture;
+	bool has_playback =3D !hcp->hcd.no_i2s_playback;
+
+	if (!((has_playback && !tx) || (has_capture && tx)))
+		return;
=20
 	hcp->chmap_idx =3D HDMI_CODEC_CHMAP_IDX_UNKNOWN;
 	hcp->hcd.ops->audio_shutdown(dai->dev->parent, hcp->hcd.data);
--=20
2.34.1
