Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E4912FB3E
	for <patches@lists.linux.dev>; Fri, 17 May 2024 17:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967253; cv=fail; b=bn1VYhjy11wF3w9/ejFc7U6+VM/Vwpk9I+QBRW+fx5ph/mLFLXA3Q+a3jqWor7vlOCq15dYsB9+Qdxjn7hF1WrzYzsQv65WQTgDPNwYF8wXNT2i5zgtpX8u886Bp9cESXARs1jVu5phQSWXqMqvI8d6Bu08rAbzxE61NFNrjT/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967253; c=relaxed/simple;
	bh=eHM/cGN/ra+h/pjGDBgAitE0l8YbOjfigVLPWeO1vX8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tEprAJ9iJHyXYMAH6qfMip+Fu/mPxaOjBimldZkVG7MjtmD+qsUQvAwV2CKUn7jEHrb8jt0hqMH7K1JTt1AF5iska5pw9TImUOnlg8/grE1vtJzV8T0XdL5JvfoudyCmg+alZ0K94gawflM61WcMk6l+D4DDFQ3HilAaOWat6pk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hRx/x4GZ; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hRx/x4GZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715967253; x=1747503253;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eHM/cGN/ra+h/pjGDBgAitE0l8YbOjfigVLPWeO1vX8=;
  b=hRx/x4GZiJ6v3zySl/uOQKh0nLOcsopygtqxENWq1xDTuWCMI0JTv/cB
   11+fzZF4K5XldswiHQLm/5+mqySE5c1NHrqt/JMThA50oPhWua+gir+qh
   DBxaWhIfGmdWVq5gAecBJ+HC/0RUKGVquXQPzMKebdgJxjeU8lY6oFed+
   rckycXSvMMQVBIoVcmsH5+fXNf/r/6qoZBREJ11vUhHv0NTA9uNr6n2KV
   pjhHfvqxJwiitiOABD/Zz53iH6vJuJGIeA8nhxIgUcbWyJw+lKtFoI2IN
   13PzPgIEg4lyxEgdv6tdqhRT9MYZi2x41QPXzeTxnZqZnQrxpZk/2aWvi
   Q==;
X-CSE-ConnectionGUID: 5DwfzmUaTz6iSGPu1EiEtQ==
X-CSE-MsgGUID: p1LreE3BSX+yCfk0Rl8o9A==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="15989667"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="15989667"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 10:34:12 -0700
X-CSE-ConnectionGUID: OJNVBta+TOqlhUzU90RXBA==
X-CSE-MsgGUID: 4n8RrjJwQfG0lQ71lerwww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="36669135"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 10:34:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 10:34:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 10:34:10 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 10:34:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYySl+qIqlfIRVJ5u9qRaalQRRCMK2M5cmqRhBZrQvgEpznN7vBc3ls5p0vJDg/iBbGgNZPpWTRCj9ZKFGlRnLgQUVlYI+kNF1LlxdJAD7BlBBlUCH8hV4W/hFx51Hwwap8UOHGjmhFymPOVFf22+D+O7hjV7McCd2CCrCihdgvf1v4HCjnE+JyqlGZd3btYshGXQ2D5m2s6sHhb5yan8AUchu9AIaQtG23JWN1fqFoaSJIlOAxoBcRs0Mda50cpH4h0PSzlB8r90sd2kNXxlARRfuOU2UmvC9H/vglOvufeRsxs6jJVPCb4nCPmOtQpfqWIGvgF/MOByKOdScCX3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlQwzNMi/kAlbERZCQVpRn+2VuXlXril5bSzMjoUMG4=;
 b=OKCVUjBvoQTwlLcWukjCdHo8vJ9TYdApIpPnwEt7KOsaNtu4R0ctfSu/w9OvcryxoDshaqPIDJ7MWV0meErE6Hoky5D9fkAh0xlQnyzPMerg9OUyRx1qQPTmZ4FxiihelaEeAP+jxIRPqlb00dG39teztMf6pwTT2adanoGzdIVTi7ABnMlCU6aX4LaL2h1rYBwYDYdGfpb9dWOPHaYsDICjoWnECOzh/PU2eqhwkuHbQZQQqST6+F15KfIuCmx92adfDfK6NCWoFZ9uOveiuN1jRVwGgc3BahdM9AWs7q5h1PfB5LaiL4feX49WKRpRXkj6jhUvDLgqiAXErzVvjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH8PR11MB6975.namprd11.prod.outlook.com (2603:10b6:510:224::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Fri, 17 May
 2024 17:34:00 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 17:34:00 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, Uros Bizjak <ubizjak@gmail.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik
	<mjguzik@gmail.com>, Thomas Renninger <trenn@suse.de>, Greg Kroah-Hartman
	<gregkh@suse.de>, Andi Kleen <ak@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v3] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Topic: [PATCH v3] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Index: AQHaqH6zwUWGNcLDPEWX8DDSkF3v67GbrzUQ
Date: Fri, 17 May 2024 17:34:00 +0000
Message-ID: <SJ1PR11MB60836FA552BC0DFF4FDDD449FCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240517172134.7255-1-tony.luck@intel.com>
In-Reply-To: <20240517172134.7255-1-tony.luck@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH8PR11MB6975:EE_
x-ms-office365-filtering-correlation-id: 13bf6e88-9e00-45ee-ab00-08dc76978a15
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|7416005|376005|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?/fno5y0noCqBtPL2VpwkC5p4AxST8XtOaJHbPuqMPXMd7EUnuVbVugOscS80?=
 =?us-ascii?Q?ngA5pqlfYwYwE9n89B1OqQj9S0e+5etRUZhNSXRCh2gmw/eF4HypDbM6v8zo?=
 =?us-ascii?Q?0HFcLB8u9li7KYvNynQszXXn8Mv7qITvvR8EhdBkmWwH5n5oi3xH5zvKZsNd?=
 =?us-ascii?Q?1gy1FiF0Oc1bwRMgUfVAglC02vCZsyODFwwUchQe4A/YbfRkGbXH1VHKF/Y9?=
 =?us-ascii?Q?FsdQv6+1nF4Vog8zuhQhdy834P49/kSgCnDOhRJfPNLgT5FxlM3T6pTwJl8Z?=
 =?us-ascii?Q?pvlAjR0sKIssCNMT0g5Z2cggpea3+vJnsuM75lcThovT7SjTYezSczdgSaRy?=
 =?us-ascii?Q?Hj8p5xFohjn2PAeQRttPpr9QuxpHtTORBYxDeSDwzokGcUS8rthy0CwnE76I?=
 =?us-ascii?Q?OzSRHKin2GLcMvu0v4HmEAzt6YSqPe/tUVKo5OSEdJ6zzeA6iWcznp2OTJNT?=
 =?us-ascii?Q?fCGwfw5RqU3oTH25c4G1NII/2dUd+Cd2bZEKT+RokoRQTXOFwPbnCsWd6c3I?=
 =?us-ascii?Q?GsmMxCpCd4pNaW8/gUldn1xy+rK0umU+YLI/kZE4FyOorJVI1ufFdKkBlHeV?=
 =?us-ascii?Q?BfmCFOa96J2y71cnAXYgUql56841Qhx+pqy/HCLE+W1A+JRPW7R8odROMllQ?=
 =?us-ascii?Q?gy007tQNKj9fQxWczlRcwpd8U61ynEKDNCpY15pFojQDG2b+Hac9MuIJ7iEr?=
 =?us-ascii?Q?bQ3GiyOrxv6lh1eXJpfcHWhBdr87Lm20pUnyRQl6PiF3HZR+IR2Rm0zxplQ7?=
 =?us-ascii?Q?V5SZ4S9hxjHoxQsY4UxpzJQO9/kS/VZHfnLYduI/BfR8RCw7/RokEUDoITED?=
 =?us-ascii?Q?8ugkBvRKVgYlW4DNMhFStY42Ki2U2x7xicTFToMgkEcA0wXJk6GAUCYs68um?=
 =?us-ascii?Q?iuxPxKP7HmE687pCCd5tk1sU26oe4/WbYGIdzGr7Z6szCcuJR/rQdiC8mUov?=
 =?us-ascii?Q?H6lA3a1xy/BjL67XGPByDT7GIVw+Gqg3NQLHBUISD9xb25XfdzhYKZ4PlDvx?=
 =?us-ascii?Q?8dff4/JOAQFMT+fA+qQEz26awqeRnFBwRRJsmx/vxf1quNBhBqsLCkKpIRd/?=
 =?us-ascii?Q?4VL9F46BXyw69MstE+rE2xQCRp9tSSqTuW7X4o2I+XWdSoTgk7cbg0ffp4yU?=
 =?us-ascii?Q?j8K38fVUT35qRDYJNnPWUVizIeJEfEQc7TTwNUtdyR8RVgU+9jRSoTfW1nte?=
 =?us-ascii?Q?oJWhWEKGyKAJiVNAE3Lt/ro5bUZKcVHWRPhaWFB0/LCUb5SzyimFnSWN1FGq?=
 =?us-ascii?Q?0Ihz6Q6v2hpmhGkHO1A1Vpd6rGIzlfpidbKB/um3VdU9YSbldrx2iINXKMdR?=
 =?us-ascii?Q?9Ut/a4w2Xojd4p52Pjz2uubErFgcwDqx7B4dj6HfuimhIQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?E0QRTYQjBtrJXWHbU+0qpxURFYN41a3CBq3yYHP2Fozari1xl1xUuF9ip2HY?=
 =?us-ascii?Q?FEBIjkbxm0vaCeN6LfalEkjKBw3jp3pSL31Pd0JZ8gBTLnm4YgbM7mhqcfkK?=
 =?us-ascii?Q?fvYE72PHtVEAQefTCmVbsJMInZGJd5z9uN7kwB9xxOoA6P5zn4MYcrAjD3S0?=
 =?us-ascii?Q?RXb8Zrpc68+8fdcwK9TGvayVCxA/048GQVQ7iSdDbttfy2JyjkY0tY3thhlf?=
 =?us-ascii?Q?jiKp2wdq9gSrKnn7C2CO3LGP8kLsoayLnUitgCn23CiTeJf2kZdiIoxmuFsj?=
 =?us-ascii?Q?APDW4+bGBVZB/8H8VH3M7s6SnQ2ja5TY4/rz1SZvQX7fZq5wZl1wAQraJdH1?=
 =?us-ascii?Q?tg/RrRpxOP/7ywQb9AvvdO+kGuL6sVAH4O1QlpExNzGSLSQ/RpyH9eDXjmzk?=
 =?us-ascii?Q?2Vu2D/71DyDjFouv/OzWgTbisH8o9lGd09jnqnfq+nDVFp3Ox+T51yk4d6nD?=
 =?us-ascii?Q?p3s65bX8L7QXnok/PeNKXjjCheGwHbfH5SuX1NnJc4zEc4YWVOsXoVYNZtjR?=
 =?us-ascii?Q?8VCxDFG/Fw5C1urvooicRMw/5KWNvOEmAHiSNKwcKpY5X7UNAHrGln+T7JFV?=
 =?us-ascii?Q?0vQzXp47CrLBActG6No1iqtlCRqK+olOPMpfE0fF+qYMzBRuQeQQMdPsfup6?=
 =?us-ascii?Q?wWcJR59oZBPoVs9r+/RGxUpIy7MRjFIPYLFiQuK2XMVu7n1Q089uRxieWmpc?=
 =?us-ascii?Q?j2TSz2jEA+DZJjssdk0orZ05h/bGLu9FfoyL7tW/+K0Husc+mMmKeQR+xI+U?=
 =?us-ascii?Q?d5LdbonbPdrCnu/ezOWo4s29JJl9wrG9GUVoZfgVemLvJ+7STXSxv0FxxsLK?=
 =?us-ascii?Q?pmx73TkdfboFcoxln3B/HvyJIWk8D5Le6UdA941MS2jjZzlf4smNEiZtYKdt?=
 =?us-ascii?Q?zOQiQmgAFEB6nc+olqSuONpRQ3wW8dYSrAhPWAkspdwKJJN98wFz0/EiUIkI?=
 =?us-ascii?Q?SH1KUFXwyvko8W1e9d+X83SzwrBUvdKHfrv/LvUgJbKYuQQi6C6WEkCyGY62?=
 =?us-ascii?Q?zM92w7mYh6RaFM+e3ghISYzQWCdEJmy+d2PTPeUDwHVTtPi9xJs2BYnz3ct1?=
 =?us-ascii?Q?VMzA2xe51gO8IE+An6dMUvIJ/o6Z5TeZnqS4aQrGFyhWH4t5RAQhtaMITliV?=
 =?us-ascii?Q?C2x9ssIKVGlJSdzcNYNJjH4xZzd9Heoh+yXolvs5znFp5KyRPhj/UyJ3FvQy?=
 =?us-ascii?Q?X0ux0yqXs4NKYCuPVpbedRHp2Z6CkESPlJxmhPkDyF3UbF9qNc5pVrHY9Xt8?=
 =?us-ascii?Q?jhn7TppmryKDBmqA9wfAREHLlGHHCPwWhoFyTtvQmSx18ti2puWc9V0asmud?=
 =?us-ascii?Q?O22Ino6VfHMawNhZvpt4YHJ3908SpvLu2tD4GAupPXMqcSweEwOspU3m3FNh?=
 =?us-ascii?Q?2JZBa8tHG2E5YnKXpt2uxRsaDW75WJnu0o8k4QFIeXg9gENTpEGJDsNCK+6V?=
 =?us-ascii?Q?Z1guRIaTQ0KgmA+Va6rAlkn6ybcCHJyO3mQR58GrvuQn4sYce0GzHno1zckD?=
 =?us-ascii?Q?ZIZTUn0z5gdxSJHV5adSRgf3CbOqd8zhNn/AL1CPuqMRCa8nV2xUJIciA0jf?=
 =?us-ascii?Q?s0OEoX/9XQXbtjv4d+4UbiRPlnj/1CSvOrvj3277?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13bf6e88-9e00-45ee-ab00-08dc76978a15
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2024 17:34:00.8262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YkECBMKFQDhOKMJozGd1NAs8TYnYlkbvBmDio6JKjkjdHEJnp3V7mE2OPYtHkoBw4AOontlga40uXzPbPBjCtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6975
X-OriginatorOrg: intel.com

> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/proc=
essor.h
> index cb4f6c513c48..271c4c95bc37 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -175,10 +175,10 @@ struct cpuinfo_x86 {
>       unsigned                initialized : 1;
>  } __randomize_layout;
>
> -#define X86_VENDOR_INTEL     0
>  #define X86_VENDOR_CYRIX     1
>  #define X86_VENDOR_AMD               2
>  #define X86_VENDOR_UMC               3
> +#define X86_VENDOR_INTEL     4
>  #define X86_VENDOR_CENTAUR   5
>  #define X86_VENDOR_TRANSMETA 7
>  #define X86_VENDOR_NSC               8

Bother ... I pasted in the whole of old patch to get the change log.=20
Obviously this part isn't needed in v3

Sorry.

-Tony
