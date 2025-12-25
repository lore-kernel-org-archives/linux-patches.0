Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D21E10E3
	for <patches@lists.linux.dev>; Thu, 25 Dec 2025 12:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766664031; cv=fail; b=S/ZHFY7kwHFfE1+ZFqrVuAjhPKCr35IAr9qpItfwcCglOGc2NujGgZOrde4dxoXj+56a6fRAmBonY4q5msf3l2X7CqInocz7CFAwUuBJ2zwCjNUQ/w0nf8PivBJ7Fy7j2bhY5FnEFyWi3l5IPxfKSo+rZcU1H+5cjL1HzjE4zSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766664031; c=relaxed/simple;
	bh=NPtoZs0MbjScTLDIU/E74CX/PHZrdwkx3dBJBBqli0o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y1/8jqQrKIhwePGsmmoCjYbcBW2RRoSceTzlRi23wD0JAWFN6HI2tgylq0HX0zOIoGajK/Lf6XQAmTdjk2DvEGRLzQsmqXdeuHNw4NVgDZD/FdL/mkIFEWeoGtAgLJm6OYKN/a2MIj1j6FllGjRkd9fJp3GbFpHwTRpRSlFoUyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=RvM+TpXr; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=g+aC6BpK; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RvM+TpXr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="g+aC6BpK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1766664028; x=1798200028;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NPtoZs0MbjScTLDIU/E74CX/PHZrdwkx3dBJBBqli0o=;
  b=RvM+TpXr2fogc0SvClQYvbmLoCAMtySlS6f0IucllyFkQ/aWIALiysp0
   nqYnGW3XeY+RbVG459zdnimjl9cz9BwRLLb/5cH9BAZneJ8JC/p7sVBhZ
   fK5cyP2Z8YYef1czZUu+TMUlHMz5RdFwyQaSS37UwgUojxf/qUAmqCLPK
   djQvAvI2IsLD3/jiGq70HSU06T/MA9DC7S7ieWIr2XA10nTTD8sn8iDGM
   X7kpJTi1fwnZahFuUxN1ZLvSJij//ZigRilzwU1x7d6ml7BQhMPiDxyjP
   BfwpldJECiplsKKO3TiFCLiLqmXRWhVl99cpBPHNQoP/+ingNxSK7gOfE
   A==;
X-CSE-ConnectionGUID: tYgF5SyBT/qspcp3F0W6HA==
X-CSE-MsgGUID: Y1wplNBHQ2KKUa83do5+lg==
X-IronPort-AV: E=Sophos;i="6.21,176,1763395200"; 
   d="scan'208";a="137740090"
Received: from mail-eastusazon11011062.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.62])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Dec 2025 20:00:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QRHRyr8hL0vvYZ2i/JNOR97gjAVPFnGN8VwudGP3Zf9pFqDqwDUiof+jtjUZuodGn1G6/HHuB1e+KHqqksV71VHuA5/GATiiN3IwrheFuE1Jin00GMHXOEvhNRsPFRhuxng8CLo/lD2Cg7ob2DKHgTROdP2sd6YEhag167Zd7VFCugyztRdYsaO1mBzR59tRj7+8IrVX9CQ6+g/wuRUsEUhpYCdKT+Ls5gdIimvkl7+rnHuCYxKt893qn96JHV/Qrg8v0aOtnOgDBXJQmBk5ER121TslZqoJJSZ3Y+iyTRrCb+X2gEdhps9U7WNdu2vjeITuJJOCm0MVBOrMp9tYyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knYrqA/int/Apwx7yYR86HFyViPVv2k5JVUpqzu8ne8=;
 b=Aky+YAp/KtwZ7j3L3m7sI4vdjK93ilE58pYBuphbNh2ypmDmoOSXRZAt64dC8pgydY2Dr9pf6y3gYlwskojlWkmm5AZkNHRh6KSHpFeMohfTwviuu/TwVznDXg6UlOVm+iwAzeHo8U3mN23jLo4d9xrWvS6RMw+rRHriK8+rsDL5hriXFpd3qs5iKnGr+9bAM56DybUjSF+JICYSVWYvwdFLkmlhDaBEosdKiVIxYh/8XJ7BfLnHcm1RQzRglbfBX73u3DJZkCQ+IW6r8U5NXCaZWOcm14W/OhiDo052jJ3DpHXlbsooj3F2B7so5a0AQwbixmflUp5Y/wY4aqtArQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knYrqA/int/Apwx7yYR86HFyViPVv2k5JVUpqzu8ne8=;
 b=g+aC6BpKe3N8/pLJArlSWecxHVXwtgKFd7hjl+KvNyEys3wHA3DgkGqEvC7idG0UXiH8u4YYvGe5qEM7XIbZAgXlnJE7auFzZ8EAsVmr1YR470EnBSO2abrWm6RWIb/Uy3u778dhY+h3LRDfQbOv7A02d+Onz28sX+ujwnWSwpU=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by LV8PR04MB8958.namprd04.prod.outlook.com (2603:10b6:408:180::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Thu, 25 Dec
 2025 12:00:20 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9456.008; Thu, 25 Dec 2025
 12:00:18 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Swarna Prabhu <sw.prabhu6@gmail.com>
CC: Bart Van Assche <bvanassche@acm.org>, Luis Chamberlain
	<mcgrof@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "gost.dev@samsung.com" <gost.dev@samsung.com>,
	"kernel@pankajraghav.com" <kernel@pankajraghav.com>, Chaitanya Kulkarni
	<kch@nvidia.com>
Subject: Re: [PATCH v4 1/2] blktests: replace module removal with patient
 module removal
Thread-Topic: [PATCH v4 1/2] blktests: replace module removal with patient
 module removal
Thread-Index: AQHcXverMdISXcicTESRwucSMTRsk7UFOs0AgCNYDACABYvggIAET2mA
Date: Thu, 25 Dec 2025 12:00:18 +0000
Message-ID: <aU0kLVQHvE5Jicfk@shinmob>
References: <20251126171102.3663957-1-mcgrof@kernel.org>
 <20251126171102.3663957-2-mcgrof@kernel.org>
 <a38bbe68-97e8-4476-a406-5c5228167e96@acm.org>
 <7e056be2-d9c6-41f6-848d-f87e91983968@wdc.com>
 <aUmJtfPM7A26swxN@deb-101020-bm01.eng.stellus.in>
In-Reply-To: <aUmJtfPM7A26swxN@deb-101020-bm01.eng.stellus.in>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|LV8PR04MB8958:EE_
x-ms-office365-filtering-correlation-id: caa0f5d1-0390-4132-e610-08de43ad2c74
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?6ERedl1v50DJ237GKpavRTTvi91PFM86on2jSKvxc4+7JQEMV5NWFt6TR28s?=
 =?us-ascii?Q?ULTuFyYjw9GLdSyI1FkLc53SqN+3P8BdKT73w8sUdSprJLIRhZq5NOniQPw2?=
 =?us-ascii?Q?DGkzPNO5nm9j0NebsBEv+NPHARsVyJY0GJuqE5hYLpHcJM6oAozBhiUGR7ki?=
 =?us-ascii?Q?F2uvslV5QIoJ9Ht/Hrd8wscACd+HhhHtJ6F+pSskJ9R0L/QrILg0pH5qMhz/?=
 =?us-ascii?Q?V/DYOz2/hC1oTrh7W2cgwSEmXji3TIo2spwPJrykugTMBn3y+9E9YPhq9yCx?=
 =?us-ascii?Q?E+wYGblGECXwe8XorSPj+RsLmW+w0v5T3kESba438kcyRMoWFnvrWMFDpKG/?=
 =?us-ascii?Q?ZVk7mFziKqlNpcoPOO2Dj/IeIrtTP5AS/kAgHVZmiKsrWPRmZKz0FqQlJxOG?=
 =?us-ascii?Q?oG5x+JaJ62tFMFJARAenEk/O9VZ2diBY+evTVgGkadfFgIRLg1QnW8kbOWct?=
 =?us-ascii?Q?arxdTmJ/ZjcUUP37gXCgfAItNTyhdzyCLbvlAaTTa+McJYYiiP3b6R74bZPi?=
 =?us-ascii?Q?7h0+GZQoi/2bj05s4BBK4GS8TQj1ffClkkjXlHIfyjJyz8tNOGZM+2IVN/Ix?=
 =?us-ascii?Q?4bxiRTup5NjMfdq0sQlwukUKkVmfh21LUIk7fhw7sffCzuE7mjVB+W+3eGJd?=
 =?us-ascii?Q?2VpQ7OwxvLXxIDb8gvpGWxcazCnyIFgrdzUjIPI9nGg50tZb++E1HHj9hBUa?=
 =?us-ascii?Q?WXA2w5n0xAJqL4w+sDRU19THuG5jSdBfy0ChcmCTluTIcEsn9shAR7gI6tuj?=
 =?us-ascii?Q?2BxRId16VsJpo3A9E4XORMmUB3eKLW6f0Trr2pr0WJijUri9+wAR8aUSXkZz?=
 =?us-ascii?Q?1sdkPqIaGb/34hUpimRmH8F6TjQ5FwpDRh2rijKQ6risrHgDd2mKgS8E4lUr?=
 =?us-ascii?Q?YtPAe9teAls2ushTnqgeDE9BHU5qLOctze6La83dammgHmMD92m0PAaBAGlI?=
 =?us-ascii?Q?n55ovu5Hru6c6qnjQ1Se15m+E+OGUrGXV7T7BW0Uh2SDrBDzGQSRdzZsm/2i?=
 =?us-ascii?Q?qAQKAdF6fXAkW6fX22Tbxxy2C7Q88663bRnH3zp4vFXHaaRlNL6FiaYYRMWs?=
 =?us-ascii?Q?hAnfr4op17aNghMKJCOFSK/WuS5JzgksIGxEp0STXluyAKJWH8lVqudksru9?=
 =?us-ascii?Q?UKh4Emx9pCDNiw4qAxHB+CSEMqPc0vBl8xjbi0vQj1hKUzMnOe7A7dbaaC0H?=
 =?us-ascii?Q?Dzf1cPnr0EFq7a0Idp+OX0dllL7Yui4P6wDF8xmknfmkodBrXlA0t7E1uGV9?=
 =?us-ascii?Q?xmnHlPF9sGVbn6ZZPWdHW2zlGeV9rVmP+ZJPe/kKamTiuhnAgslBzzUohWiD?=
 =?us-ascii?Q?RxTuLVQSrcBkLNj+bLQbjUPr+lmdi4uYhNfBfgep5rgsddsoq7VIGaOfP8wb?=
 =?us-ascii?Q?vJ22ROXHmaVjY3UfDk+qtczScWtL/t4CVQ6RyIyvacSpjnWxL6KuSEIlmcxQ?=
 =?us-ascii?Q?Vc8wAPpvlTmEH8/aR7GgB0yYXqEpJjv+fHIxgNYJIzPgg0daWvhfrp2LKkL4?=
 =?us-ascii?Q?z48jYkKl4Et3L/R1nKJm3B56DOrLarMtLrZZb4wqALCEmV+PBQ6El1RoUw?=
 =?us-ascii?Q?=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?GS1/Lj++RkUH5uiWn+5xuuB8Etd+NSi+NrX2hvKwqvTRGgA9ovPXco/L05PX?=
 =?us-ascii?Q?NCRkv/nTs//VD4sLUAhCvm8WtC5M041ZJirwzMPTZk3ZGZ3R+3djFCSJl5uZ?=
 =?us-ascii?Q?L0dUKMAJvYN2W+ai+9wCULI7J/J6b6hY4egzMte588ZJHYa1R1uohh4QGQ2m?=
 =?us-ascii?Q?4wTnO/nzetfl59N6cI8FEkXASl7g7JVn0jDMmAQLqNPl9RqIw4xbJxQlNqvk?=
 =?us-ascii?Q?5t/JaEdHEPnDKHZ7LZgiVVq91qIQOHkPif1dCMdRio4gbzzFShYmdXJhTu4x?=
 =?us-ascii?Q?RHZBsLPW7Qip7JMJxPppGoAYrqJOZZf5L+xeOg40iDvAmsObFg50X5OQ0+XZ?=
 =?us-ascii?Q?wyDQ+0oicKbtCmEd4nMj1gzMH3M9Dl+YcUN2G5TApC0wT1bGBXC90oIeET84?=
 =?us-ascii?Q?CrCrZYG3qWNT4EOwDrRCz+6VccwmwWVGADnBw6au3BLtG2wOFU9WokIzGYqp?=
 =?us-ascii?Q?YI439Vih/Q3IjHvjhJvO7NOwlCql+h6Lolm7Z3XCiXDgT5caOnxMuYge2YmK?=
 =?us-ascii?Q?wDFv//4vJxk4Bdl7m4m5F3T5X9whIZtNDgGg0efLImkCFckXfH3/MaJTMSM5?=
 =?us-ascii?Q?3Z9jog7jSPhoC4d4S/VpzMIvNnc5p5dFSrrdF5x7OWBWPjRMbWC4NLOzgvNK?=
 =?us-ascii?Q?lDi0g8jqf4LYUcaS+wUF6hlNC0zE/xOYW/KlZe3/Cwsp0hQqO0VpCPfqEXiW?=
 =?us-ascii?Q?SgBBwXQ50abaAxfHpq6CnieTJuyBF9cg1dWExNjMiMOCn3bzUTcU5NNQ0SgF?=
 =?us-ascii?Q?PMmJcwrJSap6qMCUQRfkKjtZqdsqNfZucP9oKnr0oFeuR9OwLGd/bbutX0ve?=
 =?us-ascii?Q?aafWrvFTGUg8VzHvWFmWsydj+il1CbSXbvEYPjDVEQZ4RawwupG2L45grDpe?=
 =?us-ascii?Q?95/jMiCcUgO6fDyINPsDG/Esl5x9p2y6xMiQfK0ToiMqqm5kAHVlxdkY8JkE?=
 =?us-ascii?Q?uCeNRK6AItbpQlAZzERKTtGsj/QfrpkX+2EOmlWbH4FCNfQJ/ZyYYR6dOLZ9?=
 =?us-ascii?Q?toOsO3brCZMjHBiePcazJheStai/kqmIYOhAEa7S7RaKP3M+qQNwCNTsidro?=
 =?us-ascii?Q?tc9zsUy99vINChkZfoAFmi0cdHe0JfJ2PGGyH5mt+KvL+t3PaAEKloTzfVkB?=
 =?us-ascii?Q?//7+BWcT+QlM0soP4t5YpfQpS7838iXzodUac08QJpTcw6x02rGJyQibBhuu?=
 =?us-ascii?Q?iMwk86dvHedYQ17og+qVzW7OFgf3V45HXiqzyCf79KAjYh3wy31z85G9UYGO?=
 =?us-ascii?Q?IuXuqQ2IHPpLrH3v3NsUdoAlMIsXk3d3QTGd7WoxkVsDri/j0ghpNuAbPvUN?=
 =?us-ascii?Q?D6btOn9bGd8Tox9H2j9sfK7uRZm4fs87DuflVzzbZvyqiObNRwa6NpciwEM2?=
 =?us-ascii?Q?f91i6h1ADqeSRTLI/1UI7EN+vHl0PV/MEib1STpYYFlRzshWl0PzGOth/Ti/?=
 =?us-ascii?Q?MzQGpqVavQ7twJrm6CrRqB5ZAHw5OEI1Zeb6meKGRJPIy78e1BguBjTYX6Fn?=
 =?us-ascii?Q?TkN8WhH6ZoyvhiTFpZNLPO93KPkAxi/NImUmAkZgITQ9l22u+FQQSJDbXVKI?=
 =?us-ascii?Q?gQLaPuPS1m1qeY0l+CLpTezjNCs1obPyDohSHeFQdV7rReNOJzCKjF3kuNdp?=
 =?us-ascii?Q?6rNxgCOK6ECIOY7OdXLKZR2Xm6QFFv8qHR0AosHplR3Taupnqa1qdiw7K4y4?=
 =?us-ascii?Q?zo/yV1nT3PPnui6bxUIrKbdCFZYgSlFjGTWiIiGAx+WPWcH5WmFL/+1WX3nZ?=
 =?us-ascii?Q?uPL97b4y0QDWeWjcWEImn+fFktFTO2E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BC9BD263486AF44A9A7BE9E3A4CBAFC2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zOOSZEjOO7A62y3Unvy42YeyCgAUoB2bU93iQN5MHiosc8QnhLj4yaDBe9f2jILGVEbzeYjV1EIGQNCu68vmLGewapKwaPtwAUqZjNrYBdt8dwCbUXSOX/qOYWoitRKdYiJ4QcDzsirsGoyV7M6/DVk2dFKtH0jCkU5r00EVRKtSRzrIibUqXZdvKr0nWMfQtMlk1UU8u6JWvYL9lya7E8/pM8J3BONhbI5pLqUfioZQ8OytX315PiDjDS5S+t+8MDnB/bsQ1Mhz31qBwLujILt1tMxcUSEETP5NmcQ3iKgQ+KfEnids0PNDpyAXtuHmomvN79EgjInNozi/uLUMwm9MHGIRXwRmvUAUSh41Gk/gRijAI7g4VkjAbkefzZ1r5SOSiQgGzbhHUxji3AOSYVlK1tGaIQrE17QeRsVseKPLbEwdP7SSCQlHGBUvdz5nIXsNAxRp1TUBtMxl3v62mkp5ADFfKhiz1AU3xDMhjMwrDCusH12i3Ig8QGi3P9K74nKOUPxKiOWSOGG+GitjbVFMF9ERV9jbYL7WLE/HrK1WbSKzrRf+yfe060wTQRrFICbJaecIrfQmzH6MyFrNxGAkEt5vctTA9JEryzxuqVsQl2JDjLulfSZbCXrrVnP1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caa0f5d1-0390-4132-e610-08de43ad2c74
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2025 12:00:18.7118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZUovCjy/ErfmW3w8JFuYX3mFIIZxD1RoyRRPpZAC2u1AArXraXIrliNwyw+tilxnorV2zn5Y7dkKWYJwQ01hB2nDqxkIzftNqVA+v6pgQzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB8958

On Dec 22, 2025 / 18:11, Swarna Prabhu wrote:
> On Fri, Dec 19, 2025 at 05:29:06AM +0000, Shinichiro Kawasaki wrote:
> > On 11/27/25 2:45 AM, Bart Van Assche wrote:
> > > On 11/26/25 9:11 AM, Luis Chamberlain wrote:
> > >> Long ago a WAIT option for module removal was added... that was then
> > >> removed as it was deemed not needed as folks couldn't figure out whe=
n
> > >> these races happened. The races are actually pretty easy to trigger,=
 it
> > >> was just never properly documented. A simpe blkdev_open() will easil=
y
> > >> bump a module refcnt, and these days many thing scan do that sort of
> > >> thing.
> > >=20
> > > It would be appreciated if "thing" could be replaced with a more
> > > specific description of what actually happens.
> > >> The proper solution is to implement then a patient module removal
> > >> on kmod and that has been merged now as modprobe --wait=3DMSEC optio=
n.
> > >> We need a work around to open code a similar solution for users of
> > >> old versions of kmod. An open coded solution for fstests exists
> > >> there for over a year now. This now provides the respective blktests
> > >> implementation.
> > >=20
> > > How can it be concluded what the proper solution is without explainin=
g
> > > the root cause first? Please add an explanation of the root cause. I
> > > assume that the root cause is that some references are dropped
> > > asynchronously after module removal has been requested for the first
> > > time?
> >=20
> > I agree that the clarification on the above points will improve the com=
mit
> > message. Said that, I do not think lack of the clarifications should de=
lay the
> > application of this series.
> >=20
> > Swarna, Luis, if there is any URL to the "flaky bug" that Swaran faced,=
 please
> > share. I can add it as a Link tag to show another reason for this serie=
s.
> >
>=20
> I donot have any URL to the bug, but below is the description for it:=20
>=20
> I had seen a sporadic kernel hang  while running block tests (block/003) =
when testing =20
> scsi driver with sector size 16k which is detailed in the  testing descri=
ption of the=20
> cover letter sent for RFC v1 series for scsi fix.=20
> (link here- https://lore.kernel.org/all/20251202021522.188419-1-sw.prabhu=
6@gmail.com/ ).
> The fio task triggerd at test block/003 would race with udevs generated w=
hile stressing=20
> scsi debug module in test - block/001.
>=20
> I havent been able to reproduce the hang in the current setup lately, so =
i pasted below the=20
> snippet of the dmesg i had captured when the hang occured with block/003 =
test:
>=20

Swarna, thanks for the description. The problem you faced looks like the sa=
me
problem that Luis described. I will amend the commit log to add the link to=
 this
e-mail thread for recording.

As Luis described, the problem looks having multiple aspects, and this pati=
ent
module removal solution addresses one of the aspects. Another aspect I noti=
ced
was that lots of udev events influence following test cases. Similar proble=
m was
observed for loop/010 [*], and solution for loop/010 was disabling udev eve=
nts
during the testcase run. At this moment, I think and hope this patient modu=
le
removal solution is enough for block/001, and there is no need to disable u=
dev
events in block/001, probably.

[*] https://github.com/linux-blktests/blktests/issues/181=
