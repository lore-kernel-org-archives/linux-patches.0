Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2053.outbound.protection.outlook.com [40.107.15.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAFE1FCF
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 08:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="nPJRJEOM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHnjZLZdTg1EAAitFI9dGfdVOzOvlMYS8bZNwl+wpFDSGHDscTXI39IGfATjrVw+rA206pOY1OSt318rGEQ+unTkI+vxBH+yZjMEvYvqAVrHOAlK0clAwK6lwdRtIqbx93Ym8jdM/i4cOAy+5AIw0kMXcADrOpWyWJPcf/kSzgrJ1bWiM6j+FtkcNf00CcYA1Ye4+t93A+pzecIledYKFKgm6mMb04e4aAbNSwj5VVgtieh25VQviVR5uFRm/r4l+UWKmXk5qWhcKShCmP4QXzuQn+kSXt2+qcxQH8eupoToNx9futs7ByVhw4+ngmBegxdthnulRIvgtxZKtso4CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xqFfjp4FpYk4a32Gg+BYYpn0mqDgnjvQ5y12haEX6Co=;
 b=LSP24+sTiu4PCCbvYLTy25IHmJW5btP06OXOM/UdDGIu3ekW3lpWgWjF/Jj1+XqNOiHA0jpQUglm7vXkTSqvi1zaBYbWc+B6fDLnZ5dhrklPY7xpJevD+/iCOazFwBFL/VR73YYcBYG3vmHAYu94C7tVfxaNgrmwPEcLCkgyO/jqDeux9Ytb2Q/0Rh3rTj8NUuqSc5s1T0HoJ/q1xbe9yXqCrjD9SlRWlyLqNjSvebsDUT1X9QTWds5LKhFnoyUdqoLAmhWyVawckVcfrROGqILSkJZY9OHezpRw+1KMg7xBeY7ttQspM5vhmmJHJE0juFE4dM56lqnL0BUpOQ1+hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqFfjp4FpYk4a32Gg+BYYpn0mqDgnjvQ5y12haEX6Co=;
 b=nPJRJEOMH9gihuBmhrrynFFmFfxDmk8UsUD3ynqBcyrmYsTJDwrjQ0YqmifQMIQSVXARfhpHIWUws8R6LOFmW1wjshiLLiL20BuFAfmCLh9Uiv2AbN1v1/pj1xB/5mi1NZ7ygLPnR79emXSIhk93f0rA2zB9kWg0vkDom7g2GTRklOZDCX77yRQRs2v7Dd6CFUXjqHuuWA2Se7S3IGP3UJ6scFbfHv/uzQBHZtU3t3o323xgsAnmZE8OGIsCc6ZSFFiBJIfrvwJ/vVH8EkT9G+OkALyz8NRnaMNxiW5QV9IhT6Ea1tRztlJ+mpAKYoQgCLfQ/7czzvQ5mZ79kpAAbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS8PR04MB8465.eurprd04.prod.outlook.com (2603:10a6:20b:348::19)
 by AS1PR04MB9407.eurprd04.prod.outlook.com (2603:10a6:20b:4d9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.43; Tue, 10 Oct
 2023 08:53:36 +0000
Received: from AS8PR04MB8465.eurprd04.prod.outlook.com
 ([fe80::21dc:8a5f:80a7:ad6b]) by AS8PR04MB8465.eurprd04.prod.outlook.com
 ([fe80::21dc:8a5f:80a7:ad6b%6]) with mapi id 15.20.6838.033; Tue, 10 Oct 2023
 08:53:35 +0000
Message-ID: <c55ba96b-9058-42ac-817b-2d42b45ddf3a@suse.com>
Date: Tue, 10 Oct 2023 19:23:15 +1030
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 70/91] btrfs: reject unknown mount options early
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Anand Jain <anand.jain@oracle.com>,
 David Sterba <dsterba@suse.com>
References: <20231009130111.518916887@linuxfoundation.org>
 <20231009130113.943075052@linuxfoundation.org>
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJjTSJVBQkNOgemAAoJEMI9kfOh
 Jf6oapEH/3r/xcalNXMvyRODoprkDraOPbCnULLPNwwp4wLP0/nKXvAlhvRbDpyx1+Ht/3gW
 p+Klw+S9zBQemxu+6v5nX8zny8l7Q6nAM5InkLaD7U5OLRgJ0O1MNr/UTODIEVx3uzD2X6MR
 ECMigQxu9c3XKSELXVjTJYgRrEo8o2qb7xoInk4mlleji2rRrqBh1rS0pEexImWphJi+Xgp3
 dxRGHsNGEbJ5+9yK9Nc5r67EYG4bwm+06yVT8aQS58ZI22C/UeJpPwcsYrdABcisd7dddj4Q
 RhWiO4Iy5MTGUD7PdfIkQ40iRcQzVEL1BeidP8v8C4LVGmk4vD1wF6xTjQRKfXHOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJjTSJuBQkNOge/AAoJEMI9kfOhJf6o
 rq8H/3LJmWxL6KO2y/BgOMYDZaFWE3TtdrlIEG8YIDJzIYbNIyQ4lw61RR+0P4APKstsu5VJ
 9E3WR7vfxSiOmHCRIWPi32xwbkD5TwaA5m2uVg6xjb5wbdHm+OhdSBcw/fsg19aHQpsmh1/Q
 bjzGi56yfTxxt9R2WmFIxe6MIDzLlNw3JG42/ark2LOXywqFRnOHgFqxygoMKEG7OcGy5wJM
 AavA+Abj+6XoedYTwOKkwq+RX2hvXElLZbhYlE+npB1WsFYn1wJ22lHoZsuJCLba5lehI+//
 ShSsZT5Tlfgi92e9P7y+I/OzMvnBezAll+p/Ly2YczznKM5tV0gboCWeusM=
In-Reply-To: <20231009130113.943075052@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME2PR01CA0053.ausprd01.prod.outlook.com
 (2603:10c6:201:2b::17) To AS8PR04MB8465.eurprd04.prod.outlook.com
 (2603:10a6:20b:348::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8465:EE_|AS1PR04MB9407:EE_
X-MS-Office365-Filtering-Correlation-Id: 3933f6c2-a968-436f-a91a-08dbc96e6358
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zlluk5ROfXZP0//35ZRV3DCY9MKTYw1BY9RnLFd0udbW6/03FNT2NNw3jY/vglywKay1wngZdrbEyaVlxa1RoRNMwXFyn9lRfEDnRzv+3s6LsKQz8rsE6jSmIcMrj41Im8YHxbgaH4iwpdB+elaNOb2lUpMPl+4T0euRlF0cCS8sUBWVOKKm05+7u1iLjEAK4fIXAl1vz1SCOrP2hdt7czIfBibFWsrbP9msQbA/Pc4hOJnD829jU9wNpz7njYjs5MeUY4jOpEdAbTozgeKp30NlxJqBp0MAGqa6u3GvKBuqspePSp/24xcIEw+PR4vII4K493ZQFHCJ9x6NIvF6mMNGkorzXTsBpkS8wHoNSXcU3L+yuKw05YhlbETQTyjOG40hTtebSyBDPgGdmJNxxIl0ztwDbhps8rQ/XyPJxcwCBZCsadEhs3XCE3r4cb0c0USP5cBHjgEsmGij3+eDGJKLydMc4EMQXg3FXXL30jEnthlet+RS+qxkFa/vwr02VqxsHJG71L40aHJhc+y4nKh6H1B7pOqTyYFUVTKwkQUvwq5Uh0b+a/+TbMpWheid+luJhDFDJNUflqK4tUiVtg3Tab4Js4RzwnmqUA3vENm9jZQxyQOvIZ3RIdnmlqHfKwR+g2LL8/Uz6L86mzMRTw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8465.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(346002)(39860400002)(376002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(31686004)(86362001)(31696002)(38100700002)(36756003)(6666004)(66946007)(2906002)(6506007)(41300700001)(5660300002)(4326008)(6512007)(478600001)(8936002)(8676002)(107886003)(6486002)(83380400001)(53546011)(2616005)(54906003)(66556008)(66476007)(316002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bE5aOENPWXUvclFWWXlZY0NkZ2p6RFFXVktSak04L2l3SW0rYmlwM0tJMnJI?=
 =?utf-8?B?V3JrRGpsSE5ZbDhqdWR1TDVPaURXSEVqSmk2RGtBeTgvY2NGYm0zQk41eFJZ?=
 =?utf-8?B?UmpLMzdHNU1xbkY2bzdBdHloWGJqUS90a3FhOHI2Q0xrYkJMYTFjVmlZVUpB?=
 =?utf-8?B?S2U5MlcwQUFyNGdBTER5Mm5CK2huNzJQalp6WnZJUHZ0bjNWVzdKOVNCZlpp?=
 =?utf-8?B?elgxR1RyQ3NTYXFjQUIzZEtpQ2ROY2FBbVJ4SkVLSEZvdzh2alhpTTNKQUpH?=
 =?utf-8?B?OURvSVJ5ZUhzRkM1d0Mva3J6OWxIWWZrTExjbkdMcGFxZDBTTVNNa3JybnlT?=
 =?utf-8?B?a093a3NiODVGZXhuOVhEMzhGaEYyUlh1Ry93VnVETEVqSjNuZmNaOXUrQWlT?=
 =?utf-8?B?c25HY1pUblJXM3NBeGFiWFp5V0MxWStTdkk3aGhlWUo3amxxbGlPaENUVUg0?=
 =?utf-8?B?aHFNa2JnZVczeC9NcUV3b3Y1c0oyNE1kY0U2czZRSkdJSS9sQ1BnZVhVMjhQ?=
 =?utf-8?B?YjVodzVYRFNNMDh6VXRSY1RCZnNYek8xYXIwNVdBQ0ZWMFNsNFpiWld3MWZG?=
 =?utf-8?B?SURSMmJ2U0hJekRpdlRHbEFrdURxSG96YWJMKzdSaHR4TkdobitZc3dLSDlq?=
 =?utf-8?B?blU3RnFrQ2ErZXVjSXc4UHQ2bEtHTHNkc3NyL3IxV3phK3Rza2pKaHJwbElw?=
 =?utf-8?B?YnNMY1JZNlo0eFIzbmJCeVJ2NHFiVnVFSEtWZTQ1VklRaWd6dnBUM3U2Y1NN?=
 =?utf-8?B?VSt2cDBnQ3JNN0doaHdIYXpNSEs4VkZibVQ1ME5qUzcvOS9MY2dRYlRFZFZk?=
 =?utf-8?B?VVBnSlVoNUVDK1R6TWxkZTJyNjMwc0c0b0d1Ly9QYUdIV290SE9haERNSE53?=
 =?utf-8?B?YUNnU2JTY0J5ZXQ0Zy9QdzdwOXoyZnlya1FuWHREZ1BTTGtVa1NxVXkzRndV?=
 =?utf-8?B?eTlJdjh4NFJtamlocWJEM2hxbkp3bkE3NFBJM2p3eDhvaUxDMGZ3bndWRWl4?=
 =?utf-8?B?YTBTd0FjMEQ4Sm0rUTYwYU5oMFZOZmtRMTlFTC9mcW9uUTNoMWc5c2pEVDJ3?=
 =?utf-8?B?WjdHVHpRWUxHME0zMVBrUlhYUS9SQkRXMzVyWWxGYUc4M2NZZkgrbmxiTlFz?=
 =?utf-8?B?Zm1HaXV3N3dvazBmWGpQWDlwcElXdGxEa0wrTGx2ZzI5VzdWakdPenVGOG1w?=
 =?utf-8?B?ekpjVkFEL3M0YXppOW1TZkx2Y2l2MWpnditJTlQ3eFd3elpEUEN2T09ITHFz?=
 =?utf-8?B?VkhIMXdoTzFscUdRTmh6OFNIeS82RUZOUG04ajV6L2c5cnJMZ2NCTEF1c1cw?=
 =?utf-8?B?aDVVNDdzZWNwLzJlNTk4NWxPNFUrT01HZzBkK3I4WWFmNkVtalFOMmNrSUY3?=
 =?utf-8?B?czRwK0dTUWMveWh0SmtBZEZsU2FCUGtkV2pKVUxnVzR4NzVzTEhqVGppN2hr?=
 =?utf-8?B?QWdFOURiNTdvQWVKY3VneGR1cFNndzlKaVNoRjZTZXg5dStJdXVGRk9DZ2Q5?=
 =?utf-8?B?enozNWhUa3k2Q1ZzZllXdWR0OWlIUTZDcTU0Z29BVjdjUXk3N0NrU3JpbXpK?=
 =?utf-8?B?eEk0QytmLzFwcktYU3BUUk5rY1lPTHd4dUhWRWVUUFZUQTd4dS9ROHlINlc5?=
 =?utf-8?B?ZnZFY0JJZiszd0diKzFjSXVULzFXdHlJaVRjWU5TTFhvS1lQNHVFUmxjcXBK?=
 =?utf-8?B?WitMdHBJeUNWNHdSY0N2VWtzc0daZG14dUhNd2FlQ3VCOWpjTUNvaEpXQ29Q?=
 =?utf-8?B?UGlvTHlGTDNwclQyNnRLbUNacVQxYWtiSmxKK2UrTW1kZE1zT1V1UWcxOHQ5?=
 =?utf-8?B?VmZRUWJSOFRXNXgyWVlKNzdsS2NnaGRsdG1kQ213MCtDTWdyTnB4VnVJUmZi?=
 =?utf-8?B?UkJlVkFBcldEbGJNQlgyVUUvQ3JXTFEvNTFtMVcyRUM2VUpLajhna2FlcXRD?=
 =?utf-8?B?UmJLVEFGdlh5Y09UZ3BLdW9SZW9Fb1BzVGp3NWY0VDJJRlRtamd4MUlBNnlk?=
 =?utf-8?B?RjkzUGFiYzU0ZWlVQ0FNQlVaL2xFWkdEYmFPRFRjSzV3SEJxbnNPQllCaHQx?=
 =?utf-8?B?RjIrM0JESFRtZGs1enRFeFFsLzFvSVY1UjhhSjZzQnRpbjRkVGpGRmd2bmRz?=
 =?utf-8?Q?nxu0=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3933f6c2-a968-436f-a91a-08dbc96e6358
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8465.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 08:53:35.8663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7E7LHiPq4TeDiDtpFDtDXRVKrevse1LIVkNcL+eOvHEDPW83dxs1CA4rRVEHlkC6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9407



On 2023/10/9 23:36, Greg Kroah-Hartman wrote:
> 4.19-stable review patch.  If anyone has any objections, please let me know.

Please reject the patch from all stable branches (if that's not yet too 
late).

The rejection is too strict, especially the check is before the security 
mount options, thus it would reject all security mount options.

Sorry for the trouble,
Qu

> 
> ------------------
> 
> From: Qu Wenruo <wqu@suse.com>
> 
> commit 5f521494cc73520ffac18ede0758883b9aedd018 upstream.
> 
> [BUG]
> The following script would allow invalid mount options to be specified
> (although such invalid options would just be ignored):
> 
>    # mkfs.btrfs -f $dev
>    # mount $dev $mnt1		<<< Successful mount expected
>    # mount $dev $mnt2 -o junk	<<< Failed mount expected
>    # echo $?
>    0
> 
> [CAUSE]
> For the 2nd mount, since the fs is already mounted, we won't go through
> open_ctree() thus no btrfs_parse_options(), but only through
> btrfs_parse_subvol_options().
> 
> However we do not treat unrecognized options from valid but irrelevant
> options, thus those invalid options would just be ignored by
> btrfs_parse_subvol_options().
> 
> [FIX]
> Add the handling for Opt_err to handle invalid options and error out,
> while still ignore other valid options inside btrfs_parse_subvol_options().
> 
> Reported-by: Anand Jain <anand.jain@oracle.com>
> CC: stable@vger.kernel.org # 4.14+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/btrfs/super.c |    4 ++++
>   1 file changed, 4 insertions(+)
> 
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -991,6 +991,10 @@ static int btrfs_parse_subvol_options(co
>   		case Opt_subvolrootid:
>   			pr_warn("BTRFS: 'subvolrootid' mount option is deprecated and has no effect\n");
>   			break;
> +		case Opt_err:
> +			btrfs_err(NULL, "unrecognized mount option '%s'", p);
> +			error = -EINVAL;
> +			goto out;
>   		default:
>   			break;
>   		}
> 
> 
