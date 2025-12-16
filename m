Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azolkn19012059.outbound.protection.outlook.com [52.103.10.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BED272E54
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 18:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.10.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765909726; cv=fail; b=Ffo9hGeV29VAcpWcCzsxqdok5Qx9UdKA53nQBP8CIJPVS1lFo6iDhkGCjeGM+dV3OZzzhVmsw9kT9UcMUphzBib4QToUtPlBei/VU7DjCA3d6/2FbxtPmGG15wS84v8AgQa1CPa4O3/Oy7QYZ/pw25OopACLmyWkepOAsU5b0bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765909726; c=relaxed/simple;
	bh=VETSTSshpBVpgQ/wu9Sl2M0XExJ1CEMyU8x1CT0rTvk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E7JJcyAC5hA+mBNRb3Ph44mduDw+Yt/usfQgE3T1zBXWRFDuHgZDq86S3WLm+6z+p8hNFrDEqjn+y3lrc1EVcRpoDu59PMPlgLaGqXpgLWhL2aK3YDH+4beg1uBZqljlLZvpV2dl88G0v04HjP1vqA74fbvHRy3/bdblCbmqapQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=ez5dB8qa; arc=fail smtp.client-ip=52.103.10.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="ez5dB8qa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VEWKY0bYCaahS0iF+FJt9p6Hcu1gZXb5KG5RtIyQPf7a54W2wBEo/bkz6w9pnNlDEEhMs91MhGZ3GL9sRDsLLDmgjIiNEwiZh2EJ+wV600nYhDR0qq6m9RAGht+i3ZaKWB60cPOcY/2bfpxfFRpG3RAgQgyQ2nDaPbUM/RNnBAYfrlI874ShpW8J4ffcqIW6XZiZoGEmIcQ/IMAQM1vEw7D/VLhpPH2P8vFt/BdUGYTNM2BsuuyvY7O8RFwmMPBQTE4tWm/0NCrnvr+Gf9KA4hbZMtnb5hvmoazXnFRKfY6sOpo2dCUaDJmrrsDek9gMfOp/YUXW3IvpSgIqGWqkNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glrFbcAhaIeSUkMv36FMYtKt6dPZr//y60zB+9RR3UU=;
 b=GFKPiKeDRF5ba5E/Lfq+MqkA28PB9KQBm6z6rsZVTXHRON8nEFLZGPKGwA1CVuUa150Jt7lJyYH3K01RLlZaPkX5/HtFg3WuN8XF9WMZo14PjMBmcHrOrB/gr8zRMeEtpT4DownWOEguGt+CnKh/56DmMIZT+fBdSPX6/YYEe2w2TGj5qAKEaotZAPRSppxXhLva2xMLhU6e8+hW4Evv7TZw48HvqHvnosxEZlEgJboaSDdERauXC3cbAUvEygqZHIgYXsNbWfaPnwdYwkQ8/EX/pBxUCNWlJUSAPI4Cw3gGZo0TBex4xPNA1BlHbIOUBZkI/GXzdquDvROQTxtqAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glrFbcAhaIeSUkMv36FMYtKt6dPZr//y60zB+9RR3UU=;
 b=ez5dB8qahPOnnDuo47spzU2qnU4FiunZ34BJJ5cMlKbX1Mm35oYfGXcZGj1Rn9qw+g6aO09EjrQ14uBIpRMqfoSgylH5gZDKCzPvBsyKqZ8kRgdzzssHpCk0J8a1oS4XO5voZUo7VU/oBT2qSIGRE64eWAjpqWg6hl7jmhzmaInKXjmG5vfWEgXpCpehfEM+KlJsQHwMfhTx24L2q5VpXVlvlYe1P+mdSAngNbsSeMzy9ZJinFp4FWa+3wLOsVLxpjLdBg62eqGXaqrR06gFuJRm0KWxDJ8B0ym7aUfnIbLJVjSg1Lh+5cl8ueD2Hm3AAfEfKCy9/bcAAgCaDmdbBw==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by SA2PR02MB7548.namprd02.prod.outlook.com (2603:10b6:806:14a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 18:28:40 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6%3]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 18:28:40 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, Wei Liu <wei.liu@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Roman Kisel
	<romank@linux.microsoft.com>, Alok Tiwari <alok.a.tiwari@oracle.com>, Sasha
 Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.17 247/507] Drivers: hv: VMBus protocol version 6.0
Thread-Topic: [PATCH 6.17 247/507] Drivers: hv: VMBus protocol version 6.0
Thread-Index: AQHcboJfcRXshjpiKEmemavNMK7Qp7UklcJw
Date: Tue, 16 Dec 2025 18:28:40 +0000
Message-ID:
 <SN6PR02MB4157943A3FE6E7BADC7DF1F2D4AAA@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20251216111345.522190956@linuxfoundation.org>
 <20251216111354.443732020@linuxfoundation.org>
In-Reply-To: <20251216111354.443732020@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|SA2PR02MB7548:EE_
x-ms-office365-filtering-correlation-id: b48e7317-6828-4a9d-8cae-08de3cd0ef84
x-ms-exchange-slblob-mailprops:
 AZnQBsB9XmqhcEBlXno9HJGOoZcx42eNuEN8y5bVn1aBWdDU3BxVulh0n3mdAO6RQqLgkJOyQgtUKiIgo8mi95N4E8onBkG2aPFxrGCK99oV8HOjkJEfKJC0rJw0adlknpj6K7Q893NWAO9ughdx/eT8cOq2DVLg9p0WtXRKujM1zUhyRlEjlI+pBjYeVtvQnmRv0Qpf5aKvImeu4DUEzBa4913+iIs8313XRfLJSpap/KUPb8U/B9IRddpjrCVg3Nspl3ViopvFHVt58tS9J4jU+ULlT+EDZt+9Syyv4qPeVVXqRnNsYJWm1H8TCEkHMMSI02ejYZobPKNpmczrFgyB4k2rG/Kz4ehfH1dwu7zirjXxLOLuHGv8kazhZwt9qGuMJZvsUWiYCRM9ax8bo2bIqhGPqTYuYZXlX2EoMgzIWMHeRHurt0TksRAXOvDRuq+XQmPWXhQZNKZ5Cl4g5VsBidfR+Us80Bl8c6xA/VpRqdkDwHgxkQuB5+5lAP/nLcVnxdqlcXNNnfnBdFjNjJ2emhNrHlfbmE8zNtqDsdTAx24ZnPs8AXnnocfGdLHYDom5aDKsvs5m0mMfZ2yTeLwSOsjIMOvPz7yFraUuO8Q5A5faKJYtUdu6mhXJy/3NpMjyeKqnA6/gfXhgj8nUsSXGSKX8aXDvdMycs5giGTrHFskKF409Lo/sVYSrx6QDd1DhfjouaFUm/UgoefznYYaS6IJPcSFJP1Fpoh1AKtbCrXJdbdq9qy9QahQKrXZJguqnEPKy/5Y=
x-microsoft-antispam:
 BCL:0;ARA:14566002|8062599012|31061999003|461199028|12121999013|41001999006|8060799015|15080799012|19110799012|13091999003|440099028|3412199025|40105399003|52005399003|12091999003|102099032|56899033;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?3qYfiVfErrH9nJ8AyLBqXZi0AmRGouOfy5LiXX/mBXQD8195QayFKULDE7z6?=
 =?us-ascii?Q?PqF33F/Tc7k28rr9CXAT4S4rCURtrBbn3Ow+15u8pK9GMJI7aPew2vLZxQmW?=
 =?us-ascii?Q?kVIPNyKZJg8bCb6kHpuZploB9ZdryD8QFJ8TfxlpdvXodleQn0DOif5pnpC4?=
 =?us-ascii?Q?op9oBXleTl13pRRjEcOGKXzkAFt38bcDgrVLi4kfJrqPIm8QbLrA6DnrcMLK?=
 =?us-ascii?Q?MzDVMsF70FUD6qtyoHnkNUinnTlR4fJkw7AOx1BMZZA6YOyIhmgcntxO6vht?=
 =?us-ascii?Q?+HN0wfaTpFB7DekgpAnDta+yAyJeHwcJVRowPii/DtZNViN8c67hPxmQdhCI?=
 =?us-ascii?Q?TKp6deCLn4cugPYKm9q3QF2VOEqHhVTFyyhSZM42S/8rREye8+ZN7q69Djsb?=
 =?us-ascii?Q?skfrJY4rg0AiamVLUqBESUsAQnnqvuxqGEWokan3+gqTIENAFeVqx1Qk9zQO?=
 =?us-ascii?Q?eiFChjv9pQwESBJHR0EelJcHvdv8GzEOtE/LbIxBX6gFXgc4N/Cd8AAAVK/0?=
 =?us-ascii?Q?hC5UAcI5MOa4QSSL6CX2cbqgsyS2RPoJknx2qabxqwIW+6he0AvJFX0IScLb?=
 =?us-ascii?Q?WyVnBKH2sEV5Q4/54vKA2+dbyrfX1yNy2igyQcybcbsLbIt2ng7zpzwCDchM?=
 =?us-ascii?Q?p3qwqHmw5DugM1rzaRLT48dU/2YU9rbvx8En0h5wBigd+ZSZKsfyrs21Nim6?=
 =?us-ascii?Q?JdkyrJkazTpmymA0NYjxc6n4jvy7y+0rUbrG/0BzZUthxkbyReOABgVd/fE9?=
 =?us-ascii?Q?riwzFjmkqNI6fwZU63uYcA82y6hP/9dNCPqO6Nkk4jrd8mOGDnM/awLw6GLw?=
 =?us-ascii?Q?a6tlWxl3TraSp0nDnY6hCxFRfQK/13IIxLGIh19jF4xjmrmhwEgZ0CE/cbVR?=
 =?us-ascii?Q?gKYySyyxe6qAu4SSgjYYHhmPA1Fk4qA+I5aWIKX/94EMut1td56iusYmgJks?=
 =?us-ascii?Q?vBqnr9D+h5Ld1tUuGcak2xqn5L1klqqhlmC94PdeWpf+MJ+0lpEc10fawZTw?=
 =?us-ascii?Q?rhKz1vXBByrOog8gGjmui4ySHc58RUb3XfqTruqoAXakabYwQfsmZXBJK4j9?=
 =?us-ascii?Q?1EXiNvBNgSyzQt68nc+UsFKWRkmRkL+jy6E764CrJUplcLQr2VfqX6tK8D1o?=
 =?us-ascii?Q?rtYJffmFv1pwkdV9ykMaxNpEwFM1J2VjZj2dE1zEkPG2ZpOHRnrb97mOMY9v?=
 =?us-ascii?Q?h1xtwD45OGgvwPFCzfYAPH7IDYLQajD5n+SXU7GXHGe41WJXUCGBDBvwdsPZ?=
 =?us-ascii?Q?4Ksjh7GU7dWY6uPa14UQM79IrAfzhziDTQ8SfytZZ4fzlIGIf9iCQ1h+zvWj?=
 =?us-ascii?Q?l5+2lgRH9utmiy2/Isywwc33?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?EPqk/4CwwVQpn9OcTRRigEmGD7S9bSXaSCAGxrFBRW5VlKX7elktp4EYsGEF?=
 =?us-ascii?Q?4L92hK/spJdf6yCO9dH7CVwFK3BqrpHv+yT6Np4L7NOQsvVmpHJqxv/dL+Vv?=
 =?us-ascii?Q?a4A5p15tTkyurJOvo7Q4uRWbSZu+CjcxB4GB34ogVM6GRfaOIQhlw/flYjIC?=
 =?us-ascii?Q?kJME33CQRh05iNyHIYgZfXBqnimgPtzfrpj7BAuSfuazO994JEdIrvHrn382?=
 =?us-ascii?Q?JqFmlNtEfDGFCdQgaTh8YDcyeSxH3TmTXu0oMWxF2goB6/DZ0AN3FPi3FJdT?=
 =?us-ascii?Q?iJTLv9wSFajBvzjiP/E5YLTnNIMqGUGArW4LopsTccucSjdeeGYtPfLZnZJP?=
 =?us-ascii?Q?kokV4B/CBv27mlZE1Ycfmi7tBYME8TD2ylSlpLeFJmsQNqdhr6lcWBgrPODl?=
 =?us-ascii?Q?A/ShIIlZnPF0VdORvUn/GAGD3ym7Hmcz0mmoIVhS2ZjOoHKOr8y+My7FYyCx?=
 =?us-ascii?Q?qAapn7BKtf7bs8bcbq5Zq1rIBoe9JKHRRkIsfay5FYkX1MpJht/6Nlvzu1g/?=
 =?us-ascii?Q?dXxm2jN/97In7d46+0XLWedcpF2zz3GbcQb4g0RM7sd3kZoM0QXpAfYu38AJ?=
 =?us-ascii?Q?0EOnhksG6+0PgnmLQSo6AkpbcjJyV4ECHOKKxIZctlcoZVLs8I5ULOyj98gB?=
 =?us-ascii?Q?36BM5dtqw9jveEgjvd3cwm524U7I8usAzdkjtdKEvI+Ez7663629yHx5zRig?=
 =?us-ascii?Q?xK4eJVoGmAV3rLCiCXayFj7QsscV/fuzS3VonJD2wvk5lBTvFBPkTo7ueBCF?=
 =?us-ascii?Q?9+tYN6rNUChl0tIf+X554d1C7tUDBF0/V89CVWWvUZVHGeQGS7SoAFCGD7QF?=
 =?us-ascii?Q?IUDcAkpn6fsYHgAvC9tyjFiq85N5JdqrVHn+1/OmGnOQLMA/K0baz3rGXbga?=
 =?us-ascii?Q?uVdWCQ3ZCz7esF9M6Nah1mYjUPK9/A8WBPshg6g1PscyU/3clgV3cpac756d?=
 =?us-ascii?Q?Qw1MkBYKke7fJfcj2i/DCVTGefMx+lOlGct8JecMWPefaAJXcCBZ3yChUSnV?=
 =?us-ascii?Q?jkTp2wbzziD9neCuZXBHNW5mhzBbbIjlkJ2kUYRf7f9eYCZUQKkjgMPzF6KI?=
 =?us-ascii?Q?kUSu96gFfvllIWY/oh3eoGjgf/C5nj+cjq5rzvWjsyQAtme4VOhYTy7kIYXa?=
 =?us-ascii?Q?rMWXVfNbOnLOSw5byfMXGX5Z/TdHmUqxR/EQXWsFLhGpX0QPU4BnFgYpYPZV?=
 =?us-ascii?Q?4GuVkeblWyEHBOg3hHSPzUvThTAc1NShcfsQF7MhXaLRr2/XIE8D+VHjSuw?=
 =?us-ascii?Q?=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b48e7317-6828-4a9d-8cae-08de3cd0ef84
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2025 18:28:40.2446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7548

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org> Sent: Tuesday, Decemb=
er 16, 2025 3:11 AM
>=20
> 6.17-stable review patch.  If anyone has any objections, please let me kn=
ow.

I don't think this patch should be backported to any stable versions. It's =
part
of a large-ish patch set that implements a new feature.

Wei Liu -- is there anything going on behind the scenes that would suggest =
otherwise?

Michael

>=20
> ------------------
>=20
> From: Roman Kisel <romank@linux.microsoft.com>
>=20
> [ Upstream commit 6802d8af47d1dccd9a74a1f708fb9129244ef843 ]
>=20
> The confidential VMBus is supported starting from the protocol
> version 6.0 onwards.
>=20
> Provide the required definitions. No functional changes.
>=20
> Signed-off-by: Roman Kisel <romank@linux.microsoft.com>
> Reviewed-by: Alok Tiwari <alok.a.tiwari@oracle.com>
> Reviewed-by: Michael Kelley <mhklinux@outlook.com>
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Stable-dep-of: 510164539f16 ("Drivers: hv: Free msginfo when the buffer f=
ails to
> decrypt")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/hv/hyperv_vmbus.h   |  2 ++
>  drivers/hv/vmbus_drv.c      | 12 +++++++
>  include/hyperv/hvgdk_mini.h |  1 +
>  include/linux/hyperv.h      | 69 +++++++++++++++++++++++++++----------
>  4 files changed, 65 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> index 0b450e53161e5..4a01797d48513 100644
> --- a/drivers/hv/hyperv_vmbus.h
> +++ b/drivers/hv/hyperv_vmbus.h
> @@ -333,6 +333,8 @@ extern const struct vmbus_channel_message_table_entry
>=20
>  /* General vmbus interface */
>=20
> +bool vmbus_is_confidential(void);
> +
>  struct hv_device *vmbus_device_create(const guid_t *type,
>  				      const guid_t *instance,
>  				      struct vmbus_channel *channel);
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 2ed5a1e89d694..c2f913b9aad58 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -56,6 +56,18 @@ static long __percpu *vmbus_evt;
>  int vmbus_irq;
>  int vmbus_interrupt;
>=20
> +/*
> + * If the Confidential VMBus is used, the data on the "wire" is not
> + * visible to either the host or the hypervisor.
> + */
> +static bool is_confidential;
> +
> +bool vmbus_is_confidential(void)
> +{
> +	return is_confidential;
> +}
> +EXPORT_SYMBOL_GPL(vmbus_is_confidential);
> +
>  /*
>   * The panic notifier below is responsible solely for unloading the
>   * vmbus connection, which is necessary in a panic event.
> diff --git a/include/hyperv/hvgdk_mini.h b/include/hyperv/hvgdk_mini.h
> index 1be7f6a023046..981a687bdc7eb 100644
> --- a/include/hyperv/hvgdk_mini.h
> +++ b/include/hyperv/hvgdk_mini.h
> @@ -260,6 +260,7 @@ union hv_hypervisor_version_info {
>  #define HYPERV_CPUID_VIRT_STACK_PROPERTIES	 0x40000082
>  /* Support for the extended IOAPIC RTE format */
>  #define HYPERV_VS_PROPERTIES_EAX_EXTENDED_IOAPIC_RTE	 BIT(2)
> +#define HYPERV_VS_PROPERTIES_EAX_CONFIDENTIAL_VMBUS_AVAILABLE	 BIT(3)
>=20
>  #define HYPERV_HYPERVISOR_PRESENT_BIT		 0x80000000
>  #define HYPERV_CPUID_MIN			 0x40000005
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index a59c5c3e95fb8..a1820fabbfc0c 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -265,16 +265,18 @@ static inline u32 hv_get_avail_to_write_percent(
>   * Linux kernel.
>   */
>=20
> -#define VERSION_WS2008  ((0 << 16) | (13))
> -#define VERSION_WIN7    ((1 << 16) | (1))
> -#define VERSION_WIN8    ((2 << 16) | (4))
> -#define VERSION_WIN8_1    ((3 << 16) | (0))
> -#define VERSION_WIN10 ((4 << 16) | (0))
> -#define VERSION_WIN10_V4_1 ((4 << 16) | (1))
> -#define VERSION_WIN10_V5 ((5 << 16) | (0))
> -#define VERSION_WIN10_V5_1 ((5 << 16) | (1))
> -#define VERSION_WIN10_V5_2 ((5 << 16) | (2))
> -#define VERSION_WIN10_V5_3 ((5 << 16) | (3))
> +#define VMBUS_MAKE_VERSION(MAJ, MIN)	((((u32)MAJ) << 16) | (MIN))
> +#define VERSION_WS2008
> 	VMBUS_MAKE_VERSION(0, 13)
> +#define VERSION_WIN7
> 	VMBUS_MAKE_VERSION(1, 1)
> +#define VERSION_WIN8
> 	VMBUS_MAKE_VERSION(2, 4)
> +#define VERSION_WIN8_1
> 	VMBUS_MAKE_VERSION(3, 0)
> +#define VERSION_WIN10
> 	VMBUS_MAKE_VERSION(4, 0)
> +#define VERSION_WIN10_V4_1
> 	VMBUS_MAKE_VERSION(4, 1)
> +#define VERSION_WIN10_V5				VMBUS_MAKE_VERSION(5, 0)
> +#define VERSION_WIN10_V5_1
> 	VMBUS_MAKE_VERSION(5, 1)
> +#define VERSION_WIN10_V5_2
> 	VMBUS_MAKE_VERSION(5, 2)
> +#define VERSION_WIN10_V5_3
> 	VMBUS_MAKE_VERSION(5, 3)
> +#define VERSION_WIN10_V6_0
> 	VMBUS_MAKE_VERSION(6, 0)
>=20
>  /* Make maximum size of pipe payload of 16K */
>  #define MAX_PIPE_DATA_PAYLOAD		(sizeof(u8) * 16384)
> @@ -335,14 +337,22 @@ struct vmbus_channel_offer {
>  } __packed;
>=20
>  /* Server Flags */
> -#define VMBUS_CHANNEL_ENUMERATE_DEVICE_INTERFACE	1
> -#define VMBUS_CHANNEL_SERVER_SUPPORTS_TRANSFER_PAGES	2
> -#define VMBUS_CHANNEL_SERVER_SUPPORTS_GPADLS		4
> -#define VMBUS_CHANNEL_NAMED_PIPE_MODE			0x10
> -#define VMBUS_CHANNEL_LOOPBACK_OFFER			0x100
> -#define VMBUS_CHANNEL_PARENT_OFFER			0x200
> -#define VMBUS_CHANNEL_REQUEST_MONITORED_NOTIFICATION	0x400
> -#define VMBUS_CHANNEL_TLNPI_PROVIDER_OFFER		0x2000
> +#define VMBUS_CHANNEL_ENUMERATE_DEVICE_INTERFACE		0x0001
> +/*
> + * This flag indicates that the channel is offered by the paravisor, and=
 must
> + * use encrypted memory for the channel ring buffer.
> + */
> +#define VMBUS_CHANNEL_CONFIDENTIAL_RING_BUFFER			0x0002
> +/*
> + * This flag indicates that the channel is offered by the paravisor, and=
 must
> + * use encrypted memory for GPA direct packets and additional GPADLs.
> + */
> +#define VMBUS_CHANNEL_CONFIDENTIAL_EXTERNAL_MEMORY		0x0004
> +#define VMBUS_CHANNEL_NAMED_PIPE_MODE
> 	0x0010
> +#define VMBUS_CHANNEL_LOOPBACK_OFFER
> 	0x0100
> +#define VMBUS_CHANNEL_PARENT_OFFER
> 	0x0200
> +#define VMBUS_CHANNEL_REQUEST_MONITORED_NOTIFICATION	0x0400
> +#define VMBUS_CHANNEL_TLNPI_PROVIDER_OFFER				0x2000
>=20
>  struct vmpacket_descriptor {
>  	u16 type;
> @@ -621,6 +631,12 @@ struct vmbus_channel_relid_released {
>  	u32 child_relid;
>  } __packed;
>=20
> +/*
> + * Used by the paravisor only, means that the encrypted ring buffers and
> + * the encrypted external memory are supported
> + */
> +#define VMBUS_FEATURE_FLAG_CONFIDENTIAL_CHANNELS	0x10
> +
>  struct vmbus_channel_initiate_contact {
>  	struct vmbus_channel_message_header header;
>  	u32 vmbus_version_requested;
> @@ -630,7 +646,8 @@ struct vmbus_channel_initiate_contact {
>  		struct {
>  			u8	msg_sint;
>  			u8	msg_vtl;
> -			u8	reserved[6];
> +			u8	reserved[2];
> +			u32 feature_flags; /* VMBus version 6.0 */
>  		};
>  	};
>  	u64 monitor_page1;
> @@ -1008,6 +1025,10 @@ struct vmbus_channel {
>=20
>  	/* boolean to control visibility of sysfs for ring buffer */
>  	bool ring_sysfs_visible;
> +	/* The ring buffer is encrypted */
> +	bool co_ring_buffer;
> +	/* The external memory is encrypted */
> +	bool co_external_memory;
>  };
>=20
>  #define lock_requestor(channel, flags)					\
> @@ -1032,6 +1053,16 @@ u64 vmbus_request_addr_match(struct vmbus_channel
> *channel, u64 trans_id,
>  			     u64 rqst_addr);
>  u64 vmbus_request_addr(struct vmbus_channel *channel, u64 trans_id);
>=20
> +static inline bool is_co_ring_buffer(const struct vmbus_channel_offer_ch=
annel *o)
> +{
> +	return !!(o->offer.chn_flags &
> VMBUS_CHANNEL_CONFIDENTIAL_RING_BUFFER);
> +}
> +
> +static inline bool is_co_external_memory(const struct vmbus_channel_offe=
r_channel
> *o)
> +{
> +	return !!(o->offer.chn_flags &
> VMBUS_CHANNEL_CONFIDENTIAL_EXTERNAL_MEMORY);
> +}
> +
>  static inline bool is_hvsock_offer(const struct vmbus_channel_offer_chan=
nel *o)
>  {
>  	return !!(o->offer.chn_flags & VMBUS_CHANNEL_TLNPI_PROVIDER_OFFER);
> --
> 2.51.0
>=20
>=20

