Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FB51E0084
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 09:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955625; cv=fail; b=Nti+fRi5l8zvcWFR5c6f5l4hUv4RERtjYlBLlsvkYvPbXEZV5GpgpXrMG0qQJ/OzmJEXikExmINjMrQtbyvU8oc/+0QbolstE2D8bgIjUjNiukoI8ctPYKee/Bblqm0sWba9NKtWPuGZT6CzFwmlt6QgXa+8empdmQBYDSfa7Rk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955625; c=relaxed/simple;
	bh=7uLPYUc9dooX8Wr9tUJjnJv/1R8YmNDMd2q0Udz5cyE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Sm1h3v/14lGl9pXFjW+AbkG2z2lelszvEC0gly44QgrrHhS8PD2L3ROexn0VlePmuSkZRKuexMrcm3IClvJomYUxNPhmusjWgz1Ror3tjI3dn4vAt+ZGbh9+aejTeujdRzWcyVKkcIoXVOigZnuOtXmdDhjaVfyxcbcw/134dlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SFtRGjkz; arc=fail smtp.client-ip=40.107.93.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SFtRGjkz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vrhAWYYyw/9W7Nhj6QKq4k+DylxxHZlFIf5WdJ/LeZe3JgHw1Nb+aeZKnhIinllT0AF9Qh8v6FG2VLfPeZbMQ7BLfu3rsFG6dhCwTighqNBxHgkzf+s1ff9vDlaBLNTKr0xkYsjX+6LvyvweeveuiLBVd9L+a8WU/TjIVQO7cdS6p6KJp++gcZ69V2d1qslG9zsqD+M5iqXAzyLCFyftu8AhMG6zAh9F9D58LC1we+bG2/6uo2QQUHS83/qVOnjeD0Bv3B3dBsr9iuO1D8ouFw32Fjl7pJT+vlRxRr/iaaMUTU0R8btDlT7NK54xeJpfoznRiCoXRU9tFIGayH5OZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7uLPYUc9dooX8Wr9tUJjnJv/1R8YmNDMd2q0Udz5cyE=;
 b=q/PmBeHY7VNcVBk3LAP4Wux9T6o6UCNLMbJkWK1d8+H18vyFQjME43YHzrBuu4HleUAq5bpTTXFiTZbmEdm1xFOCnNiA6enVvxdzdaZDXaS5oz9o0roIaowzlyO8aPsH6Y5PAgF8u8Mq0Ws9YAzkax7w6WSGiuQCBu2S7CJRqn4T/vKVZSvJFenC9kfdC3cCrZ40WEfiB3X2Fe4w8DpaBGjhnsKonLUQxK4b9b2WZFUwBQCZYlaA39vxyAkCQGzru584J1ELlFIGTMNeiMksFoe5KIj8qNToGGCwA/FPn8wcO8yNeeTtJCPwVNfomHcTx9GOTmweM/LSBl8RXgJHKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7uLPYUc9dooX8Wr9tUJjnJv/1R8YmNDMd2q0Udz5cyE=;
 b=SFtRGjkzXh52y2NO5nVDAIsnMvJcKG8YaqewGD86KHLYtmXFMCarapTaTCWVysZatWKRFtsf7Oa1cGFub4B7LU+5Et0peo5Jy5BwJGRt3gXx4UiMiXRLOUIZDDspOJrm+5nDoDQxyvPGYw/Opt3lHkRNQWK7+ZKd3Kpx/jStK7rytw5ekcXwpNMEgvGl1sZEpZvR1rBMpSWCbYHNXlrK/XlAbuvz2quXcrVFpJFlEdVYNoGTuCWYEt9Ahr9+GEuMc2CHASDhGsEKR1qdZlGR/W/YpihOxzS4DQhdC/WAHCNWPbCOIu3ZJ6baB7jiEwhceXxaWYQucaVxNuulyX4q9A==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CYYPR12MB8731.namprd12.prod.outlook.com (2603:10b6:930:ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Wed, 19 Feb
 2025 09:00:19 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%4]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 09:00:19 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Jason Gunthorpe
	<jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 098/274] vfio/nvgrace-gpu: Read dvsec register to
 determine need for uncached resmem
Thread-Topic: [PATCH 6.13 098/274] vfio/nvgrace-gpu: Read dvsec register to
 determine need for uncached resmem
Thread-Index: AQHbgqkylkPjGA+BNkOdRou5Fxpf9rNOUm23
Date: Wed, 19 Feb 2025 09:00:19 +0000
Message-ID:
 <SA1PR12MB719961A0F0CFBF6AD3561D94B0C52@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250219082609.533585153@linuxfoundation.org>
 <20250219082613.458476146@linuxfoundation.org>
In-Reply-To: <20250219082613.458476146@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CYYPR12MB8731:EE_
x-ms-office365-filtering-correlation-id: 7f167d32-fd5c-450a-766b-08dd50c3d611
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?OFZ8uSkBGpU+pyGYJcGD+6jDsDhdOoo/MLvmvYzS7y1S2tmQLYmn93/wtz?=
 =?iso-8859-1?Q?Sftn70jnKiLAthb7IhpE2aYP32sC4oxbN++7OhDAsP9p6jEnt9f7dMlX7E?=
 =?iso-8859-1?Q?CI9Nya2HpBUQv1zvty0BA42I9FoyNUaur6kPcnxXzgjTJGuKryX1dUPVVX?=
 =?iso-8859-1?Q?XCQHx/8OgNB15/oIzyRMFQRRw8cIpz0EOUtBTFBOwILRIujmRWpsVpmOUl?=
 =?iso-8859-1?Q?oF9yxkdm0AEanKQ8HKAFf/o9kzOAs9VxKarXp7oMzCiGPuHlSC3aqxLBL2?=
 =?iso-8859-1?Q?RG9jt3u73pnye0qoTqhfBdSkSKjESIDby2PO6uUnNDfnsCWqwwS0PssNEu?=
 =?iso-8859-1?Q?tu3IjEVhjocrThUp6mz9pYTzPSrB8/yQ0jN4A8JIR4sbPtoQSI5twEpgUg?=
 =?iso-8859-1?Q?bP6wWuVE2/D9EA4u5UW07jmhsM/SeYCrj7HAX+yG6jyxPhtBAMQQzuASd3?=
 =?iso-8859-1?Q?rE/E856KzVZW3heqcOqcZZavuZAuLuHEZ6hAPtOkG/auKvLrKpVreJ+3Rr?=
 =?iso-8859-1?Q?b3+RUCXiQjolhj4qI8df2fx+ZW2c0FwpihEWWDISTXmVHn0YSrk8SqtWhD?=
 =?iso-8859-1?Q?H1zg45qqDUsbiO+BfTu++fpZiyzAtbcJ+m5md2ud2L0xjMRpJ0RACjfggA?=
 =?iso-8859-1?Q?qoIIlmo7uAEZo8WXItlhOnSzru7n8Y6W1ZIXi2IDx2mpQZ/GiteV1D5q/S?=
 =?iso-8859-1?Q?6QsR94+8TAZAsYXfJbDF+LMPt1qYLslY3dG6/uXDxCMqmsdVuG4u1fnwd7?=
 =?iso-8859-1?Q?a0FsGsy7Jy0M8p8RWTt6gINTlA/5xwwBGuEWjiKmtSN2GCuWeEhtRro4cd?=
 =?iso-8859-1?Q?SWnUpfsf8x/hqsCvBFKXs2s1drMxbNNuuXNLYnpNBOYAoGClN2ay4h4LjP?=
 =?iso-8859-1?Q?lO51Jfkj7XUuf4LoASw41fV3b8EzlwMhpMWV5EWW3V4bg9G7YRRHXApPc2?=
 =?iso-8859-1?Q?3O4CztAeAqdT8NOQINdbL+kITAO0aIS3cYn1vio3Q2PTswc8oC2LxN53Sm?=
 =?iso-8859-1?Q?X654F7USNdeCJE9Pwg7i/ErSDjqhHYdcSCsmKXKqy042eFt2qZjIohntRC?=
 =?iso-8859-1?Q?gNgmvsVzNVYcrNFVBUTBZD+xxh+u7du4xqOzQ3WwOxA6eUAd13Dqsv63PG?=
 =?iso-8859-1?Q?jxdfoUfxk5mhY6QbQkvVtnG7TwIAkwXtIiiDJdxz2W5XHalnuv2QnNj9PX?=
 =?iso-8859-1?Q?7zb7c9qLKrCmnastsHqIrBe8hURfrXbhqqPz46hIu13bFWyuhcnT8xAjz0?=
 =?iso-8859-1?Q?69NDarUBkTm3s5bWeLYZz4b+dncCkq/+hOqs8X/BK94LI/TbzxKo5bma0w?=
 =?iso-8859-1?Q?UALvaOPfuIhmyckdN1zx+xeXPsMJnBA4wDusMIgbW3eVpzp4E0ride3fDR?=
 =?iso-8859-1?Q?6zKDXKaPGKE7IfLgJD6zDkWH/Sca+KRrajS3469U/JqqhmkZDGdio+11C1?=
 =?iso-8859-1?Q?It2gVY7lUumRZ8TSq0vyAKlkNgQzFuL9Xw61gx9wR6qqw1KAjIbQru1I8J?=
 =?iso-8859-1?Q?srdAoAGGEZlpKMeKfuD3zT?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?PF7my6rw/akK5FN62CU4kcsqMxwsWjCeBm9QwDGaKMVU8lP90B4Ydsb+EI?=
 =?iso-8859-1?Q?/Il0PnKonOl/O9EWQ8K52x5gP5LOGmz89olLtVr0CTcLKPGT3ogMgcpBhx?=
 =?iso-8859-1?Q?zqiJKVJ772/3FPOUQNdSOEqqwDIUVlJ1i0RUshniqOrAnjNUpjQvmU+slA?=
 =?iso-8859-1?Q?V23F/lMFRDJTQcfU6XpaSgDLjvi8XXzdJdZf8cDWaOWHfvOVMfcDpDjTyA?=
 =?iso-8859-1?Q?2jvOwprT3uuW6kHTJKocH8ZNIeiBsxj2WVuUC+t2Iuo0JzcFjvexn1CiYP?=
 =?iso-8859-1?Q?IVbs4STZzRqAJhmVZPuF7S1Re7/lBExEBBorG4Tr+duDQYCUcmkcZObGPO?=
 =?iso-8859-1?Q?BJ0nuKTORy51ViGkepmnzP79uBH8EzMu74LG6aKCDr5SUWK/qGuTrz8nUf?=
 =?iso-8859-1?Q?ymYeErA5hH4RWGdUfSnvErEu+97O0nIWHWT0VA1EziS6FCQ04tZyfn5Kgy?=
 =?iso-8859-1?Q?jqB9GnIf/LVCB48ey9RiyzPSvv36RR+P4gbLhqVyrldG3PWPUe3PPcRITk?=
 =?iso-8859-1?Q?w4Q+adkCFIieA+APQtIIRk8caGYVlMLDilykWH4sdRXeJlymchwNCzTYzO?=
 =?iso-8859-1?Q?sSMKksrzcLd06K/pPswDBdFbkTs/Il5mTbX0ZwUJSEj473+XJyH/5DPHI4?=
 =?iso-8859-1?Q?0wb9U0GW1NMYoQWuFJv/cMsIckR8XyYCMWNxN3FPnzCSnZM6FxIjPqCiBM?=
 =?iso-8859-1?Q?TcOvqYmIR6B212dTN2BwT4oqmxy67Vz5m+GopKeqkeFTTb0fyX1nM1HCbi?=
 =?iso-8859-1?Q?QiFofCnE33LMkqBtTt4FCJRKQxclOq43oBdI4WIsxhE3aZqxGn3oix8YVL?=
 =?iso-8859-1?Q?LRJmEuZS1i7pnq1fBn4Y9Y0ErA+qR88+WGd3ye72qhRZ64b02fAz0MVZgw?=
 =?iso-8859-1?Q?+VPCjh9CIIx2bFAof1jC0en5roijMza+m/XAd6s4ZBW1PIxMX+ERGZyEiO?=
 =?iso-8859-1?Q?YEgKerHr4DBq6HdLnyMp3LAQ0o3mG6m2Uo15/CrCbQGQMHqZhMwNVTA/4D?=
 =?iso-8859-1?Q?ePUWeVx/OADbgILzOPPc9WLQ1oBDRZDWYHrrMxPUkTbCquXMeqTz3/F+wL?=
 =?iso-8859-1?Q?LVi6nx8QFCG6TU78mS8H9SRz13Gx52hUiB9StdXXD7ErSv7iSDNF4GzsyJ?=
 =?iso-8859-1?Q?lCPGroyw58a5zMfrfKFJsQLrhA8mbdAsfhZ7aURAb1KG6cjql4l0Ege7d4?=
 =?iso-8859-1?Q?LwLoHcOWRF3VZ+6uhf20nNz3VwF8qTZS2lQPb/0FCixNGDVGshEdbTRZA+?=
 =?iso-8859-1?Q?pgCmDBpHaORWzuFLXMLQiFMzL5N8k9ylUImsDFScgKYmb/hpfFRdOjuJ6+?=
 =?iso-8859-1?Q?sghMh6RhQ/wkyyK+gc45YMtygdC7qhCmKZyPdud8dC/0lTtleuo4W6jpd3?=
 =?iso-8859-1?Q?PA2Zws1N20Ua0Vtjrlo4owR9AgMK+RbNh0DH3Ka0fNoN4g4FD66H4mNmL5?=
 =?iso-8859-1?Q?kZXv1GO/ywUOz98juH2c+8YW6TJi1qaGTgmO57a4BAmuRCsbkyxQybKfE8?=
 =?iso-8859-1?Q?nR7sMGi5rrxcRegGjAyhzD7BSsGj3Yc+lgDb//UYQDY2lBQxcQE42oQMYP?=
 =?iso-8859-1?Q?YjHhJlTrQbIPm4chNwhM9oA2cIAzQ8uN0jJbupfoJG8pm4MtsH8nks2UDK?=
 =?iso-8859-1?Q?5nO54uhLgW2yg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f167d32-fd5c-450a-766b-08dd50c3d611
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2025 09:00:19.6496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u7nze2HLta6/60uEeiOZo+O9zYw+d1BSLkEN1RZ3gK0kcSQkVF2/4Vh5bF0xnsU2f4wUYQ7uJXrN8d4PhmhJVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8731

Hi Greg, thanks for sending this out. One thing is that this was part=0A=
of a 4 patch series. However, I only see 2 patches here. Are you planning=
=0A=
to include them later? Following are the other 2 patches for reference:=0A=
3/4: https://lore.kernel.org/all/20250124183102.3976-4-ankita@nvidia.com/=
=0A=
4/4: https://lore.kernel.org/all/20250124183102.3976-5-ankita@nvidia.com/=
=0A=
=0A=
Thanks=0A=
Ankit Agrawal=0A=
________________________________________=0A=
From:=A0Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
Sent:=A0Wednesday, February 19, 2025 1:55 PM=0A=
To:=A0stable@vger.kernel.org <stable@vger.kernel.org>=0A=
Cc:=A0Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.=
dev <patches@lists.linux.dev>; Jason Gunthorpe <jgg@nvidia.com>; Kevin Tian=
 <kevin.tian@intel.com>; Ankit Agrawal <ankita@nvidia.com>; Alex Williamson=
 <alex.williamson@redhat.com>; Sasha Levin <sashal@kernel.org>=0A=
Subject:=A0[PATCH 6.13 098/274] vfio/nvgrace-gpu: Read dvsec register to de=
termine need for uncached resmem=0A=
=A0=0A=
External email: Use caution opening links or attachments=0A=
=0A=
=0A=
6.13-stable review patch.=A0 If anyone has any objections, please let me kn=
ow.=0A=
=0A=
------------------=0A=
=0A=
From: Ankit Agrawal <ankita@nvidia.com>=0A=
=0A=
[ Upstream commit bd53764a60ad586ad5b6ed339423ad5e67824464 ]=0A=
=0A=
NVIDIA's recently introduced Grace Blackwell (GB) Superchip is a=0A=
continuation with the Grace Hopper (GH) superchip that provides a=0A=
cache coherent access to CPU and GPU to each other's memory with=0A=
an internal proprietary chip-to-chip cache coherent interconnect.=0A=
=0A=
There is a HW defect on GH systems to support the Multi-Instance=0A=
GPU (MIG) feature [1] that necessiated the presence of a 1G region=0A=
with uncached mapping carved out from the device memory. The 1G=0A=
region is shown as a fake BAR (comprising region 2 and 3) to=0A=
workaround the issue. This is fixed on the GB systems.=0A=
=0A=
The presence of the fix for the HW defect is communicated by the=0A=
device firmware through the DVSEC PCI config register with ID 3.=0A=
The module reads this to take a different codepath on GB vs GH.=0A=
=0A=
Scan through the DVSEC registers to identify the correct one and use=0A=
it to determine the presence of the fix. Save the value in the device's=0A=
nvgrace_gpu_pci_core_device structure.=0A=
=0A=
Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/=A0[1]=
=0A=
=0A=
CC: Jason Gunthorpe <jgg@nvidia.com>=0A=
CC: Kevin Tian <kevin.tian@intel.com>=0A=
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>=0A=
Link: https://lore.kernel.org/r/20250124183102.3976-2-ankita@nvidia.com=0A=
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>=0A=
Signed-off-by: Sasha Levin <sashal@kernel.org>=0A=
---=0A=
=A0drivers/vfio/pci/nvgrace-gpu/main.c | 28 ++++++++++++++++++++++++++++=0A=
=A01 file changed, 28 insertions(+)=0A=
=0A=
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace=
-gpu/main.c=0A=
index a467085038f0c..b76368958d1c5 100644=0A=
--- a/drivers/vfio/pci/nvgrace-gpu/main.c=0A=
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c=0A=
@@ -23,6 +23,11 @@=0A=
=A0/* A hardwired and constant ABI value between the GPU FW and VFIO driver=
. */=0A=
=A0#define MEMBLK_SIZE SZ_512M=0A=
=0A=
+#define DVSEC_BITMAP_OFFSET 0xA=0A=
+#define MIG_SUPPORTED_WITH_CACHED_RESMEM BIT(0)=0A=
+=0A=
+#define GPU_CAP_DVSEC_REGISTER 3=0A=
+=0A=
=A0/*=0A=
=A0 * The state of the two device memory region - resmem and usemem - is=0A=
=A0 * saved as struct mem_region.=0A=
@@ -46,6 +51,7 @@ struct nvgrace_gpu_pci_core_device {=0A=
=A0=A0=A0=A0=A0=A0=A0 struct mem_region resmem;=0A=
=A0=A0=A0=A0=A0=A0=A0 /* Lock to control device memory kernel mapping */=0A=
=A0=A0=A0=A0=A0=A0=A0 struct mutex remap_lock;=0A=
+=A0=A0=A0=A0=A0=A0 bool has_mig_hw_bug;=0A=
=A0};=0A=
=0A=
=A0static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_=
vdev)=0A=
@@ -812,6 +818,26 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,=0A=
=A0=A0=A0=A0=A0=A0=A0 return ret;=0A=
=A0}=0A=
=0A=
+static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)=0A=
+{=0A=
+=A0=A0=A0=A0=A0=A0 int pcie_dvsec;=0A=
+=A0=A0=A0=A0=A0=A0 u16 dvsec_ctrl16;=0A=
+=0A=
+=A0=A0=A0=A0=A0=A0 pcie_dvsec =3D pci_find_dvsec_capability(pdev, PCI_VEND=
OR_ID_NVIDIA,=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 GPU_CAP_DVS=
EC_REGISTER);=0A=
+=0A=
+=A0=A0=A0=A0=A0=A0 if (pcie_dvsec) {=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pci_read_config_word(pdev,=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pcie_dvsec + DVSEC_BITMAP_OFFSET,=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &dvsec_ctrl16);=0A=
+=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (dvsec_ctrl16 & MIG_SUPPORTE=
D_WITH_CACHED_RESMEM)=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return =
false;=0A=
+=A0=A0=A0=A0=A0=A0 }=0A=
+=0A=
+=A0=A0=A0=A0=A0=A0 return true;=0A=
+}=0A=
+=0A=
=A0static int nvgrace_gpu_probe(struct pci_dev *pdev,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const struct pci_device_id *id)=0A=
=A0{=0A=
@@ -832,6 +858,8 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,=0A=
=A0=A0=A0=A0=A0=A0=A0 dev_set_drvdata(&pdev->dev, &nvdev->core_device);=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 if (ops =3D=3D &nvgrace_gpu_pci_ops) {=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nvdev->has_mig_hw_bug =3D nvgra=
ce_gpu_has_mig_hw_bug(pdev);=0A=
+=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Device memory properties=
 are identified in the host ACPI=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * table. Set the nvgrace_g=
pu_pci_core_device structure.=0A=
--=0A=
2.39.5=0A=
=0A=
=0A=
