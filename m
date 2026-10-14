Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F984485931;
	Wed, 14 Oct 2026 21:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792012003; cv=fail; b=VBPvS1j3bkJrGm2dEVROdjj2RvqsEp6ufklMoPDeAzx9T6BVK59cIFkwYbPlvT/UnzE0V5kCIbnpWmaz2jBz43/Jq5Jre9JQA8TmROyg7nFo1+Lbl6YQXh71hNnVA7rM8qVAvC9adU9UKNwOuRKGrD0TDX8Lj4b1WNOwYLua6wQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792012003; c=relaxed/simple;
	bh=LoBkrPJHZtZlDXIcKkoZkQjy9Akmc9h88WIEZrcty7k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YAo/eCG2fDr7xhTbGoOM93weXROM40iA+I0wuAueN5rE6YQhuPOQc/fK2muxKoo5ymmvMWDd0e1tpqGXbXEFoGMWyeM6TerYdRIGccZdt/WbsrYexEEC08G5xwDgmEkdDVPEiV04VBfWA2OdWkgMvnAV3jdHaCaGJfUJd1/1dqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W1px7l2L; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YBeDaAJ4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W1px7l2L";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YBeDaAJ4"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EL1AFE1609787;
	Wed, 14 Oct 2026 21:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UFT4qqpeLf3UDC4DLArsHauhs7ScwvQKobQvn1aJbdw=; b=
	W1px7l2Lf0lVPtkImeVdfIj5s28K9BqBZSaot0HIX9TNYUVP4tSCNlrnta2/Fbtb
	35Rcn4rQ3BRCYnNu/MA+ay/LDYechPnoPKwyIMdDvABgVrOFSbyTD7tgMITGfxRb
	xdhYTMqtC5VlbIEEt7Pq8BAkZ6JuIz+bN1w/fcVP2TIYFrSzcdmSAVJgko+SllDx
	3IAa5p++vqeTUu5jj79Dz4koAC2sH0bmeG7635wd9iVItbd3T72Ana/fqHZL45WJ
	iuohqyUb8IbMt2h8g501K9PW7USGCpiIRDonyXEvty0tSl4e/fR6caodZFrwBLOa
	UJ396u8FLJ8fITx0gTEzrQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7y1ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Oct 2026 21:06:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69EL6OUj007731;
	Wed, 14 Oct 2026 21:06:29 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011013.outbound.protection.outlook.com [40.107.208.13])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btc5u5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Oct 2026 21:06:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZUAQCJ+2PQwT8Y5Vnni8kgxHq7IXoSMZqK7YAZp7G/y9yNBx2vTze/IZLUnJnd9xZHEqB5BvCPE36ODkoayAqH+VJTjbXMz+1yY5U9dZAGlPRtoQrAyoVMDXZHKuvWQaXM2Fci39XlpIQPo7cDs+rEOK9WVMCpQGRJTR2qVZXMztoQlk7Bpoqz0o/kk0HB0L6LquazjrDq8kcqmuB6Qohx05m4lv0idjc99pM54DL573ylstplG8MazD0xMMEwNvYPrhf9CSjrm74Ks3wSJs3p/aFANkWSS4P1TwlJREk4PL3kIPymTGJDMZyh2UC8mVwJcxJvi6APEjCr76mxP/jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFT4qqpeLf3UDC4DLArsHauhs7ScwvQKobQvn1aJbdw=;
 b=Nh/KT2oR8BdQhYOTuBGLvI7Zm6usfizrZsMlvOKr71WPHRGfB78HKFdTPdgA6DrD7ExTTTnpgJiOsVSxjvBXWZQI0xwbe1Z7hFBFlLcsPd3mdOjUc+i7uv9vd7VAKZUk0h+PeweRW8qXQWmhKoxq3E68+CwY1QsohciYJxC56j03OkFsqutLjPs6vRS/JbZNOSJZESBYRLcZW/f5pnJ8ItTbKiwI27Bn9D7yKQDlKoDUOqdsgxqTA2TB2OBReTct9Ygy4WbaPwIOvwWZQB9DNQ6+6vrx0dTWwvp3IdKsoApTekIh9QxGEWzrabjNZM1Gse+TU9owB8FR+EIcNJ5yGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFT4qqpeLf3UDC4DLArsHauhs7ScwvQKobQvn1aJbdw=;
 b=YBeDaAJ4m2HZOOKVMcnf3f9OGCi0FrcPbqaSDrTcmyvKebKxspuJcyieDwTSV5Dq9X4AMT5SsBVd1aFSJyZC5TK7rsQFZzEKYn+bqXbOF+N2s/VsMyNVPw6HyN6k06veKPwh/LJAe7vCGMZ/OT9CJonMG0JgSKv36zLVx2+uGhs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DSVPR10MB998128.namprd10.prod.outlook.com (2603:10b6:8:3a6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Wed, 14 Oct
 2026 21:05:50 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 21:05:50 +0000
Message-ID: <55fe666e-77e9-45eb-9a9f-0d5a22abbfd6@oracle.com>
Date: Thu, 15 Oct 2026 02:35:41 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 112/497] PCI: Accept AtomicOps already enabled by the
 hypervisor
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Nikola Prica <nikola.prica@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Gerd Bayer <gbayer@linux.ibm.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
References: <20261013112907.864180619@linuxfoundation.org>
 <20261013112910.548997665@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261013112910.548997665@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DO3P289CA0011.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1f::14) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DSVPR10MB998128:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b32eb33-0d85-44da-f09c-08df2a36ecbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|56012099006|5023799004|4143699003|261009223027099003|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2ce/WYfPmbGeHgFVDKib8WJGP7/H3HFWplgNIRaHMhnqHeOY3mZEjOmjQcb9KBvcI7eBhUYwtxDu7erGHo8buF0dil+MkIOKZLZ4uyDZePveL1Ha9XJFW4ScQlqGzTtxO9JuIam7zLri78LaoM0rNhaQbObRl7Jea8Y6ZlJ+0/yNBMjQWiio/7r7U3sqhMyk65Cr7rsG5Wcv6MB4do2P1FvZ94FYqdJI3xpXmar5OW+V+neobXeWCYMMooc4UPmBtDDV16fS3ArfwQG3uybVMfNr/wEI2NkVUTa1EC8IuQ2HAqMtb7KxXBBqtvbSGfocm8irh+B4AC0x+74CcvSJXX0yPtc1yzaZc5imQE7sDpCbm/ahc/NCqAC8MzHb78FnCvc96kn6yCiLiOQPTOrjliy1Tt8kb2gbtfnOL//a8Hv4bs7oBFevhCM2FIqL6Y7ROqz302nUrxO5w7hA+wwMTbzh796R2Kw21WQrB52Tc8GE9O+W1OUxCzTRIFyWK0jUyk0pzqhy5jByqQpjxXbFoleKCALn2AOoZhpHPMCPyArF1BbqV7rMGBA6vc/h51WFJlDLXL9WFwhD52ktPR7Q5buqdlyWAISjTktmjRdiP5evt3MZKMeV/JpN+rwIdjZu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(56012099006)(5023799004)(4143699003)(261009223027099003)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmVtRTNvTFBJcHMxSTNIU0p3NUVheUtaZ0VEN1N2QVF3NWJPd2t6U2dqa3Er?=
 =?utf-8?B?c0doWDRzUzRhaGJRVCtxUUd1bnNGeTlkZXhJd1F2TG9Dekhpd3lDaTZ2dm1v?=
 =?utf-8?B?SzcrRTMybThLRXovd3NLeC9VakNPOHduU21FTVovRkQ0SGl5bDhtU3BEa2lL?=
 =?utf-8?B?eG9lT2RKa012NUZtQkUzeTZzU3RNeTFqdHNoYU1GZG5QemtjQ2JXR1lvbDZ3?=
 =?utf-8?B?cVZKbjVvL0grR3M2eDErQUFRZlB3elVKSHJOQUlqSmNsdVJVdm9vSnB1VjU5?=
 =?utf-8?B?bGtDbE9IU2dYdC90elpwQkxjQjdyUSttTEZNWUhGS1BZT3diclhrOFQ2czZX?=
 =?utf-8?B?ZDFqTEwwWEpQaS84eHhkQUp5SHl6dWhwL1doa2dKV0pieTlQOU5MTkpYQjV0?=
 =?utf-8?B?eTRnVHo3VmtsZHhRTC9TeDNhWEk4SUt2d3NMeC9uQy9VdENqczRaQStNTnlZ?=
 =?utf-8?B?REFIRzRUWHdWTHQ1b1VtVTRJODJDMjF3Q24vYTNnWGlFbW5yYjh1Y3JLRnJK?=
 =?utf-8?B?eDFQVzNjVDJMOEpFamp3eSswTlN4TVErWDVITE5TcWMrZjVCMzFrQ3JDcmFl?=
 =?utf-8?B?aGtSc25FNkR5VjBFMjFVY21ORGFrdUJPemIxWGpmcHp3UXQ1L2JJeU0zU0pL?=
 =?utf-8?B?TzJlL3M5L1NTbUR3RllLa1hQRngxdnlnNW1teHR3cHNtaGNpWGo0aHJZUk96?=
 =?utf-8?B?T3I5T24rdU11aEhQZmF3M3hnTm5BUXluYlFFU3ppVExXdkN3NE53TFdKMTZy?=
 =?utf-8?B?NzFnT3NRN2diRk5QaDNXUWczV0RQcjVEdWRIb2Z0NCtMVENKRXV2SkJWYmRa?=
 =?utf-8?B?V2lMWnNBWTQ5WndqK3ZuMHBMM0hIazJRLy9kbXJuUHBxL2ZLMzhvNlMzMXla?=
 =?utf-8?B?cUJ6RjBFM2tHNm1lcE1wb0Z2eTNXZmxwVGxGVEN5U0gzeTEvTXRZSmlwVEFW?=
 =?utf-8?B?Z0w0M2JqZ3lBT0dJN3dDMzdpMDkxN3hnRFBObi83WmNEcDBldFhicDhFYnRY?=
 =?utf-8?B?L0swOHhSWDBueXh5V28zYnFCOWVDTmd1RjZMbnMyb0tJRFI3aTJwcE9qT0k2?=
 =?utf-8?B?TC9rUlFtTGo2MGVYeG81dk53R3lGbDhOZ1RPQ0Q3NWJSUU9qcjBXMUJod0hQ?=
 =?utf-8?B?OXpXeUhEY0RWRkpTdWRHQU95bEtGS3MwellHQml2YkNGSXJ3R0hsY3d2SWsw?=
 =?utf-8?B?SURUdmZ4WkdabUQ3eHNYM1ZKeUdPeWQ4MkJqaWszTzRnWTkrdVVHWVlMYXkx?=
 =?utf-8?B?Q3NyN293WDZ1Q3BRWTZwNWJNY1YvYUNqdHRlTlg4Vm9kdWZkVW1WSmRLN1Bt?=
 =?utf-8?B?V1Q5UWpIRWdLMkN4WjlnQnFXSGpxa3VtVmtybGJrckJ0TUNFWk5STmt6bmRG?=
 =?utf-8?B?a05jNWZiSFl3WHVxUTRXLyt4SnF5N3NmK2p4RFM3STBlZ2swT0o4cDh5THJk?=
 =?utf-8?B?elBIU3d2UjZsQm9ZUTNUMGZqRFp3MzhzREo2WjE3eU1Td0tTOVpBZWl0enkr?=
 =?utf-8?B?R2V4NUFFSVladE9KVktIa1FwVjlWN1JoeGpQRmpOZitWUFRBSTZwUzljYTdz?=
 =?utf-8?B?M2tpQlRjekpVellsaHJHQ2ZScWR6RStKTmM5azA1Mzk1Y2FKQmQ1N3ZReXFE?=
 =?utf-8?B?UnJQTkpNZzNuU2NBZ09FNVhtNkdSVEM1d3UremlCMS93ZjU2M00xRFNFUUdL?=
 =?utf-8?B?aGswZHE1TldnR1djdDdNeWtaZjRsSXptdVgvTVJsSE9ibkNyVGZlYldsa3VB?=
 =?utf-8?B?d0VzN2ZKU01RYXAzWTMrSTBWMDRleHN1STVaZjBRMzl6OXoySUcveFN4YjQx?=
 =?utf-8?B?Tnp4L08rb3ZDTGl2RndKOWhpRGtSRXRqOVJWeWU5SG9KNTdoQ0U1STdZYk1C?=
 =?utf-8?B?RVU5TTZXRWlDbjlWakl0NGJDYkRYaHB6N2phZHlXV3ZmblRiRjFja1lCWFEy?=
 =?utf-8?B?V25VS09NZU1TR3ltN1Zkb3VwdmRHR2QyaHJHMjQ3dW1kOHpEM0YraFVqaUR2?=
 =?utf-8?B?SlpNQ205MXdreHZCOHQ0QlBKdlBHeXZmbEdVTW8xTkRzekdJMjZQSUtRclBi?=
 =?utf-8?B?QWovcy9XV1UzVkcvUFh1emZheXNqRWdLTXRnV3N1bGtNRTlsL1R6MzdLUG5W?=
 =?utf-8?B?cnJtVkhvb0lHR01RYTFxeDczUnZIV2ZSL1JpNlNLb0VKVXJWNmNmeUlSOW5P?=
 =?utf-8?B?aG5QNGo3MStWWGxmcHNvTUlNY1ZuTDNJK1pDTlgrdWkwbGZ3UjZqR3U1NmlG?=
 =?utf-8?B?cDJqOUJubDdsaWdMdXRYK3ZRODYzR0xPYURnLzUreU9GVkhCcVUvTGxjT0t3?=
 =?utf-8?B?bWNpRG9lOGJSRGJTRzFwNUJianRYZ2dhRWc1cEtGWnVHa1NsUnh4U1NIdGdp?=
 =?utf-8?Q?sWz3ysL/itO3+iB9IPdxBs+J8qUPNZYrx2YQ+?=
X-Exchange-RoutingPolicyChecked:
	2ROUdGo3cuNhxaT/LVrj42x5ja3X2zh4RgGcABlD69DUP8Y1+XWS4IqQgpu1TfZIRst73KgDTxKlPJefsyF02a7xmghh3dxB/UhLJ9Snqwb/61mRpbbRSCtzwjjxuuvIif8vBWC9FrGjCX9pf7Q+Cn6OnKkaT8wxBZCykm5jHVTgdRS2X5T5CAqmE3Q7eG7WmbaRkUi4esTzZtSEhkZH+bt+dDr8JBQyxmY0TU8m/94YK1CSZ5vOXTNpjBL6tL8IP+nc2BVTokm1W9WzaRysVcXM4/Of/ClfRM4PlsZGzJp9saRnogqomncx2U/GA/XnXSRMJ+MI5bt92PlRgTby3A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oE+xvPBbub+Kal7axTD7NaU5dGOIH/x2pM6g9zh9xp4tRIgsk3MAz8NIVx70QJ+2Pywb7VlLpeQfqB1//ZhKMRwX05B2gnDPw4bU5RC0t1AE6TdUTrpHFMmg/bdr3Sy8rs7eq5hJsW3FTwEJ85NTPbWrW1KylOw64dRfu52B/5eSeCtlUY+Yqheczn5sbtyPFWrt6Ld3C8QyRjWFQXh6akxLD/WpqIZ5FALfoUNOIgrH19OJKLy4f6oxMQbnzuZCH59DzeaPSyXyQBVfM6qDOjSHvFu24xeYAX+g5J28XIjdXXfSpwc1vYka2vdnH1ZoUqEcMysHD9BiI0XNqiO3yF8YdQ11p0RlL7lsiBeBQjfKnEggelQYmNfVyPOr+cDCRrbB703cQbvHjVsbvm7PJ2KRzY3RExMSeUio/6rka+3Wv5ufuoLj/r8e3U30UPAwjtIJEghKE4CUxkY8zZvOaSt24HUJepsuKemOrxtLKjWVjnngav+c/rP+T7Cu8dV5T+a9qG4lsL96gzvYX30eotRF4dujkglrL5DJhxwYmIqijLP3mmlmkjnF8PcKKLajHFoBX0ez23PBNJGwTTZDqz/ouys0WU87pxAcPym4u8o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b32eb33-0d85-44da-f09c-08df2a36ecbe
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 21:05:50.1995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oz66jmHJ9L9co38F/jK9Bz9xTcCrWsZ4l6KptLp8vQUx+e1UxD1wqtznfPrbhhhj+rqAVwVvYUkJFJQ/VW51QgGN0oxEt/hRfaj1afRnexeyCa4PbpqZzmEvREZeATUK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR10MB998128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610140084
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acfeed5 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=bC-a23v3AAAA:8
 a=zd2uoN0lAAAA:8 a=1XWaLZrsAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=Vx6ySO2R8BUdQSl3NsEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA4MyBTYWx0ZWRfX4yUkKYbH6XtA
 SfMiFQIe8MePfFDWbLwE8oFPxGa1w3yRUExswQjDUx+K6ehUCXdVum/Wvu67PAbm75Rojvf1QWB
 r6ECIV71uyeTt1YiYbzbEGd7fuYPaRhzkE8zRjoYACSfTrCOCZjUh6YcU8S0/ImxQoMjpkMKBRL
 Qk/xbclsOa7lzzmgiwdOGCEberhwMlweZvS2HHjTTVpS6/IpNIFrEAHiyXoTadRKFYxOROMeoeK
 Zlgz8/yoGf6NkEDVfySNSwn7T1z0FAeW7uxyIxvK84R0av9Rfw89QBGUtcYurlGWDoiNsbNjaBP
 PLAXlZZcPe6HorbUA4pZQp+gT9uOIdLOT6OhJoEjInDg16JfRxe9CCW/UlsMvDyILmnifFlvaVx
 JXl7dIJwV9dMvUJckc3BktRTYLtGxwpiv+Jl+vQpOKPo32PaQ4lkww2ieEor64bewGXU/9Gn5pH
 F5/fxYLWTpkjo9MpWNw==
X-Proofpoint-ORIG-GUID: QIzsq1_GJXfulvQ6TDGSr-kP5brr_ezV
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA4MyBTYWx0ZWRfXyaRTdhnPzsOl
 UccF7jSZUzD7RwhGJZSH08OwopZW5b2bz4L4mXWNeuadZSlytnrSHDGIxLBrhu6lYObVuKfoN2v
 JQMO6N3ta00+UkJdHLGr51a/8imtjUb4AbbL/Sd2d1g4iH3gl3Ny
X-Proofpoint-GUID: QIzsq1_GJXfulvQ6TDGSr-kP5brr_ezV

Hi Greg/Sasha,

On 13/10/26 5:04 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Nikola Prica <nikola.prica@amd.com>
> 
> [ Upstream commit 40cce45b921f7930886bcba43069edc579725457 ]
> 
> pci_enable_atomic_ops_to_root() currently fails when no Root Port is
> visible. That is common in passthrough guests (ESXi, Hyper-V): the Endpoint
> is assigned to the VM, but the Root Port above it is not visible in the
> guest topology.
> 
> In those setups the hypervisor may already have enabled AtomicOp Requester
> Enable on the device. If PCI_EXP_DEVCTL2_ATOMIC_REQ is set, treat AtomicOps
> as already enabled and return success instead of failing the Root Port
> walk.
> 
> After 1ae8c4ce1570 ("PCI: Enable AtomicOps only if Root Port supports
> them"), pci_enable_atomic_ops_to_root() always returns failure if the Root
> Port is not visible, so drivers don't use atomics when they could.  On
> systems where the Root Port is not visible but *does* support AtomicOps,
> this is a regression: prior to 1ae8c4ce1570, it enabled AtomicOps in the
> endpoint and returned success.
> 
> Fixes: 1ae8c4ce1570 ("PCI: Enable AtomicOps only if Root Port supports them")
> Signed-off-by: Nikola Prica <nikola.prica@amd.com>
> [bhelgaas: commit log, code comment]
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Tested-by: Gerd Bayer <gbayer@linux.ibm.com>
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
> Link: https://patch.msgid.link/20260921111903.978687-1-nikprica@amd.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/pci/pci.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 4364ed7cdc27b..0d33b30ec2f67 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3764,8 +3764,21 @@ int pci_enable_atomic_ops_to_root(struct pci_dev *dev, u32 cap_mask)
>   	}
>   
>   	root = pcie_find_root_port(dev);
> -	if (!root)
> +	if (!root) {
> +
> +		/*
> +		 * A hypervisor may expose a topology with the root port
> +		 * not visible to the guest.  If the hypervisor has already
> +		 * set AtomicOp Requester Enable in the endpoint, we assume
> +		 * it has verified support in the root port, so it is safe
> +		 * for the driver to use AtomicOps.
> +		 */
> +		pcie_capability_read_dword(dev, PCI_EXP_DEVCTL2, &ctl2);
> +		if (ctl2 & PCI_EXP_DEVCTL2_ATOMIC_REQ)
> +			return 0;
> +
>   		return -EINVAL;
> +	}

^^^

An AI-assisted backport review highlighted a missing device-type
restriction in original 6.12.113-rc1 patch 112, e57cb3788563. I
confirmed the difference by checking upstream against the 6.12.y tip
f4ffa8dc360b. It remains in rc2 at 4a8beb0f1e36 (replacement
4f0ed08a1994), in drivers/pci/pci.c:pci_enable_atomic_ops_to_root().

Downstream accepts RCiEP requesters (whitespace normalized):

     switch (pci_pcie_type(dev)) {
     case PCI_EXP_TYPE_ENDPOINT:
     case PCI_EXP_TYPE_LEG_END:
     case PCI_EXP_TYPE_RC_END:
         break;

Upstream 40cce45b921f and current 0fcb05b72344 reject that type:

     switch (pci_pcie_type(dev)) {
     case PCI_EXP_TYPE_ENDPOINT:
     case PCI_EXP_TYPE_LEG_END:
         break;
     default:
         return -EINVAL;
     }

The new no-Root-Port branch returns success when Requester Enable is
set. An RCiEP can now reach that return downstream, whereas the parent
rejected it. Callers can consequently advertise atomic support for a
requester type upstream excludes. The restriction comes from
03ec922f0025 ("PCI: Do not enable AtomicOps by RCiEPs"), which precedes
the upstream patch and has no equivalent at either endpoint.

So we need to backport this prereq before this patch I think.

Thanks,
Harshit>
>   	pcie_capability_read_dword(root, PCI_EXP_DEVCAP2, &cap);
>   	if ((cap & cap_mask) != cap_mask)

