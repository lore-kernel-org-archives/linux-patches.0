Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2DA125B8
	for <patches@lists.linux.dev>; Mon,  5 Feb 2024 09:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707125250; cv=fail; b=KWSwnYnacQzV3AHn1QwFmm2dGBxT3cY14Sp8g548iOnUOLB/ipykNFY/OtjJ73UcGLRc2OO3DS4zWlpOk225t64A819BzPxHJV2N3xwee43DqgM6Ezqzo0Gi9WAv5yI2SAL/bcIK3hejcWy2tA8p4CSsqQ1pc4K0m09QzG7l67E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707125250; c=relaxed/simple;
	bh=0E1nkr4GuN08aXf4d9MBPyDR5G20JxMlVZ3X12JuHyo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rqUpQh1joIPX12bAGBMKs/12lCzZxPusgN3VX+v4cCwq43Quqjggzu4lQ6LgLLgO2NCdmFqrJWA7EiQUH8nuxYDsD4c9v+Tr5XFP2Reg7jaSFLmLiiFwnMt1IDIxGkyxeQA6Vkx2y4LhCfPFNa68hRY9YvDMJOM4BL3C5ISLNrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HSXEbnhO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jCOfnoXu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HSXEbnhO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jCOfnoXu"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4159OIOD009619;
	Mon, 5 Feb 2024 09:27:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=j1eq6/PcnMVBpHZ4XAQqOqkr35mI0CXhmcfbqgbaJ3E=;
 b=HSXEbnhOGjAiCeKo3sp2ufJhxyqNd9RwXYJU/8MtDx31T+CEr5Fpkqon1Dl+GstHDtrX
 NpIxOTtRMv5xM90pRuBBG93IpUzZwPW+4on35eidhem5hIWlowPjbkL5smNC4cKHnwnb
 /UEJQUgcH2pj+aqYz5VSbSEWr3+lj5clUIUQP5Zn7O6e4mqwzlgtCoEth0BE+X/9dK8O
 jFoGLgTQfnQpZJ4+N7N3C8cn8nD6zrAK5/zUo7Lzgd0qaCaOBTqgTdIBHzDhhTYgTAw/
 +hxT7hdL4YjuTidYKflarpLQ3/vp17tdh86TpneLZe6QoqqL6OogEkRmVwLY9nTDhIdF JA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dhdbfgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Feb 2024 09:27:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4158j980036819;
	Mon, 5 Feb 2024 09:27:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx5ehyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Feb 2024 09:27:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXEPqwvVuSgRmyfP7szNhkBjJCIsPmk9wuB+Zt0jA6d11/UJDbqu3RYzfI+Bfr2elownGT3ajHEIsAN+C0cgEAIxr/iiT13yYKexVyjJQikRwrR7+XkYuTI8Vg6I3ni45Ubg1iu8GBKK6CCGyPfsxa6RirhZ3I07wBLAsSHJzzGXT/OBJ248+nPM373H/P5rhmBWXVzODUewBBycYPaMTkhQbnU2qMGR0xDtpcRrwkbQV9zkPfRo88B8tsS5oVcDt1ogFsVSNhBOX9aWO7PHfA5LY5oWh3mwtDoiNp/TR5I/iNdmWUoPFEicioznwVpFyld7rYy0DrXZiCVezuWWOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1eq6/PcnMVBpHZ4XAQqOqkr35mI0CXhmcfbqgbaJ3E=;
 b=d0GY7GDPTHnBGCIKDymOg3Ss4/I0qDAn06jmusX1jRMDdDMJQVyf9VxJ5NLNXmeBuy7rXdttdrS4duA9Fz48fGl8fkv+gOD00ZMkgATqHfFeE9DWSMuviHizCe4nF9TJOswDE97PVOA33loxCZGLwppKeJIb1oghElXKWi64DEAouhatp05ri+wfrIGelv28B5P/azwLgvaL43g7hoP+OLXEExNwMVejPrb7Fk+/E9V+UOo12VN92Hi8lX2rx8Mx91ES2bQ+iiKW+PQ81hlEc4b7vnmn5voIuMIT6tKIf7NFxAnUE2vB0uZW52OD1+SR0KrKsTrTXN49GPgf91dxwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1eq6/PcnMVBpHZ4XAQqOqkr35mI0CXhmcfbqgbaJ3E=;
 b=jCOfnoXut+RDv9Id7lZuSqxgoot/ub3+bBOiIHrhgiLcN0i/r4GxoH3MAjwHS3bREz67J9XkBkg89OI9Ln7MxC+irOY6A1atC5FfibOAD9mFsvW9xfp9agykYmGrN/aSKxBePT0aIyKa1tSPVvKCSTMdyHciIcYBT1BoyPkm1Yk=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by LV3PR10MB7842.namprd10.prod.outlook.com (2603:10b6:408:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 09:27:04 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2e34:ae4e:d7db:ab33]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2e34:ae4e:d7db:ab33%4]) with mapi id 15.20.7249.032; Mon, 5 Feb 2024
 09:27:04 +0000
Message-ID: <6e02ac20-490a-48ff-9370-5e466cb740bb@oracle.com>
Date: Mon, 5 Feb 2024 10:26:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 003/331] docs: kernel_feat.py: fix potential command
 injection
Content-Language: en-US
To: Justin Forbes <jforbes@fedoraproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Salvatore Bonaccorso <carnil@debian.org>,
        Jonathan Corbet
 <corbet@lwn.net>, stable@vger.kernel.org,
        patches@lists.linux.dev, Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <ZbkfGst991YHqJHK@fedora64.linuxtx.org>
 <87h6iudc7j.fsf@meer.lwn.net>
 <CAFbkSA2tft--ejgJ58o3G-OxNqnm-C6fK4-kXThsN92NYF8V0A@mail.gmail.com>
 <2024020151-purchase-swerve-a3b3@gregkh>
 <CAFbkSA25o88DjaWHc3GRk5vkvANnpi-NJ61XJudz4=ARTyrhtw@mail.gmail.com>
 <CAFbkSA3M74kvF+v_URm593xSnJTVzeKmy2K6dw0WQYw7BDdwmg@mail.gmail.com>
 <CAFbkSA3vHDn-Pk9fB6PbWeniGHH6W3bo=jQ9utE9xh88S8bzxA@mail.gmail.com>
 <1a160e5f-d5ce-4711-b683-808ab87b289b@oracle.com>
 <Zb_DwdZ3PUr1VbBg@eldamar.lan> <Zb_0NEeCqok8icwz@eldamar.lan>
 <2024020402-scotch-upchuck-9e11@gregkh>
 <CAFbkSA08Wo-rWJiOXf4BmNu_nXFX6gQriW5J09L8KzSHUU1j9g@mail.gmail.com>
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 xsFNBE4DTU8BEADTtNncvO6rZdvTSILZHHhUnJr9Vd7N/MSx8U9z0UkAtrcgP6HPsVdsvHeU
 C6IW7L629z7CSffCXNeF8xBYnGFhCh9L9fyX/nZ2gVw/0cVDCVMwVgeXo3m8AR1iSFYvO9vC
 Rcd1fN2y+vGsJaD4JoxhKBygUtPWqUKks88NYvqyIMKgIVNQ964Qh7M+qDGY+e/BaId1OK2Z
 92jfTNE7EaIhJfHX8hW1yJKXWS54qBMqBstgLHPx8rv8AmRunsehso5nKxjtlYa/Zw5J1Uyw
 tSl+e3g/8bmCj+9+7Gj2swFlmZQwBVpVVrAR38jjEnjbKe9dQZ7c8mHHSFDflcAJlqRB2RT1
 2JA3iX/XZ0AmcOvrk62S7B4I00+kOiY6fAERPptrA19n452Non7PD5VTe2iKsOIARIkf7LvD
 q2bjzB3r41A8twtB7DUEH8Db5tbiztwy2TGLD9ga+aJJwGdy9kR5kRORNLWvqMM6Bfe9+qbw
 cJ1NXTM1RFsgCgq7U6BMEXZNcsSg9Hbs6fqDPbbZXXxn7iA4TmOhyAqgY5KCa0wm68GxMhyG
 5Q5dWfwX42/U/Zx5foyiORvEFxDBWNWc6iP1h+w8wDiiEO/UM7eH06bxRaxoMEYmcYNeEjk6
 U6qnvjUiK8A35zDOoK67t9QD35aWlNBNQ2becGk9i8fuNJKqNQARAQABzShWZWdhcmQgTm9z
 c3VtIDx2ZWdhcmQubm9zc3VtQG9yYWNsZS5jb20+wsF4BBMBAgAiBQJX+8E+AhsDBgsJCAcD
 AgYVCAIJCgsEFgIDAQIeAQIXgAAKCRALzvTY/pi6WOTDD/46kJZT/yJsYVT44e+MWvWXnzi9
 G7Tcqo1yNS5guN0d49B8ei9VvRzYpRsziaj1nAQJ8bgGJeXjNsMLMOZgx4b5OTsn8t2zIm2h
 midgIE8b3nS73uNs+9E1ktJPnHClGtTECEIIwQibpdCPYCS3lpmoAagezfcnkOqtTdgSvBg9
 FxrxKpAclgoQFTKpUoI121tvYBHmaW9K5mBM3Ty16t7IPghnndgxab+liUUZQY0TZqDG8PPW
 SuRpiVJ9buszWQvm1MUJB/MNtj1rWHivsc1Xu559PYShvJiqJF1+NCNVUx3hfXEm3evTZ9Fm
 TQJBNaeROqCToGJHjdbOdtxeSdMhaiExuSnxghqcWN+76JNXAQLlVvYhHjQwzr4me4Efo1AN
 jinz1STmmeeAMYBfHPmBNjbyNMmYBH4ETbK9XKmtkLlEPuwTXu++7zKECgsgJJJ+kvAM1OOP
 VSOKCFouq1NiuJTDwIXQf/zc1ZB8ILoY/WljE+TO/ZNmRCZl8uj03FTUzLYhR7iWdyfG5gJ/
 UfNDs/LBk596rEAtlwn0qlFUmj01B1MVeevV8JJ711S1jiRrPCXg90P3wmUUQzO0apfk1Np6
 jZVlvsnbdK/1QZaYo1kdDPEVG+TQKOgdj4wbLMBV0rh82SYM1nc6YinoXWS3EuEfRLYTf8ad
 hbkmGzrwcc7BTQROA01PARAA5+ySdsvX2RzUF6aBwtohoGYV6m2P77wn4u9uNDMD9vfcqZxj
 y9QBMKGVADLY/zoL3TJx8CYS71YNz2AsFysTdfJjNgruZW7+j2ODTrHVTNWNSpMt5yRVW426
 vN12gYjqK95c5uKNWGreP9W99T7Tj8yJe2CcoXYb6kO8hGvAHFlSYpJe+Plph5oD9llnYWpO
 XOzzuICFi4jfm0I0lvneQGd2aPK47JGHWewHn1Xk9/IwZW2InPYZat0kLlSDdiQmy/1Kv1UL
 PfzSjc9lkZqUJEXunpE0Mdp8LqowlL3rmgdoi1u4MNXurqWwPTXf1MSH537exgjqMp6tddfw
 cLAIcReIrKnN9g1+rdHfAUiHJYhEVbJACQSy9a4Z+CzUgb4RcwOQznGuzDXxnuTSuwMRxvyz
 XpDvuZazsAqB4e4p/m+42hAjE5lKBfE/p/WWewNzRRxRKvscoLcWCLg1qZ6N1pNJAh7BQdDK
 pvLaUv6zQkrlsvK2bicGXqzPVhjwX+rTghSuG3Sbsn2XdzABROgHd7ImsqzV6QQGw7eIlTD2
 MT2b9gf0f76TaTgi0kZlLpQiAGVgjNhU2Aq3xIqOFTuiGnIQN0LV9/g6KqklzOGMBYf80Pgs
 kiObHTTzSvPIT+JcdIjPcKj2+HCbgbhmrYLtGJW8Bqp/I8w2aj2nVBa7l7UAEQEAAcLBXwQY
 AQIACQUCTgNNTwIbDAAKCRALzvTY/pi6WEWzD/4rWDeWc3P0DfOv23vWgx1qboMuFLxetair
 Utae7i60PQFIVj44xG997aMjohdxxzO9oBCTxUekn31aXzTBpUbRhStq78d1hQA5Rk7nJRS6
 Nl6UtIcuLTE6Zznrq3QdQHtqwQCm1OM2F5w0ezOxbhHgt9WTrjJHact4AsN/8Aa2jmxJYrup
 aKmHqPxCVwxrrSTnx8ljisPaZWdzLQF5qmgmAqIRvX57xAuCu8O15XyZ054u73dIEYb2MBBl
 aUYwDv/4So2e2MEUymx7BF8rKDJ1LvwxKYT+X1gSdeiSambCzuEZ3SQWsVv3gn5TTCn3fHDt
 KTUL3zejji3s2V/gBXoHX7NnTNx6ZDP7It259tvWXKlUDd+spxUCF4i5fbkoQ9A0PNCwe01i
 N71y5pRS0WlFS06cvPs9lZbkAj4lDFgnOVQwmg6Smqi8gjD8rjP0GWKY24tDqd6sptX5cTDH
 pcH+LjiY61m43d8Rx+tqiUGJNUfXE/sEB+nkpL1PFWzdI1XZp4tlG6R7T9VLLf01SfeA2wgo
 9BLDRko6MK5UxPwoYDHpYiyzzAdO24dlfTphNxNcDfspLCgOW1IQ3kGoTghU7CwDtV44x4rA
 jtz7znL1XTlXp6YJQ/FWWIJfsyFvr01kTmv+/QpnAG5/iLJ+0upU1blkWmVwaEo82BU6MrS2 8A==
In-Reply-To: <CAFbkSA08Wo-rWJiOXf4BmNu_nXFX6gQriW5J09L8KzSHUU1j9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR3PR09CA0028.eurprd09.prod.outlook.com
 (2603:10a6:102:b7::33) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|LV3PR10MB7842:EE_
X-MS-Office365-Filtering-Correlation-Id: e47a9952-3837-468d-6c8f-08dc262c9d7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	GYdp5ym1VqXjsxAR6KbyFNNzdwEySoB+PwHfSqi+xSii/bFM8cXdnIWlDl753ko03H6MWx0P1Waaa03eNBvdfkohDHyAabnygJl4XLMLtctkeBcvnDaoPJC5MTxqPgTpRLjZfOoffcshoxXRUdJ+8iK4rPR7srDt3RKM1O6qo7b0GRd7nIKHxAD7zSWCPeXmrVw2wMZfw8wsdZPkdXQ/awLzshxCJPOx9se28hx9VLN+ZfXkxEYEW0O7Or6o7G+6puCooO+JqOcO7HYBTyJsUAeq4EeqBKvf4d8H0CX/ab1WE6dJItzBFMb09JmVlUuGhRoxNLgg2P994LS+/IGRpGwelPEE3eZBAwBHR4tsKmh3qGVR1p/zjfHucst7Akczi8Tx+DF/MS9EZOhu7iJ6wlKyT+OpmaLYnaY+2raiBQWJeYimuLiKAu4AkgqAVmYenUgfpcau8JbG6B6x0SXnjAxKqrnP+PgjXAURvWepmt2s4sg77aKuIl5VC8Ta9yE77ZkzJzW5eOfxnwd5HxNT4QTDIwm+vMhuwxpz9569UKCTDW2OrqqkBvlrqPU94jn+yYc1xuzMtvKhBmDj7uS/BWUwlcV8kXZrinx+bITTOMsiaMsmUshXTIiyfbqtzFPihXbCRFqk6JpGoW5TDm0W8w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(39860400002)(366004)(376002)(396003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(31686004)(36756003)(41300700001)(38100700002)(478600001)(2906002)(31696002)(83380400001)(26005)(6512007)(6666004)(86362001)(2616005)(6506007)(53546011)(66476007)(4326008)(54906003)(316002)(66946007)(6486002)(66556008)(110136005)(5660300002)(8936002)(8676002)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MDhDMDFsQjNjUHJnL01QTHRPRlRKREtWTVdNYStYRXJJdk45VSs4c1lJdmJC?=
 =?utf-8?B?R3hyaXZZNWJkVFBBV0J6Q1RHVlRiZndVcEZuNVpTVzZNNXArY0daVEdXbWlv?=
 =?utf-8?B?MmpNVGI5VjhhVlFOYnR2K2g1NVRoZnhOYitlWjV3QVp0YlozSjV1VHJQZE9l?=
 =?utf-8?B?bW5yd21FVFRLbFNiOUlQdEd3czBtbFg1YmlIcmMrNFpaOERiSXlLZ0ZhSm5E?=
 =?utf-8?B?bndJd0M2Y1R4cU53bFJhMS8raWZ3SHR0V2tHLy9nRm1UNmRzUTNIU0dOV0Yz?=
 =?utf-8?B?QnJJWDYyQVpERDNXUDl5ZkhQWCtPY0Zyb2xQNVF3a2J3RmxDVko0eDVBQk9V?=
 =?utf-8?B?Y0xTc2Zpa1ZZQW5lWUp0czlhMWhHTGx1Nm9sZFhFWWhRSkpFaGNRRGtnOWR6?=
 =?utf-8?B?OGJZZkQvVEk2NnNSZWxmRVBCOGJsTjFOWElLbXB6UGZ4UWxQNkMxZE9Ucjh1?=
 =?utf-8?B?akhFelkzMUZYMzJOVzlLTU9ETzBvQklURGNaRXpKNEEzb3RxQkNUNXJSWm5O?=
 =?utf-8?B?L0srREMrRFRMN3RDR0VycWhFakIrZGxZUFU1d2lBWEJ5d3VTSjZrek1wTE4w?=
 =?utf-8?B?dEFsVFJvQWNZM2IrUUd6bmhvVXZwbVpVKzJZc2U2bEFVYlllZXpzbkI3cFFK?=
 =?utf-8?B?L25SSVpOeThXSnpSYWRpZ0JNZzR5YTVrQm5PR2l1NkY2UkMrdGhRY20zYkk1?=
 =?utf-8?B?UEpMay9kWVg4MjRmOTFnWWlBamdLdk5YZ3FtL1J3MEoyazZrRnUzSHQ3blNy?=
 =?utf-8?B?MmxRUkpUZ0hKdlRvcUQyZWUyYlNGVnRjck1abFNWa1VGVXFZRy9IVmx5KzNu?=
 =?utf-8?B?eXIzS2tWRzgyRVhhSzhBaTgxWXpaZG1qM1F3dFBsZjQxcGM0WlJmaUJlL0V0?=
 =?utf-8?B?bEdzekJwbjdxVzl2Ui9MQWFoOXdoRCtTQVBRRHRYaWxOUjlpU3dRMjhaSWRo?=
 =?utf-8?B?U1JTeXA1SVExZ0E3Nm5EZWcxMTZBaEZXWkJiVFBKOTRjbEJxR005cUI1SXZZ?=
 =?utf-8?B?MzdmeVZXVlgxeFlCTnEwOWw1aEhhK2J4cXB1akZlR09ackZscmMvZXVodDk4?=
 =?utf-8?B?RFhwRXJFQjRQdzJLS1ZTbmxvZ1dlTEhMSVB4UyswRzcxM1h4aG9ORmJRYlRF?=
 =?utf-8?B?RGs5RUVnWWZPRUcrbERDK2FJUDBRTUVoWXpNQlg4U3RydFY1Y1ZrLzF6cU15?=
 =?utf-8?B?TTlCSXhPMnZjWnltRVlhWW9yTGFpeFlWZmRPdERwMmVpTi9GbmZnMmVHT1lO?=
 =?utf-8?B?cGFWNE9KR3MraVdXOUxhTFd4Zy9IV2hZa1ZoaWJIYVhuTDBsbzFTRzdzemJh?=
 =?utf-8?B?K3JQVW80NGx2NVVsU2VwSGVNNWJHTUxDRUFoK2NyalFlSkZ5MEcwZUhFbWd1?=
 =?utf-8?B?d1pQdmQ3dStveDAyM3ptVi8wNmwzYVE0RStadXZETjFkd3diTGZLRjBsYTZa?=
 =?utf-8?B?dklSeGVTSzBDQ0FNT08xOGQ1RTlIWE04VzNiaW5sRHVKVmxQZlJVMGxLYWpz?=
 =?utf-8?B?bENhblFGNlVqK1lFNDRQNHBTOWVpRCtMZGFpbkxJU3dMYndsZkFaT0RQTm02?=
 =?utf-8?B?S1VKb0RkbHpWNHJkNk1uL3o5VllXblhhVmdyRVpJR0s2dDFueUF5S0M3UnA1?=
 =?utf-8?B?SDhFVWJ1cmg5VHlaTlcxOS9HNG1GM25KeGFyajhRNkw4U1F0ek9GMXdveld4?=
 =?utf-8?B?WmUxWkUwckRyUVJuOFFzR1lpSXpJVWFVRUNrNmdWUndiVFl3cmppenJDV1Zq?=
 =?utf-8?B?dWlsdzZWVnJyNTJvSUlnR2pCT1ZMYTJTZzVxdnRQeHlkZS84cWZxeEkxL1BC?=
 =?utf-8?B?T3RWemdFSUs4T0F1RktkcExRNC9MbGhBdWJyL05USkhwS2paSG9HQnpiQU1B?=
 =?utf-8?B?S1NadnhOY1FMSGVmZTZBVnJMRlFjM1R1MGN1S1BjTThnSUtWcmVxUTZHQ2h3?=
 =?utf-8?B?ajI5K2N2SjMyTjVWeE1tTXgzWVVEdjF6RkFlZm9aelN6MUNMb0pxb2dJV0w5?=
 =?utf-8?B?NDEyaWZZZnJvZW9pUnJMUTJIZTloU2w1U2MzYkdxdTZqemRyZDRqY3BNMFM3?=
 =?utf-8?B?cGlmcHZHaUdUeXR5aU5rbXJjVUNETmtxeERaWWRiSXZyajRjUkFFWElwNURa?=
 =?utf-8?B?ekdYb25oR1dXeW1xdWphTFJERFpKRUxYUmQ1UWZjRFVGUXc3Yk9XQXFSc3Vx?=
 =?utf-8?B?OUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	HrjWXk2k7MhSrGGRZKT2tUuidIpqwVCwJu5zHvA16pNxVi7Ipe3rD0c0hh871KAzIP0z34V3/kBK+/X2AM8u6MRznDwJVc032mop7qF1CjrE4h8Gx63EIx0ArQ14Os6q7Rr09NToqxd82YV6KQ/e06+Jb+CCH5xZGTOSXOLnPd67I3yfOBFejFnd47j8neK5C64nxtD3rg7NWAQ13nu5z1p19acuod3wAq2HXK623wFdhAOoVUmFEepSRxI2HHJHZsZ8tW2V2b7v0VG5e8S3k7a4Xb57DBWMVGOCcc2+wegHz3fZkr0v03ZaLm1wGxk1JO5ODWrpOdzfpwBbcmJ7zbHWdYkI5l5rhj3HpLA8lXpdQXRPX15juMOJNSuXmgRv93Ye1d/f4QDbdVWL3+ezvHOKFrovf6zQbOvph5pF4OjC7XcKt4OgkX+7T+4yAOSKaRvmop52ZfGPgnhB9FzDfPdPYqxosWsgiIiAug/z+xq97qbQNrznsy5XpVU46z2bKEHTexnWqSv9Sx0aNWK/cOzllNLK0wCF+03xPcjIABGovztqGLQHhsJpMc0+LnjQsK2ZzV1urw7uIuNzp6+bjIZGR2i8+5350mOMHI8eL9o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e47a9952-3837-468d-6c8f-08dc262c9d7c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 09:27:04.4781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ojpXEo6mJId1RXrum3p3rnbeZrkCY9jSPqV9Sn5Je7JVWZlyIYarOXc+ChYyuU7PKkWkttVZnjhF2P1aW/gev51bVwXj7TwunskqJxVt3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7842
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_04,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050071
X-Proofpoint-GUID: ye2lboab5m9eqh9mJ7XZHnR6vq7iwRue
X-Proofpoint-ORIG-GUID: ye2lboab5m9eqh9mJ7XZHnR6vq7iwRue

On 05/02/2024 03:36, Justin Forbes wrote:
> On Sun, Feb 4, 2024 at 7:29 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Sun, Feb 04, 2024 at 09:31:48PM +0100, Salvatore Bonaccorso wrote:
>>> On Sun, Feb 04, 2024 at 06:05:05PM +0100, Salvatore Bonaccorso wrote:
>>>> On Thu, Feb 01, 2024 at 05:34:25PM +0100, Vegard Nossum wrote:
[...]
>>>>> I'm guessing maybe a different patch between 6.6 and current mainline is
>>>>> causing 'fname' to always get assigned for the newer versions and thus
>>>>> make the run succeed, in spite of the bug.
>>>>>
>>>>> Something like the patch below (completely untested) should restore the
>>>>> previous behaviour, but I'm not convinced it's correct.

[...]

>>>> Your above change seems to workaround the issue in fact, but need to
>>>> do a full build yet.
>>>
>>> For Debian I'm temporarily reverting from the 6.6.15 upload:
>>>
>>> e961f8c6966a ("docs: kernel_feat.py: fix potential command injection")
>>>
>>> This is not the best solution, but unbreaks several other builds.
>>>
>>> The alternative would be to apply Vegard's workaround or the proper
>>> solution for that.
>>
>> What is the "proper" solution here?  Does 6.8-rc3 work?  What are we
>> missing to be backported here?
> 
> I am not sure what the "proper"fix was, but as I mentioned with
> 6.6.15, this patch broke the build with 6.6.15, but 6.7.3 and newer
> were fine.  I think the fix came in through another path incidentally,
> but Vegard mentioned a possible fox for 6.6 kernels.  Realistically,
> Fedora has moved on to 6.7.x now, but I do still test 6.6.x stable rcs
> and while I reported that 6.6.16 was good, it was only because I saw
> no regressions from 6.6.15. The docs failure from this patch still
> exists.

I'm thinking this might be missing from the backport of the stable
patch, causing it to break on 6.6.15 (since ia64 was removed in 6.7):

diff --git a/Documentation/arch/ia64/features.rst 
b/Documentation/arch/ia64/features.rst
index d7226fdcf5f8..056838d2ab55 100644
--- a/Documentation/arch/ia64/features.rst
+++ b/Documentation/arch/ia64/features.rst
@@ -1,3 +1,3 @@
  .. SPDX-License-Identifier: GPL-2.0

-.. kernel-feat:: $srctree/Documentation/features ia64
+.. kernel-feat:: features ia64

I also think I understand the kernel_feat.py code a bit better and will
submit a proper fix for that -- basically, if it doesn't manage to
process any lines from the referenced file (which it won't for ia64
since it literally tries to open a file called $srctree/...) then it
calls self.nestedParse() with a non-existent 'fname' and an empty
'lines' -- so the value of the fname parameter is truly unused in the
degenerate case, but it's still referencing the undefined 'fname'.

So I'm thinking:

1) the ia64/features.rst patch above for stable (only) to fix the
immediate breakage in stable,

2) kernel_feat.py patch for mainline that can trickle down into stable
once it's been merged.

Thanks, and sorry for the breakage.


Vegard
